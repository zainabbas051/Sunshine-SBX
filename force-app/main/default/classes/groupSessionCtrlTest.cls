@isTest
public class groupSessionCtrlTest {
    
      static testMethod void GroupSession_Test(){
            
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
         
             
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.Admit_Date_Time__c = DateTime.Now().AddDays(-5);
         cl.Discharge_Date_Time__c = DateTime.Now();
         cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         cl.Track_Post_Detox__c = 'Blue Track';
         insert cl;
         
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
         
         UtlizationReviewOrder__c util = new UtlizationReviewOrder__c();
         util.Client_Chart__c  = cl.ID;
         util.Bed__c = iBed.ID;
         util.Status__c = 'Active';
         insert util;
         
         List<Group_Therapy_Session__c> lstGrp = new List<Group_Therapy_Session__c>();
         
         
         Group_Therapy_Session__c grpSession = new Group_Therapy_Session__c();
         grpSession.Date__c = Date.Today();
         grpSession.Status__c = 'Open';
         grpSession.Start_Time__c = '09:00 AM';
         grpSession.End_Time__c = '10:00 AM';
         grpSession.House__c = iHouse.Id;
         grpSession.Client_Track__c = 'Blue Track';
         lstGrp.add(grpSession);
         
         grpSession = new Group_Therapy_Session__c();
         grpSession.Date__c = Date.Today();
         grpSession.Status__c = 'Completed';
         grpSession.Start_Time__c = '09:00 AM';
         grpSession.End_Time__c = '10:00 AM';
         grpSession.House__c = iHouse.Id;
         grpSession.Client_Track__c = 'Blue Track';
         lstGrp.add(grpSession);
         
         grpSession = new Group_Therapy_Session__c();
         grpSession.Date__c = Date.Today();
         grpSession.Status__c = 'Review Pending';
         grpSession.Start_Time__c = '09:00 AM';
         grpSession.End_Time__c = '10:00 AM';
         grpSession.House__c = iHouse.Id;
         grpSession.Client_Track__c = 'Blue Track';
         lstGrp.add(grpSession);
         
         grpSession = new Group_Therapy_Session__c();
         grpSession.Date__c = Date.Today().AddDays(-2);
         grpSession.Status__c = 'Completed';
         grpSession.Start_Time__c = '09:00 AM';
         grpSession.End_Time__c = '10:00 AM';
         grpSession.House__c = iHouse.Id;
         grpSession.Client_Track__c = 'Blue Track';
         lstGrp.add(grpSession);
         
         insert lstGrp;
         
         
         groupSessionCtrl grpCtrl = new groupSessionCtrl();
         grpCtrl.statusRecordID = lstGrp[0].ID;
         grpCtrl.ChangeStatus();
         grpCtrl.ChangeOwner();
         
      }
}