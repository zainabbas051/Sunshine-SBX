//Test Class : initiateVobOnRelatedOpportunityTest
trigger initiateVobOnRelatedOpportunity on Insurance_Information__c (after insert, after update) {
    
    Map<Id, List<Insurance_information__c>> opportunityInsuranceListMap = new Map<Id,List<Insurance_information__c>>();
    
    for(Insurance_Information__c ii : Trigger.New){
        if(ii.Related_Opportunity_VOB_Status__c=='Completed'){
            if(opportunityInsuranceListMap.containsKey(ii.Opportunity__c)){
                List<Insurance_Information__c> tempList = new List<Insurance_Information__c>();
                tempList = opportunityInsuranceListMap.get(ii.Opportunity__c);
                tempList.add(ii);
                opportunityInsuranceListMap.put(ii.opportunity__c, tempList);
            }else{
                List<Insurance_Information__c> tempList = new List<Insurance_Information__c>();
                tempList.add(ii);
                opportunityInsuranceListMap.put(ii.opportunity__c, tempList);
            }
        }
    }
    
    if(opportunityInsuranceListMap.keySet().size()!=null){
        List<Opportunity> oppUpdateList = new List<Opportunity>();
        for(Id oppId : opportunityInsuranceListMap.keySet()){
            TransfertoMSNewCtrl  msnc = new TransfertoMSNewCtrl(oppId, False);
            Opportunity tempOpp = new Opportunity(); 
            tempOpp = msnc.initiateVOBTempOpportunity(oppId);
            tempOpp.Latest_VOB_Request__c = msnc.initiateVOBRequest(oppId, opportunityInsuranceListMap.get(oppId)[0].id); 
            oppUpdateList.add(tempOpp);
        }
        
        if(oppUpdateList.size()>0)
            update oppUpdateList;
    }
    
}