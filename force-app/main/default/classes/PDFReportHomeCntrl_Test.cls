@isTest
/*
 * Created By: Altaf Zafar
 * Version =>  1
 * Changes from Older Version => None
*/
public class PDFReportHomeCntrl_Test {
    
    static testMethod void testMethod1(){
        
        Client_Chart__c cc = new Client_Chart__c();
            cc.Name = 'Test Client Chart';
            cc.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); //'0120P000000auF8';
        insert cc;
        
        
  //Start Test for Apex page

  Test.StartTest(); 
  
  PDFReportHomeCntrl testClientChartHome = new PDFReportHomeCntrl();

  PageReference pageRef = Page.PDFReportsHome; 
  pageRef.getParameters().put('id', String.valueOf(cc.Id));
  Test.setCurrentPage(pageRef);
        
        testClientChartHome.getPDFMerge();
        testClientChartHome.NewPDFMerge();
 Test.StopTest();
        
    }

}