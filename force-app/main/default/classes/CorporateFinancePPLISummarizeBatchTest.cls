@isTest
public class CorporateFinancePPLISummarizeBatchTest
{
    Public static Account a;
    Public static Account ms;
    Public static Account cc;
    Public static Account wsr;
    Public static Opportunity oms;
    Public static Payment_Plan__c ppRecord;
    public static Payment_Plan_Line_Items__c ppli;
    public static Payment_Plan_Line_Items__c ppli2;
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
        
        Id msRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = msRecTypeId;
        oms.Account = a;
        oms.Selected_Treatment_Center__c = a.id;
        oms.Closing_Agent__c = userAdmin.id;
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.Sunshine_Center__c = ms.id;
        oms.LeadSource = 'Monarch Shores';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        oms.Stage_Pipeline_Forcast__c = 'Working';
        insert oms;
        
        ppRecord = new Payment_Plan__c();
        ppRecord.Opportunity__c = oms.id;
        ppRecord.Start_Date__c = date.Today();
        ppRecord.Total_Amount_To_Be_Collected__c = 1000;
        ppRecord.Payment_Plan_Type__c = 'Custom';
        insert ppRecord;
        
        ppli = new Payment_Plan_Line_Items__c();
        ppli.Payment_Plan__c = ppRecord.id;
        ppli.Status__c = 'Closed';
        ppli.Amount_For_Collection__c = 100;
        ppli.Closed_Date__c = date.today();
        insert ppli;
        
        ppli2 = new Payment_Plan_Line_Items__c();
        ppli2.Payment_Plan__c = ppRecord.id;
        ppli2.Status__c = 'Closed';
        ppli2.Amount_For_Collection__c = 100;
        ppli2.Closed_Date__c = date.today();
        insert ppli2;
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
        
        Test.startTest();

            CorporateFinancePPLISummarizeBatch obj1 = new CorporateFinancePPLISummarizeBatch();
            DataBase.executeBatch(obj1);

            Corporate_Finance_Deals_Information__c cfdi = new Corporate_Finance_Deals_Information__c();
            cfdi.Close_Date__c = date.today();
            insert cfdi;
            
            CorporateFinancePPLISummarizeBatch obj2 = new CorporateFinancePPLISummarizeBatch();
            DataBase.executeBatch(obj2);


        Test.stopTest();
    }
    
    static testMethod void testMethod2()
    {
        createSampleData();
        
        oms.Sunshine_Center__c = cc.id;
        update oms;
        
        Test.startTest();

            CorporateFinancePPLISummarizeBatch obj1 = new CorporateFinancePPLISummarizeBatch();
            DataBase.executeBatch(obj1);
            
            Corporate_Finance_Deals_Information__c cfdi = new Corporate_Finance_Deals_Information__c();
            cfdi.Close_Date__c = date.today().addDays(-1);
            insert cfdi;
            
            CorporateFinancePPLISummarizeBatch obj2 = new CorporateFinancePPLISummarizeBatch();
            DataBase.executeBatch(obj2);


        Test.stopTest();
    }
    
    static testMethod void testMethod5()
    {
        createSampleData();
        
        oms.Sunshine_Center__c = wsr.id;
        update oms; 
        
        Test.startTest();

            CorporateFinancePPLISummarizeBatch obj1 = new CorporateFinancePPLISummarizeBatch();
            DataBase.executeBatch(obj1);
            
            Corporate_Finance_Deals_Information__c cfdi = new Corporate_Finance_Deals_Information__c();
            cfdi.Close_Date__c = date.today().addDays(-2);
            insert cfdi;
            
            CorporateFinancePPLISummarizeBatch obj2 = new CorporateFinancePPLISummarizeBatch();
            DataBase.executeBatch(obj2);

        Test.stopTest();
    }

}