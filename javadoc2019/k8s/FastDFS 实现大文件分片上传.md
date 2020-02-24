# FastDFS 实现大文件分片上传

引入fastdfs
```
<!-- fastdfs包 -->
<dependency>
    <groupId>com.github.tobato</groupId>
    <artifactId>fastdfs-client</artifactId>
    <version>1.25.2-RELEASE</version>
</dependency>
<!-- huTool工具包 -->
<dependency>
    <groupId>cn.hutool</groupId>
    <artifactId>hutool-all</artifactId>
    <version>4.0.12</version>
</dependency>

```

编写控制层Controller

```
@GetMapping("/check_before_upload")
@ApiOperation("分片上传前的检测")
public RespMsgBean checkBeforeUpload(@RequestParam("userId") Long userId, @RequestParam("fileMd5") String fileMd5) {
    return fileService.checkFile(userId, fileMd5);
}
 
@PostMapping("/upload_big_file_chunk")
@ApiOperation("分片上传大文件")
public RespMsgBean uploadBigFileChunk(@RequestParam("file") @ApiParam(value="文件",required=true) MultipartFile file,
                                      @RequestParam("userId") @ApiParam(value="用户id",required=true) Long userId,
                                      @RequestParam("fileMd5") @ApiParam(value="文件MD5值",required=true) String fileMd5,
                                      @RequestParam("fileName") @ApiParam(value="文件名称",required=true) String fileName,
                                      @RequestParam("totalChunks") @ApiParam(value="总块数",required=true) Integer totalChunks,
                                      @RequestParam("chunkNumber") @ApiParam(value="当前块数",required=true) Integer chunkNumber,
                                      @RequestParam("currentChunkSize") @ApiParam(value="当前块的大小",required=true) Integer currentChunkSize,
                                      @RequestParam("bizId") @ApiParam(value="业务Id",required=true)String bizId,
                                      @RequestParam("bizCode") @ApiParam(value="业务编码",required=true)String bizCode) {
    return fileService.uploadBigFileChunk(file, userId, fileMd5, fileName, totalChunks, chunkNumber, currentChunkSize, bizId, bizCode);
}
```

编写业务接口以及实现类

