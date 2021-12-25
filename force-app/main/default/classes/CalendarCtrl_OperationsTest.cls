@isTest
public class CalendarCtrl_OperationsTest {
    
    
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
    static testMethod void CalendarOperationTest(){
        
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
         util.Status__c= 'Active';
         insert util;
         /*END*/
         
         Recurring_Assessment__c recu = new Recurring_Assessment__c();
         recu.Client_Chart__c = cl.ID;
         recu.Time_Due__c = DateTime.Now();
         recu.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId();
         insert recu;
         
         Intake_Forms__c intake = new Intake_Forms__c();
         intake.Client_Chart__c = cl.ID;
         intake.Due_Date_Time__c = DateTime.Now();
         intake.RecordTypeID =  Schema.SObjectType.Intake_Forms__c.getRecordTypeInfosByName().get('Advance Directive').getRecordTypeId(); 
         intake.Status__c = 'Open';
         insert intake;
         
          Medical__c med = new Medical__c();
         med.Client_Chart__c = cl.ID;
         med.RecordTypeID = Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('BAC and Drug Screen').getRecordTypeId();
         med.Due_Date_Time__c = DateTime.Now();
         insert med;
         
          Medical__c med2 = new Medical__c();
         med2.Client_Chart__c = cl.ID;
         med2.RecordTypeID = Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('Admit Order').getRecordTypeId();
         med2.Due_Date_Time__c = DateTime.Now();
         insert med2;
         
         
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
         
          Group_Therapy_Session__c grp = new Group_Therapy_Session__c();
         grp.Status__c = 'Open';
         grp.RecordTypeID = Schema.SObjectType.Group_Therapy_Session__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         grp.Date__c = Date.Today();
         grp.Start_Time__c = '03:30 AM';
         grp.End_Time__c = '05:30 AM';
         grp.OwnerID = userAdmin.ID;
         insert grp;
         
           Test.setCurrentPageReference(new PageReference('/apex/Calendar5'));
         System.currentPageReference().getParameters().put('rt', 'Monarch Shores');
         CalendarCtrl_Operations ctrl = new CalendarCtrl_Operations();
              /*ALL NEW WORK*/
             ctrl.selectHouse = iHouse.ID;
             /*END*/
         ctrl.pageLoad();
         
         test.stopTest();
         
    }

}