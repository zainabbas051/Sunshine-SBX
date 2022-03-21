global class SMSBlast_Batch implements Schedulable{
    
  
        global void execute(SchedulableContext sc) {
            
            List<SMSBlast__c> scope = [Select externalfield__c, Name__c, PhoneNumber__c,senderId__c  , SMSText__c FROM 
                                           SMSBlast__c WHERE IsProcessed__c = FALSE];
             List<smagicinteract__smsMagic__c> lstSendSMS = new list<smagicinteract__smsMagic__c>();
            
            for(SMSBlast__c issms : scope){
               
                smagicinteract__smsMagic__c smsObjNew = new smagicinteract__smsMagic__c();
                smsObjNew.smagicinteract__PhoneNumber__c = string.valueOf(issms.PhoneNumber__c); 
                smsObjNew.smagicinteract__SMSText__c = issms.SMSText__c;
                smsObjNew.smagicinteract__senderId__c = issms.senderId__c;
                smsObjNew.smagicinteract__Name__c = issms.Name__c;
                smsObjNew.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                lstSendSMS.add(smsObjNew);
                issms.IsProcessed__c = true;
               
           }  
           
           insert lstSendSMS;
           update scope;
       }
     
 }