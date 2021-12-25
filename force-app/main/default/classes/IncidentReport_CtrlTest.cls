@isTest
public  class IncidentReport_CtrlTest {
    
    @TestSetup
    static void createTestData() {

      Account acc = new Account();
        acc.Name = 'Willowsprings Recovery';
        insert acc;

        Incident_Report_SBH__c inc = new Incident_Report_SBH__c();
        inc.Sunshine_Center__c = acc.Id;
        inc.Date_Time_of_Incident__c = DateTime.Now();
        inc.Completed_By_Email__c = 'test@test.com';
        insert inc;
        
       Employee__c supvisor = new Employee__c();
       supvisor.Name__c = 'supervisor';
       supvisor.Designation__c = 'bht';
       supvisor.email__c = 'safia.osman@hotmail.com';
       insert supvisor;
    }

    @isTest static void myTest() {
        
        test.StartTest();
        Employee__c emp = [Select id from Employee__c  limit 1];
        IncidentReport_Ctrl inc = new IncidentReport_Ctrl();
        string incidentId = [Select Id from Incident_Report_SBH__c  limit 1 ].Id;
        string accId = [Select Id from Account limit 1].Id;
        PageReference pageRef = Page.IncidentReportPDF_HTML; // Add your VF page Name here
        pageRef.getParameters().put('id',incidentId);   
        Test.setCurrentPage(pageRef);
        IncidentReport_Ctrl.getAllIncidents(10,10,'test');
        IncidentReport_Ctrl.getPickListValues('Level_Two_Incident_Type__c');
        IncidentReport_Ctrl.getIncidentById(incidentId);
        IncidentReport_Ctrl.getEmpSunshine(emp.Id);
        IncidentReport_Ctrl.getSearchIncident(Date.Today().addDays(-2),
                                                Date.Today().addDays(2),
                                                'test',1,10);
        IncidentReport_Ctrl.saveIncident(new Incident_Report_SBH__c(Sunshine_Center__c = accId,Completed_By_Email__c = 'test@test.com'));
        IncidentReport_Ctrl.sendEmail(incidentId,'http://test.com');

        test.StopTest();
    }
}