@isTest
public class txdc_detoxtreatmentplanTest {
    
    static testMethod void TxdcCdetoxtreatmentplanTest(){
        
         test.startTest();
         Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
         List<Tx_and_D_C_Plans__c> lstTx = new List<Tx_and_D_C_Plans__c>();
         Id detoxID = Schema.SObjectType.Tx_and_D_C_Plans__c.getRecordTypeInfosByName().get('Detox Treatment Plan').getRecordTypeId();
         Id dishchargeID = Schema.SObjectType.Tx_and_D_C_Plans__c.getRecordTypeInfosByName().get('Discharge Plan').getRecordTypeId();
         
         Tx_and_D_C_Plans__c tx = new Tx_and_D_C_Plans__c();
         tx.Client_Chart__c = cl.ID;
         tx.RecordTypeID = dishchargeID;
         tx.Status__c = 'Open';
         insert tx;
         
         tx = new Tx_and_D_C_Plans__c();
         tx.Client_Chart__c = cl.ID;
         tx.RecordTypeID = detoxID;
         tx.Presenting_Problem__c = 'abc;xyz';
         tx.Status__c = 'Open';
         insert tx;
         
         Detox_Objectives__c detoxObj = new Detox_Objectives__c();
         detoxObj.Tx_and_D_C_Plans__c = tx.ID;
         insert detoxObj;
         
         Task tObj = new Task();
         tObj.WhatID = detoxObj.ID;
         insert tObj;
         
         
         Task tObj1 = new Task();
         tObj1.WhatID = detoxObj.ID;
         insert tObj1;   
         
         awsBucket__c AmazonBucketValue = new awsBucket__c();
         AmazonBucketValue.Name ='FREEPU';
         AmazonBucketValue.accessKeyId__c = 'ABC';
         AmazonBucketValue.secretAccessKey__c ='XYZ';
         insert AmazonBucketValue;
         
         
         Test.setCurrentPageReference(new PageReference('/apex/TxDcDetailPage'));
         System.currentPageReference().getParameters().put('ID', cl.ID);
         System.currentPageReference().getParameters().put('txdcObj', tx.ID);
         System.currentPageReference().getParameters().put('TargetObjID', detoxObj.ID);
         System.currentPageReference().getParameters().put('targetIndex', '0');
          System.currentPageReference().getParameters().put('TargetId',detoxObj.ID );
         
         txdc_detoxtreatmentplan txdcObj = new txdc_detoxtreatmentplan();
         
         
         txdcObj.EditFullPage();
         txdcObj.CancelPage();
         txdcObj.submit();
         txdcObj.ObjectiveIndex = 0;
         txdcObj.SaveObjective();
         txdcObj.Edit();
         
         txdcObj.AddTargets();
         txdcObj.SaveTargets();
         txdcObj.TargetID = detoxObj.ID ;
       //  txdcObj.TargetID = 0;
         txdcObj.TargetIndex = 0;
         txdcObj.EditTarget();
         txdcObj.AddMore();
         txdcObj.txdc.Status__c = 'In Use';
         txdcObj.SelectedSignedOption = 'Staff';
         txdcObj.ImageUrlAddress = 'http/abc';
         txdcObj.ActiveTXDxPlans();
         
         txdcObj.txdc.Status__c = 'In Use';
         txdcObj.SelectedSignedOption = 'Patient';
         txdcObj.ImageUrlAddress = 'http/abc';
         txdcObj.ActiveTXDxPlans();
         
         txdcObj.txdc.Status__c = 'Open';
         txdcObj.SelectedSignedOption = 'Staff';
         txdcObj.ImageUrlAddress = 'http/abc';
         txdcObj.ActiveTXDxPlans();
         
         txdcObj.txdc.Status__c = 'Open';
         txdcObj.SelectedSignedOption = 'Patient';
         txdcObj.ImageUrlAddress = 'http/abc';
         txdcObj.ActiveTXDxPlans();
         txdcObj.RemoveTarget();
         
         txdcObj.ObjectiveIndex = 0;
         txdcObj.RemoveObjectiveFromList();
        
         
         test.stopTest();
        
    }
}