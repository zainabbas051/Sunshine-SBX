@isTest(seeAllData=true)

private class ClaimToVOBTest{
 public Static ApexPages.StandardController opportunityController;
    Public static Opportunity o_erp;
    Public static Account a;
    public Static Profile adminProfile;


public Static testmethod void test_ClaimToVOB_Class(){
       test.startTest();
       system.runAs(userAdmin){
           
           createSampleData();
           
           opportunityController = new ApexPages.StandardController(o_erp);
           ApexPages.currentPage().getParameters().put('id', o_erp.id);
           ApexPages.currentPage().getParameters().put('record_type_id', o_erp.recordTypeId);
           
           o_erp.ownerid=System.Label.Tahil_User_Id;
           update o_erp;
           
           ClaimToVOB.ClaimToVOB(o_erp.id);//Claiming the VOB Request as userAdmin and the claiming user is not a member of MS VOB Queue
           
           //Adding the userAdmin user as a member of the MS VOB Queue
           List<Group> QueueId = [select Id from Group where Name = 'MS VOB Queue' and Type = 'Queue'];
           GroupMember gm = new GroupMember();
           gm.GroupId = QueueId[0].id;
           gm.UserOrGroupId = userAdmin.id;
           insert gm;
           
           ClaimToVOB.ClaimToVOB(o_erp.id);//Claiming the VOB Request as userAdmin after this user has been added as a member of MS VOB Queue
           list<user>LstConcernedUsers = new list<user>();
           LstConcernedUsers.add(userAdmin);
           ClaimToVOB.sendSMS (userAdmin.id,o_erp.name,LstConcernedUsers);
           
           //monarchShoresOpp.cancel1();

       }
         test.StopTest();
             
      }
public Static void createSampleData(){
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Lead;
        Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recTypeId = rtMapByName.get('Monarch Shores').getRecordTypeId(); 
        
        Schema.DescribeSObjectResult d_opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = d_opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
        
      
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        
        
        o_erp = new Opportunity();
        o_erp.Name = 'test opp';
        o_erp.Account = a;
        o_erp.Selected_Treatment_Center__c = a.id;
        o_erp.Closing_Agent__c = userAdmin.id;
        o_erp.Amount = 999;
        o_erp.StageName = 'Paid';
        o_erp.CloseDate = date.Today();
        o_erp.recordTypeId = recTypeIdOpp;
        o_erp.Test_Class_Checkbox__c  = true;
        o_erp.Cash_Client__c = False;
        o_erp.Insurance_Providers__c= 'Spectra';
        insert o_erp;
        
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