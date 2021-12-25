@isTest
public class CorporateFinanceCasesSummarizeBatchTest
{
    Public static Account a;
    Public static Account ms;
    Public static Account cc;
    Public static Account wsr;
    Public Static Opportunity oerp1;
    public static case c;
    public static case c2;
    public static case c3;
    public static case c4;
    public static case c5;
    public static case c6;
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
        
        oerp1 = new Opportunity();
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
        
        Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId(); 
        
        c = new Case();
        c.Opportunity__c = oerp1.id;
        c.Status = 'Closed';
        c.Bill_Date__c = date.today();
        c.Bill_From_Date__c = date.today().addDays(-5);
        c.Bill_To_Date__c = date.today();
        c.Billed_Amount__c = 1500;
        c.Co_Pay_Amount__c = 200;
        c.Deductible_Amount__c = 100;
        c.Collected_Amount__c = 1000;
        c.Collection_Date__c = Date.today().addDays(-1);
        c.RecordTypeId = recTypeId;
        insert c;
        
        c2 = new Case();
        c2.Opportunity__c = oerp1.id;
        c2.Status = 'Closed';
        c2.Bill_Date__c = date.today();
        c2.Bill_From_Date__c = date.today().addDays(-5);
        c2.Bill_To_Date__c = date.today();
        c2.Billed_Amount__c = 1500;
        c2.Co_Pay_Amount__c = 200;
        c2.Deductible_Amount__c = 100;
        c2.Collected_Amount__c = 1000;
        c2.Collection_Date__c = Date.today().addDays(-1);
        c2.RecordTypeId = recTypeId;
        insert c2;
        
        c3 = new Case();
        c3.Opportunity__c = oerp1.id;
        c3.Status = 'Closed';
        c3.Bill_Date__c = date.today();
        c3.Bill_From_Date__c = date.today().addDays(-5);
        c3.Bill_To_Date__c = date.today();
        c3.Billed_Amount__c = 1500;
        c3.Co_Pay_Amount__c = 200;
        c3.Deductible_Amount__c = 100;
        c3.Collected_Amount__c = 1000;
        c3.Collection_Date__c = Date.today().addDays(-1);
        c3.RecordTypeId = recTypeId;
        c3.Appeal_for_Adjustment_Requested__c = True;
        c3.Adjustment_Collected_Date__c = Date.today();
        c3.Adjustment_Amount__c = 20;
        insert c3;
        
        c4 = new Case();
        c4.Opportunity__c = oerp1.id;
        c4.Status = 'Closed';
        c4.Bill_Date__c = date.today();
        c4.Bill_From_Date__c = date.today().addDays(-5);
        c4.Bill_To_Date__c = date.today();
        c4.Billed_Amount__c = 1500;
        c4.Co_Pay_Amount__c = 200;
        c4.Deductible_Amount__c = 100;
        c4.Collected_Amount__c = 1000;
        c4.Collection_Date__c = Date.today().addDays(-1);
        c4.RecordTypeId = recTypeId;
        c4.Appeal_for_Adjustment_Requested__c = True;
        c4.Adjustment_Collected_Date__c = Date.today();
        c4.Adjustment_Amount__c = 20;
        insert c4;
        
        c5 = new Case();
        c5.Opportunity__c = oerp1.id;
        c5.Status = 'Adjustment in Progress';
        c5.Bill_Date__c = date.today();
        c5.Bill_From_Date__c = date.today().addDays(-5);
        c5.Bill_To_Date__c = date.today();
        c5.Billed_Amount__c = 1500;
        c5.Co_Pay_Amount__c = 200;
        c5.Deductible_Amount__c = 100;
        c5.Collected_Amount__c = 1000;
        c5.Collection_Date__c = Date.today().addDays(-2);
        c5.RecordTypeId = recTypeId;
        c5.Appeal_for_Adjustment_Requested__c = True;
        insert c5;
        
        c6 = new Case();
        c6.Opportunity__c = oerp1.id;
        c6.Status = 'Adjustment in Progress';
        c6.Bill_Date__c = date.today();
        c6.Bill_From_Date__c = date.today().addDays(-5);
        c6.Bill_To_Date__c = date.today();
        c6.Billed_Amount__c = 1500;
        c6.Co_Pay_Amount__c = 200;
        c6.Deductible_Amount__c = 100;
        c6.Collected_Amount__c = 1000;
        c6.Collection_Date__c = Date.today().addDays(-2);
        c6.RecordTypeId = recTypeId;
        c6.Appeal_for_Adjustment_Requested__c = True;
        insert c6;
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

            CorporateFinanceCasesSummarizeBatch obj1 = new CorporateFinanceCasesSummarizeBatch();
            DataBase.executeBatch(obj1);

            Corporate_Finance_Deals_Information__c cfdi = new Corporate_Finance_Deals_Information__c();
            cfdi.Close_Date__c = date.today();
            insert cfdi;
            
            CorporateFinanceCasesSummarizeBatch obj2 = new CorporateFinanceCasesSummarizeBatch();
            DataBase.executeBatch(obj2);


        Test.stopTest();
    }
    
    static testMethod void testMethod2()
    {
        createSampleData();
        
        oerp1.Sunshine_Center__c = cc.id;
        update oerp1; 
        
        Test.startTest();

            CorporateFinanceCasesSummarizeBatch obj1 = new CorporateFinanceCasesSummarizeBatch();
            DataBase.executeBatch(obj1);
            
            Corporate_Finance_Deals_Information__c cfdi = new Corporate_Finance_Deals_Information__c();
            cfdi.Close_Date__c = date.today().addDays(-1);
            insert cfdi;
            
            CorporateFinanceCasesSummarizeBatch obj2 = new CorporateFinanceCasesSummarizeBatch();
            DataBase.executeBatch(obj2);


        Test.stopTest();
    }
    
    static testMethod void testMethod5()
    {
        createSampleData();
        
        oerp1.Sunshine_Center__c = wsr.id;
        update oerp1; 
        
        Test.startTest();

            CorporateFinanceCasesSummarizeBatch obj1 = new CorporateFinanceCasesSummarizeBatch();
            DataBase.executeBatch(obj1);
            
            Corporate_Finance_Deals_Information__c cfdi = new Corporate_Finance_Deals_Information__c();
            cfdi.Close_Date__c = date.today().addDays(-2);
            insert cfdi;
            
            CorporateFinanceCasesSummarizeBatch obj2 = new CorporateFinanceCasesSummarizeBatch();
            DataBase.executeBatch(obj2);

        Test.stopTest();
    }

}