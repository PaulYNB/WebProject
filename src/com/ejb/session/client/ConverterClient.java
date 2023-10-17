package com.ejb.session.client;

import javax.ejb.CreateException;
import javax.naming.*;
import javax.rmi.PortableRemoteObject;

import com.ejb.session.Converter;
import com.ejb.session.ConverterHome;    
 
public class ConverterClient {
  
   public static void main(String[] args) {
       try {
           //  �� ��һ�� JNDI naming contest
           Context initial = new InitialContext();
          
           //  �� JNDI  ���� MyConverter  ��������λ������ ( �ڷ�������ָ���� JNDI ���� )
          //  Object objref = initial.lookup("java:comp/env/ejb/ConverterEJB");
           Object objref = initial.lookup("MyConverter");
          
           //  ͨ �� objref  �õ� ConverterHome  ���ؽӿ�  
           ConverterHome home = (ConverterHome)PortableRemoteObject.narrow(
                   objref, ConverterHome.class);    
          
           //  �� �� Home  �ӿڵ� create  ����������һ���������ϵ� EJB ʵ��
           Converter currencyConverter = home.create();
          
           //  �� �� EJB  �еķ���
           double amount = currencyConverter.dollarToYen(100.00);
           System.out.println(String.valueOf(amount));
           amount = currencyConverter.yenToEuro(100.00);
           System.out.println(String.valueOf(amount));
       } catch(Exception e) {
    	   e.printStackTrace();
       }
   }
}