```
package com.xxxx.cloud.platfrom.common.file.service.impl;
 
import cn.hutool.core.convert.Convert;
import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.StrUtil;
import com.alibaba.fastjson.JSONObject;
import com.xxxx.cloud.platfrom.common.pojo.protocol.RespMsgBean;
import com.github.tobato.fastdfs.domain.StorePath;
import com.github.tobato.fastdfs.service.AppendFileStorageClient;
import com.google.gson.Gson;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
 
import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;
 
/**
 * 〈一句话功能简述〉<br> 
 * 〈文件接口实现〉
 * @author xxxx
 * @create 2019/7/1
 * @since 1.0.0
 */
@Service
public class FileServiceImpl implements FileService {
 
    private Logger logger = LoggerFactory.getLogger(FileServiceImpl.class);
 
    @Override
    public RespMsgBean checkFile(Long userId, String fileMd5) {
        RespMsgBean backInfo = new RespMsgBean();
        if (StrUtil.isEmpty(fileMd5)) {
            return backInfo.failure("fileMd5不能为空");
        }
        if (userId == null) {
            return backInfo.failure("userId不能为空");
        }
        String userIdStr = userId.toString();
        CheckFileDto checkFileDto = new CheckFileDto();
 
        // 查询是否有相同md5文件已存在,已存在直接返回
        FileDo fileDo = fileDao.findOneByColumn("scode", fileMd5);
        if (fileDo != null) {
            FileVo fileVo = doToVo(fileDo);
            return backInfo.success("文件已存在", fileVo);
        } else {
            // 查询锁占用
            String lockName = UpLoadConstant.currLocks + fileMd5;
            Long lock = JedisConfig.incrBy(lockName, 1);
            String lockOwner = UpLoadConstant.lockOwner + fileMd5;
            String chunkCurrkey = UpLoadConstant.chunkCurr + fileMd5;
            if (lock > 1) {
                checkFileDto.setLock(1);
                // 检查是否为锁的拥有者,如果是放行
                String oWner = JedisConfig.getString(lockOwner);
                if (StrUtil.isEmpty(oWner)) {
                    return backInfo.failure("无法获取文件锁拥有者");
                } else {
                    if (oWner.equals(userIdStr)) {
                        String chunkCurr = JedisConfig.getString(chunkCurrkey);
                        if (StrUtil.isEmpty(chunkCurr)) {
                            return backInfo.failure("无法获取当前文件chunkCurr");
                        }
                        checkFileDto.setChunk(Convert.toInt(chunkCurr));
                        return backInfo.success("", null);
                    } else {
                        return backInfo.failure("当前文件已有人在上传,您暂无法上传该文件");
                    }
                }
            } else {
                // 初始化锁.分块
                JedisConfig.setString(lockOwner, userIdStr);
                // 第一块索引是0,与前端保持一致
                JedisConfig.setString(chunkCurrkey, "0");
                checkFileDto.setChunk(0);
                return backInfo.success("", null);
            }
        }
    }
 
    @Override
    public RespMsgBean uploadBigFileChunk(MultipartFile file, Long userId, String fileMd5, String fileName, Integer chunks, Integer chunk, Integer chunkSize, String bizId, String bizCode) {
        RespMsgBean backInfo = new RespMsgBean();
        ServiceAssert.isTrue(!file.isEmpty(), 0, "文件不能为空");
        ServiceAssert.notNull(userId, 0, "用户id不能为空");
        ServiceAssert.isTrue(StringUtil.isNotBlank(fileMd5), 0, "文件fd5不能为空");
        ServiceAssert.isTrue(!"undefined".equals(fileMd5), 0, "文件fd5不能为undefined");
        ServiceAssert.isTrue(StringUtil.isNotBlank(fileName), 0, "文件名称不能为空");
        ServiceAssert.isTrue(chunks != null && chunk != null && chunkSize != null, 0, "文件块数有误");
        // 存储在fastdfs不带组的路径
        String noGroupPath = "";
        logger.info("当前文件的Md5:{}", fileMd5);
        String chunkLockName = UpLoadConstant.chunkLock + fileMd5;
 
        // 真正的拥有者
        boolean currOwner = false;
        Integer currentChunkInFront = 0;
        try {
            if (chunk == null) {
                chunk = 0;
            }
            if (chunks == null) {
                chunks = 1;
            }
 
            Long lock = JedisConfig.incrBy(chunkLockName, 1);
            if (lock > 1){
                logger.info("请求块锁失败");
                return backInfo.failure("请求块锁失败");
            }
            // 写入锁的当前拥有者
            currOwner = true;
 
            // redis中记录当前应该传第几块(从0开始)
            String currentChunkKey = UpLoadConstant.chunkCurr + fileMd5;
            String currentChunkInRedisStr =  JedisConfig.getString(currentChunkKey);
            Integer currentChunkSize = chunkSize;
            logger.info("当前块的大小:{}", currentChunkSize);
            if (StrUtil.isEmpty(currentChunkInRedisStr)) {
                logger.info("无法获取当前文件chunkCurr");
                return backInfo.failure("无法获取当前文件chunkCurr");
            }
            Integer currentChunkInRedis = Convert.toInt(currentChunkInRedisStr);
            currentChunkInFront = chunk;
 
            if (currentChunkInFront < currentChunkInRedis) {
                logger.info("当前文件块已上传");
                return backInfo.failure("当前文件块已上传", "001");
            } else if (currentChunkInFront > currentChunkInRedis) {
                logger.info("当前文件块需要等待上传,稍后请重试");
                return backInfo.failure("当前文件块需要等待上传,稍后请重试");
            }
 
            logger.info("***********开始上传第{}块**********", currentChunkInRedis);
            StorePath path = null;
            if (!file.isEmpty()) {
                try {
                    if (currentChunkInFront == 0) {
                        JedisConfig.setString(currentChunkKey, Convert.toStr(currentChunkInRedis + 1));
                        logger.info("{}:redis块+1", currentChunkInFront);
                        try {
                            path = defaultAppendFileStorageClient.uploadAppenderFile(UpLoadConstant.DEFAULT_GROUP, file.getInputStream(),
                                    file.getSize(), FileUtil.extName(fileName));
                            // 记录第一个分片上传的大小
                            JedisConfig.setString(UpLoadConstant.fastDfsSize + fileMd5, String.valueOf(currentChunkSize));
                            logger.info("{}:更新完fastDfs", currentChunkInFront);
                            if (path == null) {
                                JedisConfig.setString(currentChunkKey, Convert.toStr(currentChunkInRedis));
                                logger.info("获取远程文件路径出错");
                                return backInfo.failure("获取远程文件路径出错");
                            }
                        } catch (Exception e) {
                            JedisConfig.setString(currentChunkKey, Convert.toStr(currentChunkInRedis));
                            logger.error("初次上传远程文件出错", e);
                            return new RespMsgBean().failure("上传远程服务器文件出错");
                        }
                        noGroupPath = path.getPath();
                        JedisConfig.setString(UpLoadConstant.fastDfsPath + fileMd5, path.getPath());
                        logger.info("上传文件 result = {}", path);
                    } else {
                        JedisConfig.setString(currentChunkKey, Convert.toStr(currentChunkInRedis + 1));
                        logger.info("{}:redis块+1", currentChunkInFront);
                        noGroupPath = JedisConfig.getString(UpLoadConstant.fastDfsPath + fileMd5);
                        if (noGroupPath == null) {
                            logger.info("无法获取已上传服务器文件地址");
                            return new RespMsgBean().failure("无法获取已上传服务器文件地址");
                        }
                        try {
                            String alreadySize = JedisConfig.getString(UpLoadConstant.fastDfsSize + fileMd5);
                            // 追加方式实际实用如果中途出错多次,可能会出现重复追加情况,这里改成修改模式,即时多次传来重复文件块,依然可以保证文件拼接正确
                            defaultAppendFileStorageClient.modifyFile(UpLoadConstant.DEFAULT_GROUP, noGroupPath, file.getInputStream(),
                                    file.getSize(), Long.parseLong(alreadySize));
                            // 记录分片上传的大小
                            JedisConfig.setString(UpLoadConstant.fastDfsSize + fileMd5, String.valueOf(Long.parseLong(alreadySize) + currentChunkSize));
                            logger.info("{}:更新完fastdfs", currentChunkInFront);
                        } catch (Exception e) {
                            JedisConfig.setString(currentChunkKey, Convert.toStr(currentChunkInRedis));
                            logger.error("更新远程文件出错", e);
                            return new RespMsgBean().failure("更新远程文件出错");
                        }
                    }
                    if (currentChunkInFront + 1 == chunks) {
                        // 最后一块,清空upload,写入数据库
                        Long size = Long.parseLong(JedisConfig.getString(UpLoadConstant.fastDfsSize + fileMd5));
                        // 持久化上传完成文件,也可以存储在mysql中
                        noGroupPath = JedisConfig.getString(UpLoadConstant.fastDfsPath + fileMd5);
                        String url = UpLoadConstant.DEFAULT_GROUP + "/" + noGroupPath;
                        FileDo fileDo = new FileDo(fileName, url, "", size, bizId, bizCode);
                        fileDo.setCreateUser(userId);
                        fileDo.setUpdateUser(userId);
                        FileVo fileVo = saveFileDo4BigFile(fileDo, fileMd5);
                        String[] deleteKeys = new String[]{UpLoadConstant.chunkCurr + fileMd5,
                                UpLoadConstant.fastDfsPath + fileMd5,
                                UpLoadConstant.currLocks + fileMd5,
                                UpLoadConstant.lockOwner + fileMd5,
                                UpLoadConstant.fastDfsSize + fileMd5
                        };
                        JedisConfig.delKeys(deleteKeys);
                        logger.info("***********正常结束**********");
                        return new RespMsgBean().success(fileVo);
                    }
                } catch (Exception e) {
                    logger.error("上传文件错误", e);
                    return new RespMsgBean().failure("上传错误 " + e.getMessage());
                }
            }
        } finally {
            // 锁的当前拥有者才能释放块上传锁
            if (currOwner) {
                JedisConfig.setString(chunkLockName, "0");
            }
        }
        logger.info("***********第{}块上传成功**********", currentChunkInFront);
        return backInfo.success("第" + currentChunkInFront + "块上传成功");
    }
 
}
```

