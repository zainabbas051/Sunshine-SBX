//test class : insertUpdateKUPUBillableItemsTest
public without sharing class Utilities_KIPUBillableItemsTemp {
    
    public static KIPU_Billable_Items__c KIPUBillableItems_Create (KIPU_Billable_Items_Temp__c kbit, Id snapshotId){
         
         KIPU_Billable_Items__c kbi = new KIPU_Billable_Items__c();
         kbi.Client_KIPU_Snapshot__c = snapshotId;
         kbi.KIPU_MRN__c = kbit.KIPU_MRN__c;
         
         if(kbit.Appointment__c != null){
             kbi.Name =kbit.Appointment__c;
             kbi.RecordTypeId = Schema.SObjectType.KIPU_Billable_Items__c.getRecordTypeInfosByName().get('Appointments').getRecordTypeId();
             kbi.Scheduled_By__c  = kbit.Scheduled_By__c;
             kbi.Authorizations__c = kbit.Authorizations__c;
             kbi.Status__c = kbit.Status__c;
             kbi.Start_Date__c = kbit.Start_Date__c;
             kbi.End_Date__c = kbit.End_Date__c;
             kbi.Duration__c = kbit.Duration__c;
             kbi.Appointment__c = kbit.Appointment__c;
             kbi.KIPU_Billable_Items_Temp__c = kbit.id;
         }
         
         if(kbit.Evaluation_Template_ID__c != null){
             kbi.Name =kbit.Evaluation__c;
             kbi.RecordTypeId = Schema.SObjectType.KIPU_Billable_Items__c.getRecordTypeInfosByName().get('Evaluations').getRecordTypeId();
             kbi.Signed_By__c = kbit.Signed_By__c;
             kbi.Authorizations__c = kbit.Authorizations__c;
             kbi.Status__c = kbit.Status__c;
             kbi.Completed_At__c = kbit.Completed_At__c;
             kbi.Start_Date__c = kbit.Start_Date__c;
             kbi.End_Date__c = kbit.End_Date__c;
             kbi.Duration__c = kbit.Duration__c;
             kbi.Evaluation__c = kbit.Evaluation__c;
             kbi.KIPU_Billable_Items_Temp__c = kbit.id;
             kbi.Evaluation_Template_ID__c = kbit.Evaluation_Template_ID__c;
         }
         
         if(kbit.Session__c != null){
             kbi.Name =kbit.Session__c;
             kbi.RecordTypeId = Schema.SObjectType.KIPU_Billable_Items__c.getRecordTypeInfosByName().get('Sessions').getRecordTypeId();
             kbi.Topic__c = kbit.Topic__c;
             kbi.Provider__c = kbit.Provider__c;
             kbi.Authorizations__c = kbit.Authorizations__c;
             kbi.Status__c = kbit.Status__c;
             kbi.Start_Date__c = kbit.Start_Date__c;
             kbi.End_Date__c = kbit.End_Date__c;
             kbi.Duration__c = kbit.Duration__c;
             kbi.Completed_At__c = kbit.Completed_At__c;
             kbi.Session__c = kbit.Session__c;
             kbi.KIPU_Billable_Items_Temp__c = kbit.id;
         }
         
         if(kbit.Speciment_ID__c != null){
             kbi.Name ='Lab Test';
             kbi.RecordTypeId = Schema.SObjectType.KIPU_Billable_Items__c.getRecordTypeInfosByName().get('Lab Tests').getRecordTypeId();
             kbi.Speciment_ID__c = kbit.Speciment_ID__c;
             kbi.Specimen_Source__c = kbit.Specimen_Source__c;
             kbi.Vendor__c = kbit.Vendor__c;
             kbi.Collected__c = kbit.Collected__c;
             kbi.Lab_Test__c = kbit.Lab_Test__c;
             kbi.KIPU_Billable_Items_Temp__c = kbit.id;
         }
        
        return kbi;     
    } 
  
}