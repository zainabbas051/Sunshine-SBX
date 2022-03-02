//Test Class : bizDevSMSAlertTriggerTest
trigger bizDevSMSAlertTrigger on Lead (after insert, after update) {
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && Trigger_Custom_Setting__c.getValues('Default').Disable_bizDevSMSAlertTrigger__c == True)
    return; 
    
    Map<Id,List<Lead>> referralLeadListMap = new Map<Id,List<Lead>>();
    Map<Id,Id> referralOwnerMap = new Map<Id,Id>();
    Map<Id,String> referralNameMap = new Map<Id,String>();
    Map<id,List<String>> smsMap = new Map<id,List<String>>();
    
    If(trigger.isInsert){
        for(Lead l : Trigger.New){
            if(l.Inbound_Referral__c != null){
                if(referralLeadListMap.containsKey(l.Inbound_Referral__c)){
                    List<Lead> tempList =new List<Lead>();
                    tempList = referralLeadListMap.get(l.Inbound_Referral__c);
                    tempList.add(l);
                    referralLeadListMap.put(l.Inbound_Referral__c,tempList);
                }else{
                    List<Lead> tempList =new List<Lead>();
                    tempList.add(l);
                    referralLeadListMap.put(l.Inbound_Referral__c,tempList);
                }
            }
        }
    }else{
        for(Lead l : Trigger.New){
            if((l.Inbound_Referral__c != null && l.Inbound_Referral__c != Trigger.OldMap.get(l.id).Inbound_Referral__c)
                ||
               (l.Inbound_Referral__c != null && l.Inbound_Referral__c == Trigger.OldMap.get(l.id).Inbound_Referral__c && l.Status != trigger.OldMap.get(l.id).Status)){
                   if(referralLeadListMap.containsKey(l.Inbound_Referral__c)){
                       List<Lead> tempList =new List<Lead>();
                       tempList = referralLeadListMap.get(l.Inbound_Referral__c);
                       tempList.add(l);
                       referralLeadListMap.put(l.Inbound_Referral__c,tempList);
                   }else{
                       List<Lead> tempList =new List<Lead>();
                       tempList.add(l);
                       referralLeadListMap.put(l.Inbound_Referral__c,tempList);
                   }
               }    
        }
    }
    
    if(referralLeadListMap.keySet().isEmpty()==False){
        for(Account a : [Select Id, OwnerId, Name from Account where ID IN: referralLeadListMap.keySet()]){
            referralOwnerMap.put(a.id,a.OwnerId);
            referralNameMap.put(a.id,a.Name);
        }
    }
    
    if(referralOwnerMap.keySet().isEmpty()==False){
        for(id accId : referralLeadListMap.keySet()){
            if(referralOwnerMap.containsKey(accId)){
                for(Lead l : referralLeadListMap.get(accId)){
                    String smsBody = 'Lead '+l.FirstName+' '+l.LastName+' with Referral Account : '+referralNameMap.get(accId)+' is in '+l.Status+' status.';
                    if(smsMap.containsKey(referralOwnerMap.get(accId))){
                        List<String> tempList = new List<String>();
                        tempList = smsMap.get(referralOwnerMap.get(accId));
                        tempList.add(smsBody);
                        smsMap.put(referralOwnerMap.get(accId),tempList);
                    }else{
                        List<String> tempList = new List<String>();
                        tempList.add(smsBody);
                        smsMap.put(referralOwnerMap.get(accId),tempList);
                    }
                }    
            }
        }
    }
    
    if(smsMap.keySet().isEmpty()==False){
        Utilities.sendSMS2(smsMap);
    }
    
}