@isTest
private class updateBizibleAttributionOnOppTest{
    
    Public static Account a;
    Public static Opportunity opp;
    Public static bizible2__Bizible_Attribution_Touchpoint__c bt;
    
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
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        opp = new Opportunity();
        opp.Name = 'test opp';
        opp.AccountId = a.id;
        opp.Selected_Treatment_Center__c = a.id;
        opp.Closing_Agent__c = userAdmin.id;
        opp.Amount = 999;
        opp.StageName = 'Paid';
        opp.CloseDate = date.Today();
        opp.recordTypeId = oppRecordTypeId;
        insert opp;
        
        bt = new bizible2__Bizible_Attribution_Touchpoint__c();
        bt.bizible2__Opportunity__c = opp.id;
        bt.bizible2__Ad_Campaign_Name__c = 'Google Bing';
        bt.bizible2__Ad_Content__c = 'Google Bing';
        bt.bizible2__Ad_Destination_URL__c = 'www.google.com';
        bt.bizible2__Ad_Group_Name__c = 'GOOGLE PIXEL';
        bt.bizible2__Browser__c = 'Google';
        bt.bizible2__Form_URL__c = 'www.google.com';
        bt.bizible2__Geo_City__c = 'Macomb';
        bt.bizible2__Geo_Country__c = 'United States';
        bt.bizible2__Geo_Region__c = 'Michigan';
        bt.bizible2__Keyword_Text__c = 'Google Keyword';
        bt.bizible2__Landing_Page__c = 'www.eliterehabplacement.com';
        bt.bizible2__Marketing_Channel_Path__c = 'Direct';
        bt.bizible2__Marketing_Channel__c = 'Direct';
        bt.bizible2__Medium__c = 'Web';
        bt.bizible2__Platform__c = 'Android (5.1)';
        bt.bizible2__Referrer_Page__c = 'www.addictionnetwork.com';
        bt.bizible2__Segment__c = 'Segment';
        bt.bizible2__Touchpoint_Position__c = 'FT';
        bt.bizible2__Touchpoint_Source__c = 'Web Direct';
        bt.bizible2__Touchpoint_Type__c = 'Web Visit';
        bt.bizible2__UniqueId__c = 'a19857894231';
        insert bt;
        
    }
    
   
    
    public Static testmethod void testCase1(){
        test.startTest();
        
        createSampleData();
        
        test.StopTest();
    }
    
     
}