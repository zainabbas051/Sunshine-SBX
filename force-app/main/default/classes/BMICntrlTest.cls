@isTest(seeAllData = true)
public class BMICntrlTest {
    static{
        
    }
    static testMethod void BMICntrlTest(){
        
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
         cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
     
         insert cl;
         Recurring_Assessment__c recu = new Recurring_Assessment__c();
         recu.Client_Chart__c = cl.ID;
         recu.Time_Due__c = DateTime.Now();
         recu.BMI_Assessment_Required__c = TRUE;
         recu.BMI_Assessment_Recurring_Time__c = 'Every 7 Days';
         recu.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId();
         insert recu;
        
         Recurring_Assessment__c recu2 = new Recurring_Assessment__c();
         recu2.Client_Chart__c = cl.ID;
         recu2.Time_Due__c = DateTime.Now();
         recu2.related_to__c = recu.Id;
         recu2.BMI_Assessment_Required__c = TRUE;
         recu2.BMI_Assessment_Recurring_Time__c = 'Every 7 Days';
         recu2.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId();
         insert recu2;
         
         Test.setCurrentPageReference(new PageReference('/apex/BMIVFP'));
         System.currentPageReference().getParameters().put('id', cl.Id);
         BMICntrl ctrl = new BMICntrl();
         ctrl.accessKeyId = Constants.accessKeyId;
         ctrl.secretAccessKey = Constants.secretAccessKey;
         ctrl.buildData();
         ctrl.recordId = recu2.Id;
         PageReference b1 = ctrl.Add();
         PageReference b2 = ctrl.AddVitalSigns();
          if(ctrl.lstWrapperRA.size()>0)
         ctrl.lstWrapperRA[0].selected = true;
         ctrl.generatePDF();
         try{
         PageReference b3 = ctrl.save();
         }
         catch(exception e){
        ctrl.bmiId = recu.Id;
         if(ctrl.lstWrapperRA.size()>0)
         ctrl.lstWrapperRA[0].selected = true;
         ctrl.generatePDF();
         PageReference b4 = ctrl.UpdateFileupload();
         }
         test.stopTest();
         
    }
}