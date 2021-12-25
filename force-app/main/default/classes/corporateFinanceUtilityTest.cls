@isTest
private class corporateFinanceUtilityTest{
    
    Public static Account a;
    Public static Opportunity oppMS;
    Public static Opportunity oppERP;
    Public static Case caseRecord;
    Public static Payment_Plan__c ppRecord;
    public static Payment_Plan_Line_Items__c ppli;
    public static Card_Information__c ciRecord;
    public Static Profile adminProfile;
    public static Corporate_Finance_Endpoints__c cfe;
    public static Corporate_Finance_Deals_Information__c cfdi;
    public static Trigger_Custom_Setting__c tcs;
    
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
        
        cfe = new Corporate_Finance_Endpoints__c();
        cfe.Name = 'Default';
        cfe.Authorization__c = '1234';
        cfe.Create_No_Of_Deals_URL__c = 'www.google.com';
        cfe.Create_Revenue_URL__c = 'www.google.com';
        insert cfe;
        
        cfdi = new Corporate_Finance_Deals_Information__c();
        //cfdi.Name = 'Test';
        insert cfdi;
        
     } 
     
    public Static testmethod void test_createDeals(){
       
       test.startTest();
           createSampleData();
           Date d = date.today();
           sObject sObj = corporateFinanceUtility.createDeals(cfdi.id,'Corporate_Finance_Deals_Information__c',1,null,1,'Total Number Of Closed Opportunities');
           sObject sObj2 = corporateFinanceUtility.createDeals(cfdi.id,'Corporate_Finance_Deals_Information__c',1,d,1,'Total Number Of Closed Opportunities');
           //corporateFinanceUtility.createDeals(cfdi.id,'Corporate_Finance_Deals_Information__c');
           
       test.stopTest();
    
    }
    
    public Static testmethod void test_createRevenue(){
       
       test.startTest();
           createSampleData();
           Date d = date.today();
           
           sObject sObj = corporateFinanceUtility.createRevenue(cfdi.id,'Corporate_Finance_Deals_Information__c',1,null,1,'Total Number Of Closed Opportunities');
           sObject sObj2 = corporateFinanceUtility.createRevenue(cfdi.id,'Corporate_Finance_Deals_Information__c',1,d,1.0,'Insurance');
           
           //corporateFinanceUtility.createRevenue(cfdi.id,'Corporate_Finance_Deals_Information__c');
           
       test.stopTest();
    
    }
    

}