@isTest
public class ClinicalNotesHomePageControllerTest {
    
     static testMethod void ClinicalNotesTest(){
            
          test.startTest();
         
         TabViews__c tv = new TabViews__c();
         tv.Name = 'ClinicalNotes';
         insert tv;
         
         Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
             
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.Admit_Date_Time__c = DateTime.Now().AddDays(-5);
         cl.Discharge_Date_Time__c = DateTime.Now();
         cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
         Clinical_Note__c clNotes = new Clinical_Note__c();
         clNotes.RecordTypeID = Schema.SObjectType.Clinical_Note__c.getRecordTypeInfosByName().get('Group Session Notes').getRecordTypeId();
         clNotes.Client_Chart__c = cl.ID;
         clNotes.Date__c = Date.Today().AddDays(-2);
         
         insert clNotes;
         
          Test.setCurrentPageReference(new PageReference('/apex/ClinicalNotesHomePage'));
         System.currentPageReference().getParameters().put('ID', cl.ID);
         
         ClinicalNotesHomePageController clCtrl = new ClinicalNotesHomePageController();
         clCtrl.SelectedOption = 'Progress Notes,';
         clCtrl.getPreviousWeek();
         clCtrl.GetNextWeek();
         clCtrl.SaveNewClinicalRecords();
         Boolean Flag = clCtrl.buttonAccessType;
       
         
         test.stopTest();
         
         
     }
}