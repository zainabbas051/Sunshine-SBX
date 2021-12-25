@isTest//(SeeAllData=true)
private class TestSuite{
    
    Public static Lead l;
    Public static Account a;
    Public static Opportunity o;
    Public static Opportunity o_erp;
    Public static User u_test;
    public Static Profile adminProfile;
    public Static ApexPages.StandardController opportunityController;
    public Static monarchShoresOpportunities monarchShoresOpp;
 
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
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Lead;
        Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recTypeId = rtMapByName.get('Elite Rehab Placement').getRecordTypeId(); 
        
        Schema.DescribeSObjectResult d_opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = d_opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Elite Rehab Placement').getRecordTypeId(); 
        
        
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
        //l.ownerid = '00GU0000001M4VD';
        insert l;
        
        Lead l1 = New Lead();
        l1.FirstName = 'Test';
        l1.LastName = 'Test';
        l1.LeadSource = 'Contact Form';
        l1.Company = 'Test';
        l1.Email='test@test.com';
        l1.Preferred_Contact__c = 'Daytime Phone';
        //l.phone = 8447751453;
        insert l1;
        
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
        insert o;
        
        o_erp = new Opportunity();
        o_erp.Name = 'test opp';
        o_erp.Account = a;
        o_erp.Selected_Treatment_Center__c = a.id;
        o_erp.Closing_Agent__c = userAdmin.id;
        o_erp.Amount = 999;
        o_erp.StageName = 'Paid';
        o_erp.CloseDate = date.Today();
        o_erp.recordTypeId = recTypeIdOpp;
        o_erp.Reason_not_admitted_to_Sunshine_Center__c  = 'Acuity- Medical';
        insert o_erp;
        
     } 

       public Static testmethod void testWebtToLeadData(){
       test.startTest();
       createSampleData();
       
              
       test.StopTest();
             
      }
      
      public Static testmethod void testLeadHelperTrigger(){
       test.startTest();       
       system.runAs(userAdmin){
           
           createSampleData();
           
       
           lead l2 = new lead();
           l2.LastName = 'Test';
           l2.Company = 'Test';
           l2.LeadSource = 'Other';
           l2.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId();
           l2.Status = 'Qualified';
           l2.Test_Class_Checkbox__c = True;
           l2.Client_Calling__c = 'Yes';
           insert l2;
           
           
           Lead_Helper__c lh = new Lead_Helper__c();
           lh.lead_Id__c = l2.id;
           insert lh;
           
           lh.Lead_Update_Needed__c = True;
           update lh;
       }       
       test.StopTest();
             
      }
      
      public Static testmethod void testQueueManagement(){
       test.startTest();       
       system.runAs(userAdmin){
        
           Queues__c  q = new Queues__c ();
           q.name = 'Inferno';
           q.Last_assigned__c = true;
           //q.Queue_Name__c = 'Inferno';
           insert q;
           
           Queues__c  q2 = new Queues__c ();
           q2.name = 'Sparta';
           //q2.Queue_Name__c = 'Sparta';
           insert q2;
           
           NW_Queues__c q3 = new NW_Queues__c();
           q3.name = 'The Samurai';
           q3.last_assigned__c = true;
           //q3.Queue_Name__c = 'The Samurai';
           insert q3;
           
           CtrlManageQueues obj = new CtrlManageQueues();
           obj.showAddQueueScreen();
           obj.cancel();
           obj.indexVal =1;
           obj.EditW();
           obj.indexVal =1;
           obj.EditNW();
           obj.indexVal =1;
           obj.DelW();
           obj.indexVal =1;
           obj.DelNW();
           obj.indexVal =1;
           obj.DisableNW();
           obj.indexVal =1;
           obj.DisableW();
           obj.indexVal =1;
           obj.SaveNW();
           
           obj.SaveW();
           obj.SaveNewQueues();
           
           
       }       
       test.StopTest();
             
      }

        public Static testmethod void testANPricePopulationTrigger(){
           test.startTest();
           system.runAs(userAdmin){
           
           Schema.DescribeSObjectResult d = Schema.SObjectType.Lead;
            Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
            Id recTypeId = rtMapByName.get('Addiction Network').getRecordTypeId();

           lead l2 = new lead();
           l2.recordtypeid = recTypeId;
           l2.LastName = 'Test';
           l2.Company = 'Test';
           l2.Status = 'Open';
           l2.Test_Class_Checkbox__c = True;
           
           insert l2;
           
       }       
       test.StopTest();
             
      }
      
       public Static testmethod void testRecordTypeUpdateTrigger(){
           test.startTest();
           system.runAs(userAdmin){
           
           Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
            Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
            Id recTypeId = rtMapByName.get('Elite Rehab Placement').getRecordTypeId();
            
            Opportunity opp = new Opportunity();
            opp.Addiction_Network_Lead__c = True;
            opp.StageName = 'Initial Qualified Contact';
            opp.CloseDate = date.Today();
            opp.Name = 'test opp';
            opp.Account = a;
            //opp.Selected_Treatment_Center__c = a.id;
            opp.Closing_Agent__c = userAdmin.id;
            //opp.Amount = 999;
            opp.recordtypeid = recTypeId;
            
            insert opp;
            }
            test.stopTest();
      }
      
      public Static testmethod void testANPricePopulationTrigger_Opportunity(){
           test.startTest();
           system.runAs(userAdmin){
           
           Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
            Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
            Id recTypeId = rtMapByName.get('Addiction Network').getRecordTypeId();

           Opportunity l2 = new Opportunity();
           l2.StageName = 'Initial Qualified Contact';
           l2.CloseDate = date.Today();
           l2.Name = 'test opp';
           l2.recordtypeid = recTypeId;
           l2.Test_Class_Checkbox__c = True;
           insert l2;
           
           update l2;
       }       
       test.StopTest();
             
      }


      public Static testmethod void testMyFutureHandler(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           list<Group> queueList = new list<Group>(); 
           queueList = [select id, Name from Group where Type =: 'Queue' AND (Name =: 'Shield Ops' OR Name =: 'Closers Queue')];
           
           Map<Id,Id> leadIdQueueIdMap = new Map<Id,id>();
           Map<Id,String> leadIdOwnerNameMap = new Map<Id,String>();
           Map<Id,String> leadIdQueueNameMap = new Map<Id,String>();
           
           for(Group q : queueList){
               if(q.Name == 'Shield Ops'){
                   leadIdQueueIdMap.put(l.id,q.id);
                   leadIdOwnerNameMap.put(l.id,'Test');
                   leadIdQueueNameMap.put(l.id,q.Name);
                   MyFutureClass.leadAssignmentMethod(leadIdQueueIdMap,leadIdOwnerNameMap,leadIdQueueNameMap);    
               }
               if(q.Name == 'Closers Queue'){
                   leadIdQueueIdMap.put(l.id,q.id);
                   MyFutureClass.leadAssignmentMethod(leadIdQueueIdMap);            
               }
                   
           }
       }       
       test.StopTest();
             
      }

      
      public Static testmethod void testSendingSMSTextTrigger(){
          
           test.startTest();
           createSampleData();
       /*
           l.ownerid = '00GU0000001M4VD';
           l.Test_Class_Checkbox__c = True;
           update l;
       
           l.ownerid = '00GU0000001Lw4R';
           update l;
           
           l.ownerid = '00GU0000001Ma7A';
           update l;
           
           l.ownerid = '00GU0000001MgQ1';
           update l;
           
           
           
           l.ownerid = '00GU0000002SYbG';
           update l;
           
           l.ownerid = '00GU0000002T5mf';
           update l;
           try{
           l.ownerid = '00GU0000002ToHS';
           update l;
           
           l.ownerid = '00GU0000002UyKA';
           update l;
           }
           catch(exception e){system.debug(e.getMessage());}
           Schema.DescribeSObjectResult d = Schema.SObjectType.Lead;
            Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
            Id recTypeId = rtMapByName.get('Addiction Network').getRecordTypeId(); 
            try{            
            l.recordTypeId = recTypeId;
            l.ownerid = '00GU0000002T9lD';
           update l;
           
           l.ownerid = '00GU0000002T9lI';
           update l;
           
           Id recTypeId2 = rtMapByName.get('Monarch Shores').getRecordTypeId(); 
                        
            l.recordTypeId = recTypeId2;
            l.ownerid = '00GU0000002UqzR';
           update l;
           
           l.ownerid = '00GU0000002UqzW';
           update l;
           
           l.ownerid = '00GU0000002mgcV';
           update l;
            }
            catch(exception e){system.debug(e.getMessage());}*/
       test.StopTest();
      }
      
      public Static testmethod void testSendSMSClosedWonOpportunityTrigger(){
          
           test.startTest();
           createSampleData();
       
           o.StageName = 'Closed Won';
           o.Test_Class_Checkbox__c = True;
           o.Travel_Costs__c = 0.00;
           update o;
       
           
       test.StopTest();
      }
      
      public Static testmethod void testSendSMSNewOpportunityOwner(){
          
           test.startTest();
           createSampleData();

           o.OwnerId = [Select id from user where isactive = true limit 1].Id;
           o.Test_Class_Checkbox__c = True;
           update o;
       
           
       test.StopTest();
      }
      
     
      
      public Static testmethod void testAddictionNetworkOpportunityBillingMail(){
           test.startTest();
           system.runAs(userAdmin){
           
               Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
                Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
                Id recTypeId = rtMapByName.get('Addiction Network').getRecordTypeId();
                
                Opportunity opp = new Opportunity();
                opp.StageName = 'Initial Qualified Contact';
                opp.CloseDate = date.Today()-1;
                opp.Name = 'test opp';
                opp.Account = a;
                opp.Closing_Agent__c = userAdmin.id;
                opp.recordtypeid = recTypeId;
                opp.Renew_Date__c = date.Today();
                opp.Account_Status__c = 'Active';
                insert opp;
                
                addictionNetworkOpportunityBillingMail objectInstance = new addictionNetworkOpportunityBillingMail();
                objectInstance.addictionNetworkOpportunityBillingMail();
                
                
            }
            test.stopTest();
      }
      
      public Static testmethod void testAddictionNetworkWebToLeadClass(){
           test.startTest();
           system.runAs(userAdmin){
           
                Messaging.InboundEmail email = new Messaging.InboundEmail();
                Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
                
                AddictionNetworkWebToLeadClass instance = new AddictionNetworkWebToLeadClass();
                
                //email.HTMLBody = '<html>name Test  Last  Name Test  Company Test  Contact Phone 8527834688  Contact Email de@gmail.com  category adolescent  Treatment Center Name Test  Website https://www.google.com  Intake Email developers.salesforce.com@gmail.com  Intake Phone 8527834688  Street Address Test 1  City New York  State NY  Zip 122001  Country Test  Brief Overview Test  Overview of Program Test  Treatment Approach Test  Unique Selling Points Test</html>';
                email.HTMLBody = '<html><Table><tr><td>name</td><td>Test</td></Tr><tr><td>Last Name</td><td>Test</td></Tr><tr><td>Company</td><td>Test</td></Tr><tr><td>Contact Phone</td><td>8527834688</td></Tr><Tr><td>Contact Email</td><td> </td></Tr><tr><td>category</td><td>adolescent</td></Tr><tr><td>Treatment Center Name</td><td>Test</td></Tr><tr><td>Website</td><td>https://www.google.com</td></Tr><tr><td>Intake Email</td><td> </td></Tr><tr><td>Intake Phone</td><td>8527834688</td></Tr><tr><td>Street Address</td><td>Test 1</td></Tr><tr><td>City</td><td>New York</td></Tr><tr><td>State</td><td>NY</td></Tr><tr><td>Zip</td><td>122001</td></Tr><tr><td>Country</td><td>Test</td></Tr><tr><td>Brief Overview</td><td>Test</td></Tr><tr><td>Overview of Program</td><td>Test</td></Tr><tr><td>Treatment Approach</td><td>Test</td></Tr><tr><td>Unique Selling Points</td><td>Test</td></Tr></Table></HTML>';
                Messaging.InboundEmailResult result = instance.handleInboundEmail(email, env);
            }
            test.stopTest();
      }
      
      /*public Static testmethod void testANOpportunityAndAttachmentTrigger(){
           test.startTest();
           system.runAs(userAdmin){
           
               Schema.DescribeSObjectResult d = Schema.SObjectType.Lead;
            Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
            Id recTypeId = rtMapByName.get('Addiction Network').getRecordTypeId();

           lead l2 = new lead();
           l2.recordtypeid = recTypeId;
           l2.LastName = 'Test';
           l2.Company = 'Test';
           l2.Status = 'Open';
           l2.Test_Class_Checkbox__c = True;
           insert l2;
           
           Attachment att = new Attachment();
            att.name = 'test attachment';
            att.body = blob.valueof('attachment body');
            att.parentid = l2.Id;
            att.description = 'Lead ID: "'+l2.id+'"';
           insert att;
           
           Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(l2.id);
            lc.setDoNotCreateOpportunity(false);
            lc.setConvertedStatus('Free Listing Active');
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess()); 
            }
            test.stopTest();
      }*/
      
      public Static testmethod void testAccountStatusCheckANOpps(){
           test.startTest();
           system.runAs(userAdmin){
           
               Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
                Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
                Id recTypeId = rtMapByName.get('Addiction Network').getRecordTypeId();
                
                Opportunity opp = new Opportunity();
                opp.StageName = 'Initial Qualified Contact';
                opp.CloseDate = date.Today()-1;
                opp.Name = 'test opp';
                opp.Account = a;
                opp.Closing_Agent__c = userAdmin.id;
                opp.recordtypeid = recTypeId;
                opp.Renew_Date__c = date.Today();
                opp.Account_Status__c = 'Active';
                insert opp;
                
                
                update opp;  
                
                
            }
            test.stopTest();
      }
      
      /*public Static testmethod void testActiveEmailForANLead_Class(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
       
           Schema.DescribeSObjectResult d = Schema.SObjectType.Lead;
           Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
           Id recTypeId = rtMapByName.get('Addiction Network').getRecordTypeId(); 
                        
           l.recordTypeId = recTypeId;
           update l;
           
           PageReference pageRef = Page.activeEmailForANLead_Page;
           Test.setCurrentPage(pageRef);
           
           ApexPages.currentPage().getParameters().put('id',l.id);
           
           activeEmailForANLead_Class controller = new activeEmailForANLead_Class();
           String nextPage = controller.sendEmail().getUrl();
           
            //The following line of code is for test coverage of ANLeadAttachmentDescriptionUpdate Trigger
            Blob b = Blob.valueOf('Test Data');
            Attachment attachment = new Attachment();
            attachment.ParentId = l.ID;
            attachment.Name = 'Test Attachment for Parent';
            attachment.Body = b;
            insert(attachment);
           
       }       
       test.StopTest();
             
      }
      */
      
      /*
      public Static testmethod void test_monarchShoresOpportunities_Class(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           opportunityController = new ApexPages.StandardController(o_erp);
           monarchShoresOpp = new monarchShoresOpportunities(opportunityController); 
           ApexPages.currentPage().getParameters().put('Id', o_erp.id);
           
           ApexPages.currentPage().getParameters().put('record_type_id', o_erp.recordTypeId);
           
           monarchShoresOpp.createMonarchShoresOpportunity();
           
           monarchShoresOpp.cancel1();
           
           List<SelectOption> sol = new List<SelectOption>();
           sol = monarchShoresOpp.getItems();
           
           Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
           Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
           Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
           
           Opportunity oms = new Opportunity();
           oms.Name = 'test opp';
           oms.RecordTypeId = recTypeIdOpp;
           oms.Account = a;
           oms.Selected_Treatment_Center__c = a.id;
           oms.Closing_Agent__c = userAdmin.id;
           oms.Amount = 999;
           oms.StageName = 'Working';
           oms.CloseDate = date.Today();
           oms.Test_Class_Checkbox__c = True;
           insert oms;
           
           ApexPages.currentPage().getParameters().put('Id', oms.id);
           
           ApexPages.currentPage().getParameters().put('record_type_id', oms.recordTypeId);
           
           monarchShoresOpp.createEliteRehabPlacementOpportunity();
           
           List<SelectOption> so2 = new List<SelectOption>();
           so2 = monarchShoresOpp.getItems();
           
       }       
       test.StopTest();
             
      }*/
      
      public Static testmethod void test_MSOpportunityAssignmentTrigger(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
           Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
           Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
           
           Opportunity oms = new Opportunity();
           oms.Name = 'test opp';
           oms.RecordTypeId = recTypeIdOpp;
           oms.Account = a;
           oms.Selected_Treatment_Center__c = a.id;
           oms.Closing_Agent__c = userAdmin.id;
           oms.Amount = 999;
           oms.StageName = 'Working';
           oms.CloseDate = date.Today();
           oms.Test_Class_Checkbox__c = True;
           insert oms;
           
           
       }       
       test.StopTest();
             
      }
      
      public Static testmethod void test_ERPOpportunityAssignmentTrigger_CreatedFromMS(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
           Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
           Id recTypeIdOpp = rtMapByNameOpp.get('Elite Rehab Placement').getRecordTypeId(); 
           
           Opportunity oms = new Opportunity();
           oms.Name = 'test opp';
           oms.RecordTypeId = recTypeIdOpp;
           oms.Account = a;
           oms.Selected_Treatment_Center__c = a.id;
           oms.Closing_Agent__c = userAdmin.id;
           oms.LeadSource = 'Monarch Shores';
           oms.Amount = 999;
           oms.StageName = 'Working';
           oms.CloseDate = date.Today();
           oms.Test_Class_Checkbox__c = True;
           insert oms;
           
           
       }       
       test.StopTest();
             
      }
    public static testMethod void test_TrgLeadSendSMSToIntakeAgent(){
        
        test.startTest();
        //monarch shores record type id
        Id LeadRecordTypeID = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        
        
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
        l.recordTypeId = LeadRecordTypeID;
        l.Status    ='Open';
        l.Opening_Agent__c = UserInfo.getUserId(); 
        insert l;
        
        TriggerContextUtilityAN.run = true;
        
        l.Status = 'ERP';
        update l;       
        
        test.stopTest();        
    }
    
    public static testMethod void test_ctlLeadVerification(){
        
        test.startTest();
        //monarch shores record type id
        Id LeadRecordTypeID = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        
        
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
        l.recordTypeId = LeadRecordTypeID;
        //l.ownerid = '00GU0000001M4VD';        
        insert l;        
        
        PageReference myVfPage = Page.LeadInsuranceVerificationVFP;
        Test.setCurrentPage(myVfPage);
        
        ApexPages.currentPage().getParameters().put('id', l.id);
        
        ctlLeadVerification obj = new ctlLeadVerification();
        obj.EditPage();
        obj.saveLeadVerification();
        obj.cancel();
        test.stopTest();        
    }
    
    public static testMethod void test_ctlLeadVerification2(){
        
        test.startTest();
        //monarch shores record type id
        Id LeadRecordTypeID = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        
        
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
        l.recordTypeId = LeadRecordTypeID;
        l.Client_Calling__c = 'Yes';
        l.Live_Transferred__c = 'Yes';
        //l.ownerid = '00GU0000001M4VD';        
        insert l;
        
        Lead_Verification__c lv = new Lead_Verification__c();
        lv.Lead__c = l.id;
        insert lv;
                
        PageReference myVfPage = Page.LeadInsuranceVerificationVFP;
        Test.setCurrentPage(myVfPage);
        
        ApexPages.currentPage().getParameters().put('id', l.id);
        
        ctlLeadVerification obj = new ctlLeadVerification();
        
        obj.saveLeadVerification();
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(l.id);
        lc.setDoNotCreateOpportunity(false);
        lc.setConvertedStatus('Qualified');
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess()); 
            
        test.stopTest();        
    }
    
    public static testMethod void test_ctlLeadVerification3(){
        
        test.startTest();
        //monarch shores record type id
        Id Oppty_RT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name = 'test account';
        acc.Type = 'Treatment Center';
        insert acc;
        
        Opportunity MSOppty = new Opportunity();
        MSOppty.Name = 'test opp';
        MSOppty.AccountId = acc.id;        
        MSOppty.Amount = 999;
        MSOppty.StageName = 'Working';
        MSOppty.CloseDate = date.Today();
        MSOppty.RecordTypeId = Oppty_RT;
        insert MSOppty;
        
        Lead_Verification__c lv = new Lead_Verification__c();
        lv.Opportunity__c = MSOppty.id;
        insert lv;        
        
        PageReference myVfPage = Page.LeadInsuranceVerificationVFP;
        Test.setCurrentPage(myVfPage);
        
        ApexPages.currentPage().getParameters().put('id', MSOppty.id);
        
        ctlLeadVerification obj = new ctlLeadVerification();
        
        obj.saveLeadVerification();        
            
        test.stopTest();        
    }
    
    
     
       public Static testmethod void testBestDrugRehabDetoxWebToLeadClass(){
           test.startTest();
           system.runAs(userAdmin){
           
                Messaging.InboundEmail email = new Messaging.InboundEmail();
                Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
                
                BestDrugRehabDetoxWebToLeadClass inst = new BestDrugRehabDetoxWebToLeadClass();
                
                email.plainTextBody = 'From: Test Name'+'\n'+'Phone Number: 1234567890'+'\n'+'Insurance: I do not have insurance'+'\n'+'Message Body: This is test message'+'\n'+' --'+'\n'+'--';
                email.htmlBody = '<p><b>From:</b> Test Lead <test@test.cpm>\n'+
                '<b>Phone Number:</b> 122345675432\n'+
                '<b>City - State:</b> test</p>'+
                '<p><b>Subject: </b>Website Contact Submission bestdrugrehabdetox.com</p>'+
                '<p><b>Insurance:</b><br />'+
                'No, i do not have insurance</p>'+
                '<p><b>Message Body:</b><br />'+
                'Test Comments</p>'+
                '<p>--\n'+
                'This e-mail was sent from a contact form on Best Drug Rehab - Best Alcohol Detox (http://bestdrugrehabdetox.com)</p>';
                Messaging.InboundEmailResult result = inst.handleInboundEmail(email, env);
            }
            test.stopTest();
      }
      
    static testmethod void testTrgTaskLead(){
                
        Id Lead_RT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        
        Lead newLead = New Lead();
        newLead.FirstName = 'Test';
        newLead.LastName = 'Test';
        newLead.LeadSource = 'Insurance Form';
        newLead.Company = 'test';       
        newLead.recordTypeId = Lead_RT;
        //newLead.ownerid = '00GU0000001M4VD';
        insert newLead;
        
        Test.startTest();
        
        Task newtask = new Task();
        newtask.Subject = 'Call';
        newtask.ActivityDate = Date.today();
        newtask.OwnerId = UserInfo.getUserId();
        newtask.WhoId = newLead.Id;
        newtask.Status = 'Completed';
        newtask.Priority = 'Normal';
        insert newtask; 
        
        Test.stopTest();
          
    }
    
    static testmethod void testTrgTaskOpportunity(){
        
        Id Oppty_RT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name = 'test account';
        acc.Type = 'Treatment Center';
        insert acc;
        
        Opportunity MSOppty = new Opportunity();
        MSOppty.Name = 'test opp';
        MSOppty.AccountId = acc.id;        
        MSOppty.Amount = 999;
        MSOppty.StageName = 'Working';
        MSOppty.CloseDate = date.Today();
        MSOppty.RecordTypeId = Oppty_RT;
        insert MSOppty;
        
        Test.startTest();
        
        Task newtask = new Task();
        newtask.Subject = 'Call';
        newtask.ActivityDate = Date.today();
        newtask.OwnerId = UserInfo.getUserId();
        newtask.WhatId = MSOppty.Id;
        newtask.Status = 'Completed';
        newtask.Priority = 'Normal';
        insert newtask; 
        
        Test.stopTest();
        
    }
    
    static testmethod void CtrlSendEmailToClientLead(){
        
        Id Lead_RT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        
        Lead newLead = New Lead();
        newLead.FirstName = 'Test';
        newLead.LastName = 'Test';
        newLead.LeadSource = 'Insurance Form';
        newLead.Company = 'test';       
        newLead.recordTypeId = Lead_RT;
        //newLead.ownerid = '00GU0000001M4VD';
        insert newLead;
        
        Test.startTest();
        
        PageReference pageRef = Page.EmailToClient;
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', newLead.id);
        
        CtrlSendEmailToClient obj = new CtrlSendEmailToClient();
        obj.ToEmail ='test@test.com';
        obj.EmailSubject='test';
        obj.EmailBody = 'test';
        obj.sendEmailToClient();
        obj.cancel();
        Test.stopTest();
    }
    
    static testmethod void CtrlSendEmailToClientOpportunity(){
        
        Id Oppty_RT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name = 'test account';
        acc.Type = 'Treatment Center';
        insert acc;
        
        Opportunity MSOppty = new Opportunity();
        MSOppty.Name = 'test opp';
        MSOppty.AccountId = acc.id;        
        MSOppty.Amount = 999;
        MSOppty.StageName = 'Working';
        MSOppty.CloseDate = date.Today();
        MSOppty.RecordTypeId = Oppty_RT;
        insert MSOppty;
        
        Test.startTest();
        
        PageReference pageRef = Page.EmailToClient;
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', MSOppty.id);
        
        CtrlSendEmailToClient obj = new CtrlSendEmailToClient();
        obj.ToEmail ='test@test.com';
        obj.EmailSubject='test';
        obj.EmailBody = 'test';
        obj.sendEmailToClient();
        obj.cancel();
        Test.stopTest();
    }
    
    public static testMethod void testChatterFeedTrg(){
        
        test.startTest();
        //monarch shores record type id
        Id Oppty_RT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name = 'test account';
        acc.Type = 'Treatment Center';
        insert acc;
        
        Opportunity MSOppty = new Opportunity();
        MSOppty.Name = 'test opp';
        MSOppty.AccountId = acc.id;        
        MSOppty.Amount = 999;
        MSOppty.StageName = 'Working';
        MSOppty.CloseDate = date.Today();
        MSOppty.RecordTypeId = Oppty_RT;
        insert MSOppty;
        
         Task newtask = new Task();
        newtask.Subject = 'Call';
        newtask.ActivityDate = Date.today();
        newtask.OwnerId = UserInfo.getUserId();
        newtask.WhatId= MSOppty.Id;
        newtask.Status = 'Completed';
        newtask.Priority = 'Normal';
        insert newtask; 
        
        FeedItem f2 = new FeedItem();
        f2.ParentId = MSOppty.id;
        f2.Body = 'test';
        insert f2;
        
        FeedComment f = new FeedComment ();
        f.FeedItemId= f2.id;
        f.CommentBody ='test';
        insert f;
        
        Test.stoptest();
    }
}