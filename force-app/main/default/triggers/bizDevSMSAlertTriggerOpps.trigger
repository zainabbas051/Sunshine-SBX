//Test Class : bizDevSMSAlertTriggerTest
trigger bizDevSMSAlertTriggerOpps on Opportunity (after insert, after update) {
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && Trigger_Custom_Setting__c.getValues('Default').Disable_bizDevSMSAlertTriggerOpps__c == True)
    return; 
    
    Map<Id,List<Opportunity>> referralOppListMap = new Map<Id,List<Opportunity>>();
    Map<Id,Id> referralOwnerMap = new Map<Id,Id>();
    Map<Id,String> referralNameMap = new Map<Id,String>();
    Map<id,List<String>> smsMap = new Map<id,List<String>>();
    
    If(trigger.isInsert){
        for(Opportunity o : Trigger.New){
            if(o.Inbound_Referral__c != null){
                if(referralOppListMap.containsKey(o.Inbound_Referral__c)){
                    List<Opportunity> tempList =new List<Opportunity>();
                    tempList = referralOppListMap.get(o.Inbound_Referral__c);
                    tempList.add(o);
                    referralOppListMap.put(o.Inbound_Referral__c,tempList);
                }else{
                    List<Opportunity> tempList =new List<Opportunity>();
                    tempList.add(o);
                    referralOppListMap.put(o.Inbound_Referral__c,tempList);
                }
            }
        }
    }else{
        for(Opportunity o : Trigger.New){
            if((o.Inbound_Referral__c != null && o.Inbound_Referral__c != Trigger.OldMap.get(o.id).Inbound_Referral__c)
                ||
               (o.Inbound_Referral__c != null && o.Inbound_Referral__c == Trigger.OldMap.get(o.id).Inbound_Referral__c && o.StageName != trigger.OldMap.get(o.id).StageName)){
                   if(referralOppListMap.containsKey(o.Inbound_Referral__c)){
                       List<Opportunity> tempList =new List<Opportunity>();
                       tempList = referralOppListMap.get(o.Inbound_Referral__c);
                       tempList.add(o);
                       referralOppListMap.put(o.Inbound_Referral__c,tempList);
                   }else{
                       List<Opportunity> tempList =new List<Opportunity>();
                       tempList.add(o);
                       referralOppListMap.put(o.Inbound_Referral__c,tempList);
                   }
               }    
        }
    }
    
    if(referralOppListMap.keySet().isEmpty()==False){
        for(Account a : [Select Id, OwnerId, Name from Account where ID IN: referralOppListMap.keySet()]){
            referralOwnerMap.put(a.id,a.OwnerId);
            referralNameMap.put(a.id,a.Name);
        }
    }
    
    if(referralOwnerMap.keySet().isEmpty()==False){
        for(id accId : referralOppListMap.keySet()){
            if(referralOwnerMap.containsKey(accId)){
                for(Opportunity o : referralOppListMap.get(accId)){
                    String smsBody = 'Opportunity '+o.Name+' with Referral Account : '+referralNameMap.get(accId)+' is in '+o.StageName+' stage.';
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