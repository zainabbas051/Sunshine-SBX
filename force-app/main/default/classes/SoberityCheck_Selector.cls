public inherited sharing class SoberityCheck_Selector {

    public static Alumni_App_Detail__c getsOberityDetails(string recordId) {

        Date todayDate = date.Today();
        /*
        return [SELECT ID,Current_Checkin_Streak__c, Longest_Checkin__c,
                (SELECT Anxiety_Score__c, Cravings_Score__c,
                 Depression_Score__c, Feeling_Today__c, Sobriety_Checkin_Date__c 
                FROM Alumni_App_Sobriety_Checkins__r WHERE Sobriety_Checkin_Date__c != null ORDER BY Sobriety_Checkin_Date__c DESC LIMIT 1),
                (SELECT Alumni_App_Challenges_Configuration__r.Id, Alumni_App_Challenges_Configuration__r.Challenge_Medal_Image__c
                FROM Alumni_App_Challenges_Line_Items__r where Challenge_Completed__c =: True) FROM Alumni_App_Detail__c
                WHERE ID =: recordId];
        */
        
        return [SELECT ID,Current_Checkin_Streak__c, Longest_Checkin__c,
                (SELECT Anxiety_Score__c, Cravings_Score__c,
                 Depression_Score__c, Feeling_Today__c, Sobriety_Checkin_Date__c 
                FROM Alumni_App_Sobriety_Checkins__r WHERE Sobriety_Checkin_Date__c =: todayDate),
                (SELECT Alumni_App_Challenges_Configuration__r.Id, Alumni_App_Challenges_Configuration__r.Challenge_Medal_Image__c
                FROM Alumni_App_Challenges_Line_Items__r where Challenge_Completed__c =: True) FROM Alumni_App_Detail__c
                WHERE ID =: recordId];
    }
    
    public static List<Alumni_App_Sobriety_Checkin__c> getSobrietyCheckinHistory(string appDetailId,integer numberOfDays,
                                                                                 date checkinDate){
          
          Date checkinDateEnd = checkinDate.addDays(numberOfDays);
          string sqlQuery = 'SELECT Anxiety_Score__c, Cravings_Score__c, Notes__c,';
                 sqlQuery += 'Depression_Score__c, Feeling_Today__c, Sobriety_Checkin_Date__c';
                 sqlQuery += ' FROM Alumni_App_Sobriety_Checkin__c WHERE Alumni_App_Detail__c =: appDetailId';
                 sqlQuery += ' AND Sobriety_Checkin_Date__c >=: checkinDate';
                 sqlQuery += ' AND Sobriety_Checkin_Date__c < : checkinDateEnd order by Sobriety_Checkin_Date__c';
          
          return Database.query(sqlQuery);
    }
}