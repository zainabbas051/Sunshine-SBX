@isTest
private class urLOCUpdateOnClientChart_URTest{
    Public static Account a;
    Public static Client_Chart__c cc;
    Public static Opportunity o;
    public static awsBucket__c AmazonBucketValue;
    public static Utilization_Review__c ev1;
    public static Utilization_Review__c ev2;
     
     public Static void createSampleData(){
        
        AmazonBucketValue = new awsBucket__c();
        AmazonBucketValue.name='FREEPU';
        AmazonBucketValue.accessKeyId__c='testAcess';
        AmazonBucketValue.secretAccessKey__c='secretKey';
        AmazonBucketValue.Bucket__c='freepu';
        insert AmazonBucketValue;
        
        a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Treatment Center';
        a.BillingStreet ='Test';
        a.BillingState = 'CA';
        a.BillingCity = 'Test';
        a.BillingPostalCode = '12345';
        insert a;
        
        o = new Opportunity();
        o.Name = 'test opp';
        o.Account = a;
        o.Selected_Treatment_Center__c = a.id;
        o.Closing_Agent__c = UserINFO.getUserID();
        o.Amount = 999;
        o.StageName = 'Paid';
        o.CloseDate = date.Today();
        o.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        o.Test_Class_Checkbox__c  = true;
        o.Cash_Client__c = False;
        o.Insurance_Providers__c= 'Spectra';
        insert o;
        
        cc = new Client_Chart__c();
        cc.Treatment_Center__c = a.ID;
        cc.Opportunity__c = o.id;
        cc.Primary_Therapist__c = UserINFO.getUserID();
        cc.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        insert cc;
        
        ev1 = new Utilization_Review__c();
        ev1.RecordTypeId = Constants.ConcurrentReviewRecordTypeId;
        ev1.Level_Of_Care__c = 'Detox';
        ev1.Start_Date__c = date.Today();
        ev1.Client_Chart__c = cc.id;
        insert ev1;
        
        ev2 = new Utilization_Review__c();
        ev2.RecordTypeId = Constants.ConcurrentReviewRecordTypeId;
        ev2.Level_Of_Care__c = 'Residential';
        ev2.Start_Date__c = date.Today().addDays(3);
        ev2.Client_Chart__c = cc.id;
        insert ev2;
     }
     
     public Static testmethod void UtilizationReviewHomeControllerTest(){
     
         test.startTest();
       
             createSampleData();
          
          test.StopTest();                                        
                             
      }       
       
             
      
      

}