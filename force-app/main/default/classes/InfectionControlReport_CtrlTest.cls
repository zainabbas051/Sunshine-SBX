@isTest
public  class InfectionControlReport_CtrlTest {
       
    public static List<String> AccessValues = New List<String>();

    @TestSetup
    static void createTestData() {

        Account acc = new Account();
        acc.Name = 'Willowsprings Recovery';
        insert acc;

        Infection_Control_Report__c inc = new Infection_Control_Report__c();
        inc.Sunshine_Center__c = acc.Id;
        inc.Date_Symptoms_Identified__c = Date.Today();
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
        InfectionControlReport_Ctrl inf = new InfectionControlReport_Ctrl();
        string incidentId = [Select Id from Infection_Control_Report__c  limit 1 ].Id;
        string accId = [Select Id from Account limit 1].Id;
        PageReference pageRef = Page.IncidentReportPDF_HTML; // Add your VF page Name here
        pageRef.getParameters().put('id',incidentId);   
        Test.setCurrentPage(pageRef);
        InfectionControlReport_Ctrl.getAllInfectionReports(10,10,'Willowsprings Recovery',AccessValues,date.today(),date.today());
        InfectionControlReport_Ctrl.getAllInfectionReports(10,10,'Willowsprings Recovery',AccessValues,null,null);
        InfectionControlReport_Ctrl.getInfectionReportById(incidentId);
        InfectionControlReport_Ctrl.getEmpSunshine(emp.Id);
        InfectionControlReport_Ctrl.getSearchInfection(Date.Today().addDays(-2),
                                                Date.Today().addDays(2),
                                                'All',1,10,AccessValues);
        InfectionControlReport_Ctrl.saveIncident(new Infection_Control_Report__c(Sunshine_Center__c = accId,Completed_By_Email__c = 'test@test.com'));
        InfectionControlReport_Ctrl.sendEmail(incidentId,'http://test.com');

        test.StopTest();
    }
}