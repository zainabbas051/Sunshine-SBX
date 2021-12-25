@isTest
private class MSBalancePDFExtensionTest{
    Public static Account a;
    Public static Opportunity oms;
    Public static Case c;
    Public static Insurance_Information__c ii;
    Public static PTM_Invoice_Process__c invRecord;
    Public static User u_test;
    public Static Profile adminProfile;
    public Static ApexPages.StandardController MSBalancePDFController;
    public Static MSBalancePDFExtension ipdfExt;
     public static awsBucket__c AmazonBucketValue;
 
    public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US');
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
     
     public Static void createSampleData(){
        
        a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Treatment Center';
        a.BillingStreet ='Test';
        a.BillingState = 'CA';
        a.BillingCity = 'Test';
        a.BillingPostalCode = '12345';
        insert a;
        
        Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
        
        oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = recTypeIdOpp;
        oms.Account = a;
        oms.Selected_Treatment_Center__c = a.id;
        oms.Closing_Agent__c = userAdmin.id;
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        insert oms;
        
        ii = new Insurance_Information__c();
        ii.Insurance_Providers__c = 'United Healthcare';
        ii.Insurance_Policy__c = '1234'; 
        ii.Insurance_Status__c = 'Primary';
        ii.Opportunity__c = oms.id;
        insert ii;
        
        invRecord = new PTM_Invoice_Process__c();
        invRecord.Related_Opp__c = oms.id;
        insert invRecord;
        
        AmazonBucketValue = new awsBucket__c();
        AmazonBucketValue.name='FREEPU';
        AmazonBucketValue.accessKeyId__c='testAcess';
        AmazonBucketValue.secretAccessKey__c='secretKey';
        AmazonBucketValue.Bucket__c='freepu';
        insert AmazonBucketValue;
        
        c = new case();
        c.Opportunity__c = oms.id;
        c.Bill_From_Date__c = date.today().addDays(-5);
        c.Bill_To_Date__c = date.today();
        c.Level_of_Care__c = 'Detox';
        c.Billed_Amount__c = 300;
        c.Amount_Being_Paid_To_Member__c = 200;
        insert c;
       
        
     }
     
     public Static testmethod void MSBalancePDFExtensionTest(){
       test.startTest();
       system.runAs(userAdmin){
            createSampleData();
           
           ApexPages.currentPage().getParameters().put('Id', invRecord.id);
           
           MSBalancePDFController = new ApexPages.StandardController(invRecord);
           ipdfExt = new MSBalancePDFExtension(MSBalancePDFController); 
           
           
           Date flag2 = ipdfExt.todayDate;
           List<PTM_Invoice_Process__c> flag3 = ipdfExt.invList;
           List<case > flag17 = ipdfExt.caseList;
           List<Insurance_Information__c> flag18 = ipdfExt.insuranceList;
           string flag4 = ipdfExt.insuranceprovider;
           string flag5 = ipdfExt.collectorName;
           string flag6 = ipdfExt.policyNumber;
           string flag7 = ipdfExt.companyName;
           string flag8 = ipdfExt.companyAddressLine1;
           string flag9 = ipdfExt.companyAddressLine2;
           string flag10 = ipdfExt.collectorName;
           string flag11 = ipdfext.collectorPhone;
           string flag12 = ipdfext.collectorEmail;
           string flag13 = ipdfext.provideraddress;
           string flag14 = ipdfext.providercity;
           string flag15 = ipdfext.providerstate;
           string flag16 = ipdfext.providerzipcode; 
           string flag19 = ipdfext.dateOfService;
           string flag20 = ipdfext.Description;
       
           //PageReference pr = ppde.submitForApproval();
           
           //PageReference pr2 = ppde.submitForApproval();
           case casIns=ipdfExt.getcasetotal();
           
            
                             
       }       
       test.StopTest();
             
      }
       
}