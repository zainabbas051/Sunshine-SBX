@isTest
private class MSOppVOBStatusOnCompleteTest{
    Public static Opportunity o;
    Public static Account a;
    public Static Profile adminProfile;
    
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
        o.Cash_Client__c = False;
        o.Insurance_Providers__c= 'Spectra';
        insert o;
        
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

    public Static testmethod void testMSOppVOBStatusOnComplete (){
        test.startTest();
            
            createSampleData();
            
            
            //o.IsVOBCompleted__c= false;
            o.VOB_Status__c='Completed';
            o.Test_Class_Checkbox__c = True;
            update o;
       
           
        test.StopTest();
    }
      

}