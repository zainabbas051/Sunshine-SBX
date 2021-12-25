@isTest
private class KIPUChartAudit_Test{
    Public static Account a;
    Public static Account a2;
    Public static Opportunity oms;
    Public static User u_test;
    public Static Profile adminProfile;
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
        
        tcs = new Trigger_Custom_Setting__c();
        tcs.Name = 'Default';
        tcs.Disable_manageKIPUAuditRecords__c = False;
        Insert tcs;
        
        a = new Account();
        a.Name = 'Test Account';
        a.Type = 'Treatment Center';
        insert a;
        
        a2 = new Account();
        a2.Name = 'Chapters Capistrano';
        a2.Type = 'Internal Center';
        insert a2;
        
        oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        oms.Account = a;
        oms.Selected_Treatment_Center__c = a.id;
        oms.Sunshine_Center__c = a2.id;
        oms.Closing_Agent__c = userAdmin.id;
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        oms.KIPU_MRN__c = '2020-19';
        insert oms;
        
     } 
     
     public Static testmethod void test_manageKIPUAuditRecords_Trigger(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           oms.StageName = 'Admitted';
           update oms;
           
           KIPU_Chart_Audit__c kca = new KIPU_Chart_Audit__c();
           kca = [Select id from KIPU_Chart_Audit__c where Opportunity__c =: oms.id LIMIT 1];
           
           KIPU_Audit_Week_Line_Item__c wli = new KIPU_Audit_Week_Line_Item__c();
           wli.KIPU_Chart_Audit__c = kca.id;
           wli.week_start_date__c = date.Today().addDays(8);
           wli.week_end_date__c = date.Today().addDays(14);
           insert wli;
           
           oms.StageName = 'Discharged';
           oms.Discharge_Type__c = 'Completed Treatment';
           oms.Check_Out_Date__c = date.Today().addDays(3);
           update oms;
       }       
       test.StopTest();
             
      }
      
      public Static testmethod void test_updateWeekLineItemReference_oc_Trigger(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           oms.StageName = 'Admitted';
           update oms;
           
           KIPU_Chart_Audit__c kca = new KIPU_Chart_Audit__c();
           kca = [Select id from KIPU_Chart_Audit__c where Opportunity__c =: oms.id LIMIT 1];
           
           KIPU_Audit_Week_Line_Item__c wli = new KIPU_Audit_Week_Line_Item__c();
           wli.KIPU_Chart_Audit__c = kca.id;
           wli.week_start_date__c = date.Today().toStartOfWeek().addDays(7);
           wli.week_end_date__c = wli.week_start_date__c.addDays(6);
           insert wli;
           
           KIPU_Audit_Outside_Contact__c oc = new KIPU_Audit_Outside_Contact__c();
           oc.KIPU_Chart_Audit__c = kca.id;
           oc.Date_Disclosed__c = date.today();
           oc.Live_Call__c = True;
           insert oc;
           
           delete oc;
       }       
       test.StopTest();
             
      }
      
      public Static testmethod void test_updateWeekLineItemReference_cpn_Trigger(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           oms.StageName = 'Admitted';
           update oms;
           
           KIPU_Chart_Audit__c kca = new KIPU_Chart_Audit__c();
           kca = [Select id from KIPU_Chart_Audit__c where Opportunity__c =: oms.id LIMIT 1];
           
           KIPU_Audit_Week_Line_Item__c wli = new KIPU_Audit_Week_Line_Item__c();
           wli.KIPU_Chart_Audit__c = kca.id;
           wli.week_start_date__c = date.Today().toStartOfWeek().addDays(7);
           wli.week_end_date__c = wli.week_start_date__c.addDays(6);
           insert wli;
           
           KIPU_Audit_Medical_Progress_Note__c mpn = new KIPU_Audit_Medical_Progress_Note__c();
           mpn.KIPU_Chart_Audit__c = kca.id;
           mpn.Date_of_Visit__c = date.today();
           insert mpn;
           
           delete mpn;
       }       
       test.StopTest();
             
      }
      
      public Static testmethod void test_updateWeekLineItemReference_Trigger(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           oms.StageName = 'Admitted';
           update oms;
           
           KIPU_Chart_Audit__c kca = new KIPU_Chart_Audit__c();
           kca = [Select id from KIPU_Chart_Audit__c where Opportunity__c =: oms.id LIMIT 1];
           
           KIPU_Audit_Week_Line_Item__c wli = new KIPU_Audit_Week_Line_Item__c();
           wli.KIPU_Chart_Audit__c = kca.id;
           wli.week_start_date__c = date.Today().toStartOfWeek().addDays(7);
           wli.week_end_date__c = wli.week_start_date__c.addDays(6);
           insert wli;
           
           KIPU_Audit_Clinical_Progress_Note__c mpn = new KIPU_Audit_Clinical_Progress_Note__c();
           mpn.KIPU_Chart_Audit__c = kca.id;
           mpn.Start_Date_Time__c = date.today();
           insert mpn;
           
           delete mpn;
       }       
       test.StopTest();
             
      }
  }