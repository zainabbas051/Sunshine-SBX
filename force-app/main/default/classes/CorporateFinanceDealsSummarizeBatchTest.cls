@isTest
public class CorporateFinanceDealsSummarizeBatchTest
{
    Public static Account a;
    Public static Account ms;
    Public static Account cc;
    Public static Account wsr;
    public Static Profile adminProfile;
    
    public static void createSampleData(){
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        ms = new Account();
        ms.Name = 'Monarch Shores';
        ms.Type = 'Internal Center';
        insert ms;
        
        cc = new Account();
        cc.Name = 'Chapters Capistrano';
        cc.Type = 'Internal Center';
        insert cc;
        
        wsr = new Account();
        wsr.Name = 'Willow Springs';
        wsr.Type = 'Internal Center';
        insert wsr;
        
        Corporate_Finance_Endpoints__c cfe = new Corporate_Finance_Endpoints__c();
        cfe.Name = 'Default';
        cfe.Authorization__c = 'c54fe0b6a252921423acc1ebe24febed';
        cfe.Create_No_Of_Deals_URL__c = 'http://corporatefinance.addictionnetwork.com/api/v1/deals';
        cfe.Create_Revenue_URL__c = 'http://www.google.com';
        insert cfe;
        
        Stage_Forecast_Values__c sfv1 = new Stage_Forecast_Values__c();
        sfv1.Name = 'Working';
        sfv1.Record_Type__c = 'Monarch Shores';
        sfv1.Stage_Number__c = 1;
        insert sfv1;
        
        Stage_Forecast_Values__c sfv2 = new Stage_Forecast_Values__c();
        sfv2.Name = 'Initial Qualified Contact';
        sfv2.Record_Type__c = 'Elite Rehab Placement';
        sfv2.Stage_Number__c = 1;
        insert sfv2;
        
        Stage_Forecast_Values__c sfv3 = new Stage_Forecast_Values__c();
        sfv3.Name = 'Rescued';
        sfv3.Record_Type__c = 'Elite Rehab Placement';
        sfv3.Stage_Number__c = 2;
        insert sfv3;
        
        Stage_Forecast_Values__c sfv4 = new Stage_Forecast_Values__c();
        sfv4.Name = 'Admitted';
        sfv4.Record_Type__c = 'Monarch Shores';
        sfv4.Stage_Number__c = 2;
        insert sfv4;
        
        Insurance_Collector_Round_Robin_User__c icrr = new Insurance_Collector_Round_Robin_User__c();
        icrr.User_Id__c = userAdmin.id;
        icrr.Last_Assigned_To__c = False;
        icrr.Name = userAdmin.LastName;
        insert icrr;
        
        Insurance_Collector_Round_Robin_User__c icrr2 = new Insurance_Collector_Round_Robin_User__c();
        icrr2.User_Id__c = userAdmin.id;
        icrr2.Last_Assigned_To__c = True;
        icrr2.Name = userAdmin.LastName+'2';
        insert icrr2;
    }
    
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
    static testMethod void testMethod1()
    {
        createSampleData();
        
        Id erpRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        
        Opportunity oerp1 = new Opportunity();
        oerp1.Name = 'test opp';
        oerp1.RecordTypeId = erpRecTypeId;
        oerp1.Account = a;
        oerp1.Selected_Treatment_Center__c = a.id;
        oerp1.Closing_Agent__c = userAdmin.id;
        oerp1.Amount = 999;
        oerp1.StageName = 'Initial Qualified Contact';
        oerp1.CloseDate = date.Today();
        oerp1.Test_Class_Checkbox__c = True;
        oerp1.Stage_Pipeline_Forcast__c = 'Initial Qualified Contact';
        insert oerp1;
        
        oerp1.stageName = 'Rescued';
        update oerp1;
        
        Opportunity oerp2 = new Opportunity();
        oerp2.Name = 'test opp';
        oerp2.RecordTypeId = erpRecTypeId;
        oerp2.Account = a;
        oerp2.Selected_Treatment_Center__c = a.id;
        oerp2.Closing_Agent__c = userAdmin.id;
        oerp2.Amount = 999;
        oerp2.StageName = 'Initial Qualified Contact';
        oerp2.CloseDate = date.Today();
        oerp2.Test_Class_Checkbox__c = True;
        oerp2.Stage_Pipeline_Forcast__c = 'Initial Qualified Contact';
        insert oerp2;
        
        oerp2.stageName = 'Rescued';
        update oerp2;
        
        Test.startTest();

            //CorporateFinanceDealsSummarizeBatch obj = new CorporateFinanceDealsSummarizeBatch();
            //DataBase.executeBatch(obj);

            CorporateFinanceDealsSummarizeBatch2 obj2 = new CorporateFinanceDealsSummarizeBatch2();
            DataBase.executeBatch(obj2);
            
            CorporateFinanceDealsSummarizeBatch2 obj3 = new CorporateFinanceDealsSummarizeBatch2();
            DataBase.executeBatch(obj3);

        Test.stopTest();
    }
    
