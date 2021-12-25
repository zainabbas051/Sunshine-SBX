/*
    test class for Incident report
*/
@isTest
public class IncidentReportTest{
    
    static{
        awsBucket__c aws = new awsBucket__c();
        aws.accessKeyId__c =  'AKIAIKHBOKKMOFRNX5XQ';
        aws.secretAccessKey__c = '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';
        aws.Bucket__c = 'freepu';
        aws.Name = 'FREEPU';
        insert aws;
    }
    
    //test method for IncidentDetailCtrl and IRHomePageController class
    static testmethod void IncidentDetailCtrl_IRHomePageController(){
            
        test.startTest();
                  
         Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         cl.Name = 'test client';
         insert cl;
         
         Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
         scid.name = a.Name;
         scid.Account_id__c = a.id;
         scid.House_Based_Selection__c = True;
         insert scid;
         
         Test.setCurrentPageReference(Page.IncidentReportHomePage);

         //System.currentPageReference().getParameters().put('id', cl.id);
         system.currentPageReference().getParameters().put('rt','Monarch Shores');//Chapters Capistrano;Willowsprings Recovery');
         
         IRHomePageController ir = new IRHomePageController ();
         ir.SelectedOption = 'Incident Report;';
         ir.SaveNewIncidentRecords();
         
         Test.setCurrentPageReference(Page.IncidentReportDetailPage);
         
         System.currentPageReference().getParameters().put('IR', [select id from Incident_Report__c limit 1].id);
         //system.currentPageReference().getParameters().put('rt','Monarch Shores;Chapters Capistrano;Willowsprings Recovery');         
         system.currentPageReference().getParameters().put('rt','Monarch Shores');
         
         IncidentDetailCtrl ir_detail = new IncidentDetailCtrl();
         ir_detail.clientNames = new list<string>();
         ir_detail.clientNames.add('test client');
         ir_detail.claim();
         ir_detail.submit();
         ir_detail.SelectedSignedOption  = 'Staff';
         ir_detail.CloseIncidentForm();
         ir_detail.SelectedSignedOption  = 'Supervisor';
         ir_detail.CloseIncidentForm();
         ir_detail.SelectedSignedOption  = 'Compliance';
         ir_detail.CloseIncidentForm();
         
         
         test.stoptest();
    }    
    
    //test method for IncidentReportHomeCtrl class
    testmethod static void IncidentReportHomeCtrl(){
        
        test.startTest();
                  
         Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
         Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
         scid.name = a.Name;
         scid.Account_id__c = a.id;
         scid.House_Based_Selection__c = True;
         insert scid;
         
         Test.setCurrentPageReference(Page.IncidentReportsHomePage);

         System.currentPageReference().getParameters().put('id', cl.id);
         system.currentPageReference().getParameters().put('rt','Monarch Shores;Chapters Capistrano;Willowsprings Recovery');
         
         IncidentReportHomeCtrl ir_home = new IncidentReportHomeCtrl();
         ir_home.SelectedOption = 'Incident Report,';
         ir_home.SaveNewContracts();
         test.stoptest();
         
    }
}