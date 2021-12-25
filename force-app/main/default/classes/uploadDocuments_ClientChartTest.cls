@isTest
public class uploadDocuments_ClientChartTest {
        
         static testMethod void uploadDocumentsTest(){
         
          test.startTest();
         Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
             
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.Admit_Date_Time__c = DateTime.Now().AddDays(-5);
         cl.Discharge_Date_Time__c = DateTime.Now();
         cl.Client_ID_URL2__c ='http://www.google.com';
         cl.Client_Image_URL2__c  = 'http://www.yahoo.com';
         cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
     
         insert cl;
         
            awsBucket__c AmazonBucketValue = new awsBucket__c();
         AmazonBucketValue.Name ='FREEPU';
         AmazonBucketValue.accessKeyId__c = 'ABC';
         AmazonBucketValue.secretAccessKey__c ='XYZ';
         insert AmazonBucketValue;
         
         Documents_Type__c docType = new Documents_Type__c();
         doctype.Object_API_Name__c = 'Client_Chart__c';
         docType.Is_Active__c = true;
         docType.Name = 'abc';
         insert docType;
         
         PageReference pageRef = Page.FaceSheetHomePage;
         Test.setCurrentPage(pageRef);

        pageRef.getParameters().put('message', 'error');
         ApexPages.StandardController sc = new ApexPages.StandardController(cl);
         
         uploadDocuments_ClientChart up = new uploadDocuments_ClientChart(sc);
         up.cancelCustom();
         up.validationError();
         uploadDocuments_ClientChart.document_uploaded_true('abc');
         uploadDocuments_ClientChart.updateLink('{ "ID":"'+cl.ID+'", "name":"Client Image", "car":null }');
         
         test.stopTest();
         
         }
}