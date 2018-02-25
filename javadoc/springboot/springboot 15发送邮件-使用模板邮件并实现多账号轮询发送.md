# 发送邮件-使用模板邮件并实现多账号轮询发送

# 添加依赖
```xml
<!-- mail -->
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-mail</artifactId>
		</dependency>
```
# 配置
```xml
# mail
spring.mail.host: smtp.exmail.qq.com
spring.mail.username:service@ctoEdu.com,education@ctoEdu.com
spring.mail.password:
spring.mail.properties.mail.smtp.auth: true
# 企业qq的邮箱或者是163这类，不建议使用私人qq
```
# 代码实现
实现多账号

```java
/**
 * 实现多账号，轮询发送
 * 
 * @author wujing
 */
@Configuration
@EnableConfigurationProperties(MailProperties.class)
public class EduJavaMailSenderImpl extends JavaMailSenderImpl implements JavaMailSender {

	private ArrayList<String> usernameList;
	private ArrayList<String> passwordList;
	private int currentMailId = 0;

	private final MailProperties properties;

	public EduJavaMailSenderImpl(MailProperties properties) {
		this.properties = properties;

		// 初始化账号
		if (usernameList == null)
			usernameList = new ArrayList<String>();
		String[] userNames = this.properties.getUsername().split(",");
		if (userNames != null) {
			for (String user : userNames) {
				usernameList.add(user);
			}
		}

		// 初始化密码
		if (passwordList == null)
			passwordList = new ArrayList<String>();
		String[] passwords = this.properties.getPassword().split(",");
		if (passwords != null) {
			for (String pw : passwords) {
				passwordList.add(pw);
			}
		}
	}

	@Override
	protected void doSend(MimeMessage[] mimeMessage, Object[] object) throws MailException {

		super.setUsername(usernameList.get(currentMailId));
		super.setPassword(passwordList.get(currentMailId));

		// 设置编码和各种参数
		super.setHost(this.properties.getHost());
		super.setDefaultEncoding(this.properties.getDefaultEncoding().name());
		super.setJavaMailProperties(asProperties(this.properties.getProperties()));
		super.doSend(mimeMessage, object);

		// 轮询
		currentMailId = (currentMailId + 1) % usernameList.size();
	}

	private Properties asProperties(Map<String, String> source) {
		Properties properties = new Properties();
		properties.putAll(source);
		return properties;
	}

	@Override
	public String getUsername() {
		return usernameList.get(currentMailId);
	}

}


```

# 实现发送功能

```java
@Component
publicclass EduJavaMailComponent {
	privatestaticfinal String template = "mail/ctoEdu.ftl";

	@Autowired
	private FreeMarkerConfigurer freeMarkerConfigurer;
	@Autowired
	private EduJavaMailSenderImpl javaMailSender;

	publicvoid sendMail(String email) {
		Map<String, Object>map = new HashMap<String, Object>();
		map.put("email", email);
		try {
			String text = getTextByTemplate(template, map);
			send(email, text);
		} catch (IOException | TemplateException e) {
			e.printStackTrace();
		} catch (MessagingException e) {
			e.printStackTrace();
		}
	}

	private String getTextByTemplate(String template, Map<String, Object>model) throws TemplateNotFoundException, MalformedTemplateNameException, ParseException, IOException, TemplateException {
		return FreeMarkerTemplateUtils.processTemplateIntoString(freeMarkerConfigurer.getConfiguration().getTemplate(template), model);
	}

	private String send(String email, String text) throws MessagingException, UnsupportedEncodingException {
		MimeMessage message = javaMailSender.createMimeMessage();
		MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
		InternetAddress from = new InternetAddress();
		from.setAddress(javaMailSender.getUsername());
		from.setPersonal("ctoedu", "UTF-8");
		helper.setFrom(from);
		helper.setTo(email);
		helper.setSubject("测试邮件");
		helper.setText(text, true);
		javaMailSender.send(message);
		returntext;
	}

}

```
