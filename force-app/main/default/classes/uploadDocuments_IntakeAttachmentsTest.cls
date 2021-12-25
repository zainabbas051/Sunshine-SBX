@isTest
public class uploadDocuments_IntakeAttachmentsTest {
        
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
         
         Intake_Forms__c md = new Intake_Forms__c();
         md.Client_Chart__c = cl.id;
         md.RecordTypeID = Schema.SObjectType.Intake_Forms__c.getRecordTypeInfosByName().get('Admit Agreement').getRecordTypeId();
         md.Status__c = 'Open';
         insert md;
         
         awsBucket__c AmazonBucketValue = new awsBucket__c();
         AmazonBucketValue.Name ='FREEPU';
         AmazonBucketValue.accessKeyId__c = 'ABC';
         AmazonBucketValue.secretAccessKey__c ='XYZ';
         insert AmazonBucketValue;
         
         Documents_Type__c docType = new Documents_Type__c();
         doctype.Object_API_Name__c = 'Intake_Forms__c';
         docType.Is_Active__c = true;
         docType.Name = 'Intake Attachment1';
         insert docType;
         
         PageReference pageRef = Page.uploadDocuments_IntakeAttachments;
         Test.setCurrentPage(pageRef);
         ApexPages.CurrentPage().getParameters().put('rtID',md.RecordTypeId);
         ApexPages.CurrentPage().getParameters().put('id',md.id);
         Apexpages.currentPage().getParameters().put('message','error');   
         ApexPages.StandardController sc = new ApexPages.StandardController(cl);
         
         uploadDocuments_IntakeAttachments up = new uploadDocuments_IntakeAttachments(sc);
         up.cancelCustom();
         up.validationError();
         uploadDocuments_IntakeAttachments.document_uploaded_true('abc');
         uploadDocuments_IntakeAttachments.updateLink('{ "ID":"'+md.id+'", "name":"Medical Attachment1", "car":null, "link":"www.google.com" }');
         uploadDocuments_IntakeAttachments.updateLink('{ "ID":"'+md.id+'", "name":"Medical Attachment2", "car":null, "link":"www.google.com" }');
         uploadDocuments_IntakeAttachments.updateLink('{ "ID":"'+md.id+'", "name":"Medical Attachment3", "car":null, "link":"www.google.com" }');
         uploadDocuments_IntakeAttachments.updateLink('{ "ID":"'+md.id+'", "name":"Medical Attachment4", "car":null, "link":"www.google.com" }');
         uploadDocuments_IntakeAttachments.updateLink('{ "ID":"'+md.id+'", "name":"Medical Attachment5", "car":null, "link":"www.google.com" }');
         uploadDocuments_IntakeAttachments.updateLink('{ "ID":"'+md.id+'", "name":"Medical Attachment6", "car":null, "link":"www.google.com" }');
         uploadDocuments_IntakeAttachments.updateLink('{ "ID":"'+md.id+'", "name":"Medical Attachment7", "car":null, "link":"www.google.com" }');
         uploadDocuments_IntakeAttachments.updateLink('{ "ID":"'+md.id+'", "name":"Medical Attachment8", "car":null, "link":"www.google.com" }');
         uploadDocuments_IntakeAttachments.updateLink('{ "ID":"'+md.id+'", "name":"Medical Attachment9", "car":null, "link":"www.google.com" }');
         uploadDocuments_IntakeAttachments.updateLink('{ "ID":"'+md.id+'", "name":"Medical Attachment10", "car":null, "link":"www.google.com" }');
     
     test.stopTest();
     
     }
}