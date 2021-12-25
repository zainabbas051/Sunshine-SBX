@isTest
private class ctrl_csvimport_ClientKIPUSnapshotsTest{
    
    Public static Blob csvFileBlob;
    Public static ctrl_csvimport_ClientKIPUSnapshots ctrl;
    
    public Static testmethod void test_Labs(){
        test.startTest();
        
            String csvFileString = 'MR,Specimen ID,Vendor,Specimen Source,Collected\nMS2019-86,W0093878,Sunshine Behavioral Health Partners,Urine,10/21/19';
        
            csvFileBlob = Blob.valueOf(csvFileString);
            
            ctrl = new ctrl_csvimport_ClientKIPUSnapshots();
            ctrl.setcenterName('Chapters Capistrano');
            ctrl.setobjectName('KIPU_Billable_Items_Temp__c');
            ctrl.csvFileBody = csvFileBlob;
            
            ctrl.readFromFile();
            ctrl.saveData();
            
            List<SelectOption> listCenterNames = new List<SelectOption>();
            List<SelectOption> listObjectNames = new List<SelectOption>();
            
            listCenterNames = ctrl.getCenterNames();
            listObjectNames = ctrl.getObjectNames();
            
            String center_name = ctrl.getcenterName();
            String object_name = ctrl.getobjectName();
            
        
        test.StopTest();
    }
    
    public Static testmethod void test_Evaluations(){
        test.startTest();
        
            String csvFileString = 'MR,Evaluation,Signed By,Started,Ended,Duration,Authorizations,Status,Completed At,Template ID\nMS2019-86,Breathalyzer BID,Henrry Mendoza,10/21/19 20:48,10/21/19 20:53,0.08,UM6063877 - Start: 10/15/2019 - End: 10/21/2019 - Freq: daily - LOC: Residential,Status Complete,10/21/19 20:48,616033';
            csvFileBlob = Blob.valueOf(csvFileString);
            
            ctrl = new ctrl_csvimport_ClientKIPUSnapshots();
            ctrl.setcenterName('Chapters Capistrano');
            ctrl.setobjectName('KIPU_Billable_Items_Temp__c');
            ctrl.csvFileBody = csvFileBlob;
            
            ctrl.readFromFile();
            ctrl.saveData();
        
        test.StopTest();
    }
    
    public Static testmethod void test_ErroMessage(){
        test.startTest();
        
            String csvFileString = 'MR,Evaluation,Signed By,Started,Ended,Duration,Authorizations,Status,Completed At,Template ID\nMS2019-86,Breathalyzer BID,Henrry Mendoza,10/21/19 20:48,10/21/19 20:53,0.08,UM6063877 - Start: 10/15/2019, End: 10/21/2019 - Freq: daily - LOC: Residential,Status Complete,10/21/19 20:48,616033';
            csvFileBlob = Blob.valueOf(csvFileString);
            
            ctrl = new ctrl_csvimport_ClientKIPUSnapshots();
            ctrl.csvFileBody = csvFileBlob;
            ctrl.readFromFile();
            
            ctrl.setcenterName('Chapters Capistrano');
            ctrl.setobjectName('KIPU_Billable_Items_Temp__c');
            
            ctrl.readFromFile();
            
            ctrl.setobjectName('Client_KIPU_Snapshot__c');
            
            ctrl.readFromFile();
        
        test.StopTest();
    }
}