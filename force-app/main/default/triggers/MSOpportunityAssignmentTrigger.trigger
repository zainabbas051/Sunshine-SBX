//Test Class : TransfertoMSNewCtrlTest 
trigger MSOpportunityAssignmentTrigger on Opportunity (after insert){
     
     if(Trigger_Custom_Setting__c.getValues('Default') != null && 
     Trigger_Custom_Setting__c.getValues('Default').Disable_MSOpportunityAssignmentTrigger__c == True)
     return;
     
     Id recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();//Getting the id of Monarch Shore Opportunity Record Type
     List<Opportunity> oppList = new List<Opportunity>();
     List<Opportunity> oppUpdateList = new List<Opportunity>();
     
     for(Opportunity o : Trigger.New){
         if(o.recordTypeId == recTypeId){
             oppList.add(o); 
         }
     }
     
     for(Opportunity opp : oppList){
         TransfertoMSNewCtrl  msnc = new TransfertoMSNewCtrl(opp.id, False);
         Opportunity TempOpp = new Opportunity(id=opp.id); 
         
         //Following Code Commented for CSR Warm Hand Off
         /*
         String msOppOwnerId = msnc.getOpportunityOwner();  
         //Assigning the owner of all new MS Opps on the basis of AC-Schedule
         if(msOppOwnerId  == null){//Seeing if no user is found for assignment from AC Schedule, the opp is assigned to Tahnil from where it can be accepted latter
            TempOpp.Closing_Agent__c = System.Label.Tahil_User_Id;//Making sure the selected user from the intermediate VF page is made the closing agent
            TempOpp.OwnerId = System.Label.Tahil_User_Id;
         }else{//If a user is found for assignment from AC Schedule, the opportunity is assigned to that user.
            TempOpp.Closing_Agent__c = msOppOwnerId;
            TempOpp.OwnerId = msOppOwnerId;
         }
         */
         
         Id insuranceInfo = msnc.createInsuranceInfo(opp.id, opp.Subscriber_Name__c, opp.Insurance_Providers__c, opp.Insurance_Policy__c, opp.Group_Number__c, 
                                                         opp.Insurance_Provider_Phone_Number__c, opp.Subscriber_DOBtext__c, opp.SSN_Last_4__c, opp.Address__c,
                                                         opp.Address_2__c, opp.City__c, opp.State__c, opp.Zip_Code__c, opp.Country__c, opp.Employer__c);
         
         if(msnc.vobRequestStatus(opp.Insurance_Providers__c, opp.Cash_Client__c) == True){
            tempOpp.Latest_VOB_Request__c = msnc.initiateVOBRequest(opp.id, insuranceInfo);
            tempOpp.VOB_Status__c = msnc.initiateVOBTempOpportunity(tempOpp.id).VOB_Status__c;
            tempOpp.Insurance_Verified_By__c = msnc.initiateVOBTempOpportunity(tempOpp.id).Insurance_Verified_By__c;
            tempOpp.VOB_Agent__c = msnc.initiateVOBTempOpportunity(tempOpp.id).VOB_Agent__c;
            tempOpp.Insurance_Verified_Time_Stamp__c = msnc.initiateVOBTempOpportunity(tempOpp.id).Insurance_Verified_Time_Stamp__c;
            tempOpp.VOB_Completed__c = msnc.initiateVOBTempOpportunity(tempOpp.id).VOB_Completed__c;
         }                                           
         
         //Following Lines Update for CSR Warm Hand Off
         //msnc.sendSMS(TempOpp.OwnerId,opp.name, msOppOwnerId);//Sending SMS for all new MS Opps
         
         msnc.sendSMS(opp.OwnerId,opp.name, opp.OwnerId);//Sending SMS for all new MS Opps
         oppUpdateList.add(TempOpp);
         
     }
     
     
     if(oppUpdateList.size() != null)
         update oppUpdateList;
     
}