用到的工具类


```
package com.xxx.cloud.platfrom.common.file.config;
 
import cn.hutool.core.util.StrUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;
 
import java.util.List;
 
/**
 * @Description: JedisConfig
 * @ClassName: JedisConfig
 * @Author: xxx
 * @Date: 2019/12/31 16:23
 * @Version: 1.0
 */
public class JedisConfig {
 
    private static Logger logger = LoggerFactory.getLogger(JedisConfig.class);
 
    protected static final ThreadLocal<Jedis> threadLocalJedis = new ThreadLocal<>();
    private static JedisPool jedisPool;
    /**
     * Redis服务器IP
     */
    private static String ADDR_ARRAY = "192.168.1.122";
 
    /**
     * Redis的端口号
     */
    private static int PORT = 6379;
 
    /**
     * 访问密码
     */
    private static String AUTH = "123456";
 
    /**
     * 可用连接实例的最大数目，默认值为8
     * 如果赋值为-1，则表示不限制；如果pool已经分配了maxActive个jedis实例，则此时pool的状态为exhausted(耗尽)。
     */
    private static int MAX_ACTIVE = -1;
 
    /**
     * 控制一个pool最多有多少个状态为idle(空闲的)的jedis实例，默认值也是8。
     */
    private static int MAX_IDLE = 16;
 
    /**
     * 等待可用连接的最大时间，单位毫秒，默认值为-1，表示永不超时。如果超过等待时间，则直接抛出JedisConnectionException；
     */
    private static int MAX_WAIT = 1000 * 5;
 
    // 超时时间
    private static int TIMEOUT = 1000 * 5;
 
    /**
     * 在borrow一个jedis实例时，是否提前进行validate操作；如果为true，则得到的jedis实例均是可用的；
     */
    private static boolean TEST_ON_BORROW = true;
 
    /**
     * redis过期时间,以秒为单位
     */
    /**
     * 一小时
     */
    public final static int EXRP_HOUR = 60 * 60;
    /**
     * 一天
     */
    public final static int EXRP_DAY = 60 * 60 * 24;
    /**
     * 一个月
     */
    public final static int EXRP_MONTH = 60 * 60 * 24 * 30;
 
    public JedisConfig() {
    }
 
    static {
        initialPool();
    }
 
    /**
     * 初始化Redis连接池,注意一定要在使用前初始化一次,一般在项目启动时初始化就行了
     */
    public static JedisPool initialPool() {
        JedisPool jp = null;
        try {
            JedisPoolConfig config = new JedisPoolConfig();
            config.setMaxTotal(MAX_ACTIVE);
            config.setMaxIdle(MAX_IDLE);
            config.setMaxWaitMillis(MAX_WAIT);
            config.setTestOnBorrow(TEST_ON_BORROW);
            config.setTestOnCreate(true);
            config.setTestWhileIdle(true);
            config.setTestOnReturn(true);
            config.setNumTestsPerEvictionRun(-1);
            jp = new JedisPool(config, ADDR_ARRAY, PORT, TIMEOUT, AUTH);
            jedisPool = jp;
            threadLocalJedis.set(getJedis());
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("redis服务器异常",e);
        }
        return jp;
    }
 
    /**
     * 获取Jedis实例,一定先初始化
     * @return Jedis
     */
    public static Jedis getJedis() {
        boolean success = false;
        Jedis jedis = null;
        int i=0;
        while (!success) {
            i++;
            try {
                if (jedisPool != null) {
                    jedis = threadLocalJedis.get();
                    if (jedis == null){
                        jedis = jedisPool.getResource();
                    }else {
                        if(!jedis.isConnected() && !jedis.getClient().isBroken()){
                            threadLocalJedis.set(null);
                            jedis = jedisPool.getResource();
                        }
                        return jedis;
                    }
                }else {
                    throw new RuntimeException("redis连接池初始化失败");
                }
            } catch (Exception e) {
                System.out.println(Thread.currentThread().getName()+":第"+i+"次获取失败!!!");
                success = false;
                e.printStackTrace();
                logger.error("redis服务器异常",e);
            }
            if (jedis != null){
                success = true;
            }
            if (i >= 10 && i < 20){
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            if (i >= 20 && i < 30){
                try {
                    Thread.sleep(2000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
 
            }
            if (i >= 30 && i < 40){
                try {
                    Thread.sleep(3000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            if (i >= 40){
                System.out.println("redis彻底连不上了~~~~(>_<)~~~~");
                return null;
            }
        }
        if (threadLocalJedis.get() == null) {
            threadLocalJedis.set(jedis);
        }
        return jedis;
    }
 
    /**
     * 设置 String
     * @param key
     * @param value
     */
    public static void setString(String key, String value) {
        Jedis jo = null;
        try {
            value = StrUtil.isBlank(value) ? "" : value;
            jo = getJedis();
            jo.set(key, value);
        } catch (Exception e) {
            threadLocalJedis.set(null);
            logger.error("redis服务器异常",e);
            throw new  RuntimeException("redis服务器异常");
        } finally {
            if (jo != null) {
                close(jo);
            }
        }
    }
 
    /**
     * 设置 过期时间
     * @param key
     * @param seconds 以秒为单位
     * @param value
     */
    public static void setString(String key, int seconds, String value) {
        Jedis jo = null;
        try {
            value = StrUtil.isBlank(value) ? "" : value;
            jo = getJedis();
            jo.setex(key, seconds, value);
        } catch (Exception e) {
            threadLocalJedis.set(null);
            e.printStackTrace();
            logger.error("redis服务器异常",e);
            throw new RuntimeException("redis服务器异常");
        } finally {
            if (jo != null) {
                close(jo);
            }
        }
 
 
    }
 
    /**
     * 获取String值
     * @param key
     * @return value
     */
    public static String getString(String key) {
        Jedis jo = null;
        try {
            jo = getJedis();
            if (jo == null || !jo.exists(key)) {
                return null;
            }
            return jo.get(key);
        } catch (Exception e) {
            threadLocalJedis.set(null);
            e.printStackTrace();
            logger.error("redis服务器异常",e);
            throw new  RuntimeException("redis操作错误");
        } finally {
            if (jo != null) {
                close(jo);
            }
        }
    }
 
    public static long incrBy(String key, long integer) {
        Jedis jo = null;
        try {
            jo = getJedis();
            return jo.incrBy(key, integer);
        } catch (Exception e) {
            threadLocalJedis.set(null);
            e.printStackTrace();
            logger.error("redis服务器异常",e);
            throw new  RuntimeException("redis操作错误");
        } finally {
            if (jo != null) {
                close(jo);
            }
        }
    }
 
    public static long decrBy(String key, long integer) {
        Jedis jo = null;
        try {
            jo = getJedis();
            return jo.decrBy(key, integer);
        } catch (Exception e) {
            threadLocalJedis.set(null);
            e.printStackTrace();
            logger.error("redis服务器异常",e);
            throw new  RuntimeException("redis操作错误");
        } finally {
            if (jo != null) {
                close(jo);
            }
        }
    }
 
    /**
     * 删除多个key
     */
    public static long delKeys(String [] keys){
        Jedis jo = null;
        try {
            jo = getJedis();
            return jo.del(keys);
        } catch (Exception e) {
            threadLocalJedis.set(null);
            e.printStackTrace();
            logger.error("redis服务器异常",e);
            throw new  RuntimeException("redis操作错误");
        } finally {
            if (jo != null) {
                close(jo);
            }
        }
 
    }
 
    /**
     * 删除单个key
     */
    public static long delKey(String  key){
        Jedis jo = null;
        try {
            jo = getJedis();
            return jo.del(key);
        } catch (Exception e) {
            threadLocalJedis.set(null);
            e.printStackTrace();
            logger.error("redis服务器异常",e);
            throw new  RuntimeException("redis操作错误");
        } finally {
            if (jo != null) {
                close(jo);
            }
        }
 
    }
 
    /**
     * 添加到队列尾
     */
    public static long rpush(String  key,String node){
        Jedis jo = null;
        try {
            jo = getJedis();
            return jo.rpush(key,node);
        } catch (Exception e) {
            threadLocalJedis.set(null);
            e.printStackTrace();
            logger.error("redis服务器异常",e);
            throw new  RuntimeException("redis操作错误");
        } finally {
            if (jo != null) {
                close(jo);
            }
        }
    }
 
    /**
     * 删除list元素
     */
    public static long delListNode(String  key,int count,String value){
        Jedis jo = null;
        try {
            jo = getJedis();
            return jo.lrem(key,count,value);
        } catch (Exception e) {
            threadLocalJedis.set(null);
            e.printStackTrace();
            logger.error("redis服务器异常",e);
            throw new  RuntimeException("redis操作错误");
        } finally {
            if (jo != null) {
                close(jo);
            }
        }
    }
 
    /**
     * 获取所有list
     */
    public static List getListAll(String key){
        Jedis jo = null;
        List list=null;
        try {
            jo = getJedis();
            list=    jo.lrange(key,0,-1);
        } catch (Exception e) {
            threadLocalJedis.set(null);
            e.printStackTrace();
            logger.error("redis服务器异常",e);
            throw new  RuntimeException("redis操作错误");
        } finally {
            if (jo != null) {
                close(jo);
            }
        }
        return  list;
    }
 
    /**
     * 清理缓存redis
     */
    public void cleanLoacl(Jedis jo){
        threadLocalJedis.set(null);
        close(jo);
    }
 
    public static void close(Jedis jedis) {
        if (threadLocalJedis.get() == null && jedis != null){
            jedis.close();
        }
    }
}
```

