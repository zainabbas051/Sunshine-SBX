/*
Author : Zain Abbas
Date : 26/11/2021
Description : Trigger on Lead object, check if the lead is Premium or not.
*/
trigger PremiumLeadTrg on Lead (before insert, before update) {
    //Iterating over Lead records going to insert/update
    for(Lead l: trigger.new){
        //If the lead is inserting, only check "Insurance Provider" field is not empty
        if(trigger.isInsert){
            //Call the method of class for checking Premium Lead
            if(!string.isBlank(l.Insurance_Providors__c) || l.leadsource != null){
                LeadInsuranceKeywordUtil.updatePremiumLeads(trigger.new);
            }
        }
        //If the lead is updating, check "Insurance Provider" field is not empty
        //Also it is changed then previous value just to avoid duplicate execution of trigger
        else if(trigger.isUpdate){
            //Call the method of class for checking Premium Lead
            if((!string.isBlank(l.Insurance_Providors__c) && l.Insurance_Providors__c != trigger.oldMap.get(l.id).Insurance_Providors__c)
              	|| (l.leadSource != null && l.LeadSource != trigger.oldMap.get(l.id).LeadSource)){
                LeadInsuranceKeywordUtil.updatePremiumLeads(trigger.new);
            }
        }
    }

}