package com.ejb.session.client;

import javax.ejb.CreateException;
import javax.naming.*;
import javax.rmi.PortableRemoteObject;

import com.ejb.session.Converter;
import com.ejb.session.ConverterHome;    
 
public class ConverterClient {
  
   public static void main(String[] args) {
       try {
           //  创 建一个 JNDI naming contest
           Context initial = new InitialContext();
          
           //  从 JNDI  中以 MyConverter  名子来定位到对象 ( 在发布名称指定了 JNDI 名称 )
          //  Object objref = initial.lookup("java:comp/env/ejb/ConverterEJB");
           Object objref = initial.lookup("MyConverter");
          
           //  通 过 objref  得到 ConverterHome  本地接口  
           ConverterHome home = (ConverterHome)PortableRemoteObject.narrow(
                   objref, ConverterHome.class);    
          
           //  再 由 Home  接口的 create  方法来创建一个服务器上的 EJB 实例
           Converter currencyConverter = home.create();
          
           //  调 用 EJB  中的方法
           double amount = currencyConverter.dollarToYen(100.00);
           System.out.println(String.valueOf(amount));
           amount = currencyConverter.yenToEuro(100.00);
           System.out.println(String.valueOf(amount));
       } catch(Exception e) {
    	   e.printStackTrace();
       }
   }
}
