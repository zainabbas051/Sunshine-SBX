//Test Class : ConvertIntoOutreachAccountTest
global class ConvertIntoOutreachAccount{
    
     webservice static String ConvertIntoOutreachAccount(String outReachID){
         
         system.debug('OutReachID::::'+outReachID);
         string result;
         string newOwnerId;
         boolean flag = false;
         list<OUTREACH_ACCOUNT__c> oaList = new  list<OUTREACH_ACCOUNT__c>();
         
       
         OUTREACH_REQUEST__c orRecord = [select id, OwnerId, AssignedSEO__c, Prospect_URL__c, Category__c, Sub_Category__c, Status__c, Contact_Email_Address__c,
                                            Contact_Phone_Number__c,Email_Address_Used_to_Initiate_Contact__c,Domain_Authority__c,Outreach_Request_Converted_Date_Time__c,
                                            General_Guidelines_For_Website__c,Do_They_Charge_for_Links__c,Amount_Charged_Per_Link__c  from OUTREACH_REQUEST__c where id=:outReachID];
         for(OUTREACH_ACCOUNT__c oa : [select id, Related_Outreach_Request__c from OUTREACH_ACCOUNT__c where Related_Outreach_Request__c =:orRecord.id]){
            oaList.add(oa);
         }
            system.debug('oalist:::'+oalist);
            if (oaList.size() > 0){
                result = 'An OUTREACH ACCOUNT related to this Outreach Request already Exists!!';
            }else{
                 system.debug('orRecord :::'+orRecord );
                 system.debug('Assigned SEO:::'+orRecord.AssignedSEO__c);    
                 system.debug('newOwnerId :::'+orRecord.AssignedSEO__c);
                 system.debug('current orRecord Owner ::::'+orRecord.OwnerId);    
                 if(orRecord.AssignedSEO__c != Null){ 
                     if(UserInfo.getUserId() ==  orRecord.AssignedSEO__c){
                        OUTREACH_ACCOUNT__c oaRecord =  new OUTREACH_ACCOUNT__c();
                        oaRecord.OwnerID = orRecord.OwnerId;
                        oaRecord.Related_Outreach_Request__c = orRecord.id;
                        oaRecord.Prospect_URL__c = orRecord.Prospect_URL__c;
                        oaRecord.Category__c = orRecord.Category__c;
                        oaRecord.Sub_Category__c = orRecord.Sub_Category__c;
                        oaRecord.Status__c = 'Initial Contact Created';
                        oaRecord.Contact_Email_Address__c = orRecord.Contact_Email_Address__c;
                        oaRecord.Contact_Phone_Number__c = orRecord.Contact_Phone_Number__c;
                        oaRecord.Email_Address_Used_to_Initiate_Contact__c = orRecord.Email_Address_Used_to_Initiate_Contact__c;
                        oaRecord.Domain_Authority__c=orRecord.Domain_Authority__c ;
                        orRecord.Outreach_Request_Converted_Date_Time__c=datetime.now();
                        oaRecord.General_Guidelines_For_Website__c= orRecord.General_Guidelines_For_Website__c;
                        oaRecord.Amount_Charged_Per_Link__c=orRecord.Amount_Charged_Per_Link__c;
                        oaRecord.Do_They_Charge_for_Links__c=orRecord.Do_They_Charge_for_Links__c;
                        

                        system.debug('oaRecord :::'+oaRecord );
                        try{
                            insert oaRecord;
                            update orRecord;
                            result = 'The Outreach Request is Sucessfully Converted!!';
                        }catch(exception e){
                            result = 'OOOPS, Some thing went wron while converting to Outreach Account. Please Contact the Admin!!';    
                        }
                    }else{
                        result = 'An OUTREACH ACCOUNT can only be created by the Assigned SEO on this Outreach Request!!';
                    }
                }else{
                  result = 'User can not convert to Outreach Account if Assigned SEO field is blank!!';
                }
            }
            system.debug('result:'+ result);
            return result;
        }
}