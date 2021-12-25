@isTest
private class AssesmentDetailCtrlTest{
    Public static Account a;
    Public static Client_Chart__c cc;
    Public static Case c;
    Public static Assessment_IR_Tools__c  assessment;
    Public static User u_test;
    public Static Profile adminProfile;
    public static awsBucket__c AmazonBucketValue;
    public static TabViews__c tv;
     
    public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US', User_Role__c = NULL, Acess_Type__c='Admin');
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
     
     public Static void createSampleData(){
        
        tv = new TabViews__c();
        tv.Name = 'Assessments';
        tv.Button_Access_Type__c = 'Admin';
        insert tv;
        
        AmazonBucketValue = new awsBucket__c();
        AmazonBucketValue.name = 'FREEPU';
        AmazonBucketValue.accessKeyId__c = '1234';
        AmazonBucketValue.secretAccessKey__c= '1234';
        insert AmazonBucketValue;
        
        a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Treatment Center';
        a.BillingStreet ='Test';
        a.BillingState = 'CA';
        a.BillingCity = 'Test';
        a.BillingPostalCode = '12345';
        insert a;
        
        Schema.DescribeSObjectResult chart = Schema.SObjectType.Client_Chart__c;
        Map<String, Schema.RecordTypeInfo> rtMapByNameChart = Chart.getRecordTypeInfosByName();
        Id recTypeIdchart = rtMapByNamechart.get('Monarch Shores').getRecordTypeId(); 
        
        cc = new Client_Chart__c();
        cc.name = 'test';
        cc.RecordTypeId = recTypeIdchart;
        insert cc;
       
        
        
        assessment = new Assessment_IR_Tools__c();
        assessment.Client_Chart__c = cc.id;
        assessment.Status__c = 'Open';
        insert assessment;
        }
     
     public Static testmethod void AssesmentDetailCtrlTest(){
       test.startTest();
       system.runAs(userAdmin){
            createSampleData();
           
         ApexPages.currentPage().getParameters().put('Id', cc.id);
         ApexPages.currentPage().getParameters().put('IR', assessment.id); 
          
           
         AssesmentDetailCtrl adc = new AssesmentDetailCtrl();
         Constants con = new Constants();

         
         string flag = adc.RecordType;
         boolean flag1 = adc.IsEdit;
         string flag2= adc.OrgName;
         string flag3 = adc.SelectedSignedOption;
         string flag4 = adc.ImageUrlAddress;
         string flag5 = adc.accessKeyId ;
         
          List<SelectOption> options = adc.getscore();
          adc.calcScore();
          
           adc.SelectedSignedOption = 'Staff';
           adc.CloseAssesmentForm();
          
          adc.SelectedSignedOption = 'Patient';
          adc.CloseAssesmentForm();
          
          adc.RecordType = 'Nutritional Screen' ;
          assessment.Status__c = 'Complete';
          assessment.SignedBy__c = 'All'; 
          update assessment;
          
          assessment.Status__c = 'In progress';
          assessment.SignedBy__c = 'None';
          update assessment;
          
          adc.changeStatus();
          adc.submit();
         /* string flag1 = ahpc.SelectedOption;
          list<Assessment_IR_Tools__c> flag3 = ahpc.lstAssessments;
          ahpc.SelectedOption  = Schema.SObjectType.Assessment_IR_Tools__c.getRecordTypeInfosByName().get('Behavioral Contract').getName()+',';
          
          ahpc.SaveNewAssesmentRecords();
          
           newARtool.Status__c ='Open';
           ahpc.SaveAssementAllRecords(); */
           Boolean FlagAccessType = adc.buttonAccessType;                 
       }       
       test.StopTest();
             
      }
       
}