@isTest(seeAllData=true)
private class unclaimVOBTest{
 public Static ApexPages.StandardController opportunityController;
    Public static Opportunity o_erp;
    Public static Account a;
    public Static Profile adminProfile;

    public Static testmethod void test_unclaimVOB(){
       test.startTest();
       
           
           createSampleData();
           
           opportunityController = new ApexPages.StandardController(o_erp);
           ApexPages.currentPage().getParameters().put('id', o_erp.id);
           ApexPages.currentPage().getParameters().put('record_type_id', o_erp.recordTypeId);
           
           o_erp.ownerid=System.Label.Tahil_User_Id;
           update o_erp;
           
           system.runAs(userAdmin){
               ClaimToVOB.ClaimToVOB(o_erp.id);//Claiming the VOB Request as userAdmin and the claiming user is not a member of MS VOB Queue
               unclaimVOB.unclaimVOB(o_erp.id);//Unclaiming the VOB request as userAdmin, which will throw a validation message.
           }
           
           user TatianaUser = [select id from User where id=:system.label.Tatiana_User_Id];
           
           system.runAs(TatianaUser){
               unclaimVOB.unclaimVOB(o_erp.id);//Unclaiming an Open VOB request, will throw a Validation message.
           }
           
           o_erp.VOB_Status__c ='In Progress';
           o_erp.VOB_Agent__c = system.label.Tatiana_user_id;
           update o_erp;
           
           system.runAs(TatianaUser){
               unclaimVOB.unclaimVOB(o_erp.id);//Unclaiming an In Progress VOB request, to make sure the unclaim feature works.
           }
           
         test.StopTest();
             
      }
    public Static void createSampleData(){
        
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
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