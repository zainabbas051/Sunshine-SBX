@isTest

private class TransfertoMSNewCtrlTest{

    public Static ApexPages.StandardController opportunityController;
    Public static Opportunity o_erp;
    Public static Account a;
    Public Static Contact c;
    public static OpportunityContactRole newOCR;
    public Static Profile adminProfile;
    public Static TransfertoMSNewCtrl TransfertoMSNewCtrlIns;
    public static MS_Admision_Coordinator_Schedule__c msacs;
    public static MS_Admision_Coordinator_Schedule__c msacs2;
    public static Trigger_Custom_Setting__c tcs;
    
    public Static testmethod void test_TransfertoMSNewCtrl_Class(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           opportunityController = new ApexPages.StandardController(o_erp);
           ApexPages.currentPage().getParameters().put('id', o_erp.id);
           TransfertoMSNewCtrlIns= new TransfertoMSNewCtrl (); 
           ApexPages.currentPage().getParameters().put('record_type_id', o_erp.recordTypeId);
           
           TransfertoMSNewCtrlIns.createMonarchShoresOpportunity();
           
           createSampleSingleMAC();
           
           TransfertoMSNewCtrlIns.createMonarchShoresOpportunity();
           
           createSampleSecondMAC();
           
           TransfertoMSNewCtrlIns.createMonarchShoresOpportunity();
           String ownerId = TransfertoMSNewCtrlIns.getOpportunityOwner();
           String owenrIdLead = TransfertoMSNewCtrl.getNormalLeadOwner();
           //monarchShoresOpp.cancel1();
           
           Id tempInsInfoId = TransfertoMSNewCtrlIns.createInsuranceInfo(o_erp.id, 'Naveen Chugh', 'United HealthCare', '123456', '123456', '1234567891',
                                '04/08/1988', '1234', 'Test', 'Test', 'Macomb', 'Michigan', '48044', 'USA','ELite Rehab Placement');
           
           opportunity tempOpp = TransfertoMSNewCtrlIns.initiateVOBTempOpportunity(o_erp.id);
           
           TransfertoMSNewCtrlIns.sendSMS(userAdmin.id,o_erp.Name,null);
           TransfertoMSNewCtrlIns.sendSMS(userAdmin.id,o_erp.Name,userAdmin.LastName);
       }
         test.StopTest();
             
      }
      
      public Static testmethod void test_TransfertoMSNewCtrl_OffHoursAssignment(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           opportunityController = new ApexPages.StandardController(o_erp);
           ApexPages.currentPage().getParameters().put('id', o_erp.id);
           TransfertoMSNewCtrlIns= new TransfertoMSNewCtrl (); 
           ApexPages.currentPage().getParameters().put('record_type_id', o_erp.recordTypeId);
           
           TransfertoMSNewCtrlIns.createMonarchShoresOpportunity();
           
           createSampleSingleMACOffHours1();
           createSampleSingleMACOffHours2();
           
           String ownerId = TransfertoMSNewCtrlIns.getOpportunityOwner();
           String owenrIdLead = TransfertoMSNewCtrl.getNormalLeadOwner();
           TransfertoMSNewCtrlIns.createMonarchShoresOpportunity();
           
          }
         test.StopTest();
             
      }
      
      public Static testmethod void test_TransfertoMSNewCtrl_VOBRequest(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           opportunityController = new ApexPages.StandardController(o_erp);
           ApexPages.currentPage().getParameters().put('id', o_erp.id);
           
           TransfertoMSNewCtrlIns= new TransfertoMSNewCtrl ();
           Id tempInsInfoId = TransfertoMSNewCtrlIns.createInsuranceInfo(o_erp.id, 'Naveen Chugh', 'United HealthCare', '123456', '123456', '1234567891',
                                '04/08/1988', '1234', 'Test', 'Test', 'Macomb', 'Michigan', '48044', 'USA','ELite Rehab Placement');
           
           Id vobId = TransfertoMSNewCtrlIns.initiateVOBRequest(o_erp.id,tempInsInfoId);
           Boolean flag = TransfertoMSNewCtrlIns.vobRequestStatus('United Healthcare',False);
           Boolean flag2 = TransfertoMSNewCtrlIns.vobRequestStatus('United Healthcare',True);
           Boolean flag3 = TransfertoMSNewCtrlIns.vobRequestStatus('AETNA',False);
          }
         test.StopTest();
             
      }
      
      public Static void createSampleSingleMAC(){
        
        msacs = New MS_Admision_Coordinator_Schedule__c();
        msacs.User__c = userAdmin.id;
        msacs.Monday_OFF__c = False;
        msacs.Monday_Start_Time__c = '0:00';
        msacs.Monday_End_Time__c = '23:30';
        msacs.Tuesday_OFF__c = False;
        msacs.Tuesday_Start_Time__c = '0:00';
        msacs.Tuesday_End_Time__c = '23:30';
        msacs.Wednesday_OFF__c = False;
        msacs.Wednesday_Start_Time__c = '0:00';
        msacs.Wednesday_End_Time__c = '23:30';
        msacs.Thursday_OFF__c = False;
        msacs.Thursday_Start_Time__c = '0:00';
        msacs.Thursday_End_Time__c = '23:30';
        msacs.Friday_OFF__c = False;
        msacs.Friday_Start_Time__c = '0:00';
        msacs.Friday_End_Time__c = '23:30';
        msacs.Saturday_OFF__c = False;
        msacs.Saturday_Start_Time__c = '0:00';
        msacs.Saturday_End_Time__c = '23:30';
        msacs.Sunday_OFF__c = False;
        msacs.Sunday_Start_Time__c = '0:00';
        msacs.Sunday_End_Time__c = '23:30';
        insert msacs;
        
     }
     
     public Static void createSampleSingleMACOffHours1(){
        
        msacs = New MS_Admision_Coordinator_Schedule__c();
        msacs.User__c = userAdmin.id;
        msacs.Monday_OFF__c = True;
        msacs.Tuesday_OFF__c = True;
        msacs.Wednesday_OFF__c = True;
        msacs.Thursday_OFF__c = True;
        msacs.Friday_OFF__c = True;
        msacs.Saturday_OFF__c = True;
        msacs.Sunday_OFF__c = True;
        msacs.Available_for_Off_Hours_Assignment__c = True;
        insert msacs;
        
     }
     
     public Static void createSampleSingleMACOffHours2(){
        
        msacs = New MS_Admision_Coordinator_Schedule__c();
        msacs.User__c = userAdmin.id;
        msacs.Monday_OFF__c = True;
        msacs.Tuesday_OFF__c = True;
        msacs.Wednesday_OFF__c = True;
        msacs.Thursday_OFF__c = True;
        msacs.Friday_OFF__c = True;
        msacs.Saturday_OFF__c = True;
        msacs.Sunday_OFF__c = True;
        msacs.Available_for_Off_Hours_Assignment__c = True;
        insert msacs;
        
     }
     
     public Static void createSampleSecondMAC(){
        
        msacs2 = New MS_Admision_Coordinator_Schedule__c();
        msacs2.User__c = userAdmin.id;
        msacs2.Monday_OFF__c = False;
        msacs2.Monday_Start_Time__c = '0:00';
        msacs2.Monday_End_Time__c = '23:30';
        msacs2.Tuesday_OFF__c = False;
        msacs2.Tuesday_Start_Time__c = '0:00';
        msacs2.Tuesday_End_Time__c = '23:30';
        msacs2.Wednesday_OFF__c = False;
        msacs2.Wednesday_Start_Time__c = '0:00';
        msacs2.Wednesday_End_Time__c = '23:30';
        msacs2.Thursday_OFF__c = False;
        msacs2.Thursday_Start_Time__c = '0:00';
        msacs2.Thursday_End_Time__c = '23:30';
        msacs2.Friday_OFF__c = False;
        msacs2.Friday_Start_Time__c = '0:00';
        msacs2.Friday_End_Time__c = '23:30';
        msacs2.Saturday_OFF__c = False;
        msacs2.Saturday_Start_Time__c = '0:00';
        msacs2.Saturday_End_Time__c = '23:30';
        msacs2.Sunday_OFF__c = False;
        msacs2.Sunday_Start_Time__c = '0:00';
        msacs2.Sunday_End_Time__c = '23:30';
        insert msacs2;
        
     }
      
public Static void createSampleData(){
        
        Id recTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        tcs = new Trigger_Custom_Setting__c();
        tcs.Name = 'Default';
        tcs.Disable_MSOpportunityAssignmentTrigger__c = False;
        Insert tcs;
      
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        c = new Contact();
        c.AccountId = a.id;
        c.LastName = 'Test';
        insert c;
        
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
        o_erp.Insurance_Providers__c = 'Spectra';
        insert o_erp;
        
        newOCR = new OpportunityContactRole();
        newOCR.OpportunityId = o_erp.id;
        newOCR.ContactId = c.id;
        newOCR.Role = 'Decision Maker';
        newOCR.IsPrimary = True;
        insert newOCR;
        
        
        
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