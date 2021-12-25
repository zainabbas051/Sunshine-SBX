@isTest
public class CalendarCtrl_MarsTest {

     
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
         cl.Primary_Therapist__c = UserINFO.getUserID();
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
         
         Medical__c med = new Medical__c();
         med.Client_Chart__c = cl.ID;
         med.RecordTypeID = Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('Admit Order').getRecordTypeId();
         med.Due_Date_Time__c = DateTime.Now();
         insert med;
         
         
         Clinical_Evaluation__c clEv = new Clinical_Evaluation__c();
         clEv.Client_Chart__c = cl.ID;
         clEv.RecordTypeID = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Phsych Evaluation').getRecordTypeId();
         clEv.Due_Date_Time__c = DateTime.Now();
         insert clEv;
         
         Clinical_Evaluation_3__c clEv3 = new Clinical_Evaluation_3__c();
         clEv3.Client_Chart__c = cl.ID;
         clEv3.RecordTypeID = Schema.SObjectType.Clinical_Evaluation_3__c.getRecordTypeInfosByName().get('History And Physical').getRecordTypeId();
         clEv3.Due_Date_Time__c = DateTime.Now();
         insert clEv3;
         
         Order__c ord = new Order__c();
         ord.Medical__c = med.ID;
         ord.Client_Chart__c = cl.ID;
         ord.Start_Date__c = dateTime.Now();
         ord.Frequency__c = 'Q1 Hours : Every Hour';
         insert ord;
         
         Medicine__c medcn = new Medicine__c();
         medcn.PRN__c = true;
         medcn.Name = 'abc';
         insert medcn;
         
         
         Event evt = new Event();
         evt.RecordTypeID = Schema.SObjectType.Event.getRecordTypeInfosByName().get('MARs').getRecordTypeId();
         evt.Status__c = 'Open';
         evt.DurationInMinutes = 50;
         evt.ActivityDateTime = DateTime.Now();
         evt.Strength__c = 'abc';
         evt.Medicine__c = medcn.ID;
         evt.WhatID = ord.ID;
         evt.Frequency__c = 'Q1 Hours : Every Hour';
         evt.Client_Chart__c = cl.ID;
         insert evt;
         
         /*  CalEvent cle = new CalEvent();
           cle.title = 'Test Titl';
                cle.AllDay = false;
                cle.startString =DateTime.Now().AddDays(-5);
                cle.endString = DateTime.Now();
                cle.className = 'event-pastdue';
                insert cle; */
         
         
         Test.setCurrentPageReference(new PageReference('/apex/Calendar4'));
         System.currentPageReference().getParameters().put('rt', 'Monarch Shores');
         CalendarCtrl_Mars ctrl = new CalendarCtrl_Mars();
          ctrl.selectHouse = iHouse.ID;
         ctrl.selectOption = 'nursing';
         ctrl.pageLoad();
         
         ctrl.selectOption = 'doctor';
         ctrl.pageLoad();
         
         
         test.stopTest();
      }
}