//Test Class : msInsuranceCaseOwnerUpdateTest
trigger updateOpportunityFlag on Case (after insert, after update) {


if(trigger.isupdate){

 For(Case c : Trigger.New){
        if(c.Status =='Underpaid' && Trigger.oldMap.get(c.id).status!='Underpaid'){
           
               if (c.isClosed != true){  
               String sText = '{'+c.Ownerid+'} case: '+c.CaseNumber+' is marked as Underpaid.';
               ConnectApiHelper.postFeedItemWithMentions(null, c.id, sText);
               
            }
        }
    }



}
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && 
    Trigger_Custom_Setting__c.getValues('Default').updateOpportunityFlag_Disable__c == True)
    return;
    
    List<Case> allCaseList = new List<Case>();
    Set<Id> oppIdSet = new Set<Id>();
    Map<Id,List<Case>> caseOppIdMap = new Map<Id,List<Case>>();
    //List<Opportunity> oppUpdateList = new List<Opportunity>();
    Map<ID,Opportunity> mapOfOpportunity = new Map<ID,Opportunity>();

    For(Case c : Trigger.New){
        if(c.RecordTypeId ==Constants.insuranceClaimRecordTypeId && c.Level_of_Care__c!='Lab Requests'){
            if(trigger.isInsert){
               if (c.isClosed != true){  
                    Opportunity opp = new Opportunity(id=c.Opportunity__c,All_Related_Insurance_Cases_Closed__c = False);
                    //oppUpdateList.add(opp); 
                    mapOfOpportunity.put(opp.ID,opp);
               }
            }else{
                    if (c.isClosed != trigger.oldMap.get(c.id).isClosed )
                        oppIdSet.add(c.Opportunity__c);
            }
        }
    }
    
    if(oppIdSet.size()>0){
        for(Case c : [Select id, Opportunity__c,Level_of_Care__c, isClosed from Case where Opportunity__c IN: oppIdSet AND RecordTypeId =:Constants.insuranceClaimRecordTypeId AND Level_of_Care__c!='Lab Requests']){
            if(caseOppIdMap.containsKey(c.Opportunity__c)){
                List<Case> tempList = new List<Case>();
                tempList = caseOppIdMap.get(c.Opportunity__c);
                tempList.add(c);
                caseOppIdMap.put(c.Opportunity__c,tempList);
            }else{
                List<Case> tempList = new List<Case>();
                tempList.add(c);
                caseOppIdMap.put(c.Opportunity__c,tempList);
            }
        }
    }
    if(caseOppIdMap.keySet().size()>0){
        for(id oppId : oppIdSet){
            if(caseOppIdMap.containsKey(oppId)){
                Boolean openFlag=False;
                for(case c : caseOppIdMap.get(oppId)){
                    if(c.Level_of_Care__c!='Lab Requests')
                    if(c.isClosed == False)
                        openFlag = True;    
                }
                if(openFlag == false){
                    Opportunity opp = new Opportunity(id=oppId,All_Related_Insurance_Cases_Closed__c = True);
                    //oppUpdateList.add(opp);
                    if(mapOfOpportunity.containsKey(opp.ID) == false)
                        mapOfOpportunity.put(opp.ID,opp);
                }
                else{
                    Opportunity opp = new Opportunity(id=oppId,All_Related_Insurance_Cases_Closed__c = false);
                    //oppUpdateList.add(opp);
                    if(mapOfOpportunity.containsKey(opp.ID) == false)
                        mapOfOpportunity.put(opp.ID,opp);
                }
                
            }
    
        }
    }   
    update mapOfOpportunity.values();
    }