@isTest
public class EfaxParseCtrl_Test {
    
    testMethod  static void testCallout(){
         
         
          EFax_Setting__c eFaxSetting = new EFax_Setting__c();
        eFaxSetting.Name = 'Freepu';
        eFaxSetting.Account_ID__c = '100005';
        eFaxSetting.User_Name__c = 'abc49';
        eFaxSetting.Password__c = 'xyz123';
        insert eFaxSetting;
        // Set mock callout class
       
       test.startTest();
          // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new HTTPMockCallout());
        
       
        
      //  PageReference ref = new PageReference('/apex/MedicinesPDF');
        Blob content = blob.valueOf('Unit.Test');
        string blobContent = EncodingUtil.base64Encode(content);
        EfaxParseCtrl.EfaxeOutBounReadRequest_Rest(blobContent, 'test@abc.com','Danish', '55555555');
        
        
        EFax_Log__c eLog = new EFax_Log__c();
        eLog.DOCID__c = '100005';
        eLog.Is_Processed__c = false;
        insert eLog;
        
        
         EfaxStatusBatchSchd m = new EfaxStatusBatchSchd();
           String sch = '20 30 8 10 2 ?';
           String jobID = system.schedule('EfaxStatusBatchSchd', sch, m);
        
      test.stopTest();
    }

}