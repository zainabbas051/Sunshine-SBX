@isTest()
private class Utilities_TempTest {
    public Static Profile adminProfile;
     
    public Static testmethod void createPAATest(){
        
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        Account a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        
        
        Opportunity o_erp = new Opportunity();
        o_erp.Name = 'test opp';
        o_erp.Account = a;
        o_erp.Selected_Treatment_Center__c = a.id;
        o_erp.Closing_Agent__c = userAdmin.id;
        o_erp.Amount = 999;
        o_erp.StageName = 'Working';
        o_erp.CloseDate = date.Today();
        o_erp.recordTypeId = recTypeIdOpp;
        o_erp.Test_Class_Checkbox__c  = true;
        o_erp.Probation_Parole__c = 'Yes';
        insert o_erp;
        
        Pre_Admission_Assessment__c paa = new Pre_Admission_Assessment__c();
        paa.Opportunity__c = o_erp.id;
        insert paa;
        test.startTest();
        
        List<id> oppIdList = new List<id>();
        oppIdList.add(paa.id);
        
        Utilities_Temp.createPAA(oppIdList);
        
        test.stopTest();
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