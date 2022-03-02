trigger AlumniAppDetailTrg on Alumni_App_Detail__c (before insert) {

    if(trigger.isInsert && trigger.isBefore){
        map<string, Alumni_App_Challenges_Configurations__c> mapOfDailyChallenges = new map<string, Alumni_App_Challenges_Configurations__c>();
        map<string, Alumni_App_Challenges_Configurations__c> mapOfTotalChallenges = new map<string, Alumni_App_Challenges_Configurations__c>();
        
        //getting all challenges and fill map of daily and total challenges with the least streak duration
        for(Alumni_App_Challenges_Configurations__c ch: [select id, Streak_Duration__c, Type__c	from Alumni_App_Challenges_Configurations__c])
        {
            if(ch.Type__c.contains('Daily')){
                if(mapOfDailyChallenges.containskey('Daily')){
                    Alumni_App_Challenges_Configurations__c dailych = mapOfDailyChallenges.get('Daily');
                    if(dailych.Streak_Duration__c != null && dailych.Streak_Duration__c > ch.Streak_Duration__c)
                    {
                        mapOfDailyChallenges.put('Daily', ch);
                    }
                }
                else{
                    mapOfDailyChallenges.put('Daily', ch);
                }
            }
            if(ch.Type__c.contains('Total')){
                if(mapOfTotalChallenges.containskey('Total')){
                    Alumni_App_Challenges_Configurations__c dailych = mapOfTotalChallenges.get('Total');
                    if(dailych.Streak_Duration__c != null && dailych.Streak_Duration__c > ch.Streak_Duration__c)
                    {
                        mapOfTotalChallenges.put('Total', ch);
                    }
                }
                else{
                    mapOfTotalChallenges.put('Total', ch);
                }
            }
        }

        //Iteration over list of trigger.new
        for(Alumni_App_Detail__c appDet: trigger.new){
            if(mapOfDailyChallenges.containskey('Daily')){
                Alumni_App_Challenges_Configurations__c dailych = mapOfDailyChallenges.get('Daily');
                decimal streak = dailych.Streak_Duration__c != null ? dailych.Streak_Duration__c : 0;
                appDet.Next_Eligible_Checkin_Streak__c = streak;
            }
            if(mapOfTotalChallenges.containskey('Total')){
                Alumni_App_Challenges_Configurations__c totalch = mapOfTotalChallenges.get('Total');
                decimal streak = totalch.Streak_Duration__c != null ? totalch.Streak_Duration__c : 0;
                appDet.Next_Eligible_Total_Checkins__c = streak;
            }
        }

    }

}