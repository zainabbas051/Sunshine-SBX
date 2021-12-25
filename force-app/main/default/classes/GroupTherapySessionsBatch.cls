/*
    @purpose: A separate process will run at 12:00 AM every night, that will look at the Group Session configuration 
    and create Group Therapy Session Records for that particular day depending on the facility and the facility 
    schedule, which will have the predefined data points from above.
    @author: Huma
    
    v1.1
    @Change
    @author: Danish
    @Date Sept-21-2017
    Add record type for group theraphy session 
    Add group client records when group is created
    
    v1.2
    @Change
    @author: Danish
    @Date Sept-22-2017
    Create events when group client created
    
    v1.3
    @Change
    @author: Danish
    @Date Feb-02-2018
    Create group client on the basis of house for Chapters Capistrano or Monarch Shores
    
    Test class : GroupTherapySessionsBatchTest
*/
global class GroupTherapySessionsBatch implements Database.Batchable < sObject > {


    global final String query;


    global GroupTherapySessionsBatch() {
        DateTime myDateTime = DateTime.now();
        String dayOfWeek = myDateTime.format('EEEE');
        system.debug(dayOfWeek);
        query = 'select id, Name, Day_of_Week__c, Facility_Name__c,Facility_Name__r.Name, Group_Name__c,House__c, ' +
            'End_Time__c, Start_Time__c,Client_Track__c, Assigned_Group_Owner__c from Group_Session_Configuration__c ' +
            'where Day_of_Week__c includes(\'' + dayOfWeek + '\')';

    }

    global Database.QueryLocator start(Database.BatchableContext BC) {

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List < sObject > scope) {

        DateTime myDateTime = DateTime.now();
        Set < string > SetOfClientTrack = new Set < String > ();

        //list to create group therapy sessions
        list < Group_Therapy_Session__c > lstCreateGroupTherapySessions = new list < Group_Therapy_Session__c > ();

        Group_Therapy_Session__c GTS;

        string RecordTypeID = '';

        Set < string > setOfHouse = new Set < string > ();

        for (Group_Session_Configuration__c GSC: (list < Group_Session_Configuration__c > ) scope) {

            GTS = new Group_Therapy_Session__c();
            GTS.Name = GSC.Group_Name__c;
            //GTS.Facility_Schedule__c = GSC.Facility_Schedule__c;
            RecordTypeID = Schema.SObjectType.Group_Therapy_Session__c.getRecordTypeInfosByName().get(GSC.Facility_Name__r.Name).getRecordTypeId();
            system.debug('###' + RecordTypeID);
            GTS.RecordTypeID = RecordTypeID;
            GTS.Rehab_Facility__c = GSC.Facility_Name__c;
            GTS.Date__c = myDateTime.date();
            GTS.Start_Time__c = GSC.Start_Time__c;
            GTS.End_Time__c = GSC.End_Time__c;
            if(GSC.Assigned_Group_Owner__c != null)
                GTS.OwnerId = GSC.Assigned_Group_Owner__c;

            if (GSC.Facility_Name__r.Name == 'Willowsprings Recovery' ){
                SetOfClientTrack.add(GSC.Client_Track__c);
                GTS.Client_Track__c = GSC.Client_Track__c;
            }
                
            else if(GSC.House__c != NULL){
                //v1.3
                setOfHouse.add(GSC.House__c);
                GTS.House__c = GSC.House__c;
            }

            lstCreateGroupTherapySessions.add(GTS);


        }


        if (lstCreateGroupTherapySessions.size() > 0) {
            insert lstCreateGroupTherapySessions;
            
            
            system.debug('$$$$$$' + setOfHouse);
            //Moved this logic to Group Session Control Class, as per Direction from Jared.
            //We Would to Create Group Clients at the Time the Group is Started instead of at the time the Group was Created.
            /*
            List < Client_Chart__c > lstClientChrt = [Select ID, Track_Post_Detox__c from Client_Chart__c where Track_Post_Detox__c in: SetOfClientTrack];

            List < UtlizationReviewOrder__c > lstUtilizationReview = [Select Client_Chart__c,
                Bed__c, Bed__r.Room__r.House__c, Bed__r.House_Name__c from UtlizationReviewOrder__c
                where Bed__r.Room__r.House__c IN: setOfHouse AND Status__c =: 'Active'];
            
            system.debug('$$$$$$' + lstUtilizationReview);

            if (!lstClientChrt.isEmpty())
                groupTheraphyBatch_Handler.CreateClientByClientTrack(lstClientChrt, lstCreateGroupTherapySessions);
            
            //v1.3
            if (!lstUtilizationReview.isEmpty())
                groupTheraphyBatch_Handler.CreateClientByHouse(lstUtilizationReview, lstCreateGroupTherapySessions);
            */

        }
    }


    global void finish(Database.BatchableContext BC) {

    }
}