@isTest
public class CalendarCtrlTest {
    
    public Static Profile adminProfile;
    
    public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US');
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
    
      static testMethod void CalendarTest(){
          
          test.startTest();
         
         awsBucket__c AmazonBucketValue = new awsBucket__c();
            AmazonBucketValue.name='FREEPU';
            AmazonBucketValue.accessKeyId__c='testAcess';
            AmazonBucketValue.secretAccessKey__c='secretKey';
            AmazonBucketValue.Bucket__c='freepu';
            insert AmazonBucketValue;
        
      
         
         Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
          /*ALL NEW WORK*/
           Bed_Board_Configuration__c iHouse = new Bed_Board_Configuration__c();
        iHouse.House_Name__c = 'testHouse';
        iHouse.Sunshine_Center__c = a.ID;
        insert iHouse;
        
          Bed_Board_Configuration__c iRoom = new Bed_Board_Configuration__c();
        iRoom.House__c = iHouse.ID;
        
        insert iRoom;
        
           Bed_Board_Configuration__c iBed = new Bed_Board_Configuration__c();
        iBed.Room__c = iRoom.ID;
        
        insert iBed;
        
        
        /*END*/
       
         
         Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
        scid.Name = 'Monarch Shores';
        scid.Requires_Admit_Order__c = False;
        scid.Account_Id__c = a.id;
        scid.Dr_Alva_Forms__c = True;
        insert scid;
        
        
             
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = userAdmin.id;
         cl.Admit_Date_Time__c = DateTime.Now().AddDays(-5);
         cl.Discharge_Date_Time__c = DateTime.Now();
         cl.Client_Status__c = 'Admitted';
         cl.Program__c = 'Detox';
         cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
     
         insert cl;
         /*ALL NEW WORK*/
         UtlizationReviewOrder__c util = new UtlizationReviewOrder__c();
         util.Client_Chart__c  = cl.ID;
         util.Bed__c = iBed.ID;
         util.Status__c = 'Active';
         insert util;
         /*END*/
         Tx_and_D_C_Plans__c txM = new Tx_and_D_C_Plans__c();
         txM.Client_Chart__c = cl.ID;
         txM.status__c = 'Open';
         txM.Due_Date_time__c = DateTime.Now();
         txM.RecordTypeID = Schema.SObjectType.Tx_and_D_C_Plans__c.getRecordTypeInfosByName().get('Master Treatment Plan').getRecordTypeId();
         insert txM;
         
         Tx_and_D_C_Plans__c tx = new Tx_and_D_C_Plans__c();
         tx.Client_Chart__c = cl.ID;
         tx.status__c = 'In Use';
         tx.Due_Date_time__c = DateTime.Now();
         tx.RecordTypeID = Schema.SObjectType.Tx_and_D_C_Plans__c.getRecordTypeInfosByName().get('Detox Treatment Plan').getRecordTypeId();
         insert tx;
         
         Tx_and_D_C_Plans__c tx_ur = new Tx_and_D_C_Plans__c();
         tx_ur.Client_Chart__c = cl.ID;
         tx_ur.status__c = 'Review Pending';
         tx_ur.Due_Date_time__c = DateTime.Now();
         tx_ur.RecordTypeID = Schema.SObjectType.Tx_and_D_C_Plans__c.getRecordTypeInfosByName().get('Detox Treatment Plan').getRecordTypeId();
         insert tx_ur;
         
         Master_Problem__c masterPlan = new Master_Problem__c();
         masterPlan.Tx_and_D_C_Plans__c = txM.ID;
         insert masterPlan;
         
         
         Detox_Objectives__c detoxObj = new Detox_Objectives__c();
         detoxObj.Tx_and_D_C_Plans__c = tx.ID;
         insert detoxObj;
         
         Task tObj = new Task();
         tObj.WhatID = detoxObj.ID;
         tObj.End_Date__c = Date.Today();
         insert tObj;
         
         Event evt = new Event();
         evt.RecordTypeID = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Concurrent Reviews').getRecordTypeId();
         evt.WhatId = cl.ID;
         evt.StartDateTime = DateTime.Now();
         evt.DurationInMinutes = 20;
         evt.Status__c = 'Review Pending';
         insert evt;
         
         Clinical_Evaluation__c clE = new Clinical_Evaluation__c();
         clE.Due_Date_Time__c = DateTime.Now();
         clE.Client_Chart__c = cl.ID;
         clE.RecordTypeID = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Bio-Psychosocial Assessment').getRecordTypeId();
         insert clE;
         
         Clinical_Evaluation__c cl_ur = new Clinical_Evaluation__c();
         cl_ur.Due_Date_Time__c = DateTime.Now();
         cl_ur.Client_Chart__c = cl.ID;
         cl_ur.Status__c = 'Review Pending';
         cl_ur.RecordTypeID = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Bio-Psychosocial Assessment').getRecordTypeId();
         insert cl_ur;
         
         Group_Therapy_Session__c grp = new Group_Therapy_Session__c();
         grp.Status__c = 'Open';
         grp.RecordTypeID = Schema.SObjectType.Group_Therapy_Session__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         grp.Date__c = Date.Today();
         grp.Start_Time__c = '03:30 AM';
         grp.End_Time__c = '05:30 AM';
         grp.OwnerID = userAdmin.ID;
         grp.House__c = iHouse.ID;
         insert grp;
         
         //Update for FREEP-411
         //Commented out as part of Update in logic, where by Supervisor Donot Need to Review Group Sessions. Interns and Counsellors can close out there own Groups    
         /*Group_Therapy_Session__c grp_ur = new Group_Therapy_Session__c();
         grp_ur.Status__c = 'Pending Review';
         grp_ur.RecordTypeID = Schema.SObjectType.Group_Therapy_Session__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         grp_ur.Date__c = Date.Today();
         grp_ur.Start_Time__c = '03:30 AM';
         grp_ur.End_Time__c = '05:30 AM';
         grp_ur.OwnerID = userAdmin.ID;
          grp.House__c = iHouse.ID;
         insert grp_ur;
         */
         
         Clinical_Note__c clNotes = new Clinical_Note__c();
         clNotes.RecordTypeID = Schema.SObjectType.Clinical_Note__c.getRecordTypeInfosByName().get('Group Session Notes').getRecordTypeId();
         clNotes.Client_Chart__c = cl.ID;
         clNotes.Start_Date_Time__c = DateTime.Now();
         insert clNotes;
         
         Clinical_Note__c clNotes_ur = new Clinical_Note__c();
         clNotes_ur.RecordTypeID = Schema.SObjectType.Clinical_Note__c.getRecordTypeInfosByName().get('Group Session Notes').getRecordTypeId();
         clNotes_ur.Client_Chart__c = cl.ID;
         clNotes_ur.Start_Date_Time__c = DateTime.Now();
         clNotes_ur.Status__c = 'Ready for Review';
         insert clNotes_ur;
         
         Utilization_Review__c cr = new Utilization_Review__c();
         cr.Client_Chart__c = cl.id;
         cr.RecordTypeId = Constants.ConcurrentReviewRecordTypeId;
         cr.Status__c = 'Review Pending';
         cr.Next_Review_Date__c = Date.Today();
         insert cr;
        
         system.runAs(userAdmin){
             Test.setCurrentPageReference(new PageReference('/apex/Calendar4'));
             System.currentPageReference().getParameters().put('rt', 'Monarch Shores');
             CalendarCtrl ctrl = new CalendarCtrl();
               /*ALL NEW WORK*/
             ctrl.selectHouse = iHouse.ID;
             /*END*/
             ctrl.selectOption = 'MyClinicalCalendar';
             ctrl.pageLoad();
             
             ctrl.selectOption = 'UnderReviewDocs';
             ctrl.pageLoad();
             
             CalendarUR_Ctrl ctUR = new CalendarUR_Ctrl();
             ctUR.selectHouse = iHouse.ID;
             ctUR.clientSelection = 'ClientsHouse';
             ctUR.pageLoad();
         }
         
         test.stopTest();
      }
}