//Test Class : msInsuranceCaseOwnerUpdateTest
trigger updateCaseOwner on Case (before Insert){
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && 
    Trigger_Custom_Setting__c.getValues('Default').Disable_updateCaseOwner__c == True)
    return;
    
    CaseService.updateCaseEmployee(Trigger.New);
    
    List<Id> oppIdList = new List<Id>();
    for(Case c : Trigger.New){
        if(c.Opportunity__c != null && c.RecordTypeId ==Constants.insuranceClaimRecordTypeId && c.Level_of_Care__c != 'Lab Requests')
            oppIdList.add(c.Opportunity__c);
    }
    
    if(oppIdList.size()>0){
        Date abdulMSTransitionDate = date.newinstance(2019, 6, 9);
        Date abdulCCTransitionDate = date.newinstance(2019, 6, 17);

        for(Opportunity opp : [Select id, Insurance_Collector__c, Sunshine_Center__r.Name from Opportunity where id IN: oppIdList]){
            for(Case c : Trigger.New){
                if(c.Opportunity__c == opp.id && c.RecordTypeId ==Constants.insuranceClaimRecordTypeId){
                    //We put in the following check to assign Only Monarch Claims to Abdul Where Bill From Date is Post 9th June 2019 and
                    //assign Only Chapters Claims to Abdul Where Bill From Date is Post 18th June 2019
                    //As of 9/9/2019, all claims across all programs are assigned to CA Billing LLC for processing.
                    c.OwnerId = label.Abdul_User_ID;
                    c.Original_Case_Owner__c=label.Abdul_User_ID;
                    /*if(((opp.Sunshine_Center__r.name == 'Monarch Shores' || opp.Sunshine_Center__r.name == 'Monarch IOP') && c.Bill_From_Date__c > abdulMSTransitionDate)
                        || (opp.Sunshine_Center__r.name == 'Chapters Capistrano' && c.Bill_From_Date__c > abdulCCTransitionDate)
                        || opp.Sunshine_Center__r.name == 'Mountain Springs Recovery'){ 
                        
                            
                    }
                    else{
                        if(opp.Insurance_Collector__c!= null){
                            c.OwnerId = opp.Insurance_Collector__c;
                            c.Original_Case_Owner__c=opp.Insurance_Collector__c;
                        }
                        
                    }*/
                }
            }
        }
    }
}