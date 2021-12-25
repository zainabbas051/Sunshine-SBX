@isTest
private class ContractDetailPageCtrlTest {
    Public static Account a;
    Public static Client_Chart__c cc;
    Public static Case c;
    Public static Incident_Report__c contract;
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
        
        
        /*
        assessment = new Assessment_IR_Tools__c();
        assessment.Client_Chart__c = cc.id;
        assessment.Status__c = 'Open';
        insert assessment;*/
        
        contract = new Incident_Report__c();
        contract.Status__c = 'Open';
        contract.RecordTypeId = Schema.SObjectType.Incident_Report__c.getRecordTypeInfosByName().get('Safety Contract').getRecordTypeId();
        contract.FRA_Acute_Intoxication__c = 'Yes';
        contract.FRA_Acute_Pain__c = 'No';
        contract.Attachment1_Id_URl__c = '/abc%67';
        contract.Attachment2_Id_URl__c = '/abc%67';
        contract.Attachment3_Id_URl__c = '/abc%67';
        contract.Attachment4_Id_URl__c = '/abc%67';
        contract.Attachment5_Id_URl__c = '/abc%67';
        contract.Attachment6_Id_URl__c = '/abc%67';
        contract.Attachment7_Id_URl__c = '/abc%67';
        contract.Attachment8_Id_URl__c = '/abc%67';
        contract.Attachment9_Id_URl__c = '/abc%67';
        contract.Attachment10_Id_URl__c = '/abc%67'; 
        insert contract;
        
        UtlizationReviewOrder__c uro = new UtlizationReviewOrder__c();
        uro.Client_Chart__c = cc.Id;
        uro.Incident_Report__c = contract.Id;
        insert uro;
        
    }
    
    public Static testmethod void ContractDetailCtrlTest(){
        test.startTest();
        system.runAs(userAdmin){
            createSampleData();
            
            ApexPages.currentPage().getParameters().put('Id', cc.id);
            ApexPages.currentPage().getParameters().put('cid', contract.id); 
            
            
            ContractDetailPageCtrl adc = new ContractDetailPageCtrl();
            Constants con = new Constants();
            
            
            string flag = adc.RecordType;
            boolean flag1 = adc.IsEdit;
            string flag2= adc.OrgName;
            string flag3 = adc.SelectedSignedOption;
            string flag4 = adc.ImageUrlAddress;
            string flag5 = adc.accessKeyId ;
            
            
            adc.SelectedSignedOption = 'Staff';
            adc.CloseContractForm();
            
            adc.SelectedSignedOption = 'Patient';
            adc.CloseContractForm();
            
            adc.RecordType = 'Safety Contract' ;
            contract.Status__c = 'Complete';
            contract.SignedBy__c = 'All'; 
            update contract;
            
            contract.Status__c = 'In progress';
            contract.SignedBy__c = 'None';
            update contract;
            
            adc.changeStatus();
            adc.submit();
             
            Boolean FlagAccessType = adc.buttonAccessType;   
            
            adc.AddAttachment();
            adc.editRecord();
            adc.SaveRecord();
            
            contract.RecordTypeId = Constants.IR_MedicationIncidentAttachmentRecordTypeId;
            update contract;
                         
            ContractDetailPageCtrl adc2 = new ContractDetailPageCtrl();
        }       
        test.StopTest();
        
    }
}