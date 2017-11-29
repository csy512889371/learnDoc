# 版本
v4.9.2

![image](https://github.com/csy512889371/reactLearn/blob/master/img/tools/postman1.png)
![image](https://github.com/csy512889371/reactLearn/blob/master/img/tools/postman2.png)
# 下载地址

http://download.csdn.net/download/qq_27384769/10134551

# 安装步骤

>* 下载类似Postman_v4.9.2.crx以crx为后缀的文件
>* 改成“zip”或"rar"文件，解压该文件
>* 将文件夹里的“_metadata”文件夹名字改成“metadata”
>* 打开chrome浏览器，单击右上角“≡”图标--> “更多工具” --> “扩展程序”
>* 加载“已解压的扩展程序”，选中解压的文件夹
>* 点击加载后的postman界面上的“启动”即可。

# 通过Postman模拟Json数据并且在服务器端显示的方法

![image](https://github.com/csy512889371/reactLearn/blob/master/img/tools/postmanuse1.png)

![image](https://github.com/csy512889371/reactLearn/blob/master/img/tools/postmanuse2.png)

```java
	@RequestMapping(value="/findById", method=RequestMethod.POST)
	public @ResponseBody ViewerResult findById(@RequestBody JSONObject obj){
		ViewerResult result = new ViewerResult();
		UmsApp app = null;
		try {
			String id = obj.getString("id");
			app = umsAppFacade.getById(id);
			AppVO appVO = new AppVO();
			appVO.convertPOToVO(app);
			result.setSuccess(true);
			result.setData(appVO);
		} catch (Exception e) {
			result.setSuccess(false);
			result.setErrMessage(e.getMessage());
			e.printStackTrace();
		}
		return result;
	}
```


