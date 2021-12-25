@isTest
public class GroupTherapySessionsBatchTest {
    
      static testMethod void GroupSession_Test(){
            
            test.startTest();
            
        awsBucket__c AmazonBucketValue = new awsBucket__c();
        AmazonBucketValue.name='FREEPU';
        AmazonBucketValue.accessKeyId__c='testAcess';
        AmazonBucketValue.secretAccessKey__c='secretKey';
        AmazonBucketValue.Bucket__c='freepu';
        insert AmazonBucketValue;
        
            
             Account a = new Account();
            a.Name = 'Willowsprings Recovery';
            a.Type = 'Internal Center';
            insert a;
            
              Account a1 = new Account();
            a1.Name = 'Chapters Capistrano';
            a1.Type = 'Internal Center';
            insert a1;
            
            Client_Chart__c cl = new Client_Chart__c();
             cl.Treatment_Center__c = a.ID;
             cl.Primary_Therapist__c = UserINFO.getUserID();
             cl.Admit_Date_Time__c = DateTime.Now().AddDays(-5);
             cl.Discharge_Date_Time__c = DateTime.Now();
             cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Willowsprings Recovery').getRecordTypeId();
             cl.Track_Post_Detox__c = 'Green Track';
     
             insert cl;
             
             Bed_Board_Configuration__c house = new Bed_Board_Configuration__c();
             house.House_Name__c = 'house1';
             insert house;
             
               Client_Chart__c cl1 = new Client_Chart__c();
             cl1.Treatment_Center__c = a1.ID;
             cl1.Primary_Therapist__c = UserINFO.getUserID();
             cl1.Admit_Date_Time__c = DateTime.Now().AddDays(-5);
             cl1.Discharge_Date_Time__c = DateTime.Now();
             cl1.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Chapters Capistrano').getRecordTypeId();
           
     
             insert cl1;
             
             
          
             
             Bed_Board_Configuration__c room = new Bed_Board_Configuration__c();
             room.Room_Number__c = '2';
             room.house__c = house.ID;
             insert room;
             
             
             Bed_Board_Configuration__c bed = new Bed_Board_Configuration__c();
             bed.Bed_Number__c = '2';
             bed.room__C = room.ID;
             insert bed;
             
             UtlizationReviewOrder__c  util = new UtlizationReviewOrder__c();
             util.Client_Chart__c = cl1.ID;
             util.Bed__c = bed.id;
             insert util;
             
             
             
             
            
            
            Group_Session_Configuration__c grpSession = new Group_Session_Configuration__c ();
            grpSession.Day_of_Week__c ='Sunday;Monday;Tuesday;Wednesday;Thursday;Friday;Saturday';
            grpSession.End_Time__c = '10:00 PM';
            grpSession.Start_Time__c = '09:00 PM';
            grpSession.Facility_Name__c = a.ID;
            grpSession.Client_Track__c ='Green Track';
            insert grpSession;
            
            Group_Session_Configuration__c grpSession1 = new Group_Session_Configuration__c ();
            grpSession1.Day_of_Week__c ='Sunday;Monday;Tuesday;Wednesday;Thursday;Friday;Saturday';
            grpSession1.End_Time__c = '10:00 PM';
            grpSession1.Start_Time__c = '09:00 PM';
            grpSession1.Facility_Name__c = a1.ID;
            grpSession1.house__c = house.ID;
            insert grpSession1;
            
             
            
            
            GroupTherapySessionsSchedule sh1 = new GroupTherapySessionsSchedule();
             String sch = '0 0 23 * * ?';
            system.schedule('Test check', sch, sh1);
            
          /*  GroupTherapySessionsBatch grp = new GroupTherapySessionsBatch();
            Database.executeBatch(grp);*/
            
            
            test.stopTest();
      }

}