    static testMethod void testMethod2()
    {
        createSampleData();
        
        Id erpRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        
        Opportunity oerp1 = new Opportunity();
        oerp1.Name = 'test opp';
        oerp1.RecordTypeId = erpRecTypeId;
        oerp1.Account = a;
        oerp1.Selected_Treatment_Center__c = a.id;
        oerp1.Closing_Agent__c = userAdmin.id;
        oerp1.Amount = 999;
        oerp1.StageName = 'Initial Qualified Contact';
        oerp1.CloseDate = date.Today();
        oerp1.Test_Class_Checkbox__c = True;
        oerp1.Stage_Pipeline_Forcast__c = 'Initial Qualified Contact';
        insert oerp1;
        
        oerp1.stageName = 'Checked Out Early';
        update oerp1;
        
        Test.startTest();

            //CorporateFinanceDealsSummarizeBatch obj = new CorporateFinanceDealsSummarizeBatch();
            //DataBase.executeBatch(obj);
            
            CorporateFinanceDealsSummarizeBatch2 obj2 = new CorporateFinanceDealsSummarizeBatch2();
            DataBase.executeBatch(obj2);
            
            CorporateFinanceDealsSummarizeBatch2 obj3 = new CorporateFinanceDealsSummarizeBatch2();
            DataBase.executeBatch(obj3);


        Test.stopTest();
    }
    
    static testMethod void testMethod3()
    {
        createSampleData();
        
        Id msRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        Opportunity oerp1 = new Opportunity();
        oerp1.Name = 'test opp';
        oerp1.RecordTypeId = msRecTypeId;
        oerp1.Account = a;
        oerp1.Selected_Treatment_Center__c = a.id;
        oerp1.Closing_Agent__c = userAdmin.id;
        oerp1.Amount = 999;
        oerp1.StageName = 'Working';
        oerp1.Sunshine_Center__c = ms.id;
        oerp1.LeadSource = 'Monarch Shores';
        oerp1.CloseDate = date.Today();
        oerp1.Test_Class_Checkbox__c = True;
        oerp1.Stage_Pipeline_Forcast__c = 'Working';
        insert oerp1;
        
        oerp1.stageName = 'Admitted';
        update oerp1;
        
        Opportunity oerp2 = new Opportunity();
        oerp2.Name = 'test opp';
        oerp2.RecordTypeId = msRecTypeId;
        oerp2.Account = a;
        oerp2.Selected_Treatment_Center__c = a.id;
        oerp2.Closing_Agent__c = userAdmin.id;
        oerp2.Amount = 999;
        oerp2.StageName = 'Working';
        oerp2.Sunshine_Center__c = ms.id;
        oerp2.LeadSource = 'Monarch Shores';
        oerp2.CloseDate = date.Today();
        oerp2.Test_Class_Checkbox__c = True;
        oerp2.Stage_Pipeline_Forcast__c = 'Working';
        insert oerp2;
        
        oerp2.stageName = 'Admitted';
        update oerp2;
        
        Test.startTest();

            //CorporateFinanceDealsSummarizeBatch obj = new CorporateFinanceDealsSummarizeBatch();
            //DataBase.executeBatch(obj);
            
            CorporateFinanceDealsSummarizeBatch2 obj2 = new CorporateFinanceDealsSummarizeBatch2();
            DataBase.executeBatch(obj2);

            CorporateFinanceDealsSummarizeBatch2 obj3 = new CorporateFinanceDealsSummarizeBatch2();
            DataBase.executeBatch(obj3);


        Test.stopTest();
    }
    
