@isTest
public  class IncidentReport_CtrlTest {
    
    public static List<String> AccessValues = New List<String>();
    
    @TestSetup
    static void createTestData() {

        
          Sunshine_Center_Id__C rec = New Sunshine_Center_Id__C();
        rec.Name = 'Chapters Capistrano';
        rec.Additional_recipients_Email__c = 'test@gmail.com';
        insert rec;
        
        
      Account acc = new Account();
        acc.Name = 'Chapters Capistrano';
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
       supvisor.Sunshine_Center_Access__c = 'Monarch Shores;Chapters Capistrano;Willowsprings Recovery';
       insert supvisor;
        
        AccessValues.add(supvisor.Sunshine_Center_Access__c);
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
        IncidentReport_Ctrl.getAllIncidents(10,10,'Willowsprings Recovery',AccessValues,date.today(),date.today());
        IncidentReport_Ctrl.getAllIncidents(10,10,'Willowsprings Recovery',AccessValues,null,null);
        IncidentReport_Ctrl.getPickListValues('Level_Two_Incident_Type__c');
        IncidentReport_Ctrl.getIncidentById(incidentId);
        IncidentReport_Ctrl.getEmpSunshine(emp.Id);
        IncidentReport_Ctrl.getSearchIncident(Date.Today().addDays(-2),
                                                Date.Today().addDays(2),
                                                'test',1,10,AccessValues);
         IncidentReport_Ctrl.getSearchIncident(Date.Today().addDays(-2),
                                                Date.Today().addDays(2),
                                                'All',1,10,AccessValues);
        IncidentReport_Ctrl.saveIncident(new Incident_Report_SBH__c(Sunshine_Center__c = accId,Completed_By_Email__c = 'test@test.com'));
        IncidentReport_Ctrl.sendEmail(incidentId,'http://test.com');
        inc.selectedOptions = 'Selected Option';
		inc.selectedOptionsL1 = 'Selected Option L1';
        inc.selectedOptionsL2 = 'Selected Option L2';
        inc.selectedOptionsL3 = 'Selected Option L3';
        inc.disabled = false;
        

        test.StopTest();
    }
}