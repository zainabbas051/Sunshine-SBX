@isTest
public class MedcialHomePageCtrlTest{
    
       static testMethod void MedicalTest(){
               
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
             
             
             List<Medical__c> lstMedical = new List<Medical__c>();
             
             Medical__c med = new Medical__c();
             med.RecordTypeID = Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('Provider Consultation').getRecordTypeId(); 
             med.Client_Chart__c = cl.ID;
             lstMedical.add(med);
             
             med = new Medical__c();
             med.RecordTypeID = Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('Urine Pregnancy Test').getRecordTypeId(); 
             med.Client_Chart__c = cl.ID;
             lstMedical.add(med);
             
             med = new Medical__c();
             med.RecordTypeID = Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('BAC and Drug Screen').getRecordTypeId(); 
             med.Client_Chart__c = cl.ID;
             med.Status__c = 'Closed';
             lstMedical.add(med);
             
             insert lstMedical;
             
             
             Clinical_Evaluation__c cle = new Clinical_Evaluation__c();
             cle.Client_Chart__c = cl.ID;
             cle.RecordTypeID = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Phsych Evaluation').getRecordTypeId(); 
             insert cle;
             
             Clinical_Evaluation_3__c cl3 = new Clinical_Evaluation_3__c();
             cl3.Client_Chart__c = cl.ID;
             cl3.RecordTypeID = Schema.SObjectType.Clinical_Evaluation_3__c.getRecordTypeInfosByName().get('History And Physical').getRecordTypeId(); 
             insert cl3;
             
             Recurring_Assessment__c ra = new Recurring_Assessment__c();
             ra.Client_Chart__c = cl.ID;
             ra.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId(); 
             ra.Status__c='Closed';
             insert ra;
             
             Test.setCurrentPageReference(new PageReference('/apex/MedicalHomePage'));
             System.currentPageReference().getParameters().put('ID', cl.ID);
        
             MedcialHomePageCtrl m = new MedcialHomePageCtrl();
             m.SelectedOption = 'Provider Consultation,';
             m.AddFormMedical();
             m.getMedicalLst();
             m.AddNewForm();
             m.closePopup();
             m.showPopup();
             m.BacktoMedicalHome();
             test.stopTest();
           
       }
}