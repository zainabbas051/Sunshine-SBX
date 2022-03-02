//Test Class : updateOppReimbursementRate_Test
trigger updateOppReimbursementRate on Account (after update){

    
   
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && 
    Trigger_Custom_Setting__c.getValues('Default').Disable_updateOppReimbursementRate__c == True)
    return;
    
    List<Id> accId = new List<Id>();
    Map<Id,Account> accountMap = new Map<Id,Account>();
    ID defaultRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Default').getRecordTypeId();
    ID msOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
    List<Opportunity> oppList = new List<Opportunity>();
    List<Opportunity> oppUpdateList = new List<Opportunity>();
    set<ID> oppUpdateIDList = new set<ID>();
    
    for(Account acc : Trigger.New){
        if(acc.Type == 'Insurance Provider' && acc.Reimbursement_Rate_Temp_Flag__c == True && Trigger.OldMap.get(acc.id).Reimbursement_Rate_Temp_Flag__c != acc.Reimbursement_Rate_Temp_Flag__c){
            accId.add(acc.id);
            accountMap.put(acc.id,acc);
        }
    }
    
    if(accId.isEmpty() == False){
        DateTime dateTimeInstance = dateTime.Now().addMonths(-6);
        for(Opportunity opp : [Select id, Cash_Client__c, Insurance_Provider__c, per_Selected_Program__c, Sunshine_Center__r.Name, Sunshine_Center__c 
                                from Opportunity where Insurance_Provider__c IN: accId AND RecordTypeId =: msOppRecordTypeId AND StageName !=: 'Closed' 
                                AND StageName !=: 'Internal Transfer' AND StageName !=: 'Transferred To ERP' AND Sunshine_Center__c !=: null 
                                AND CreatedDate >=: dateTimeInstance]){
            oppList.add(opp);
        }
    }
    
    if(oppList.isEmpty() == False){
        for(Opportunity opp : oppList){
            if(opp.Cash_Client__c == False && opp.Sunshine_Center__c != null && opp.Insurance_Provider__c != null && accountMap.containsKey(opp.Insurance_Provider__c)){
                if(opp.Sunshine_Center__r.Name.contains('Chapter')){
                    opp.per_Selected_Program__c = accountMap.get(opp.Insurance_Provider__c).Chapters_Reimbursement_Rate__c;
                    oppUpdateList.add(opp);
                    oppUpdateIDList.add(opp.id);
                }else if(opp.Sunshine_Center__r.Name.contains('Monarch') || opp.Sunshine_Center__r.Name.contains('Lincoln')){
                    opp.per_Selected_Program__c = accountMap.get(opp.Insurance_Provider__c).Monarch_Reimbursement_Rate__c;
                    oppUpdateList.add(opp);
                    oppUpdateIDList.add(opp.id);
                }else if(opp.Sunshine_Center__r.Name.contains('Willow')){
                    opp.per_Selected_Program__c = accountMap.get(opp.Insurance_Provider__c).Willow_Reimbursement_Rate__c;
                    oppUpdateList.add(opp);
                    oppUpdateIDList.add(opp.id);
                }else if(opp.Sunshine_Center__r.Name.contains('Mountain')){
                    opp.per_Selected_Program__c = accountMap.get(opp.Insurance_Provider__c).Mountain_Reimbursement_Rate__c;
                    oppUpdateList.add(opp);
                    oppUpdateIDList.add(opp.id);
                }
                
            }
        }
    }
    
    if(oppUpdateIDList.size()>0){
        for(Opportunity opp : oppList){
            if(oppUpdateIDList.contains(opp.id)==False){
                opp.per_Selected_Program__c = 0.0;
                oppUpdateList.add(opp);
            }
        }
    }else{
        for(Opportunity opp : oppList){
            opp.per_Selected_Program__c = 0.0;
            oppUpdateList.add(opp);
        }
    }
    
    
    
    if(oppUpdateList.isEmpty() == False){
        
        Trigger_Custom_Setting__c tcs = Trigger_Custom_Setting__c.getValues('Default');
        tcs.Disable_msInsuranceCaseOwnerUpdate__c = True;
        tcs.Disable_daysToClosePopulate__c = True;
        tcs.Disable_MSOpportunityAssignmentTrigger__c = True;
        tcs.Disable_outboundReferralUpdateOnLead__c = True;
        tcs.transferToMSOnCreate_Disable__c = True;
        tcs.Disable_MSNoPaymentPlanText__c = True;
        tcs.Disable_TrgOpportunity__c = True;
        tcs.Disable_UpdateRelatedMRR__c = True;
        tcs.Disable_stagePipelineForcast__c = True;
        tcs.Disable_manageKIPUAuditRecords__c = True;
        update tcs;
        
        
        update oppUpdateList;
        
        tcs.Disable_msInsuranceCaseOwnerUpdate__c = False;
        tcs.Disable_daysToClosePopulate__c = False;
        tcs.Disable_MSOpportunityAssignmentTrigger__c = False;
        tcs.Disable_outboundReferralUpdateOnLead__c = False;
        tcs.transferToMSOnCreate_Disable__c = False;
        tcs.Disable_MSNoPaymentPlanText__c = False;
        tcs.Disable_TrgOpportunity__c = False;
        tcs.Disable_UpdateRelatedMRR__c = False;
        tcs.Disable_stagePipelineForcast__c = False;
        tcs.Disable_manageKIPUAuditRecords__c = False;
        update tcs;
    }
}