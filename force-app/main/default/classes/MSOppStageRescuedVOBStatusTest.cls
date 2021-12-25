@isTest//(SeeAllData=true)
private class MSOppStageRescuedVOBStatusTest{
    Public static Opportunity o;
    Public static Account a;
    public Static Profile adminProfile;
    set<id> UserConcerned = new set<id>();
    public static list<user> LstConcernedUsers = new list<user>();


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

    public Static testmethod void testMSOppStageRescuedVOBStatus(){
    
        Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recTypeId = rtMapByName.get('Monarch Shores').getRecordTypeId();//Getting the id of Monarch Shore Opportunity Record Type
        
        test.startTest();        
        
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
        //o.StageName = 'Admitted';
       o.StageName = 'Paid';
        o.CloseDate = date.Today();
        o.RecordTypeId = recTypeId ;
        o.Family_Contact_Name__c = 'testing';
        o.Family_Contact_Phone__c = '3137789696' ;
        o.Family_Contact_Email__c = 'test@tes.com' ;
        o.Family_Contact_Relationship__c = 'Parent';
        o.Test_Class_Checkbox__c = True;
        o.Cash_Client__c = False;
        //o.Is_rescued_and_VOB_not_completed__c=False;
        o.Insurance_Providers__c= 'Spectra';
        o.Insurance_Collector__c =null;
        insert o;
        
        adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
        List<user> user1 = [SELECT id FROM user where isActive=:True and ProfileId =: adminProfile.Id LIMIT 2];
        
        Insurance_Collector_Round_Robin_User__c insColl1 = new Insurance_Collector_Round_Robin_User__c();
        insColl1.User_Id__c = user1[0].id;
        insColl1.Last_Assigned_To__c = true;
        insColl1.Name = 'test1';
        insert insColl1;

        Insurance_Collector_Round_Robin_User__c insColl2 = new Insurance_Collector_Round_Robin_User__c();
        insColl2.User_Id__c = user1[1].id;
        insColl2.Last_Assigned_To__c = False;
        insColl2.name = 'test2';
        insert insColl2;
        

            TriggerContextUtilityMSOpp.run = True;
           
           o.IsVOBCompleted__c= false;
           o.VOB_Status__c='Open';
           o.StageName = 'Admitted';
           o.Insurance_Collector__c = user1[1].id;
           update o;              
       test.StopTest();
      }
      

}