@isTest(seeAllData=True)
private class customEmailClassOppTest{
    
    Public static Account a;
    Public static Opportunity o;
    public Static Profile adminProfile;
    public Static ApexPages.StandardController opportunityController;
    public Static customEmailClassOpp customEmail;
    
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
        
       
        Schema.DescribeSObjectResult d_opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = d_opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Elite Rehab Placement').getRecordTypeId(); 
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        o = new Opportunity();
        o.Name = 'test opp';
        o.Account = a;
        o.Selected_Treatment_Center__c = a.id;
        o.Closing_Agent__c = userAdmin.id;
        o.Amount = 999;
        o.StageName = 'Paid';
        o.CloseDate = date.Today();
        o.recordTypeId = recTypeIdOpp;
        insert o;
        
        
        
     } 
    
    public Static testmethod void testSendEmailOpp(){
           
           test.startTest();
           createSampleData();
           
           Placement_Center__c pc = new Placement_Center__c();
           pc.Name = 'Monarch Shores';
           pc.Email__c = 'test@test.com';
           pc.Active__c = True;
           Insert pc;
           
           Placement_Center__c pc2 = new Placement_Center__c();
           pc2.Name = 'Solid Landings';
           pc2.Email__c = 'test@test.com';
           pc2.Active__c = True;
           Insert pc2;
           
           opportunityController = new ApexPages.StandardController(o);
           customEmail = new customEmailClassOpp(opportunityController); 
           ApexPages.currentPage().getParameters().put('Id', o.id);
           
           customEmail.setplacementCenter(pc2.id);
           customEmail.go();
           
           o.Name ='Test';
           //o.DOB__c = 'Test';           
           o.Subscriber_Name__c ='Test';
           o.Insurance_Providers__c ='Test';
           o.Insurance_Policy__c ='Test';
           o.Group_Number__c ='Test';
           o.Insurance_Provider_Phone_Number__c ='Test';
           o.Subscriber_DOBtext__c ='01/01/2014';
           o.SSN_Last_4__c ='Test';
           customEmail.go();
           
           Boolean pageFlag = customEmail.selectionPageFlag;
           String userName = customEmail.fromUserName;
           
           customEmail.sendEmail();
           
           o.Address_2__c = 'test@test.com;test';
           o.City__c = 'test';
           o.Country__c = 'test';
           o.Address__c = Null;
           customEmail.sendEmail();
           
           o.Address_2__c = Null;
           customEmail.sendEmail();
           
           List<SelectOption> so = new List<SelectOption>();
           so = customEmail.getItems();
           customEmail.pleacementCenterSet();
           customEmail.cancel1();
                      
       test.StopTest();
      }
    
}