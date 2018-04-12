# smack


## pom

```
<dependencies>
        <dependency>
            <groupId>org.igniterealtime.smack</groupId>
            <artifactId>smack-java7</artifactId>
            <version>4.2.0</version>
        </dependency>
        <dependency>
            <groupId>org.igniterealtime.smack</groupId>
            <artifactId>smack-tcp</artifactId>
            <version>4.2.0</version>
        </dependency>
        <dependency>
            <groupId>org.igniterealtime.smack</groupId>
            <artifactId>smack-im</artifactId>
            <version>4.2.0</version>
        </dependency>
        <dependency>
            <groupId>org.igniterealtime.smack</groupId>
            <artifactId>smack-extensions</artifactId>
            <version>4.2.0</version>
        </dependency>

    </dependencies>
```

## SmackService


```
public class SmackService implements Serializable {
    private static final long serialVersionUID = -7478680877851293614L;
    private SmackConfig smackConfig;

    public SmackService(SmackConfig smackConfig) {
        this.smackConfig = smackConfig;
    }

    private AbstractXMPPConnection createConnect(CharSequence username, String password, String xmppServiceDomain) throws UnknownHostException, XmppStringprepException {
        InetAddress inetAddress = InetAddress.getByName(this.smackConfig.getServerIp());
        XMPPTCPConnectionConfiguration config = ((Builder)((Builder)((Builder)((Builder)((Builder)((Builder)((Builder)((Builder)XMPPTCPConnectionConfiguration.builder().setXmppDomain(xmppServiceDomain)).setUsernameAndPassword(username, password)).setSecurityMode(SecurityMode.disabled)).setHostAddress(inetAddress)).setPort(this.smackConfig.getMsgPort())).setDebuggerEnabled(true)).setSendPresence(true)).setDebuggerEnabled(true)).setCompressionEnabled(true).build();
        return new XMPPTCPConnection(config);
    }

    public void broadcastMsgToJids(CharSequence username, String password, String xmppServiceDomain, List<Jid> jidList, String subject, String body) throws XMPPException, InterruptedException, IOException, SmackException {
        AbstractXMPPConnection connection = this.createConnect(username, password, xmppServiceDomain);
        connection.connect();
        connection.login();
        Message message = new Message();
        Iterator var9 = jidList.iterator();

        while(var9.hasNext()) {
            Jid jid = (Jid)var9.next();
            message.setTo(jid);
            message.setBody(body);
            message.setSubject(subject);
            connection.sendStanza(message);
        }

        connection.disconnect();
    }

    public void broadcastMsgToAll(CharSequence username, String password, String xmppServiceDomain, String subject, String body) throws XMPPException, IOException, InterruptedException, SmackException {
        AbstractXMPPConnection connection = this.createConnect(username, password, xmppServiceDomain);
        connection.connect();
        connection.login();
        Message message = new Message();
        message.setTo(JidCreate.from("all@broadcast." + this.smackConfig.getServerIp()));
        message.setBody(body);
        message.setSubject(subject);
        connection.sendStanza(message);
        connection.disconnect();
    }
}

```


## 配置
```
@Component
@Data
public class MessageCenterParam {
    @Value("${smack.serverIp}")
    private String serverIp;
    @Value("${smack.domain}")
    private String domain;
    @Value("${smack.msgPort}")
    private int msgPort;
    @Value("${smack.adminAccount}")
    private String adminAccount;
    @Value("${smack.adminPwd}")
    private String adminPwd;

    public MessageCenterParam() {
    }

}

```


```

@Configuration
public class MessageCenterConfig {
    @Autowired
    MessageCenterParam messageCenterParam;

    public MessageCenterConfig() {
    }

    @Bean
    public SmackService smackService() {
        SmackConfig smackConfig = new SmackConfig();
        smackConfig.setDomain(this.messageCenterParam.getDomain());
        smackConfig.setMsgPort(this.messageCenterParam.getMsgPort());
        smackConfig.setServerIp(this.messageCenterParam.getServerIp());
        return new SmackService(smackConfig);
    }
}
```



