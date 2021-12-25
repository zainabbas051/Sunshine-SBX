@isTest(seeAllData=True)
private class BizDevReferralOutEmailsTest{
    
    Public static Lead l;
    Public static Lead l2;
    Public static Opportunity o;
    Public static Opportunity o2;
    Public static Account a;
    Public static Account a2;
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
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId();
        Group queue = [select id from Group where Name=:'Unassigned Queue' AND Type = 'Queue'];
        
        l = New Lead();
        l.FirstName = 'Test';
        l.LastName = 'Test';
        l.LeadSource = 'Insurance Form';
        l.Company = 'test';
        l.Subscriber_Last_Name__c = 'Test';
        l.Subscriber_First_Name__c = 'Test';
        l.Contact_First_Name__c = 'Test';
        l.Contact_Last_Name__c = 'Test';
        l.Subscriber_DOB_Text__c = '2014-01-12';
        l.Email='test@test.com';
        l.recordTypeId = leadRecordTypeId;
        l.ownerid = queue.Id;
        l.Test_Class_Checkbox__c = True;
        l.Text_Sent_Queues__c = queue.id;
        l.Invoca_State__c = 'MI';
        l.LeadSource = 'Invoca Call';
        l.Call_Routing__c = 'Monarch Shores';
        l.Phone = '5863424795';
        l.Patient_DOB__c = '08/04/1988';
        l.City__c = 'Macomb';
        l.State__c = 'Michigan';
        l.Insurance_Providors__c = 'United health care'; 
        l.Insurance_Policy__c = '12345566';
        l.Group_Number__c = '1234';
        l.Insurance_Provider_Phone_Number__c = '586-342-4795';
        l.Reason_for_Referral_Out__c = 'Reason';
        l.Additional_Notes__c = 'Additional Notes';
        l.Biz_Dev_Access_Checkbox__c = True;
        insert l;
        
        l2 = New Lead();
        l2.FirstName = 'Test';
        l2.LastName = 'Test';
        l2.LeadSource = 'Insurance Form';
        l2.Company = 'test';
        l2.Contact_First_Name__c = 'Test';
        l2.Contact_Last_Name__c = 'Test';
        l2.Email='test@test.com';
        l2.recordTypeId = leadRecordTypeId;
        l2.ownerid = queue.Id;
        l2.Test_Class_Checkbox__c = True;
        l2.Text_Sent_Queues__c = queue.id;
        l2.Invoca_State__c = 'MI';
        l2.LeadSource = 'Invoca Call';
        l2.Call_Routing__c = 'Monarch Shores';
        l2.Biz_Dev_Access_Checkbox__c = True;
        insert l2;
        
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        a2 = new Account();
        a2.Name = 'test account';
        a2.Type = 'Insurance Provider';
        insert a2;
        
        o = new Opportunity();
        o.Name = 'test opp';
        o.Account = a;
        o.Selected_Treatment_Center__c = a.id;
        o.Closing_Agent__c = userAdmin.id;
        o.Amount = 999;
        o.StageName = 'Paid';
        o.CloseDate = date.Today();
        o.recordTypeId = recTypeIdOpp;
        o.Test_Class_Checkbox__c  = true;
        o.cash_client__c = True;//Making sure the opportunity is a Cash CLient, so that VOB is not initiated automatically
        insert o;
        
        o2 = new Opportunity();
        o2.Name = 'test opp';
        o2.Account = a;
        o2.Selected_Treatment_Center__c = a.id;
        o2.Closing_Agent__c = userAdmin.id;
        o2.Amount = 999;
        o2.StageName = 'Paid';
        o2.CloseDate = date.Today();
        o2.recordTypeId = recTypeIdOpp;
        o2.Test_Class_Checkbox__c  = true;
        o2.Incoming_Number__c = '5863424795';
        o2.Client_DOB__c = '08/04/88';
        o2.Insurance_Provider__c = a2.id;
        o2.Insurance_Policy__c='1234567';
        o2.Carve_Out_for_Behavioral_Health__c = 'Test';
        o2.Carve_Out_Policy_Number__c = '12345';
        o2.Carve_Out_Phone_Number__c = '5863424795';
        o2.Reason_for_Referral_Out__c = 'Test';
        o2.Reason_Lost__c = 'Acuity- Medical';
        o2.Additional_Notes__c = 'Additional Notes';
        insert o2;
        
        
        
    }
    
    public Static testmethod void BizDevReferralOutEmail_Leads_Test(){
        test.startTest();
        
            createSampleData();          
            String returnString = BizDevReferralOutEmails.BizDevReferralOutEmail_Leads(l.id);
        
            String returnString2 = BizDevReferralOutEmails.BizDevReferralOutEmail_Leads(l2.id);            
    
        test.StopTest();
    }
    
    public Static testmethod void BizDevReferralOutEmail_Opps_Test(){
        test.startTest();
        
            createSampleData();          
            String returnString = BizDevReferralOutEmails.BizDevReferralOutEmail_Opps(o.id);
        
            String returnString2 = BizDevReferralOutEmails.BizDevReferralOutEmail_Opps(o2.id);            
    
        test.StopTest();
    }
}