<%@page import="javax.jms.QueueSender"%>
<%@page import="javax.jms.Queue"%>
<%@page import="javax.jms.TextMessage"%>
<%@page import="javax.jms.MessageProducer"%>
<%@page import="javax.jms.Destination"%>
<%@page import="javax.jms.QueueSession"%>
<%@page import="javax.jms.QueueConnection"%>
<%@page import="javax.jms.QueueConnectionFactory"%>
<%@page import="com.ejb.session.Converter"%>
<%@page import="javax.rmi.PortableRemoteObject"%>
<%@page import="com.ejb.session.ConverterHome"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	//Test session bean
	/**	
	Properties props = new Properties();
	props.setProperty(Context.INITIAL_CONTEXT_FACTORY, "com.ibm.websphere.naming.WsnInitialContextFactory");
	props.setProperty(Context.PROVIDER_URL, "iiop://localhost:2809/");
	Context ctx = new InitialContext(props);
	Object objref = ctx.lookup("ejb/EJBear/EJBProject.jar/ConverterEJB#com.ejb.session.ConverterHome");
	ConverterHome home = (ConverterHome) PortableRemoteObject.narrow(objref, ConverterHome.class);
	Converter currencyConverter = home.create();
    //invoke EJB method
    double amount = currencyConverter.dollarToYen(100.00);
    System.out.println(String.valueOf(amount));
    amount = currencyConverter.yenToEuro(100.00);
    System.out.println(String.valueOf(amount)); 
    */
    
    //Test message driven bean
	Properties props = new Properties();
	props.setProperty(Context.INITIAL_CONTEXT_FACTORY, "com.ibm.websphere.naming.WsnInitialContextFactory");
	props.setProperty(Context.PROVIDER_URL, "iiop://127.0.0.1:2809/");
	Context context = new InitialContext(props);
    //得到一个JNDI初始化上下文：
    //InitialContext context = new InitialContext();
    //根据上下文查找JMS连接工厂：该连接工厂是由JMS提供的，每个javaEE服务器厂商都为它绑定一个全局的JNDI。
    QueueConnectionFactory factory = (QueueConnectionFactory)context.lookup("jms/MyConnectionFactory");
    Queue queue = (Queue)context.lookup("jms/MyMDBQueue");
    //从连接工厂得到一个JMS连接：
    QueueConnection qConnection = factory.createQueueConnection();
    //通过jms连接创建一个jms会话：以QueueSession(TopicSession类似)为例：第一个参数表示：不需要事务。第二个参数表示：自动确认消息已接收的会话。
    QueueSession qSession = qConnection.createQueueSession(false, QueueSession.AUTO_ACKNOWLEDGE);
	qSession.createSender(queue);
    QueueSender sender = qSession.createSender(queue);
    TextMessage message = qSession.createTextMessage();
    for (int i = 0; i < 10; i++) {
       String messageToSend = "MESSAGE: " + i;
       message.setText(messageToSend);
       // message.setJMSReplyTo(resQueue); // 应答队列
       sender.send(message);
       System.out.println("[dzmonkey] INSIDE JMS SERVLET: MESSAGE -> \"" + message.getText() + "\"");
       String messageID = message.getJMSMessageID();
       boolean bDelivered = message.getJMSRedelivered();
       System.out.println("[dzmonkey] INSIDE JMS SERVLET: MESSAGE ID -> \"" + message.getText() + ":"
                    + messageID + ":" + bDelivered + "\"");
    }
    sender.close();
    qSession.close();
    qConnection.close();    
    //查找消息目标地址：
    //Destination destination = (Destination)context.lookup("jms/myMsgQueue_JMS");
    //根据会话及目标地址来建立消息生产者
    //MessageProducer producer = qsession.createProducer(destination);
    //TextMessage msg = qsession.createTextMessage("hello fwj Queue");
    //producer.send(msg);
    //消息发送完毕后，关闭会话和连接：
    //conn.close();
    //qsession.close();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'index.jsp' starting page</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
  </head>
  
  <body>
    This is my JSP page. <br>
  </body>
</html>
