/*
 TestClass: UpdateRelatedMRRTest
*/
trigger UpdateRelatedMRR on Opportunity (after update) {
    if(Trigger_Custom_Setting__c.getValues('Default') != null && 
    Trigger_Custom_Setting__c.getValues('Default').Disable_UpdateRelatedMRR__c   == True)
    return;
  
     Map<ID,Opportunity> mapOfOpptyID = new Map<ID,Opportunity>();
  for(Opportunity opp : trigger.new){
        
         if(opp.Assigned_Medical_Records_Associate__c!= trigger.oldmap.get(opp.id).Assigned_Medical_Records_Associate__c && trigger.oldmap.get(opp.id).Assigned_Medical_Records_Associate__c != null)
        
        {
            
           mapOfOpptyID.put(opp.ID,opp);
         }
  }
  
  if(mapOfOpptyID.isEmpty()== true) return;
  
  List<Insurance_Claim_Medical_Records_Request__c > lstInsuranceClaimMRR = [Select id, OwnerId,Status__c,Related_Case__c ,Related_Case__r.Opportunity__c
                                                                         from Insurance_Claim_Medical_Records_Request__c where Related_Case__r.Opportunity__c IN :  mapOfOpptyID.keySet() 
                                                                         and Status__c != 'Closed'];
  
  for(Insurance_Claim_Medical_Records_Request__c iInsClaim : lstInsuranceClaimMRR ){
    
        iInsClaim.OwnerId = mapOfOpptyID.get(iInsClaim.Related_Case__r.Opportunity__c).Assigned_Medical_Records_Associate__c;
  }
  
  update lstInsuranceClaimMRR ;
 

}