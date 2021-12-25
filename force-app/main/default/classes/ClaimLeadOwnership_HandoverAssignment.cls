//Test Class : ClaimLeadOwnership_HandoverAssignTest
global without sharing class ClaimLeadOwnership_HandoverAssignment{
    
     webservice static String ClaimLeadOwnership_HandoverAssignment(String leadId){
         
         system.debug('leadId ::::'+leadId);
         string result;
         string newOwnerId;
         Set<Id> queueIdSet = new Set<Id>();
         
         newOwnerId =String.valueOf(UserInfo.getUserId()).substring(0, 15);
         Lead leadRecord = [select id, ownerid, Lead_Claimed_By_AC_Date_Time__c, Lead_Claimed_By_AC__c from Lead where id=:leadId];
         
         if(UserInfo.getProfileId() != label.AC_Profile_ID){
             result = 'This Lead CAN ONLY Be Claimed by an AC!!';    
         }else{
             if(leadRecord.Lead_Claimed_By_AC__c == False){
                 if(leadRecord.ownerId != newOwnerId && leadRecord.ownerId != label.Closers_Queue_Id){
                     result = 'This Lead CANNOT Be Claimed, as it is not assigne to you nor is it assigned to the Closure Queue!!';
                 }
                 if(leadRecord.ownerId == newOwnerId || leadRecord.ownerId == label.Closers_Queue_Id){
                     if(leadRecord.ownerId == label.Closers_Queue_Id)
                         leadRecord.ownerId = newOwnerId;
                     
                     leadRecord.Lead_Claimed_By_AC_Date_Time__c = dateTime.Now();
                     leadRecord.Lead_Claimed_By_AC__c = True;
                     LeadRecord.Lead_Handover_Claimed_By__c=UserInfo.getUserId();
                     try{
                         update leadRecord;
                         result = 'The Lead is Sucessfully Claimed!!';
                     }catch(exception e){
                         result = 'OOOPS, Some thing went wron while claiming the lead. Please Contact the Admin!!';    
                     } 
                 }
                        
             }else{
                 result = 'This Lead CANNOT Be Claimed, as it has already been claimed by an AC!!';
             }
            
         }
          system.debug('result:'+ result);
          return result;
          
      }

}