global class ClaimLeadOwnership{
    
     webservice static String ClaimLeadOwnership(String leadId){
         
         system.debug('leadId ::::'+leadId);
         string result;
         string newOwnerId;
         Set<Id> queueIdSet = new Set<Id>();
         
         newOwnerId =String.valueOf(UserInfo.getUserId()).substring(0, 15);
         Lead leadRecord = [select id, ownerid, Opening_Agent__c from Lead where id=:leadId];
         for(Group g : [select id from Group where (Name=:'Unassigned Queue' OR Name=:'Intake Queue' OR Name=:'MS Call Queue' OR Name=:'MS Intake Queue' OR Name=:'ERP Call Queue') AND Type =: 'Queue']){
             queueIdSet.add(g.id);
         }
         system.debug('leadRecord :::'+leadRecord);
         system.debug('queueIdSet :::'+queueIdSet);    
         system.debug('newOwnerId :::'+newOwnerId);
         system.debug('current Lead Owner ::::'+leadRecord.OwnerId);    
         
         if(queueIdSet.size()>0){
             if(queueIdSet.contains(leadRecord.OwnerId) == False){
                 result = 'This Lead CANNOT Be Claimed, as it is not owned by Claim Required QUEUE!!';
                           
             }else{
                 leadRecord.ownerId = newOwnerId;
                 leadRecord.Opening_Agent__c  = newOwnerId;
                 try{
                     update leadRecord;
                     result = 'The Lead is Sucessfully Claimed!!';
                 }catch(exception e){
                     result = 'OOOPS, Some thing went wron while claiming the lead. Please Contact the Admin!!';    
                 }
                 
              }
          }else{
              result = 'OOOPS, Some thing went wron while claiming the lead. Please Contact the Admin!!';  
          }
      
          system.debug('result:'+ result);
          return result;
      }

}