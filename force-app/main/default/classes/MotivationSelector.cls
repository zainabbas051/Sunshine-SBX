public inherited sharing class MotivationSelector {
   
    public static List<Alumni_App_Daily_Content__c> getContentMotivation(integer max,integer page){
        
        Integer offsetVariable = 0;
        if(page!= null && max!=null){
            offsetVariable = page*max;
        }
        return [SELECT ID,Author__c, Content_Body__c, Type__c,
                Main_Image_URL__c, Name, Published_Date__c, Thumbnail_Image_URL__c, Resource_URL__c
                FROM Alumni_App_Daily_Content__c WHERE (NOT Type__c LIKE '%Clinical%')
                order by Published_Date__c  limit : max offset : offsetVariable];
    }
    
     public static List<Alumni_App_Daily_Content__c> getContentCoach(integer max,integer page, string tag, string type){
        
        Integer offsetVariable = 0;
        if(page!= null && max!=null){
            offsetVariable = page*max;
        }
        
        String queryStr= 'select ID,Author__c, Content_Body__c, Type__c, Main_Image_URL__c, Name, Published_Date__c, Thumbnail_Image_URL__c, Resource_URL__c FROM Alumni_App_Daily_Content__c where ';
        
        if(type!=''){
            if(type == 'text'){
                queryStr = queryStr+' Type__c = \'Clinical Articles\'';
            }else if(type == 'video'){
                queryStr = queryStr+' Type__c = \'Clinical Video\'';
            }else if(type == 'audio'){
                queryStr = queryStr+' Type__c = \'Clinical Audio\'';
            }
        }else{
            queryStr = queryStr+' Type__c like \'%Clinical%\'';
        }
        
        if(tag != ''){
            if(tag == 'anxious'){
                queryStr = queryStr+' AND Tags__c INCLUDES (\'Anxiety\')';
            }else if(tag == 'depressed'){
                queryStr = queryStr+' AND Tags__c INCLUDES (\'Depression\')';
            }else if(tag == 'craving'){
                queryStr = queryStr+' AND Tags__c INCLUDES (\'Cravings\')';
            }
        }
        
        queryStr = queryStr+' order by Published_Date__c  LIMIT : max OFFSET : offsetVariable';
                            
        //system.debug('queryStr :::::'+queryStr);
            
        List<sObject> dailyContentList = Database.query(queryStr);
        
        List<Alumni_App_Daily_Content__c> coachContentList = new List<Alumni_App_Daily_Content__c>();
        for(SObject record : Database.query(queryStr)) {
           coachContentList.add((Alumni_App_Daily_Content__c) record);
        }
        return coachContentList;
        
        /*return [SELECT ID,Author__c, Content_Body__c, Type__c,
                Main_Image_URL__c, Name, Published_Date__c, Thumbnail_Image_URL__c, Resource_URL__c
                FROM Alumni_App_Daily_Content__c 
                WHERE Type__c like '%Clinical%' 
                order by Published_Date__c  limit : max offset : offsetVariable];
        */
        
    }
}