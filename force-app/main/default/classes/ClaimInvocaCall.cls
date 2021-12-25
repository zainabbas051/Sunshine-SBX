//Test Class : ClaimInvocaCallTest
global class ClaimInvocaCall{
    
     webservice static String ClaimInvocaCall(String callId){
         system.debug('callId::::'+callId);
         string result;
         string newOwnerId;
         Set<Id> queueIdSet = new Set<Id>();
         newOwnerId =String.valueOf(UserInfo.getUserId()).substring(0, 15);
         
         INVOCA_FOR_SF__Invoca_Call_Log__c callLogRecord;
         
         if(callId != null){
             for(INVOCA_FOR_SF__Invoca_Call_Log__c call : [select id, ownerId, Call_Claimed__c, Call_Claimed_Date_Time__c, INVOCA_FOR_SF__Lead__c, INVOCA_FOR_SF__Lead__r.OwnerId from INVOCA_FOR_SF__Invoca_Call_Log__c where id=: callId]){
                 callLogRecord = call;    
             }
         }
         
         for(Group g : [select id from Group where (Name=:'Unassigned Queue' OR Name=:'Intake Queue' OR Name=:'MS Call Queue' OR Name=:'ERP Call Queue') AND Type =: 'Queue']){
             queueIdSet.add(g.id);
         }
         
         if(callLogRecord.id != null){
             if(callLogRecord.Call_Claimed__c == True){
                 result = 'This Call Has Already Been Claimed!!';
             }else{
                 callLogRecord.ownerId = newOwnerId;
                 callLogRecord.Call_Claimed__c = True;
                 callLogRecord.Call_Claimed_Date_Time__c = dateTime.Now();  
                 
                 
                 try{
                     update callLogRecord;
                     if(queueIdSet.contains(callLogRecord.INVOCA_FOR_SF__Lead__r.OwnerId) == True){
                         Lead tempLead = new lead();
                         tempLead.id = callLogRecord.INVOCA_FOR_SF__Lead__c;
                         tempLead.ownerId = newOwnerId;
                         tempLead.Opening_Agent__c  = newOwnerId;
                         update tempLead;
                      }
                    
                     result = 'The Call is Sucessfully Claimed!!';
                 }catch(exception e){
                     result = 'OOOPS, Some thing went wron while claiming the call. Please Contact Naveen on Chatter!!';    
                 }  
             }    
          }else{
              result = 'OOOPS, Some thing went wron while claiming the call. Please Contact the Naveen on Chatter!!';  
          }
      
          system.debug('result:'+ result);
          return result;
    }
}