//Test Class : squeezeThePulpOpportunityTest
global class squeezeThePulpOpportunity{
    
     webservice static String squeezeThePulpOpportunity(String oppId, string ownerId, string oppName, String accountId){
         system.debug('oppId::::'+oppId);
         string result;
         string newOwnerId='';
         
         Integer index=0;
         Integer lastAssignedIndex=0;
         
         Integer nextAssignIndex=0;
         List<Squeeze_the_Pulp_User_Details__c> spList = Squeeze_the_Pulp_User_Details__c.getall().values();
         List<Squeeze_the_Pulp_User_Details__c> spUpdateList = new List<Squeeze_the_Pulp_User_Details__c>();
         
         system.debug('spList :::'+spList);
         if(spList.size() == 0){
             result = 'No Configuration was found to Squeeze the Pulp, Please Contact Naveen on CHATTER!!!';
         }else if(spList.size() == 1){
             newOwnerId = spList[0].User_Id__c;
         }else{
             for(Squeeze_the_Pulp_User_Details__c sp : spList){
                 if(sp.Last_Opportunity_Assigned__c==True)
                     lastAssignedIndex= index;
                 index++;
             }
             
             if(lastAssignedIndex == spList.size()-1){
                 nextAssignIndex = 0;
             }else{
                 nextAssignIndex = lastAssignedIndex+1;
             }
             
             newOwnerId = spList[nextAssignIndex].User_Id__c;
             
             spList[nextAssignIndex].Last_Opportunity_Assigned__c = True;
             spUpdateList.add(spList[nextAssignIndex]);
             
             spList[lastAssignedIndex].Last_Opportunity_Assigned__c = False;
             spUpdateList.add(spList[lastAssignedIndex]);
         }
         
         
         system.debug(newOwnerId);
         
         if(newOwnerId != ''){
             Opportunity opp = new Opportunity(id=oppId, OwnerId = newOwnerId, Closing_Agent__c = newOwnerId);
             Account acc = new Account(id=accountId, OwnerId = newOwnerId);
             try{
                 update opp;
                 update acc;
                 if(spUpdateList.size()>0){
                     update spUpdateList;
                 }
                 sendSMS(newOwnerId,oppName);
                 result = 'PULP has been SUCCESSFULLY SQUEEZED!!';
             }catch(Exception e){
                 result = e.getMessage()+'/n OOOPS, Some thing went wrong while squeezing the pulp. Please Contact Naveen on Chatter!!';
             }
         }else{
             result = 'OOOPS, Some thing went wrong while squeezing the pulp. Please Contact Naveen on Chatter!!';
         }
         system.debug('result:'+ result);
         return result;
    }
    public static void sendSMS (string idval,string oppName ){
         system.debug('idval'+ idval);
         user userIns=[SELECT name,mobilephone from user where id=:idval];
         smagicinteract__smsMagic__c smsObj = new smagicinteract__smsMagic__c();
         smsObj.smagicinteract__PhoneNumber__c = userIns.MobilePhone;//Phone Number to which text is sent
         smsObj.smagicinteract__SMSText__c = 'After squeezing the pulp, the opportunity : '+ oppName + ' has been assigned to '+userIns.name ;
         //smsObj.smagicinteract__senderId__c = 'smsMagic';
         smsObj.smagicinteract__senderId__c = '13173155065';
         smsObj.smagicinteract__Name__c = userIns.Name;
         if(!Test.isRunningTest()){
             smsObj.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
             insert smsObj;
         }
            
    }
}