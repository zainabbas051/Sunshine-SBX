@isTest
public class CorporateFinanceDealsIntegrationTest
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
        cfdi.no_of_ms_closed__c = 10;
        insert cfdi;
        
        Corporate_Finance_Integration_Fields__c cfif = new Corporate_Finance_Integration_Fields__c();
        cfif.Name = 'no_of_ms_closed';
        cfif.Company_Id__c = 2;
        cfif.Field_Name__c = 'no_of_ms_closed__c';
        cfif.Integration_Type__c = 'Deals Creation';
        cfif.Type_of_Deals__c = 'Total Number Of Closed Opportunities';
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

            CorporateFinanceDealsIntegrationBatch obj1 = new CorporateFinanceDealsIntegrationBatch();
            DataBase.executeBatch(obj1);

        Test.stopTest();
    }
    
    

}