@isTest(seeAllData = True)
private class closureQueueAssignment_HandoverAssigTest{

    public Static Profile adminProfile;
    public static Lead l;
    public static Trigger_Custom_Setting__c tcs;
    public static MS_Admision_Coordinator_Schedule__c msacs;
    public static MS_Admision_Coordinator_Schedule__c msacs2;
    
    public Static testmethod void test_TransfertoMSNewCtrl_Class(){
       test.startTest();
           system.runAs(userAdmin){
           
           
           //createSampleSingleMAC();
           createSampleData();
           
           //l.status = 'Qualified';
           // update l;
           }
        test.StopTest();
             
    }
    
    /*public Static testmethod void TriggerContextUtility3(){
       test.startTest();
           TriggerContextUtility3.setFirstRunFalse();
           Boolean flag1 = TriggerContextUtility3.isFirstRun();
        test.StopTest();
             
    }*/
      
      
      public Static void createSampleSingleMAC(){
        
        msacs = New MS_Admision_Coordinator_Schedule__c();
        msacs.User__c = userAdmin.id;
        msacs.Monday_OFF__c = False;
        msacs.Monday_Start_Time__c = '0:00';
        msacs.Monday_End_Time__c = '23:30';
        msacs.Tuesday_OFF__c = False;
        msacs.Tuesday_Start_Time__c = '0:00';
        msacs.Tuesday_End_Time__c = '23:30';
        msacs.Wednesday_OFF__c = False;
        msacs.Wednesday_Start_Time__c = '0:00';
        msacs.Wednesday_End_Time__c = '23:30';
        msacs.Thursday_OFF__c = False;
        msacs.Thursday_Start_Time__c = '0:00';
        msacs.Thursday_End_Time__c = '23:30';
        msacs.Friday_OFF__c = False;
        msacs.Friday_Start_Time__c = '0:00';
        msacs.Friday_End_Time__c = '23:30';
        msacs.Saturday_OFF__c = False;
        msacs.Saturday_Start_Time__c = '0:00';
        msacs.Saturday_End_Time__c = '23:30';
        msacs.Sunday_OFF__c = False;
        msacs.Sunday_Start_Time__c = '0:00';
        msacs.Sunday_End_Time__c = '23:30';
        insert msacs;
        
     }
     
     
      
    public Static void createSampleData(){
        
        Id recTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        
        tcs = new Trigger_Custom_Setting__c();
        tcs.name = 'Default 2';
        tcs.Handover_Switch__c = False;
        insert tcs;
        
        l = New Lead();
        l.FirstName = 'Test';
        l.LastName = 'Test';
        l.LeadSource = 'Insurance Form';
        l.Company = 'test';
        l.Subscriber_Last_Name__c = 'Test';
        l.Subscriber_First_Name__c = 'Test';
        l.Contact_First_Name__c = 'Test';
        l.Contact_Last_Name__c = 'Test';
        l.Subscriber_DOB_Text__c = '2014-01-12';
        l.Email='test@test.com';
        l.recordTypeId = recTypeId;
        l.Test_Class_Checkbox__c = True;
        l.Invoca_State__c = 'MI';
        l.LeadSource = 'Invoca Call';
        l.Call_Routing__c = 'Monarch Shores';
        l.status = 'Qualified';
        insert l;
        
        
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

}