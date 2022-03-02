//Test CLass :  outboundReferralUpdateOnLeadTest
trigger outboundReferralUpdateOnLead on Opportunity (after update) {

    if(Trigger_Custom_Setting__c.getValues('Default') != null && Trigger_Custom_Setting__c.getValues('Default').Disable_outboundReferralUpdateOnLead__c == True)
    return;    
    List<Lead> leadUpdateList = new List<Lead>();
    Map<Id,Lead> leadIdMap = new Map<Id,Lead>();
    for(Opportunity o : Trigger.new){
        
        if(o.Lead_Id__c != null && o.Outbound_Referral__c != Trigger.OldMap.get(o.id).Outbound_Referral__c){
            Lead l = new Lead(id = o.Lead_id__c);
            l.Outbound_Referral__c = o.Outbound_Referral__c;
            leadIdMap.put(l.id,l);
            //leadUpdateList.add(l);
        }
        
        if(o.Lead_Id__c != null && o.Inbound_Referral__c != Trigger.OldMap.get(o.id).Inbound_Referral__c){
            if(leadIdMap.containsKey(o.Lead_Id__c)){
                Lead tempLead = new Lead();
                tempLead = leadIdMap.get(o.Lead_Id__c);
                tempLead.Inbound_Referral__c = o.Inbound_Referral__c;
                leadIdMap.put(tempLead.id,tempLead);
            }else{
                Lead l = new Lead(id = o.Lead_id__c);
                l.Inbound_Referral__c = o.Inbound_Referral__c;
                leadIdMap.put(l.id,l);
            }
        }
        
    }
    
    if(leadIdMap.size()>0){
        for(id key : leadIdMap.keySet()){
            leadUpdateList.add(leadIdMap.get(key));
        }
    }
    
    if(leadUpdateList.size()>0){
        Update leadUpdateList;
    }
}