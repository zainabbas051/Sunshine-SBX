@isTest
public  class ClientTicket_CtrlTest {
    
    @TestSetup
    static void createTestData() {
      
      Trigger_Custom_Setting__c  cc = new Trigger_Custom_Setting__c();
      cc.updateOpportunityFlag_Disable__c = true;
      cc.Name = 'Default';
      insert cc;
      
      awsBucket__c aws = new awsBucket__c();
      aws.accessKeyId__c = 'xx';
      aws.Bucket__c = 'freepu';
      aws.Name = 'FREEPU';
      aws.secretAccessKey__c = 'xx';
      insert aws;
      
      Account acc = new Account();
      acc.Name = 'Chapters Capistrano';
      insert acc;
      
      Employee__c supvisor = new Employee__c();
       supvisor.Name__c = 'Edison';
       supvisor.Designation__c = 'bht';
       supvisor.email__c = 'danish.farooq.90@hotmail.com';
       insert supvisor;

      Case icase = new Case();
      icase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Client Tickets').getRecordTypeId();
      icase.Department__c = 'Operations';
      icase.Specific_Query_Related_to__c = 'Bed Moves';
      icase.Sunshine_Center_Id__c = acc.Id;
      icase.Escalated_To__c = supvisor.Id;
      insert icase;
        
     
    }

    @isTest static void myTest() {
        
        test.StartTest();
        Case casObj = [Select id from case limit 1];
        Employee__c emp = [Select id from Employee__c limit 1];
        casObj = ClientTicket_Ctrl.getCaseDetail(casObj.Id);
        ClientTicket_Ctrl.addComments(casObj.Id,'Test desc',emp.Id);
        ClientTicket_Ctrl.getAllCaseComments(casObj.Id);
        ClientTicket_Ctrl.getAllCases(10,1,emp.Id);
        ClientTicket_Ctrl.getAllCasesByFilter(10,1,emp.Id,'');
        ClientTicket_Ctrl.updateTicketInfo(casObj);
        ClientTicket_Ctrl.getEmployeeDetail(emp.Id);
        ClientTicket_Ctrl.escalateCase(casObj);
        ClientTicket_Ctrl.getSpecificQueryPickList('Chapters Capistrano','Operations');
        ClientTicket_Ctrl.getDeptPickList('Chapters Capistrano');
        test.StopTest();
    }
}