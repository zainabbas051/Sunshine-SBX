@isTest(seeAllData=true)
private class initiateVobOnRelatedOpportunityTest{
    
    Public static Opportunity o;
    Public static Account a;
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
        
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
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
        o.recordTypeId = recTypeIdOpp;
        o.Test_Class_Checkbox__c  = true;
        o.cash_client__c = False;
        o.Insurance_Providers__c = 'Spectra';
        //The above 2 lines would automatically initiate VOB for this opp on create
        insert o;
        
     }
     
     public Static testmethod void test_initiateVobOnRelatedOpportunity(){
         test.startTest();
             createSampleData();
             
             Opportunity opp = [Select id, Latest_VOB_Request__c from Opportunity where id=: o.id];
             
             o.VOB_Status__c = 'Completed';
             update o;
             
             VOB_Request__c vr = new VOB_Request__c(id=opp.Latest_VOB_Request__c, VOB_Request_Status__c = 'Complete');
             if(opp.Latest_VOB_Request__c!=null)
             update vr;
             
             try{
             Insurance_Information__c ii = [select id, Employer__c from Insurance_Information__c where opportunity__c =: o.id LIMIT 1];
             ii.Employer__c = 'Elite Rehab Placement';
             update ii;
             }
             catch(exception e){}
         test.stopTest();
     }
    
}