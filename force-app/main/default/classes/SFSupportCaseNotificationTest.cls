@isTest(seeAllData=true)
private class SFSupportCaseNotificationTest{

    Public static Case caseRec;
   
    Public Static testmethod void OutboundSMSOnCasesTest(){
        test.startTest();
           /* awsBucket__c AmazonBucketValue = new awsBucket__c();
            AmazonBucketValue.name='FREEPU';
            AmazonBucketValue.accessKeyId__c='testAcess';
            AmazonBucketValue.secretAccessKey__c='secretKey';
            AmazonBucketValue.Bucket__c='freepu';
            insert AmazonBucketValue;*/
            
            User u = [Select id from User where isActive=: True AND Profile.Name =: 'System Administrator' LIMIT 1];
            
            caseRec= new Case();
            caseRec.RecordTypeId  = Constants.sfSupportCaseRecordTypeId; 
            caseRec.SFDC_Support_Case_Reported_By__c = u.id;  
            insert caseRec; 

        test.StopTest();
    }          
}