/*
    Purpose:    this trigger will send sms to intake agent when lead becomes qualified
*/
trigger TrgLeadSendSMSToIntakeAgent on Lead (after update) {
    
    //list for sending sms
    list<smagicinteract__smsMagic__c> lstSendSMS = new list<smagicinteract__smsMagic__c>();    
    
    //monarch shores record type id
    Id LeadRecordTypeID = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
    
    //set of intake agent ids related to lead
    set<id> setIntakeAgentIds = new set<id>();
    
    //list of leads for updating erp qualified queue flag
    list<Lead> lstUpdateLeads = new list<Lead>();
    
    for(Lead ld : trigger.new){     
        //if lead status is qualified erp then add intake agent id to set
        if(!ld.Qualified_ERP_Text_Sent__c && ld.RecordTypeId == LeadRecordTypeID && ld.Status =='ERP'
         && ld.Status != trigger.oldmap.get(ld.id).Status && !ld.IsConverted){                        
            setIntakeAgentIds.add(ld.Opening_Agent__c);
        }        
    }
    if(TriggerContextUtilityAN.isRunOnce()){
        
        TriggerContextUtilityAN.setRunOnceFalse();
        
        if(setIntakeAgentIds.size()>0){
            
            //query user
            map<id,User> mapUsers = new map<id,User>([select id, Name, MobilePhone from User where id in: setIntakeAgentIds ]);
            
            for(Lead ld : trigger.new){ 
                //if lead status is qualified erp then send sms to intake agent
                if(!ld.Qualified_ERP_Text_Sent__c && ld.RecordTypeId == LeadRecordTypeID && ld.Status =='ERP' 
                && ld.Status != trigger.oldmap.get(ld.id).Status && !ld.IsConverted){
                    if(mapUsers.get(ld.Opening_Agent__c)!=null){
                        smagicinteract__smsMagic__c smsObj = new smagicinteract__smsMagic__c();
                        smsObj.smagicinteract__PhoneNumber__c = mapUsers.get(ld.Opening_Agent__c).MobilePhone;//Phone Number to which text is sent
                        smsObj.smagicinteract__SMSText__c = label.Qualified_ERP_Text+' : '+ld.Name;
                        smsObj.smagicinteract__senderId__c = 'smsMagic';
                        smsObj.smagicinteract__Name__c = mapUsers.get(ld.Opening_Agent__c).Name;
                        
                        smsObj.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                        lstSendSMS.add(smsObj);
                        
                        Lead updateLead = new Lead();
                        updateLead.id = ld.id;
                        updateLead.Qualified_ERP_Text_Sent__c = true;
                        lstUpdateLeads.add(updateLead);
                    }
                }   
            }
            
            if(lstSendSMS.size()>0){
                if(!Test.isRunningTest())
                insert lstSendSMS;
            }
            if(lstUpdateLeads.size()>0)
                update lstUpdateLeads;  
        }
    }
}