@isTest
private class AuditWeeklyLineItemCreateBatch_Test{
    Public static Account a;
    Public static Account a2;
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
     
     public Static testmethod void testBatchClass(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           oms.StageName = 'Admitted';
           update oms;
           
           AuditWeeklyLineItemCreateSch b = new AuditWeeklyLineItemCreateSch();
           b.execute(null);
           
       }       
       test.StopTest();
             
      }
      
      
  }