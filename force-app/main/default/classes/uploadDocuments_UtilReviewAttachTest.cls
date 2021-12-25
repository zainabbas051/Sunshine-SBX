@isTest
public class uploadDocuments_UtilReviewAttachTest {
        
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
         
        Utilization_Review__c ur = new Utilization_Review__c();
        ur.Client_Chart__c = cl.id;
        ur.RecordTypeId = Schema.SObjectType.Utilization_Review__c.getRecordTypeInfosByName().get('Utilization Review').getRecordTypeId();
        insert ur;  
         
         awsBucket__c AmazonBucketValue = new awsBucket__c();
         AmazonBucketValue.Name ='FREEPU';
         AmazonBucketValue.accessKeyId__c = 'ABC';
         AmazonBucketValue.secretAccessKey__c ='XYZ';
         insert AmazonBucketValue;
         
         Documents_Type__c docType = new Documents_Type__c();
         doctype.Object_API_Name__c = 'Utilization_Review__c';
         docType.Is_Active__c = true;
         docType.Name = 'Utilization Review Attachment1';
         insert docType;
         
         PageReference pageRef = Page.uploadDocuments_UtiliReviewAttachments;
         Test.setCurrentPage(pageRef);
         ApexPages.CurrentPage().getParameters().put('rtID',ur.RecordTypeId);
         ApexPages.CurrentPage().getParameters().put('id',ur.id);
         Apexpages.currentPage().getParameters().put('message','error');   
         ApexPages.StandardController sc = new ApexPages.StandardController(cl);
         
         uploadDocuments_UtilReviewAttachments up = new uploadDocuments_UtilReviewAttachments(sc);
         up.cancelCustom();
         up.validationError();
         uploadDocuments_UtilReviewAttachments.document_uploaded_true('abc');
         uploadDocuments_UtilReviewAttachments.updateLink('{ "ID":"'+ur.id+'", "name":"Utlization Review Attachment1", "car":null, "link":"www.google.com" }');
         uploadDocuments_UtilReviewAttachments.updateLink('{ "ID":"'+ur.id+'", "name":"Utlization Review Attachment2", "car":null, "link":"www.google.com" }');
         uploadDocuments_UtilReviewAttachments.updateLink('{ "ID":"'+ur.id+'", "name":"Utlization Review Attachment3", "car":null, "link":"www.google.com" }');
         uploadDocuments_UtilReviewAttachments.updateLink('{ "ID":"'+ur.id+'", "name":"Utlization Review Attachment4", "car":null, "link":"www.google.com" }');
         uploadDocuments_UtilReviewAttachments.updateLink('{ "ID":"'+ur.id+'", "name":"Utlization Review Attachment5", "car":null, "link":"www.google.com" }');
         uploadDocuments_UtilReviewAttachments.updateLink('{ "ID":"'+ur.id+'", "name":"Utlization Review Attachment6", "car":null, "link":"www.google.com" }');
         uploadDocuments_UtilReviewAttachments.updateLink('{ "ID":"'+ur.id+'", "name":"Utlization Review Attachment7", "car":null, "link":"www.google.com" }');
         uploadDocuments_UtilReviewAttachments.updateLink('{ "ID":"'+ur.id+'", "name":"Utlization Review Attachment8", "car":null, "link":"www.google.com" }');
         uploadDocuments_UtilReviewAttachments.updateLink('{ "ID":"'+ur.id+'", "name":"Utlization Review Attachment9", "car":null, "link":"www.google.com" }');
         uploadDocuments_UtilReviewAttachments.updateLink('{ "ID":"'+ur.id+'", "name":"Utlization Review Attachment10", "car":null, "link":"www.google.com" }');
         
         test.stopTest();
         
         }
}