@isTest(seeAllData=true)
private class squeezeThePulpOpportunityTest{
    Public static Opportunity o_erp;
    Public static Account a;
    public Static Profile adminProfile;


    public Static testmethod void test_ClaimToVOB_Class(){
       test.startTest();
       
           createSampleData();

           squeezeThePulpOpportunity.squeezeThePulpOpportunity(o_erp.id,o_erp.ownerId,o_erp.Name,a.id);//Claiming the VOB Request as userAdmin and the claiming user is not a member of MS VOB Queue
           
       test.StopTest();
             
      }
    public Static void createSampleData(){
        
        Schema.DescribeSObjectResult d_opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = d_opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Elite Rehab Placement').getRecordTypeId(); 
        
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
        o_erp.Reason_not_admitted_to_Sunshine_Center__c = 'Sunshine Denied';
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