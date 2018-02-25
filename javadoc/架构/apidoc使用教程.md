# apidoc使用教程

在开发后台接口的过程中，我们肯定要提供一份api接口文档给终端app。
目前大多数的app的接口请求应该都是http+json的方式。 
但是一直苦于做不出份漂亮的api文档，用word写，也太丑了。。怎么才能做出一份像腾讯、新浪微博等各种开放api平台那样漂亮的api文档呢？apidoc。

> 官网地址：http://apidocjs.com

> 开放API已经成为当下主流平台的一个要素，特别对于社交、电商类的平台开放API更成为了竞争力的一种。开放API文档的完整性、可阅读性往往影响着接入方是否能顺利地、快速地接入到平台，一份好的、统一的API文档也是开放平台不可或缺的要素。

>* apidoc是通过源码中的注释来生成API文档，所以只要识别兼容现今大部分流行语言的注释方法便达到了兼容语言的效果。
>* 有了它，我们只需要在写源码的时候顺手写上一些简单的注释，就可以生成出漂亮的文档了（当然，有同学会问文档不是先定义的吗？你把接口的源码声明好不就ok啦？写个简单的，然后用apidoc生成一下就出文档了)
>* 它可以对API的各种版本等级进行对比。所以无论是前端开发人员还是你都可以追溯API版本的变化

## 1、使用步骤
>* 安装nodejs。去http://www.nodejs.org/下载安装一个nodejs
>* 安装apidoc：命令行输入：npm install apidoc -g    貌似是在线安装的，稍等一下即可。
>* 准备一个目录myapp，下面放源码文件，源码文件中要按照apidoc的规范写好注释。具体规范参见官网，我这里就不翻译了。
例如我写java的源码：

```java
/** 
 * 此接口不要去实现，仅作为输出api文档用的 
 * @author xumin 
 * 
 */  
@Deprecated  
public interface ApiDoc {  
    /** 
     *  
     * @api {get} /company/list 获取公司信息 
     * @apiName 获取公司列表 
     * @apiGroup All 
     * @apiVersion 0.1.0 
     * @apiDescription 接口详细描述 
     *  
     * @apiParam {int} pageNum分页大小  
     *  
     * @apiSuccess {String} code 结果码 
     * @apiSuccess {String} msg 消息说明 
     * @apiSuccess {Object} data 分页数据封装 
     * @apiSuccess {int} data.count 总记录数 
     * @apiSuccess {Object[]} data.list 分页数据对象数组 
     * @apiSuccessExample Success-Response: 
     *  HTTP/1.1 200 OK 
     * { 
     * code:0, 
     * msg:'success', 
     * data:{} 
     *  } 
     *   
     *  @apiError All 对应<code>id</code>的用户没找到 asdfasdf  
     *  @apiErrorExample {json} Error-Response: 
     *  HTTP/1.1 404 Not Found 
     *  { 
     *   code:1, 
     *   msg:'user not found', 
     *   } 
     *    
     * @param param 
     * @return 
     * @throws Exception 
     */  
    void a();  
}  

```

> 生成api文档

```javascript
apidoc -i myapp/ -o apidoc/ -t mytemplate/
```
>* myapp是当前工作目录下的源码目录
>* apidoc是用于存放生成出的文档文件的目录
>* mytemplate是自定义模板文件夹，刚开始用，可以不指定，后面有需要了再研究怎么自定义模板吧
>* 如果看到“success: Done.”说明生成成功 ，到 apidoc目录下打开index.html查看生成的文档.




![image](https://github.com/csy512889371/reactLearn/blob/master/img/tools/ApiDoc.png)
