@isTest
public class CorporateFinanceRevenueIntegrationTest
{
    Public static Account a;
    Public static Corporate_Finance_Deals_Information__c cfdi;
    public Static Profile adminProfile;
    
    public static void createSampleData(){
        
        Corporate_Finance_Endpoints__c cfe = new Corporate_Finance_Endpoints__c();
        cfe.Name = 'Default';
        cfe.Authorization__c = 'c54fe0b6a252921423acc1ebe24febed';
        cfe.Create_No_Of_Deals_URL__c = 'http://corporatefinance.addictionnetwork.com/api/v1/deals';
        cfe.Create_Revenue_URL__c = 'http://www.google.com';
        insert cfe;
        
        cfdi = new Corporate_Finance_Deals_Information__c();
        cfdi.Close_Date__c = date.today();
        cfdi.MS_Cash_Revenue__c = 1000;
        insert cfdi;
        
        Corporate_Finance_Integration_Fields__c cfif = new Corporate_Finance_Integration_Fields__c();
        cfif.Name = 'MS_Cash_Revenue';
        cfif.Company_Id__c = 2;
        cfif.Field_Name__c = 'MS_Cash_Revenue__c';
        cfif.Integration_Type__c = 'Revenue Creation';
        cfif.Type_of_Revenue__c = 'Cash';
        insert cfif;
        
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

            CorporateFinanceRevenueIntegrationBatch obj1 = new CorporateFinanceRevenueIntegrationBatch();
            DataBase.executeBatch(obj1);

        Test.stopTest();
    }
    
    

}