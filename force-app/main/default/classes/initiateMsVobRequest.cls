//Test Class : initiateMsVobRequestTest
global class initiateMsVobRequest{
    
     webservice static String initiateMsVobRequest(String oppId){
         
         system.debug('oppId ::::'+oppId);
         string result;
         
         Opportunity oppRecord = [select id, Latest_VOB_Request__c, Latest_VOB_Request__r.VOB_Request_Status__c, VOB_Status__c, Insurance_Verified_By__c, 
                                  VOB_Agent__c, Insurance_Verified_Time_Stamp__c from Opportunity where id=:oppId];
         
         system.debug('oppRecord :::'+oppRecord);
         system.debug('oppRecord Latest VOB Request :::'+oppRecord.Latest_VOB_Request__c);    
         system.debug('Latest_VOB_Request__r.VOB_Request_Status__c :::'+oppRecord.Latest_VOB_Request__r.VOB_Request_Status__c);
         
         if(oppRecord.id != null){
             Boolean createVOB = False;
             if(oppRecord.Latest_VOB_Request__c != null){
                 if(oppRecord.Latest_VOB_Request__r.VOB_Request_Status__c != 'Complete'){
                     result = 'VOB for this Opportunity cannot be requested at this time, as a previous INCOMPLETE VOB Request exists. Please have that request completed before requesting another one!!';
                 }else{
                     createVOB = True;    
                 }          
             }else{
                 createVOB = True;
             }
             if(createVOB == True){
                  
                  try{
                     Insurance_Information__c ii = new Insurance_Information__c();
                     for(Insurance_Information__c ins :[select id from Insurance_Information__c where Opportunity__c =: oppRecord.Id AND (Insurance_Status__c =: Null OR Insurance_Status__c =: 'Primary') LIMIT 1]){
                         ii = ins;
                     }
                     TransfertoMSNewCtrl  msnc = new TransfertoMSNewCtrl(oppRecord.id, False);
                     oppRecord.Latest_VOB_Request__c = msnc.initiateVOBRequest(oppRecord.id, ii.id);
                     oppRecord.VOB_Status__c = msnc.initiateVOBTempOpportunity(oppRecord.id).VOB_Status__c ;
                     oppRecord.Insurance_Verified_By__c = msnc.initiateVOBTempOpportunity(oppRecord.id).Insurance_Verified_By__c ;
                     oppRecord.VOB_Agent__c = msnc.initiateVOBTempOpportunity(oppRecord.id).VOB_Agent__c ;
                     oppRecord.Insurance_Verified_Time_Stamp__c = msnc.initiateVOBTempOpportunity(oppRecord.id).Insurance_Verified_Time_Stamp__c ;
                     oppRecord.VOB_Completed__c = msnc.initiateVOBTempOpportunity(oppRecord.id).VOB_Completed__c ;
                     update oppRecord;
                     result = 'The VOB has been successfully Initiated!!';
                  }catch(exception e){
                     result = 'OOOPS, Some thing went wron while Initiating VOB Request. Please Contact the Admin!!';    
                  }
              }
          }else{
              result = 'OOOPS, Some thing went wron while Initiating VOB Request. Please Contact the Admin!!';  
          }
      
          system.debug('result:'+ result);
          return result;
      }

}