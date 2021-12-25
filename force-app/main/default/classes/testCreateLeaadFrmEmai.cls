@isTest(seeAllData = true)
private class testCreateLeaadFrmEmai{

 static testMethod void testCreateLeadFrmEmail() {
        /*Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();

        email.plainTextBody = 'FromEmail';
        env.fromAddress = 'ilovenagpur@gmail.com';

        CreateLeadFrmEmail creatC = new CreateLeadFrmEmail();
        creatC.handleInboundEmail(email, env );*/
        
         Messaging.InboundEmail email = new Messaging.InboundEmail() ;
  Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
  // setup the data for the email
  email.ccAddresses = new String[] {'jsmith@salesforce.com'};
  email.subject = 'Test ZillowEmail';
  email.fromAddress = 'yogi262308@gmail.com';
  env.toAddress=('forwardzillowemail@2ydvi7xh9fe3oh0ltcv8utuk7sxf4czsk9rsxchmloqeky0301.c-9mdleaq.cl.apex.sandbox.salesforce.com');
  email.htmlBody='<html><title>This s A test mail</title><body><table width="99%" border="0" cellpadding="1" cellspacing="0" bgcolor="#EAEAEA"><tr><td><table width="100%" border="0" cellpadding="5" cellspacing="0" bgcolor="#FFFFFF"><tr bgcolor="#EAF2FA"><td colspan="2">    <font style="font-family: sans-serif; font-size:12px;"><strong>Name</strong></font></td></tr><tr bgcolor="#FFFFFF"><td width="20">&nbsp;</td><td>    <font style="font-family: sans-serif; font-size:12px;">naveen test test</font></td></tr><tr bgcolor="#EAF2FA"><td colspan="2">    <font style="font-family: sans-serif; font-size:12px;"><strong>Email</strong></font></td></tr><tr bgcolor="#FFFFFF"><td width="20">&nbsp;</td><td>    <font style="font-family: sans-serif; font-size:12px;"><a>abc@gmail.com</a></font></td></tr><tr bgcolor="#EAF2FA"><td colspan="2">    <font style="font-family: sans-serif; font-size:12px;"><strong>Phone</strong></font></td></tr><tr bgcolor="#FFFFFF"><td width="20">&nbsp;</td><td>    <font style="font-family: sans-serif; font-size:12px;">(675) 675-6757</font></td></tr><tr bgcolor="#EAF2FA"><td colspan="2">    <font style="font-family: sans-serif; font-size:12px;"><strong>Preferred Contact</strong></font></td></tr><tr bgcolor="#FFFFFF"><td width="20">&nbsp;</td><td>    <font style="font-family: sans-serif; font-size:12px;">Email</font></td></tr><tr bgcolor="#EAF2FA"><td colspan="2">    <font style="font-family: sans-serif; font-size:12px;"><strong>Message</strong></font></td></tr><tr bgcolor="#FFFFFF"><td width="20">&nbsp;</td><td>    <font style="font-family: sans-serif; font-size:12px;">this is test message</font></td></tr><tr bgcolor="#EAF2FA"><td colspan="2">    <font style="font-family: sans-serif; font-size:12px;"><strong>Lead Source</strong></font></td></tr><tr bgcolor="#FFFFFF"><td width="20">&nbsp;</td><td>    <font style="font-family: sans-serif; font-size:12px;">Burner Sites</font></td></tr><tr bgcolor="#EAF2FA"><td colspan="2">    <font style="font-family: sans-serif; font-size:12px;"><strong>RT Source</strong></font></td></tr><tr bgcolor="#FFFFFF"><td width="20">&nbsp;</td><td>    <font style="font-family: sans-serif; font-size:12px;">Christian Rehab Facilities</font></td></tr><tr bgcolor="#EAF2FA"><td colspan="2">    <font style="font-family: sans-serif; font-size:12px;"><strong>Call / Web</strong></font></td></tr><tr bgcolor="#FFFFFF"><td width="20">&nbsp;</td><td>    <font style="font-family: sans-serif; font-size:12px;">Web</font></td></tr><tr bgcolor="#EAF2FA"><td colspan="2">    <font style="font-family: sans-serif; font-size:12px;"><strong>Campaign</strong></font></td></tr><tr bgcolor="#FFFFFF"><td width="20">&nbsp;</td><td>    <font style="font-family: sans-serif; font-size:12px;">Christian Rehab Facilities Contact Form</font></td></tr></table></td></tr></table></body></html>';
  test.startTest();
  CreateLeadFrmEmail testInbound=new CreateLeadFrmEmail();
  testInbound.handleInboundEmail(email,env);
       test.stopTest();
    }
    
    }