前端代码

```
<template>
  <el-upload
    class="upload-demo"
    action="http://192.168.1.120/common/file/upload_big_file_chunk"
    :http-request="uploadFile"
    :headers="headers"
   >
    <el-button size="small" type="primary">点击上传</el-button>
    <div slot="tip" class="el-upload__tip">只能上传jpg/png文件，且不超过500kb</div>
  </el-upload>
</template>
 
<script>
import axios from '../utils/http'
import SparkMD5 from 'spark-md5';
export default {
  name: 'DemoUpload',
 
  data() {
    return {
      headers: {
        Authorization:'bearer 6d8ebfeb-bbd1-4ec1-acbe-c3841fd07315'
      },
 
    };
  },
  mounted() {
 
  },
  methods: {
    uploadFile(param) {
      let file = param.file
      let md5 = 'abcdef'
      this.handlePrepareUpload(file);
      //
    },
    // 计算MD5
    handlePrepareUpload(file) {
      let fileReader = new FileReader();
      let dataFile = file;
      let _this = this
      let spark = new SparkMD5(); //创建md5对象（基于SparkMD5）
      if (dataFile.size > 1024 * 1024*10) {
        let data1 = dataFile.slice(0, 1024 * 1024*10); //将文件进行分块 file.slice(start,length)
        fileReader.readAsBinaryString(data1); //将文件读取为二进制码
      } else {
        fileReader.readAsBinaryString(dataFile);
      }
 
      //文件读取完毕之后的处理
      fileReader.onload = function(e) {
        spark.appendBinary(e.target.result);
        let md5 = spark.end()
        console.log('md5=============',md5)
        // 检验上传
        _this.detection(file,md5)
      };
    },
    // 切割上传
     async upload(file, num,md5) {
       console.log("切割上传=====",num)
       // 计算总片数
       let bytesPerPiece = 10 * 1024 * 1024; // 每个文件切片大小定为10MB
       let totalPieces = Math.ceil(file.size / bytesPerPiece); // 总片数
       if(num==totalPieces){
         return
       }
       // 切割上传
       let nextSize = Math.min((num + 1) * bytesPerPiece, file.size) // 61764222
       let fileData = file.slice(num * bytesPerPiece, nextSize);
       // let currentChunkSize = nextSize-(num * bytesPerPiece)
       let formData = new FormData();
       let param={
         totalChunks:totalPieces,
         chunkNumber:num,
         currentChunkSize:bytesPerPiece
       }
       formData.append("file", fileData);
       formData.append("userId", 271);
       formData.append("fileMd5", md5);
       formData.append("fileName", file.name);
       formData.append("totalChunks", totalPieces);
       formData.append("chunkNumber", num);
       formData.append("currentChunkSize", bytesPerPiece); // currentChunkSize: -10485760
       formData.append("bizId", 0);
       formData.append("bizCode", 2);
       console.log('data==================',param)
       let res = await axios({
         url: 'http://192.168.1.120/common/file/upload_big_file_chunk',
         method: "POST",
         data: formData
       })
       console.log('res======',res)
       if(res.data.data=='001' || res.data.code==200){ // 001
              this.upload(file, ++num,md5);
        }
     },
 
// 检测
    async detection(file,md5) {
      let res = await axios({
        url: 'http://192.168.1.120/common/file/check_before_upload',
        method: "GET",
        params: {
          userId: 271,
          fileMd5: md5
        }
      })
      console.log('res====', res)
      if(res.data.code==200 &&　!res.data.data){ // 不存在data为空
        // 切割上传
        this.upload(file, 0,md5);
      }else if(res.data.code==200 &&　res.data.data){// 已经存在
        let file = res.data.data
        console.log('文件已经存在',file)
      }
    }
}
};
</script>
 
<style >
 
</style>
```

