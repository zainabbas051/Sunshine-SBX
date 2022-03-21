public without sharing class smsBlast_Ctrl {

list<smagicinteract__smsMagic__c> lstSendSMS = new list<smagicinteract__smsMagic__c>();

public class smsMagicParams{
        
    public ID OppID;
    public String SMSBody;
    public String OppPhoneNumber;
    public String OppName;
}  
    

public class recipientObj{
        
        @AuraEnabled
        public ID OppID {get;set;}
         @AuraEnabled
        public String OppPhoneNumber {get;set;}
         @AuraEnabled
        public String OppName {get;set;}
    }  
    
 @AuraEnabled
 public static list<recipientObj> recipientList{
        get{
            if(recipientList == null){
                recipientList = new List<recipientObj>();
            }
            return recipientList;
        }set;
    }  
    

@AuraEnabled
   public static List<recipientObj> getOppList(string SunshineCenter){
         
        List<Opportunity> opportunites = new List<Opportunity>();
        List<recipientObj> recipientObjList = new List<recipientObj>();
        opportunites = OpportunitySelector.getOpportunities(SunshineCenter);
        OpportunityContactRole objContactRole = new OpportunityContactRole();

        for(Opportunity opp : opportunites) {
            recipientObj obj = new recipientObj();
           obj.OppName=opp.Name;
           obj.OppID= opp.Id;
            if(String.isBlank(opp.Phone__c) && opp.OpportunityContactRoles.Size()>0){
  
                obj.OppPhoneNumber = opp.OpportunityContactRoles[0].Contact.Phone;

            } 
            else{
                obj.OppPhoneNumber = opp.Phone__c;
            }
            if(obj.OppPhoneNumber != null)
            recipientObjList.add(obj);
        }
       recipientList = recipientObjList;
       
       return recipientList;
                 
    }
    
    @AuraEnabled
   public static List<SMSBlast__c> SendSMS(String text,String recipientList){
   
           List<recipientObj> rl = (List<recipientObj>)system.JSON.deserializeStrict(recipientList, List<recipientObj>.class);
           
           //smagicinteract__smsMagic__c smsObjNew = new smagicinteract__smsMagic__c();
            //OpportunityContactRole objContactRole = new OpportunityContactRole();
            list<SMSBlast__c> lstSendSMS = new list<SMSBlast__c>();
            for(recipientObj obj:rl){
               /* smsObjNew = new smagicinteract__smsMagic__c();
                smsObjNew.smagicinteract__PhoneNumber__c = obj.OppPhoneNumber; 
                smsObjNew.smagicinteract__SMSText__c = text;
                smsObjNew.smagicinteract__senderId__c = '13173155065';
                smsObjNew.smagicinteract__Name__c = obj.OppName;
                smsObjNew.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                lstSendSMS.add(smsObjNew);*/
                SMSBlast__c smsObjNew = new SMSBlast__c();
                smsObjNew.PhoneNumber__c = obj.OppPhoneNumber;
                smsObjNew.SMSText__c = text;
                smsObjNew.senderId__c = '13173155065';
                smsObjNew.Name__c = obj.OppName;
               // smsObjNew.externalfield__c = smagicinteract.ApexAPI.generateUniqueKey();
                lstSendSMS.add(smsObjNew);
            }
            
            insert lstSendSMS;
            return lstSendSMS; 
   
   }
}