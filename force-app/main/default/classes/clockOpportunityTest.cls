@isTest(seeAllData=True)
private class clockOpportunityTest{
    
    Public static Account a;
    Public static Opportunity o;
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
        
        Group queue = [select id from Group where Name=:'Unassigned Queue' AND Type = 'Queue'];
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        o = new Opportunity();
        o.Name = 'test opp';
        o.Account = a;
        o.Selected_Treatment_Center__c = a.id;
        o.Closing_Agent__c = userAdmin.id;
        o.Amount = 999;
        o.StageName = 'Paid';
        o.CloseDate = date.Today();
        o.State__c = 'Michigan';
        insert o;
    }
    
    public Static testmethod void clockOpportunityTest(){
        test.startTest();
        
            createSampleData();   
            ApexPages.currentPage().getParameters().put('Id', o.id);
            ApexPages.StandardController sc = new ApexPages.StandardController(o);
            clockOpportunity cl = new clockOpportunity(sc); 
         
            //cl.geta();
            
            pageReference pr1 = cl.UserTime();
            pagereference pr2 = cl.ContactTime();
            
            string s1 = cl.gets1();
            string s2 = cl.gets2();
            string m1 = cl.getm1();
            string m2 = cl.getm2();
            string h1 = cl.geth1();
            string h2 = cl.geth2();
                  
            
        test.StopTest();
    }
}