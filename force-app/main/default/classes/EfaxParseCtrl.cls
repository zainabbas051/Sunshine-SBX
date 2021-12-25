/*
Author : Danish
Date : 6/6/2018
Description : Send request to Efax Server and parse Response
Test Class : EfaxParseCtrl_Test
*/
public class EfaxParseCtrl{
   
    static EFax_Log__c eFaxLog;
   
    public EfaxParseCtrl(){
     
    }
    
    public static EFax_Log__c EfaxeOutBounReadRequest_Rest(string aPdfBlobContent,string aDispatchEmail,string aDispatchName, string aFaxNum){
        
        //XML is coming from static resource
         
            HttpRequest req = new HttpRequest();
            EFax_Setting__c eFax =  EFax_Setting__c.getValues('Freepu');
          
            //endpoint URL
          req.setEndpoint('https://secure.efaxdeveloper.com/EFax_WebFax.serv');
       
          string XML = CreateXML(aPdfBlobContent,aDispatchEmail,aDispatchName,aFaxNum);
         
          String body = 'id='+eFax.Account_ID__c+'&xml='+EncodingUtil.URLENCODE(XML,'UTF-8')+'&respond=XML';
        
          req.setbody(body);
          req.setMethod('POST');
          req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
          HttpResponse res = new HttpResponse();
          Http http = new Http();
         
          res = (Test.isRunningTest()?new HttpResponse():http.send(req));
          System.debug(res.getBody());
          Dom.Document doc;
          if(test.isRunningTest()){
                doc= new DOM.Document();
                doc.load('<?xml version="1.0"?> <OutboundResponse> <Transmission> <TransmissionControl> <TransmissionID></TransmissionID> <DOCID>42971201</DOCID> </TransmissionControl> <Response> <StatusCode>1</StatusCode> <StatusDescription>Success</StatusDescription> </Response> </Transmission> </OutboundResponse>');
          }
          else{
                doc = res.getBodyDocument();
          }
        
          return ReadOutBoundResponse(doc);
    }
    
    
    
    public static string CreateXML(string aPdfBlobContent,string aDispatchEmail,string aDispatchName, string aFaxNum){
        
        
        EFax_Setting__c eFax =  EFax_Setting__c.getValues('Freepu');
        
        Dom.Document doc = new Dom.Document();
        Dom.Xmlnode rootNode = doc.createRootElement('OutboundRequest', null, null);
        Dom.Xmlnode headerNode = rootNode.addChildElement('AccessControl', null, null);
        Dom.Xmlnode childNode1 = headerNode.addChildElement('UserName', null, null);
        Dom.Xmlnode childNode1Val = childNode1.addTextNode(eFax.User_Name__c);
        Dom.Xmlnode childNode2 = headerNode.addChildElement('Password', null, null);
        Dom.Xmlnode childNode2Val = childNode2.addTextNode(eFax.Password__c);
       
       
        Dom.Xmlnode headerNode1 = rootNode.addChildElement('Transmission', null, null);    
        childNode1 = headerNode1.addChildElement('TransmissionControl', null, null);   
        childNode2 = childNode1.addChildElement('Resolution', null,null);
        childNode2Val = childNode2.addTextNode('STANDARD');
        
        Dom.Xmlnode headerNode2 = headerNode1.addChildElement('DispositionControl', null, null);    
        childNode1 = headerNode2.addChildElement('DispositionLevel', null, null);
        childNode1Val = childNode1.addTextNode('BOTH');
        childNode1 = headerNode2.addChildElement('DispositionMethod', null, null);
        childNode1Val = childNode1.addTextNode('EMAIL');
        
        childNode1 = headerNode2.addChildElement('DispositionEmails', null, null);
        childNode2 = childNode1.addChildElement('DispositionEmail', null,null);
        Dom.Xmlnode childNode3 = childNode2.addChildElement('DispositionRecipient',null,null);
        Dom.Xmlnode childNode3Val = childNode3.addTextNode(aDispatchName);
        Dom.Xmlnode childNode4 = childNode2.addChildElement('DispositionAddress',null,null);
        Dom.Xmlnode childeNode4Val = childNode4.addTextNode(aDispatchEmail);
        
        Dom.Xmlnode headerNode3 = headerNode1.addChildElement('Recipients', null, null); 
         childNode1 = headerNode3.addChildElement('Recipient', null, null);
         childNode2 = childNode1.addChildElement('RecipientName' , null,null);
         childNode2Val = childNode2.addTextNode('Test Recipient');
          childNode3 = childNode1.addChildElement('RecipientCompany' ,null,null);
         childNode3Val = childNode3.addTextNode('Test Company');
           childNode4 = childNode1.addChildElement('RecipientFax',null,null);
          childeNode4Val = childNode4.addTextNode(aFaxNum);
          
           Dom.Xmlnode headerNode4 = headerNode1.addChildElement('Files', null, null); 
           childNode1 = headerNode4.addChildElement('File', null, null);
           childNode2 = childNode1.addChildElement('FileContents' , null,null);
            childNode2Val = childNode2.addTextNode(aPdfBlobContent);
            childNode3 = childNode1.addChildElement('FileType' ,null,null);
            childNode3Val = childNode3.addTextNode('pdf');
         
         
         
        
        
        String xmlString = doc.toXmlString();
        return xmlString;
        //System.debug('xmlString =' + xmlString);
        
         
        
        
     
    }
    
    public static EFax_Log__c  ReadOutBoundResponse(Dom.Document aDoc){
     
         Dom.XMLNode ordDtls = aDoc.getRootElement();
         Dom.XMLNode tranmissionNode = ordDtls.getChildElement('Transmission', null);
         Dom.XMLNode ResponseNode = tranmissionNode.getChildElement('Response', null);
         Dom.XMLNode TransmissionControlNode = tranmissionNode.getChildElement('TransmissionControl', null);
         eFaxLog = new EFax_Log__c();
         
         string DOCID = TransmissionControlNode.getChildElement('DOCID', null).getText();
         string statusCode = ResponseNode.getChildElement('StatusCode', null).getText();
         string statusDesc = ResponseNode.getChildElement('StatusDescription', null).getText();
         
         eFaxLog.Status_Code__c = decimal.valueOf(statusCode);
         eFaxLog.Status_Description__c = statusDesc;
         eFaxLog.DOCID__c = DOCID;
         
         system.debug('^^^^^' + TransmissionControlNode.getChildElement('DOCID', null).getText());
         system.debug('^^^^^' + ResponseNode.getChildElement('StatusCode', null).getText());
         
         //OutboundStatusRequest(DOCID);
         return eFaxLog;
            
         
        //string StatusCode = 
    }
  
}