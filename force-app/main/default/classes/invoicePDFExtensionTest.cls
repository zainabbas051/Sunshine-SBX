@isTest
private class invoicePDFExtensionTest{
    Public static Account a;
    Public static Opportunity oms;
    Public static Insurance_Information__c ii;
    Public static Payment_Plan__c ppRecord;
    public static Payment_Plan_Line_Items__c ppli;
    Public static User u_test;
    public Static Profile adminProfile;
    public Static ApexPages.StandardController invoicePDFController;
    public Static invoicePDFExtension ipdfExt;
 
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
        
        ppRecord = new Payment_Plan__c();
        ppRecord.Opportunity__c = oms.id;
        ppRecord.Start_Date__c = date.Today();
        ppRecord.Total_Amount_To_Be_Collected__c = 1000;
        ppRecord.Payment_Plan_Type__c = 'Custom';
        insert ppRecord;
        
        ppli = new Payment_Plan_Line_Items__c();
        ppli.Payment_Plan__c = ppRecord.id;
        ppli.Due_Date__c = date.today();
        ppli.Type_of_Collection__c = 'Deductible';
        ppli.Amount_For_Collection__c = 1000;
        insert ppli;
       
        
     }
     
     public Static testmethod void paymentPlansDetailExtTest(){
       test.startTest();
       system.runAs(userAdmin){
            createSampleData();
           
           ApexPages.currentPage().getParameters().put('Id', ppRecord.id);
           
           invoicePDFController = new ApexPages.StandardController(ppRecord);
           ipdfExt = new invoicePDFExtension(invoicePDFController); 
           
           Decimal flag1 = ipdfExt.sumamt;
           Date flag2 = ipdfExt.todayDate;
           List<Payment_Plan_Line_Items__c> flag3 = ipdfExt.ppliList;
           string flag4 = ipdfExt.clientName;
           string flag5 = ipdfExt.insuranceName;
           string flag6 = ipdfExt.policyNumber;
           string flag7 = ipdfExt.companyName;
           string flag8 = ipdfExt.companyAddressLine1;
           string flag9 = ipdfExt.companyAddressLine2;
           //PageReference pr = ppde.submitForApproval();
           
           //PageReference pr2 = ppde.submitForApproval();
           
           
            
                             
       }       
       test.StopTest();
             
      }
       
}