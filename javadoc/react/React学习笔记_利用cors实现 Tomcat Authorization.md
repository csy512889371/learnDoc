# js跨域访问得到 headers 中的Authorization

## 1. js 代码

```javascript
const authorization = () => {
    const user = loginUser();
    let Authorization = {};
    Authorization.appSn = appSn;
    user && (Authorization.token = user.token);
    return JSON.stringify(Authorization);
};

const headers = () => {
    let headers = new Headers();
    headers.append("Content-Type", "application/json");
    headers.append("Accept", "application/json");
    headers.append("Authorization", authorization());
    return headers;
};

const reqGetBrace = (method) => {
    return {
        method: method,
        headers: headers(),
        mode: 'cors',
        cache: 'default'
    };
};

const reqPostBrace = (method, params = {}) => {
    let postBody = {
        method: method,
        headers: headers(),
        mode: 'cors',
        cache: 'default',
        body: JSON.stringify(params)
    };
    return postBody;
};
```
## 引入jar
```xml
<cors-filter.version>2.6</cors-filter.version>

<dependency>
	<groupId>com.thetransactioncompany</groupId>
	<artifactId>cors-filter</artifactId>
	<version>${cors-filter.version}</version>
</dependency>
```


## 配置web.xml 

```xml
<filter>
        <filter-name>CORS</filter-name>
        <filter-class>com.thetransactioncompany.cors.CORSFilter</filter-class>
        <init-param>
            <param-name>cors.allowOrigin</param-name>
            <param-value>*</param-value>
        </init-param>
        <init-param>
            <param-name>cors.supportedMethods</param-name>
            <param-value>GET, POST, HEAD, PUT, DELETE</param-value>
        </init-param>
        <init-param>
            <param-name>cors.supportedHeaders</param-name>
            <param-value>Accept, Origin, X-Requested-With, Content-Type, Last-Modified, Authorization</param-value>
        </init-param>
        <init-param>
            <param-name>cors.exposedHeaders</param-name>
            <param-value>Set-Cookie</param-value>
        </init-param>
        <init-param>
            <param-name>cors.supportsCredentials</param-name>
            <param-value>true</param-value>
        </init-param>
    </filter>
    <filter-mapping>
        <filter-name>CORS</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

```
