@isTest(seeAllData=True)
private class clockLeadTest{
    
    Public static Lead l;
    
    public Static void createSampleData(){
        
        Id recTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        
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
        l.recordTypeId = recTypeId;
        l.ownerid = queue.Id;
        l.Test_Class_Checkbox__c = True;
        l.Text_Sent_Queues__c = queue.id;
        l.State__c= 'Michigan';
        insert l;
    }
    
    public Static testmethod void clockLeadTest(){
        test.startTest();
        
            createSampleData();   
            ApexPages.currentPage().getParameters().put('Id', l.id);
            ApexPages.StandardController sc = new ApexPages.StandardController(l);
            clockLead cl = new clockLead(sc); 
            
            //cl.geta();
            
            pageReference pr1 = cl.UserTime();
            pagereference pr2 = cl.ContactTime();
            
            string s1 = cl.gets1();
            string s2 = cl.gets2();
            string m1 = cl.getm1();
            string m2 = cl.getm2();
            string h1 = cl.geth1();
            string h2 = cl.geth2();
                  
            
        test.StopTest();
    }
}