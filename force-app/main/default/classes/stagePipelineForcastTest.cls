@isTest(seeAllData=True)
private class stagePipelineForcastTest{
    
    Public static Account a;
    Public static Opportunity o_erp;
    Public static Opportunity o_ms;
    public Static Profile adminProfile;
    
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
        
        Id recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        o_erp = new Opportunity();
        o_erp.Name = 'test opp';
        o_erp.Account = a;
        o_erp.Selected_Treatment_Center__c = a.id;
        o_erp.Closing_Agent__c = userAdmin.id;
        o_erp.Amount = 999;
        o_erp.StageName = 'Initial Qualified Contact';
        o_erp.CloseDate = date.Today();
        o_erp.recordTypeId = recTypeId;
        o_erp.Test_Class_Checkbox__c  = true;
        o_erp.Cash_Client__c = False;
        o_erp.Insurance_Providers__c = 'Spectra';
        insert o_erp;
        
        o_ms = new Opportunity();
        o_ms.Name = 'test opp';
        o_ms.Account = a;
        o_ms.Selected_Treatment_Center__c = a.id;
        o_ms.Closing_Agent__c = userAdmin.id;
        o_ms.Amount = 999;
        o_ms.StageName = 'Working';
        o_ms.CloseDate = date.Today();
        o_ms.recordTypeId = recTypeIdOpp;
        o_ms.Test_Class_Checkbox__c  = true;
        o_ms.Cash_Client__c = False;
        o_ms.Insurance_Providers__c= 'Spectra';
        insert o_ms;
        
    }
    
    public Static testmethod void stagePipelineForcastTest_ERP(){
        test.startTest();
        
            createSampleData();   
            
            o_erp.StageName='In Contact with Treatment Center';
            update o_erp;
                  
            
        test.StopTest();
    }
    
    public Static testmethod void stagePipelineForcastTest_MS(){
        test.startTest();
        
            createSampleData();   
            
            o_ms.StageName='Admitted';
            update o_ms;
                  
            
        test.StopTest();
    }
}