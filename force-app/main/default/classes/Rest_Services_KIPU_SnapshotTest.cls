@isTest
private class Rest_Services_KIPU_SnapshotTest{
     
     public Static testmethod void test_handler(){
        test.startTest();
           
            List<KIPU_Snapshot_Wrapper.Care_Team_Data> ctdList = new List<KIPU_Snapshot_Wrapper.Care_Team_Data>();
            List<KIPU_Snapshot_Wrapper.Billable_Items_Labs> bilList = new List<KIPU_Snapshot_Wrapper.Billable_Items_Labs>();
            List<KIPU_Snapshot_Wrapper.Billable_Items_Evaluations> bieList = new List<KIPU_Snapshot_Wrapper.Billable_Items_Evaluations>();
            List<KIPU_Snapshot_Wrapper.Billable_Items_Sessions> bisList = new List<KIPU_Snapshot_Wrapper.Billable_Items_Sessions>();
            
            KIPU_Snapshot_Wrapper ksw = new KIPU_Snapshot_Wrapper();
            ksw.Sunshine_Center = 'Chapters Capistrano';
            ksw.Snapshot_Date = 'JAN_01_2020';
            ksw.Care_Team_Data = ctdList; 
            ksw.Billable_Items_Labs = bilList;
            ksw.Billable_Items_Evaluations = bieList;
            ksw.Billable_Items_Sessions = bisList;
            
            
            
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
    
            req.addHeader('httpMethod', 'POST');
            req.requestUri = '/services/apexrest/kipu_snapshot/';       
            String JsonMsg=string.valueOf(JSON.Serialize(ksw));
            req.requestBody = Blob.valueof(JsonMsg);
            RestContext.request = req; 
            RestContext.response= res;
            Rest_Services_KIPU_Snapshot.handleRequest();
            
            string stringVar = Rest_Services_KIPU_Snapshot.jsonString;
             
        test.StopTest();
             
      }
      
    
      
}