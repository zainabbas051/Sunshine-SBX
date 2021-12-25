@isTest(seeAllData=True)
private class historicalInsuranceCollectionUpdateTest{
    
    Public static Account a;
    Public static Account atc;
    Public static Account aip;
    Public static Opportunity o;
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
        
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        a = new Account();
        a.Name = 'Chapters';
        a.Type = 'Internal Center';
        insert a;
        
        atc = new Account();
        atc.Name = 'Chapters';
        atc.Type = 'Treatment Center';
        insert atc;
        
        aip = new Account();
        aip.Name = 'test account';
        aip.Type = 'Insurance Provider';
        aip.Chapters_Total_Billed_Amount__c = 100;
        aip.Chapters_Total_Collected_Amount__c = 100;
        aip.Willow_Total_Billed_Amount__c = 100;
        aip.Willow_Total_Collected_Amount__c = 100;
        aip.Mountain_Total_Billed_Amount__c = 100;
        aip.Mountain_Total_Collected_Amount__c = 100;
        aip.Monarch_Total_Billed_Amount__c = 100;
        aip.Monarch_Total_Collected_Amount__c = 100;
        insert aip;
        
        o = new Opportunity();
        o.Name = 'test opp';
        o.Account = a;
        o.Sunshine_Center__c = a.id;
        o.Selected_Treatment_Center__c = atc.id;
        o.Closing_Agent__c = userAdmin.id;
        o.Amount = 999;
        o.StageName = 'Paid';
        o.CloseDate = date.Today();
        o.recordTypeId = recTypeIdOpp;
        o.Test_Class_Checkbox__c  = true;
        o.Cash_Client__c = False;
        o.Insurance_Provider__c = aip.id;
        insert o;
    }
    
    public Static testmethod void historicalInsuranceCollectionUpdateTest(){
        test.startTest();
        
        createSampleData();          
        String returnString = historicalInsuranceCollectionUpdate.historicalInsuranceCollectionUpdate(o.id);
        
        a.Name = 'Willow';
        update a;
        
        o.per_Selected_Program__c = null;
        update o;
        
        String returnString2 = historicalInsuranceCollectionUpdate.historicalInsuranceCollectionUpdate(o.id); 
        
        a.Name = 'Mountain';
        update a;
        
        o.per_Selected_Program__c = null;
        update o;
        
        String returnString3 = historicalInsuranceCollectionUpdate.historicalInsuranceCollectionUpdate(o.id); 
        
        a.Name = 'Monarch';
        update a;
        
        o.per_Selected_Program__c = null;
        update o;
        
        String returnString4 = historicalInsuranceCollectionUpdate.historicalInsuranceCollectionUpdate(o.id); 
        
        String returnString5 = historicalInsuranceCollectionUpdate.historicalInsuranceCollectionUpdate(o.id);           
        
        test.StopTest();
    }
}