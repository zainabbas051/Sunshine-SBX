@isTest
private class updateLastActivityOnAccount_Test{
    
    Public static Account a;
    Public static User u_test;
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
        
        Trigger_Custom_Setting__c tcs = new Trigger_Custom_Setting__c();
        tcs.Name = 'Default';
        tcs.Disable_updateLastActivityOnAccount_Task__c = False;
        tcs.Disable_updateLastActivityOnAccount_Even__c = False;
        insert tcs; 
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'RTC Center';
        a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Development').getRecordTypeId(); 
        insert a;
        
     } 

    public Static testmethod void test_updateLastActivityOnAccount_Task(){
        test.startTest();
        createSampleData();
        
            Task t = new Task();
            t.Subject = 'Invoca Call Log';
            t.whatId = a.id;
            insert t;
          
        test.StopTest();
             
    }
    
    public Static testmethod void test_updateLastActivityOnAccount_Event(){
        test.startTest();
        createSampleData();
        
            Event t = new Event();
            t.Subject = 'Invoca Call Log';
            t.whatId = a.id;
            t.DurationInMinutes = 10;
            t.ActivityDateTime = DateTime.Now();
            insert t;
          
        test.StopTest();
             
    }
      
     
      
    
}