@isTest
private class updateOpportunityReferenceTest{
    Public static Account a;
    Public static Account SunshineCenter;
    Public static Opportunity oms;
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
        
        Trigger_Custom_Setting__c tcs = new Trigger_Custom_Setting__c();
        tcs.Name = 'Default';
        tcs.Disable_updateOpportunityReference__c = False;
        insert tcs;   
        
     } 
     
     public Static testmethod void test_DeleteSnapshots_Trigger(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           list<Client_KIPU_Snapshot__c> cksInsertList= new List<Client_KIPU_Snapshot__c>();
           
           Client_KIPU_Snapshot__c cks = new Client_KIPU_Snapshot__c();
           cks.KIPU_MRN__c = 'CC2019-10';
           cks.UR_Level_of_Care_Temp__c = 'RTC - Aetna';
           cks.Discharge_Date_Time__c = dateTime.Now();
           cks.Snapshot_Date__c = date.today();
           cksInsertList.add(cks);
           
           Client_KIPU_Snapshot__c cks2 = new Client_KIPU_Snapshot__c();
           cks2.KIPU_MRN__c = 'CC2019-10';
           cks2.UR_Level_of_Care_Temp__c = 'DTX - Aetna';
           cks2.Discharge_Date_Time__c = dateTime.Now();
           cks2.Snapshot_Date__c = date.today();
           cksInsertList.add(cks2);
           
           insert cksInsertList;
           
       }       
       test.StopTest();
             
      }
      
      public Static testmethod void test_SnapshotsForAdmittedOpps_Trigger(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           oms.StageName = 'Admitted';
           update oms;
           
           list<Client_KIPU_Snapshot__c> cksInsertList= new List<Client_KIPU_Snapshot__c>();
           
           Client_KIPU_Snapshot__c cks = new Client_KIPU_Snapshot__c();
           cks.KIPU_MRN__c = 'CC2019-10';
           cks.UR_Level_of_Care_Temp__c = 'RTC - Aetna';
           cks.Discharge_Date_Time__c = dateTime.Now();
           cks.Snapshot_Date__c = date.today();
           cksInsertList.add(cks);
           
           Client_KIPU_Snapshot__c cks2 = new Client_KIPU_Snapshot__c();
           cks2.KIPU_MRN__c = 'CC2019-10';
           cks2.UR_Level_of_Care_Temp__c = 'DTX - Aetna';
           cks2.Discharge_Date_Time__c = dateTime.Now();
           cks2.Snapshot_Date__c = date.today();
           cksInsertList.add(cks2);
           
           Client_KIPU_Snapshot__c cks3 = new Client_KIPU_Snapshot__c();
           cks3.KIPU_MRN__c = 'CC2019-10';
           cks3.UR_Level_of_Care_Temp__c = 'PHP - Aetna';
           cks3.Discharge_Date_Time__c = dateTime.Now();
           cks3.Snapshot_Date__c = date.today();
           cksInsertList.add(cks3);
           
           Client_KIPU_Snapshot__c cks4 = new Client_KIPU_Snapshot__c();
           cks4.KIPU_MRN__c = 'CC2019-10';
           cks4.UR_Level_of_Care_Temp__c = 'IOP - Aetna';
           cks4.Discharge_Date_Time__c = dateTime.Now();
           cks4.Snapshot_Date__c = date.today();
           cksInsertList.add(cks4);
           
           Client_KIPU_Snapshot__c cks5 = new Client_KIPU_Snapshot__c();
           cks5.KIPU_MRN__c = 'CC2019-10';
           cks5.UR_Level_of_Care_Temp__c = 'OP - Aetna';
           cks5.Discharge_Date_Time__c = dateTime.Now();
           cks5.Snapshot_Date__c = date.today();
           cksInsertList.add(cks5);
           
           insert cksInsertList;
       }       
       test.StopTest();
             
      }
      
      public Static testmethod void test_SnapshotsForNoMatchingOps_Trigger(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           oms.StageName = 'Admitted';
           update oms;
           
           list<Client_KIPU_Snapshot__c> cksInsertList= new List<Client_KIPU_Snapshot__c>();
           
           Client_KIPU_Snapshot__c cks = new Client_KIPU_Snapshot__c();
           cks.KIPU_MRN__c = 'CC2019-10';
           cks.UR_Level_of_Care_Temp__c = 'RTC - Aetna';
           cks.Discharge_Date_Time__c = dateTime.Now();
           cks.Snapshot_Date__c = date.today();
           cksInsertList.add(cks);
           
           Client_KIPU_Snapshot__c cks2 = new Client_KIPU_Snapshot__c();
           cks2.KIPU_MRN__c = 'CC2019-10';
           cks2.UR_Level_of_Care_Temp__c = 'DTX - Aetna';
           cks2.Discharge_Date_Time__c = dateTime.Now();
           cks2.Snapshot_Date__c = date.today();
           cksInsertList.add(cks2);
           
           Client_KIPU_Snapshot__c cks3 = new Client_KIPU_Snapshot__c();
           cks3.KIPU_MRN__c = 'CC2019-10';
           cks3.UR_Level_of_Care_Temp__c = 'PHP - Aetna';
           cks3.Discharge_Date_Time__c = dateTime.Now();
           cks3.Snapshot_Date__c = date.today();
           cksInsertList.add(cks3);
           
           Client_KIPU_Snapshot__c cks4 = new Client_KIPU_Snapshot__c();
           cks4.KIPU_MRN__c = 'CC2019-10';
           cks4.UR_Level_of_Care_Temp__c = 'IOP - Aetna';
           cks4.Discharge_Date_Time__c = dateTime.Now();
           cks4.Snapshot_Date__c = date.today();
           cksInsertList.add(cks4);
           
           Client_KIPU_Snapshot__c cks5 = new Client_KIPU_Snapshot__c();
           cks5.KIPU_MRN__c = 'CC2019-11';
           cks5.UR_Level_of_Care_Temp__c = 'OP - Aetna';
           cks5.Discharge_Date_Time__c = dateTime.Now();
           cks5.Snapshot_Date__c = date.today();
           cksInsertList.add(cks5);
           
           insert cksInsertList;
           
       }       
       test.StopTest();
             
      }
      
      public Static testmethod void test_SnapshotsForNoMatchingOps2_Trigger(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           oms.KIPU_MRN__c = 'CC2019-11';
           oms.StageName = 'Admitted';
           update oms;
           
           list<Client_KIPU_Snapshot__c> cksInsertList= new List<Client_KIPU_Snapshot__c>();
           
           Client_KIPU_Snapshot__c cks = new Client_KIPU_Snapshot__c();
           cks.KIPU_MRN__c = 'CC2019-10';
           cks.UR_Level_of_Care_Temp__c = 'RTC - Aetna';
           cks.Discharge_Date_Time__c = dateTime.Now();
           cks.Snapshot_Date__c = date.today();
           cksInsertList.add(cks);
           
           Client_KIPU_Snapshot__c cks2 = new Client_KIPU_Snapshot__c();
           cks2.KIPU_MRN__c = 'CC2019-10';
           cks2.UR_Level_of_Care_Temp__c = 'DTX - Aetna';
           cks2.Discharge_Date_Time__c = dateTime.Now();
           cks2.Snapshot_Date__c = date.today();
           cksInsertList.add(cks2);
           
           insert cksInsertList;
       }       
       test.StopTest();
             
      }
  }