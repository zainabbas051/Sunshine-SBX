@isTest
public class MedicalHomeEditCtrlTest {
    
      static testMethod void MedicalEditTest(){
      
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
             med.RecordTypeID = Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('Provider Consultation').getRecordTypeId(); 
             med.Client_Chart__c = cl.ID;
             med.Status__c = 'Open';
             insert med;
             
             Medical__c med1 = new Medical__c();
             med1.RecordTypeID = Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('BAC and Drug Screen').getRecordTypeId(); 
             med1.Client_Chart__c = cl.ID;
             med1.Status__c = 'Closed';
             insert med1;
             
             Recurring_Assessment__c ra = new Recurring_Assessment__c();
             ra.Client_Chart__c = cl.ID;
             ra.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId(); 
             ra.Status__c='Closed';
             insert ra;
             
             UtlizationReviewOrder__c util = new UtlizationReviewOrder__c();
             util.Vital_Sign__c = ra.ID;
             util.Medical__c =  med.ID;
             insert util;
             
             util = new UtlizationReviewOrder__c();
             util.drugscreen__C = med1.ID;
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
            
            MedicalHomeEditCtrl m = new MedicalHomeEditCtrl();
            m.changeStatus();
            m.AddAttachment();
            m.BacktoMedicalHome();
                m.ImageUrlAddress = 'test';
                m.SelectedSignedOption = 'patient';
            m.CloseMedicals();
            m.ShowMedicalConsultForm = false;
            m.ShowMedicalLabAttachmentForm = false;
            m.showAdmitOrderForm = false;
            m.ShowOustidereferalnoteform = false;
            m.ShowDrugScreenForm = false;
            m.ShowUrinePregnacyTestForm = false;
            
               m.SelectedSignedOption = 'staff';
                    m.CloseMedicals();
          
            
            
      }
      
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
             med.RecordTypeID = Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('Lab Attachment').getRecordTypeId(); 
             med.Client_Chart__c = cl.ID;
             med.Status__c = 'Open';
             med.Attachment1_Id_URl__c = '/abc%67';
              med.Attachment2_Id_URl__c = '/abc%67';
                   med.Attachment3_Id_URl__c = '/abc%67';
              med.Attachment4_Id_URl__c = '/abc%67';
                   med.Attachment5_Id_URl__c = '/abc%67';
              med.Attachment6_Id_URl__c = '/abc%67';
                   med.Attachment7_Id_URl__c = '/abc%67';
              med.Attachment8_Id_URl__c = '/abc%67';
                   med.Attachment9_Id_URl__c = '/abc%67';
              med.Attachment10_Id_URl__c = '/abc%67';
             insert med;
             
             Medical__c med1 = new Medical__c();
             med1.RecordTypeID = Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('BAC and Drug Screen').getRecordTypeId(); 
             med1.Client_Chart__c = cl.ID;
             med1.Status__c = 'Closed';
             
             insert med1;
             
             Recurring_Assessment__c ra = new Recurring_Assessment__c();
             ra.Client_Chart__c = cl.ID;
             ra.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId(); 
             ra.Status__c='Closed';
             insert ra;
             
             UtlizationReviewOrder__c util = new UtlizationReviewOrder__c();
             util.Vital_Sign__c = ra.ID;
             util.Medical__c =  med.ID;
             insert util;
             
             util = new UtlizationReviewOrder__c();
             util.drugscreen__C = med1.ID;
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
            
            MedicalHomeEditCtrl m = new MedicalHomeEditCtrl();
            m.changeStatus();
            m.AddAttachment();
            m.BacktoMedicalHome();
                m.ImageUrlAddress = 'test';
                m.SelectedSignedOption = 'patient';
            m.CloseMedicals();
            m.ShowMedicalConsultForm = false;
            m.ShowMedicalLabAttachmentForm = false;
            m.showAdmitOrderForm = false;
            m.ShowOustidereferalnoteform = false;
            m.ShowDrugScreenForm = false;
            m.ShowUrinePregnacyTestForm = false;
            m.SaveRecord();
            m.editRecord();
            m.SelectChange();
            
               m.SelectedSignedOption = 'staff';
                    m.CloseMedicals();
          
            
            
      }
}