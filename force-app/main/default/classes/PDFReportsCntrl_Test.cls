@isTest
public class PDFReportsCntrl_Test {
    
    static testMethod void testMethod1(){
        List<string> listSelectedIds;
      
        Client_Chart__c cc = new Client_Chart__c();
            cc.Name = 'Test Client Chart';
            cc.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        insert cc;
        
        Intake_Forms__c iform =  new Intake_Forms__c();
          iform.Name = 'Test Intake Form';
          iform.Status__c = 'Closed';
          iform.Client_Chart__c = cc.Id;
          iform.RecordTypeId = Schema.SObjectType.Intake_Forms__c.getRecordTypeInfosByName().get('Admit Agreement').getRecordTypeId(); //'0120P000000auj0';
        insert iform;
        
        Clinical_Evaluation__c ce =  new Clinical_Evaluation__c();
          //ce.Name = 'Test Intake Form';
          ce.Status__c = 'Closed';
          ce.Client_Chart__c = cc.Id;
          ce.RecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Pre Admission Assesment').getRecordTypeId();
        insert ce;
        string PAARtypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Pre Admission Assesment').getRecordTypeId();
        
        Medical__c med = new Medical__c();
          //med.Name = 'Test Intake Form';
          med.Status__c = 'Closed';
          med.Client_Chart__c = cc.Id;
          med.RecordTypeId = Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('Doctors Note').getRecordTypeId(); //'0120P000000auiv';
        insert med;
        
        Clinical_Note__c cn = new Clinical_Note__c();
          //med.Name = 'Test Intake Form';
          cn.Status__c = 'Closed';
          cn.Client_Chart__c = cc.Id;
          cn.RecordTypeId = Schema.SObjectType.Clinical_Note__c.getRecordTypeInfosByName().get('Progress Notes').getRecordTypeId(); 
        insert cn;
        
  Test.StartTest(); 
  //ApexPages.StandardController sc = new ApexPages.StandardController(cc);
  PDFReportsCntrl testClientChart = new PDFReportsCntrl();

  PageReference pageRef = Page.PDFReportsVfp; // Add your VF page Name here
  pageRef.getParameters().put('id', String.valueOf(cc.Id)); //String.valueOf(cc.Id)
  Test.setCurrentPage(pageRef);
        
        testClientChart.getIntakeForms();
        testClientChart.getClinicalEvaluations();
        testClientChart.getMedicals();
        testClientChart.getClinicalNotes();
        testClientChart.getTXDC();
        testClientChart.getRecurringAssessments();
        testClientChart.getMeds();
        testClientChart.getAssessmentIR();
        testClientChart.getUtilizationReview();
        testClientChart.getPHILog();
        testClientChart.getIncidentReport();
        testClientChart.getClinicalEvaluations2();
        testClientChart.getClinicalEvaluations3();
        testClientChart.getHistoryPhysical();
        //testClientChart.buildJson(listSelectedIds);
        testClientChart.SelectedIds = '["Clinical Evaluations-'+ce.id+'-'+PAARtypeId+'-Pre Admission Assesment","Clinical Notes-'+cn.id+'-'+cn.RecordtypeId+'-Nursing Progress Notes","Medicals-'+cn.id+'-'+cn.RecordtypeId+'-Phsych Evaluation","Medicals-'+cn.id+'-'+cn.RecordtypeId+'-History And Physical"]';
        testClientChart.pdfMergeName = 'CN';
        
        Test.setMock(HttpCalloutMock.class, new PDFReportWebSrvMock());
        testClientChart.postIds();
        //testClientChart.PDFURLS();
        //testClientChart.pdf_urls();
       // testClientChart.PDFURLS();

  //testAccPlan.save(); call all your function here
   Test.StopTest();
  }
  
  static testMethod void testMethod2(){
        List<string> listSelectedIds;
      
        Client_Chart__c cc = new Client_Chart__c();
            cc.Name = 'Test Client Chart';
            cc.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        insert cc;
        
        Intake_Forms__c iform =  new Intake_Forms__c();
          iform.Name = 'Test Intake Form';
          iform.Status__c = 'Closed';
          iform.Client_Chart__c = cc.Id;
          iform.RecordTypeId = Schema.SObjectType.Intake_Forms__c.getRecordTypeInfosByName().get('Admit Agreement').getRecordTypeId(); 
        insert iform;
        
        Clinical_Evaluation__c ce =  new Clinical_Evaluation__c();
          //ce.Name = 'Test Intake Form';
          ce.Status__c = 'Closed';
          ce.Client_Chart__c = cc.Id;
          ce.RecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Pre Admission Assesment').getRecordTypeId();
        insert ce;
        string PAARtypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Pre Admission Assesment').getRecordTypeId();
        
        Medical__c med = new Medical__c();
          //med.Name = 'Test Intake Form';
          med.Status__c = 'Closed';
          med.Client_Chart__c = cc.Id;
          med.RecordTypeId = Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('Doctors Note').getRecordTypeId(); 
        insert med;
        
        Clinical_Note__c cn = new Clinical_Note__c();
          //med.Name = 'Test Intake Form';
          cn.Status__c = 'Closed';
          cn.Client_Chart__c = cc.Id;
          cn.RecordTypeId = Schema.SObjectType.Clinical_Note__c.getRecordTypeInfosByName().get('Progress Notes').getRecordTypeId(); 
        insert cn;
        
  Test.StartTest(); 
  //ApexPages.StandardController sc = new ApexPages.StandardController(cc);
  PDFReportsCntrl testClientChart = new PDFReportsCntrl();

  PageReference pageRef = Page.PDFReportsVfp; // Add your VF page Name here
  pageRef.getParameters().put('id', String.valueOf(cc.Id)); //String.valueOf(cc.Id)
  Test.setCurrentPage(pageRef);
        
        testClientChart.getIntakeForms();
        testClientChart.getClinicalEvaluations();
        testClientChart.getMedicals();
        testClientChart.getClinicalNotes();
        testClientChart.getTXDC();
        testClientChart.getRecurringAssessments();
        testClientChart.getMeds();
        testClientChart.getAssessmentIR();
        testClientChart.getUtilizationReview();
        testClientChart.getPHILog();
        testClientChart.getIncidentReport();
        testClientChart.getClinicalEvaluations2();
        testClientChart.getClinicalEvaluations3();
        testClientChart.getHistoryPhysical();
        //testClientChart.buildJson(listSelectedIds);
        testClientChart.SelectedIds = '["Face Sheet-'+ce.id+'-'+PAARtypeId+'-Face Sheet","Consents-'+cn.id+'-'+cn.RecordtypeId+'-Admit Agreement","MEDS-'+cn.id+'-'+cn.RecordtypeId+'-MEDS","AIR-'+cn.id+'-'+cn.RecordtypeId+'-AIR","Incident Report-'+cn.id+'-'+cn.RecordtypeId+'-Incident Report","Utilization Review-'+cn.id+'-'+cn.RecordtypeId+'-Utilization Review","Utilization Review-'+cn.id+'-'+cn.RecordtypeId+'-PHI"]';
        testClientChart.pdfMergeName = 'CN';
        
        Test.setMock(HttpCalloutMock.class, new PDFReportWebSrvMock());
        testClientChart.postIds();
        //testClientChart.PDFURLS();
        //testClientChart.pdf_urls();
       // testClientChart.PDFURLS();

  //testAccPlan.save(); call all your function here
   Test.StopTest();
  }
  
}