    static testMethod void testMethod4()
    {
        createSampleData();
        
        Id msRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        Opportunity oerp1 = new Opportunity();
        oerp1.Name = 'test opp';
        oerp1.RecordTypeId = msRecTypeId;
        oerp1.Account = a;
        oerp1.Selected_Treatment_Center__c = a.id;
        oerp1.Closing_Agent__c = userAdmin.id;
        oerp1.Amount = 999;
        oerp1.StageName = 'Working';
        oerp1.Sunshine_Center__c = cc.id;
        oerp1.LeadSource = 'Chapters Capistrano';
        oerp1.CloseDate = date.Today();
        oerp1.Test_Class_Checkbox__c = True;
        oerp1.Stage_Pipeline_Forcast__c = 'Working';
        insert oerp1;
        
        oerp1.stageName = 'Admitted';
        update oerp1;
        
        Opportunity oerp2 = new Opportunity();
        oerp2.Name = 'test opp';
        oerp2.RecordTypeId = msRecTypeId;
        oerp2.Account = a;
        oerp2.Selected_Treatment_Center__c = a.id;
        oerp2.Closing_Agent__c = userAdmin.id;
        oerp2.Amount = 999;
        oerp2.StageName = 'Working';
        oerp2.Sunshine_Center__c = cc.id;
        oerp2.LeadSource = 'Chapters Capistrano';
        oerp2.CloseDate = date.Today();
        oerp2.Test_Class_Checkbox__c = True;
        oerp2.Stage_Pipeline_Forcast__c = 'Working';
        insert oerp2;
        
        oerp2.stageName = 'Admitted';
        update oerp2;
        
        Test.startTest();

            //CorporateFinanceDealsSummarizeBatch obj = new CorporateFinanceDealsSummarizeBatch();
            //DataBase.executeBatch(obj);
            
            CorporateFinanceDealsSummarizeBatch2 obj2 = new CorporateFinanceDealsSummarizeBatch2();
            DataBase.executeBatch(obj2);
            
            CorporateFinanceDealsSummarizeBatch2 obj3 = new CorporateFinanceDealsSummarizeBatch2();
            DataBase.executeBatch(obj3);


        Test.stopTest();
    }
    
    static testMethod void testMethod5()
    {
        createSampleData();
        
        Id msRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        Opportunity oerp1 = new Opportunity();
        oerp1.Name = 'test opp';
        oerp1.RecordTypeId = msRecTypeId;
        oerp1.Account = a;
        oerp1.Selected_Treatment_Center__c = a.id;
        oerp1.Closing_Agent__c = userAdmin.id;
        oerp1.Amount = 999;
        oerp1.StageName = 'Working';
        oerp1.Sunshine_Center__c = wsr.id;
        oerp1.LeadSource = 'Willow Springs';
        oerp1.CloseDate = date.Today();
        oerp1.Test_Class_Checkbox__c = True;
        oerp1.Stage_Pipeline_Forcast__c = 'Working';
        insert oerp1;
        
        oerp1.stageName = 'Admitted';
        update oerp1;
        
        Opportunity oerp2 = new Opportunity();
        oerp2.Name = 'test opp';
        oerp2.RecordTypeId = msRecTypeId;
        oerp2.Account = a;
        oerp2.Selected_Treatment_Center__c = a.id;
        oerp2.Closing_Agent__c = userAdmin.id;
        oerp2.Amount = 999;
        oerp2.StageName = 'Working';
        oerp2.Sunshine_Center__c = wsr.id;
        oerp2.LeadSource = 'Willow Springs';
        oerp2.CloseDate = date.Today();
        oerp2.Test_Class_Checkbox__c = True;
        oerp2.Stage_Pipeline_Forcast__c = 'Working';
        insert oerp2;
        
        oerp2.stageName = 'Admitted';
        update oerp2;
        
        Test.startTest();

            //CorporateFinanceDealsSummarizeBatch obj = new CorporateFinanceDealsSummarizeBatch();
            //DataBase.executeBatch(obj);
            
            CorporateFinanceDealsSummarizeBatch2 obj2 = new CorporateFinanceDealsSummarizeBatch2();
            DataBase.executeBatch(obj2);
            
            CorporateFinanceDealsSummarizeBatch2 obj3 = new CorporateFinanceDealsSummarizeBatch2();
            DataBase.executeBatch(obj3);

        Test.stopTest();
    }

}