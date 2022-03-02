public with sharing class SobrietyChallengeTriggerHandler {
    public SobrietyChallengeTriggerHandler() {

    }

    public static void createAlumniChalleng(list<Alumni_App_Sobriety_Checkin__c> listTriggerNew){
        
        set<string> setOfAppDetIds = new Set<String>();
        map<string, Alumni_App_Challenges_Configurations__c> mapOfChallenges =  new map<string, Alumni_App_Challenges_Configurations__c>();
        map<string, Alumni_App_Detail__c> MapOfAppDetails = new map<string, Alumni_App_Detail__c>();
        list<Alumni_App_Challenges_Line_Items__c> listChallengesLines = new list<Alumni_App_Challenges_Line_Items__c>();
        list<Alumni_App_Detail__c> listAppDetail = new list<Alumni_App_Detail__c>();
        list<Alumni_App_Detail__c> listAppDetailUnique = new list<Alumni_App_Detail__c>();
        
        for(Alumni_App_Sobriety_Checkin__c sobCh : listTriggerNew){
            if(sobCh.Alumni_App_Detail__c != null)
                setOfAppDetIds.add(sobCh.Alumni_App_Detail__c);
        }
        if(setOfAppDetIds.size() > 0){
            MapOfAppDetails = getMapOfAppDetails(setOfAppDetIds);
            mapOfChallenges =  getMapOfChallenges();
        }

        for(Alumni_App_Sobriety_Checkin__c sobChc : listTriggerNew)
        {
            boolean NextEligibleTotal = false;
            boolean NextEligibleDaily = false;
            if(MapOfAppDetails.containsKey(sobChc.Alumni_App_Detail__c))
            {
                Alumni_App_Detail__c apDet = MapOfAppDetails.get(sobChc.Alumni_App_Detail__c);
                
                system.debug('#Current_Checkin_Streak__c=='+apDet.Current_Checkin_Streak__c);
                system.debug('#Next_Eligible_Checkin_Streak__c=='+apDet.Next_Eligible_Checkin_Streak__c);
                system.debug('#Total_Number_of_Sobreity_Checkins__c=='+apDet.Total_Number_of_Sobreity_Checkins__c);
                system.debug('#Next_Eligible_Total_Checkins__c=='+apDet.Next_Eligible_Total_Checkins__c);
                if(apDet.Current_Checkin_Streak__c != null && apDet.Next_Eligible_Checkin_Streak__c != null
                    && apDet.Current_Checkin_Streak__c +1 == apDet.Next_Eligible_Checkin_Streak__c 
                    && mapOfChallenges.containsKey('Daily Checkin'+'|'+Integer.valueOf(apDet.Next_Eligible_Checkin_Streak__c)))
                {
                    Alumni_App_Challenges_Line_Items__c chalLine = new Alumni_App_Challenges_Line_Items__c();
                    chalLine.Alumni_App_Detail__c = apDet.id;
                    chalLine.Alumni_App_Challenges_Configuration__c = mapOfChallenges.get('Daily Checkin'+'|'+Integer.valueOf(apDet.Next_Eligible_Checkin_Streak__c)).id;
                    listChallengesLines.add(chalLine);
                    system.debug('#in daily checkin 1=='+chalLine);
                    system.debug('#in daily checkin=='+listChallengesLines);
                    
                    for(Alumni_App_Challenges_Configurations__c ch : mapOfChallenges.values()){
                        if(!NextEligibleDaily && apDet.Next_Eligible_Checkin_Streak__c != null
                            && ch.Streak_Duration__c > apDet.Next_Eligible_Checkin_Streak__c
                            && ch.Type__c == 'Daily Checkin')
                        {
                            apDet.Next_Eligible_Checkin_Streak__c = ch.Streak_Duration__c;
                            NextEligibleDaily = true;
                        }
                    }
                }

                if(apDet.Total_Number_of_Sobreity_Checkins__c != null && apDet.Next_Eligible_Total_Checkins__c != null
                    && apDet.Total_Number_of_Sobreity_Checkins__c +1 == apDet.Next_Eligible_Total_Checkins__c 
                    && mapOfChallenges.containsKey('Total Checkin'+'|'+Integer.valueOf(apDet.Next_Eligible_Total_Checkins__c)))
                {
                    Alumni_App_Challenges_Line_Items__c chalLine2 = new Alumni_App_Challenges_Line_Items__c();
                    chalLine2.Alumni_App_Detail__c = apDet.id;
                    chalLine2.Alumni_App_Challenges_Configuration__c = mapOfChallenges.get('Total Checkin'+'|'+Integer.valueOf(apDet.Next_Eligible_Total_Checkins__c)).id;
                    listChallengesLines.add(chalLine2);
                    system.debug('#in total checkin 1=='+chalLine2);
                    system.debug('#in total checkin=='+listChallengesLines);

                    for(Alumni_App_Challenges_Configurations__c ch : mapOfChallenges.values()){
                        if(!NextEligibleTotal && apDet.Next_Eligible_Total_Checkins__c != null
                            && ch.Streak_Duration__c > apDet.Next_Eligible_Total_Checkins__c
                            && ch.Type__c == 'Total Checkin')
                        {
                            apDet.Next_Eligible_Total_Checkins__c = ch.Streak_Duration__c;
                            NextEligibleTotal = true;
                        }

                    }
                }

                if(apDet.Current_Checkin_Streak__c != null){
                    apDet.Current_Checkin_Streak__c = apDet.Current_Checkin_Streak__c + 1;
                }
                else {
                    apDet.Current_Checkin_Streak__c = 1;
                }

                if(apDet.Longest_Checkin__c != null && apDet.Longest_Checkin__c < apDet.Current_Checkin_Streak__c){
                    apDet.Longest_Checkin__c = apDet.Current_Checkin_Streak__c;
                }

                listAppDetail.add(apDet);

            }
             
        }

        try
        {
            if(listChallengesLines.size() > 0)
            {
                insert listChallengesLines;
            }

            if(listAppDetail.size() > 0){
                set<Alumni_App_Detail__c> uniqueAppDets = new set<Alumni_App_Detail__c>();
                uniqueAppDets.addAll(listAppDetail);
                listAppDetailUnique.addAll(uniqueAppDets);

                update listAppDetail;
            }
        }
        catch(exception e)
        {
            system.debug('#Exception= '+e.getMessage());
        }
        

    }

    public static map<string, Alumni_App_Detail__c> getMapOfAppDetails(set<string> setOfIds){
        map<string, Alumni_App_Detail__c> MapOfAppDetails = new map<string, Alumni_App_Detail__c>();
        for(Alumni_App_Detail__c apD: [select id, Current_Checkin_Streak__c, Total_Number_of_Sobreity_Checkins__c, Next_Eligible_Checkin_Streak__c,
                                            Next_Eligible_Total_Checkins__c, Longest_Checkin__c from Alumni_App_Detail__c where id IN: setOfIds])
        {
            MapOfAppDetails.put(apD.id, apD);
        }

        return MapOfAppDetails;
    }

    public static list<Alumni_App_Challenges_Configurations__c> getListOfChallenges(){
        list<Alumni_App_Challenges_Configurations__c> listChallenges = new list<Alumni_App_Challenges_Configurations__c>();
        listChallenges = [select id, name, Streak_Duration__c, Type__c from Alumni_App_Challenges_Configurations__c];

        return listChallenges;
    }

    public static map<string, Alumni_App_Challenges_Configurations__c> getMapOfChallenges(){
        map<string, Alumni_App_Challenges_Configurations__c> mapOfCh = new map<string, Alumni_App_Challenges_Configurations__c>();
        for(Alumni_App_Challenges_Configurations__c chal : [select id, Streak_Duration__c, Success_Message__c, Type__c from Alumni_App_Challenges_Configurations__c order by Type__c , Streak_Duration__c ])
        {
            mapOfCh.put(chal.Type__c+'|'+Integer.valueOf(chal.Streak_Duration__c),chal);
        }

        return mapOfCh;
    }


    public static map<string, list<Alumni_App_Challenges_Line_Items__c>> getmapOfAlumniChallenges(set<string> setAppDetIds){
        map<string, list<Alumni_App_Challenges_Line_Items__c>> mapToReturn = new map<string, list<Alumni_App_Challenges_Line_Items__c>>();
        for(Alumni_App_Challenges_Line_Items__c ch: [select id, Alumni_App_Detail__c, 
                                                            Alumni_App_Challenges_Configuration__c 
                                                            from Alumni_App_Challenges_Line_Items__c 
                                                            where Alumni_App_Detail__c IN: setAppDetIds])
        {
            list<Alumni_App_Challenges_Line_Items__c> listChallenges = new list<Alumni_App_Challenges_Line_Items__c>();
            if(mapToReturn.containsKey(ch.Alumni_App_Detail__c))
            {
                listChallenges = mapToReturn.get(ch.Alumni_App_Detail__c);
            }
            listChallenges.add(ch);
            mapToReturn.put(ch.Alumni_App_Detail__c,listChallenges);
        }

        return mapToReturn;
    }
}