@isTest
private class insertUpdateKUPUBillableItemsTest{
    Public static Account a;
    Public static Account SunshineCenter;
    Public static Opportunity oms;
    Public static User u_test;
    public Static Profile adminProfile;
    Public Static Client_KIPU_Snapshot__c cks;
    
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
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        SunshineCenter = new Account();
        SunshineCenter.Name = 'Chapters Capistrano';
        SunshineCenter.Type = 'Internal Center';
        insert SunshineCenter;
        
        oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        oms.Account = a;
        oms.Selected_Treatment_Center__c = a.id;
        oms.Closing_Agent__c = userAdmin.id;
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        oms.Sunshine_Center__c = SunshineCenter.id;
        oms.KIPU_MRN__c = 'CC2019-10';
        insert oms;
        
        Client_KIPU_Snapshot__c cks = new Client_KIPU_Snapshot__c();
        cks.KIPU_MRN__c = 'CC2019-10';
        cks.UR_Level_of_Care_Temp__c = 'RTC - Aetna';
        cks.Discharge_Date_Time__c = dateTime.Now();
        cks.Snapshot_Date__c = date.today();
        insert cks;
        
        Trigger_Custom_Setting__c tcs = new Trigger_Custom_Setting__c();
        tcs.Name = 'Default';
        tcs.Disable_insertUpdateKUPUBillableItems__c = False;
        insert tcs;   
        
     } 
     
     public Static testmethod void test_insertUpdateKUPUBillableItems_Trigger(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           KIPU_Billable_Items_Temp__c kbit1 = new KIPU_Billable_Items_Temp__c();
           kbit1.Appointment__c = 'Appointment';
           kbit1.KIPU_MRN__c = 'CC2019-10';
           kbit1.Start_Date__c = dateTime.Now();
           insert kbit1;
           
           KIPU_Billable_Items_Temp__c kbit2 = new KIPU_Billable_Items_Temp__c();
           kbit2.Appointment__c = 'Appointment';
           kbit2.KIPU_MRN__c = 'CC2019-10';
           kbit2.Start_Date__c = dateTime.Now();
           insert kbit2;
           
           KIPU_Billable_Items_Temp__c kbit3 = new KIPU_Billable_Items_Temp__c();
           kbit3.Evaluation_Template_Id__c = 'Evaluation';
           kbit3.KIPU_MRN__c = 'CC2019-10';
           kbit3.Start_Date__c = dateTime.Now();
           insert kbit3;
           
           KIPU_Billable_Items_Temp__c kbit4 = new KIPU_Billable_Items_Temp__c();
           kbit4.Evaluation_Template_Id__c = 'Evaluation';
           kbit4.KIPU_MRN__c = 'CC2019-10';
           kbit4.Start_Date__c = dateTime.Now();
           insert kbit4;
           
           KIPU_Billable_Items_Temp__c kbit5 = new KIPU_Billable_Items_Temp__c();
           kbit5.Session__c = 'Session';
           kbit5.KIPU_MRN__c = 'CC2019-10';
           kbit5.Start_Date__c = dateTime.Now();
           insert kbit5;
           
           KIPU_Billable_Items_Temp__c kbit6 = new KIPU_Billable_Items_Temp__c();
           kbit6.Session__c = 'Session';
           kbit6.KIPU_MRN__c = 'CC2019-10';
           kbit6.Start_Date__c = dateTime.Now();
           insert kbit6;
           
           KIPU_Billable_Items_Temp__c kbit7 = new KIPU_Billable_Items_Temp__c();
           kbit7.Speciment_ID__c = 'Lab Test';
           kbit7.KIPU_MRN__c = 'CC2019-10';
           kbit7.Collected__c = date.Today();
           insert kbit7;
           
           KIPU_Billable_Items_Temp__c kbit8 = new KIPU_Billable_Items_Temp__c();
           kbit8.Speciment_ID__c = 'Lab Test';
           kbit8.KIPU_MRN__c = 'CC2019-10';
           kbit8.Collected__c = date.Today();
           insert kbit8;
           
       }       
       test.StopTest();
             
      }
  }