@isTest
public class uploadDocuments_PHIAttachmentsTest {
        
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
         
         PHI_Log__c md = new PHI_Log__c();
         md.Client_Chart__c = cl.id;
         md.RecordTypeID = Schema.SObjectType.PHI_Log__c.getRecordTypeInfosByName().get('Authorization for Release of Confidential Information').getRecordTypeId();
         insert md;
         
         awsBucket__c AmazonBucketValue = new awsBucket__c();
         AmazonBucketValue.Name ='FREEPU';
         AmazonBucketValue.accessKeyId__c = 'ABC';
         AmazonBucketValue.secretAccessKey__c ='XYZ';
         insert AmazonBucketValue;
         
         Documents_Type__c docType = new Documents_Type__c();
         doctype.Object_API_Name__c = 'PHI_Log__c';
         docType.Is_Active__c = true;
         docType.Name = 'PHILog Attachment1';
         insert docType;
         
         PageReference pageRef = Page.uploadDocuments_PHIAttachments;
         Test.setCurrentPage(pageRef);
         ApexPages.CurrentPage().getParameters().put('rtID',md.RecordTypeId);
         ApexPages.CurrentPage().getParameters().put('id',md.id);
         Apexpages.currentPage().getParameters().put('message','error');   
         ApexPages.StandardController sc = new ApexPages.StandardController(cl);
         
         uploadDocuments_PHIAttachments up = new uploadDocuments_PHIAttachments(sc);
         up.cancelCustom();
         up.validationError();
         uploadDocuments_PHIAttachments.document_uploaded_true('abc');
         uploadDocuments_PHIAttachments.updateLink('{ "ID":"'+md.id+'", "name":"PHILog Attachment1", "car":null, "link":"www.google.com" }');
         uploadDocuments_PHIAttachments.updateLink('{ "ID":"'+md.id+'", "name":"PHILog Attachment2", "car":null, "link":"www.google.com" }');
         uploadDocuments_PHIAttachments.updateLink('{ "ID":"'+md.id+'", "name":"PHILog Attachment3", "car":null, "link":"www.google.com" }');
         uploadDocuments_PHIAttachments.updateLink('{ "ID":"'+md.id+'", "name":"PHILog Attachment4", "car":null, "link":"www.google.com" }');
         uploadDocuments_PHIAttachments.updateLink('{ "ID":"'+md.id+'", "name":"PHILog Attachment5", "car":null, "link":"www.google.com" }');
         uploadDocuments_PHIAttachments.updateLink('{ "ID":"'+md.id+'", "name":"PHILog Attachment6", "car":null, "link":"www.google.com" }');
         uploadDocuments_PHIAttachments.updateLink('{ "ID":"'+md.id+'", "name":"PHILog Attachment7", "car":null, "link":"www.google.com" }');
         uploadDocuments_PHIAttachments.updateLink('{ "ID":"'+md.id+'", "name":"PHILog Attachment8", "car":null, "link":"www.google.com" }');
         uploadDocuments_PHIAttachments.updateLink('{ "ID":"'+md.id+'", "name":"PHILog Attachment9", "car":null, "link":"www.google.com" }');
         uploadDocuments_PHIAttachments.updateLink('{ "ID":"'+md.id+'", "name":"PHILog Attachment10", "car":null, "link":"www.google.com" }');
         
         test.stopTest();
         
         }
}