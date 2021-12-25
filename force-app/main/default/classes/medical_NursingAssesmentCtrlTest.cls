@isTest
public class medical_NursingAssesmentCtrlTest {
    
     
      
        static testMethod void MedicalEditTest_Attch(){
      
             test.startTest();
             Account a = new Account();
             a.Name = 'Monarch Shores';
             a.Type = 'Internal Center';
             insert a;
             
               
             Client_Chart__c cl = new Client_Chart__c();
             cl.Treatment_Center__c = a.ID;
             cl.Primary_Therapist__c = UserINFO.getUserID();
             cl.Gender__c = 'Female';
             cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
             insert cl;
             
             Medical__c med = new Medical__c();
             med.RecordTypeID = Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('Nursing Assessment').getRecordTypeId(); 
             med.Client_Chart__c = cl.ID;
             med.Status__c = 'Open';
             insert med;
             
             Recurring_Assessment__c ra = new Recurring_Assessment__c();
             ra.Client_Chart__c = cl.ID;
             ra.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId(); 
             ra.Status__c='Closed';
             insert ra;
             
             Recurring_Assessment__c ra2 = new Recurring_Assessment__c();
             ra2.Client_Chart__c = cl.ID;
             ra2.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Blood Glucose').getRecordTypeId(); 
             ra2.Status__c='Closed';
             insert ra2;
             
             UtlizationReviewOrder__c util = new UtlizationReviewOrder__c();
             util.Vital_Sign__c = ra.ID;
             util.Medical__c =  med.ID;
             insert util;
             
             util = new UtlizationReviewOrder__c();
             util.Glucose__c = ra2.ID;
             util.Medical__c =  med.ID;
             insert util;
             
             awsBucket__c AmazonBucketValue = new awsBucket__c();
             AmazonBucketValue.Name ='FREEPU';
             AmazonBucketValue.accessKeyId__c = 'ABC';
             AmazonBucketValue.secretAccessKey__c ='XYZ';
             insert AmazonBucketValue;
            
            Test.setCurrentPageReference(new PageReference('/apex/MedicalHomeEditPage'));
            System.currentPageReference().getParameters().put('ID', cl.ID);
            System.currentPageReference().getParameters().put('mcid', med.ID);
            System.currentPageReference().getParameters().put('rtId', med.RecordTypeID);
            
            medical_NursingAssesmentCtrl m = new medical_NursingAssesmentCtrl();
            m.meds = med;
            m.BodyChartUrl = 'test';
            PageReference pr = m.SaveMeds();
            Boolean flag1 = m.ProcessVitalSign;
            
            med.Status__c = 'Closed';
            update med;
            Boolean flag2 = m.ProcessVitalSign;
            
      }
}