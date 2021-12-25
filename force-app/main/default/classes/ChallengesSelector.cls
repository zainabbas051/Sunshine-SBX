public inherited Sharing class ChallengesSelector {
   
    public static List<Alumni_App_Challenges_Configurations__c> getChallengesConfig(integer max,integer page){
        
        Integer offsetVariable = 0;
        if(page!= null && max!=null){
            offsetVariable = page*max;
        }
        
        return [SELECT Name,ID,Challenge_Description__c, Challenge_Landscape_Image__c,
            Challenge_Thumbnail_Image__c, Participant__c, Streak_Duration__c 
            FROM Alumni_App_Challenges_Configurations__c  limit : max offset : offsetVariable];
    }
}