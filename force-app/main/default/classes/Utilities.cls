//test class UtilitiesTest
public without sharing class Utilities {
public static void sendSMS (Map<String,String>UsersandSubject ){
         
         //Uncomment Below This Line
         list<smagicinteract__smsMagic__c> lstSendSMS = new list<smagicinteract__smsMagic__c>();
         List<user> userList = new List<user>();
         set<String> uSet = UsersandSubject.keySet();
         userList = [SELECT name,mobilephone from user where id =:uSet];
         for(String u: uSet){
             smagicinteract__smsMagic__c smsObjNew = new smagicinteract__smsMagic__c();
             for(user uList : userList ){
                 if(uList.id == u){
                    smsObjNew.smagicinteract__PhoneNumber__c = uList.MobilePhone;
                    smsObjNew.smagicinteract__SMSText__c = UsersandSubject.get(u) ;
                    //smsObjNew.smagicinteract__senderId__c = 'smsMagic';
                    smsObjNew.smagicinteract__senderId__c = '13173155065';
                    smsObjNew.smagicinteract__Name__c = uList.Name;
                    smsObjNew.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                    lstSendSMS.add(smsObjNew);
                 }
             }
          }
          if(lstSendSMS.size()>0){
                if(!Test.isRunningTest())
                insert lstSendSMS;
          } 
             
}


    public static void sendSMS2 (Map<Id,List<String>>UserAndSMS ){
         
         //Uncomment Below This Line
         list<smagicinteract__smsMagic__c> lstSendSMS = new list<smagicinteract__smsMagic__c>();
         List<user> userList = new List<user>();
         userList = [SELECT name,mobilephone from user where id =:UserAndSMS.keySet()];
         for(Id u: UserAndSMS.keySet()){
             for(user uList : userList ){
                 if(uList.id == u && uList.MobilePhone != null){
                    for(String sms : UserAndSMS.get(u)){
                        smagicinteract__smsMagic__c smsObjNew = new smagicinteract__smsMagic__c();
                        smsObjNew.smagicinteract__PhoneNumber__c = uList.MobilePhone;
                        smsObjNew.smagicinteract__SMSText__c = sms;
                        smsObjNew.smagicinteract__senderId__c = '13173155065';
                        smsObjNew.smagicinteract__Name__c = uList.Name;
                        smsObjNew.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                        lstSendSMS.add(smsObjNew);
                    }
                    
                 }
             }
          }
          if(lstSendSMS.size()>0){
                if(!Test.isRunningTest())
                insert lstSendSMS;
          } 
             
    }
    /*
    @InvocableMethod (label='sendSMSDrip')
    public static void sendSMSDrip (List<InvokableParams> UserAndSMS ){
         
        //Uncomment Below This Line
         list<smagicinteract__smsMagic__c> lstSendSMS = new list<smagicinteract__smsMagic__c>();
         Opportunity userList = new Opportunity();
         userList = [SELECT name,Phone__c from Opportunity where id =:UserAndSMS[0].OppID];
         
                 if(userList.Phone__c != null){
                   
                        smagicinteract__smsMagic__c smsObjNew = new smagicinteract__smsMagic__c();
                        smsObjNew.smagicinteract__PhoneNumber__c = userList.Phone__c;
                        smsObjNew.smagicinteract__SMSText__c = UserAndSMS[0].SMSBody;
                        smsObjNew.smagicinteract__senderId__c = '13173155065';
                        smsObjNew.smagicinteract__Name__c = userList.Name;
                        smsObjNew.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                        lstSendSMS.add(smsObjNew);
                    
                    
                 }
          
          if(lstSendSMS.size()>0){
                if(!Test.isRunningTest())
                insert lstSendSMS;
          } 
          
             
    }*/
    
    @InvocableMethod (label='sendSMSDrip')
    public static void sendSMSDrip(List<InvokableParams> UserAndSMS ){
         
        //Uncomment Below This Line
         smagicinteract__smsMagic__c smsObjNew = new smagicinteract__smsMagic__c();
         OpportunityContactRole objContactRole = new OpportunityContactRole();
        list<smagicinteract__smsMagic__c> lstSendSMS = new list<smagicinteract__smsMagic__c>();
       
        if(String.isBlank(UserAndSMS[0].OppPhoneNumber)){
        
            List<OpportunityContactRole > lst = [select id,contactId,
                                opportunityId,Contact.Phone 
                                from OpportunityContactRole where IsPrimary=true 
                                and opportunityId=:UserAndSMS[0].OppID];
            if(lst.isEmpty()){
                return;
            }
            smsObjNew.smagicinteract__PhoneNumber__c = lst[0].Contact.Phone;   
        } 
        else{
             smsObjNew.smagicinteract__PhoneNumber__c = UserAndSMS[0].OppPhoneNumber;
        }
        

                        
        smsObjNew.smagicinteract__SMSText__c = UserAndSMS[0].SMSBody;
        smsObjNew.smagicinteract__senderId__c = '13173155065';
        smsObjNew.smagicinteract__Name__c = UserAndSMS[0].OppName;
        smsObjNew.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
        lstSendSMS.add(smsObjNew);
                           
      if(lstSendSMS.size()>0){
            if(!Test.isRunningTest()){
                  insert lstSendSMS;
            }
          
      } 
          
             
    }

public static void sendEmail (Map<String,Map<String,String>>UsersandSubject ){
         set<String> uSet = UsersandSubject.keySet();
         List<user> userList = new List<user>();
         userList = [SELECT id,email from user where id=:uSet];
         List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
         for(String u: uSet){
             Map<String,String> tempMap = new Map<String,String>();
             tempMap = UsersandSubject.get(u);
             for(String subject : tempMap.keySet()){
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                 for(user uList :userList){
                     if(uList.id == u){
                         List<String> emailList = new List<String>();
                         emailList.add(uList.email);
                         mail.setToAddresses(emailList);
                         mail.setSubject(subject);
                         mail.setPlainTextBody(tempMap.get(subject));
                         mail.setSaveAsActivity(false); 
                         mails.add(mail);
               
                     }
                 }
             }

          }
         Messaging.sendEmail(mails);
} 

    @future
    public static void sendJSONEmail(String jsonString){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();         
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        List<String> emailList = new List<String>();
         emailList.add('chugh.naveen@gmail.com');
         mail.setToAddresses(emailList);
         mail.setSubject('Test JSON String');
         mail.setPlainTextBody(jsonString);
         mail.setSaveAsActivity(false); 
         mails.add(mail);
         
         Messaging.sendEmail(mails);
         
         
    }
    
    public class InvokableParams{
        
        @InvocableVariable
        public ID OppID;
        
        @InvocableVariable
        public String SMSBody;
         
        @InvocableVariable
        public String OppPhoneNumber;
        
        @InvocableVariable
        public String OppName;
    }    
}