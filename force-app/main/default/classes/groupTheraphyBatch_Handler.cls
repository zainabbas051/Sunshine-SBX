/* v1.3
    @Change
    @author: Danish
    @Date Feb-02-2018
    Create group client on the basis of house for Chapters Capistrano or Monarch Shores
    
    Test class : groupSessionCtrlTest
*/
public class groupTheraphyBatch_Handler {

    public static void CreateClientByClientTrack(List < Client_Chart__c > aLstClientChrt, List < Group_Therapy_Session__c > alstCreateGroupTherapySessions) {


        List < Group_Client__c > lstGrpClient = new List < Group_Client__c > ();
        Map < string, List < String >> iMapOfClientChart = new Map < string, List < string >> ();
        for (Client_Chart__c ccl: aLstClientChrt) {

            if (iMapOfClientChart.containsKey(ccl.Track_Post_Detox__c))
                iMapOfClientChart.get(ccl.Track_Post_Detox__c).add(ccl.ID);
            else
                iMapOfClientChart.put(ccl.Track_Post_Detox__c, new List < string > {
                    ccl.ID
                });


            for (Group_Therapy_Session__c grp: alstCreateGroupTherapySessions) {

                Group_Client__c grpClient;
                Date grpDate;
                system.debug('@@@' + grp.Client_Track__c);
                system.debug('@@@' + iMapOfClientChart);
                if (iMapOfClientChart.containsKey(grp.Client_Track__c)) {
                    for (string iClientChrtID: iMapOfClientChart.get(grp.Client_Track__c)) {

                        grpClient = new Group_Client__c();
                        grpClient.Client_Chart__c = iClientChrtID;
                        grpClient.Group_Schedule__c = grp.ID;
                        lstGrpClient.add(grpClient);

                    }
                }
            }

            if (!lstGrpClient.isEmpty()) insert lstGrpClient;
        }


    }

    public static void CreateClientByHouse(List < UtlizationReviewOrder__c > aLstUtilizationReview, List < Group_Therapy_Session__c > alstCreateGroupTherapySessions) {

        List < Group_Client__c > lstGrpClient = new List < Group_Client__c > ();
        List < Event > lstEvent = new List < Event > ();
        Map < string, List < string >> mapOfHouseWitClient = new Map < string, List < string >> ();

        for (UtlizationReviewOrder__c utilReviewOrder: aLstUtilizationReview) {

            if (mapOfHouseWitClient.containsKey(utilReviewOrder.Bed__r.Room__r.House__c))
                mapOfHouseWitClient.get(utilReviewOrder.Bed__r.Room__r.House__c).add(utilReviewOrder.Client_Chart__c);
            else
                mapOfHouseWitClient.put(utilReviewOrder.Bed__r.Room__r.House__c, new List < string > {
                    utilReviewOrder.Client_Chart__c
                });

        }

        for (Group_Therapy_Session__c grp: alstCreateGroupTherapySessions) {

            Group_Client__c grpClient;
            Date grpDate;

            if (mapOfHouseWitClient.containsKey(grp.House__c)) {
                for (string iClientChrtID: mapOfHouseWitClient.get(grp.House__c)) {

                    grpClient = new Group_Client__c();
                    grpClient.Client_Chart__c = iClientChrtID;
                    grpClient.Group_Schedule__c = grp.ID;
                    lstGrpClient.add(grpClient);

                }
            }
        }

        if (!lstGrpClient.isEmpty()) insert lstGrpClient;
    }


}