@isTest
public class MedicalConsultationViewCtrlTest {
    
      static testMethod void MedicalConsultationTest(){
            
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
             
              Recurring_Assessment__c ra = new Recurring_Assessment__c();
             ra.Client_Chart__c = cl.ID;
             ra.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId(); 
             ra.Status__c='Closed';
             insert ra;
             
             Allergies__c al = new Allergies__c();
             al.Client_Chart__c = cl.ID;
             insert al;
             
            Test.setCurrentPageReference(new PageReference('/apex/MedicalHomeEditPage'));
            System.currentPageReference().getParameters().put('ID', cl.ID);
            System.currentPageReference().getParameters().put('mcid', med.ID);
            System.currentPageReference().getParameters().put('rtId', med.RecordTypeID);
             
             MedicalConsultationViewCtrl m = new MedicalConsultationViewCtrl();
             m.getMethod();
             m.closePopup();
             m.showPopup();
             m.getAllergiesLst();
             m.EditRec();
        
      }
}