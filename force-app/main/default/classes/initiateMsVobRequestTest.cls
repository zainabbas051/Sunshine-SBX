@isTest(seeAllData=true)
private class initiateMsVobRequestTest{
    
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
        o.cash_client__c = True;//Making sure the opportunity is a Cash CLient, so that VOB is not initiated automatically
        insert o;
        
     }
     
     public Static testmethod void test_initiateMsVobRequest(){
         test.startTest();
             createSampleData();
             
             String returnString = initiateMsVobRequest.initiateMsVobRequest(o.id);//Initiating the VOB for the first time.
             
             String returnString2 = initiateMsVobRequest.initiateMsVobRequest(o.id);//Since an incomplete VOB request already exists for the related Opportunity, this should return a validation message.
             
         test.stopTest();
     }
    
    
}