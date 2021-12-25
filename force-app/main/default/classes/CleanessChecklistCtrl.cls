public with sharing class CleanessChecklistCtrl {

    @testVisible
    private static string accessType;
    @auraEnabled public List<Task_Line_Items__c> lstOfTaskLineItem {get;set;}
   
    public CleanessChecklistCtrl() {

        
    }
    
    @AuraEnabled
    public static List<House__c> getHouseList(){
        
     System.debug('Current Week #** in **Current Year** '+system.now().format('w'));
       User u = [Select ID, UserName,Facility__c FROM User where ID =: UserInfo.getUserId()];
         List<String> splittedFacility = u.Facility__c.split(';');
        return [Select Id,Name,Sunshine_Center__r.Name from House__c where Sunshine_Center__r.Name IN:splittedFacility and 
                Cleanliness_Checklist_Rolled_Out__c =true order by Name ];
    }
    
    @AuraEnabled
    public static List<House_Line_Items__c> getHouseLineItemsList(string houseId, string lineItemType, string recordType){
        
        return [Select Id,Name,Bedroom_Number__c,Bathroom_Number__c,Status__c FROM
                 House_Line_Items__c WHERE Line_Item_Type__c=:lineItemType AND
                  Related_House__c=:houseId  AND RecordType.DeveloperName =: recordType and 
                  Status__c NOT IN('Missed', 'Missed Review')
                  and Due_Date__c>=Today];
    }

    @AuraEnabled
    public static List<Task_Line_Items__c> getTasksByHouseLineItem(string hliId){
        
       return [Select Task_Name__c,Task_Type__c,Task_Completed__c,BHT_Status__c,Supervisor_Status_chkb__c,Director_Status__c,Related_House_Line_Item__r.Status__c,
                Related_House_Line_Item__r.Staff_Completed_Date__c,
                Related_House_Line_Item__r.Staff_Completed_By__c,
                Related_House_Line_Item__r.Staff_Notes__c,
                Related_House_Line_Item__r.Supervisor_Completed_Date__c,
                Related_House_Line_Item__r.Supervisor_Reviewed_By__c,
                Related_House_Line_Item__r.Suprevisor_Notes__c,
                Related_House_Line_Item__r.Director_Completed_Date__c,
                Related_House_Line_Item__r.Director_Name__c,
                Related_House_Line_Item__r.Director_Notes__c
                FROM 
                Task_Line_Items__c where
                Related_House_Line_Item__c =:hliId];     
    }
    @AuraEnabled
    public static List<Task_Line_Items__c> getTasksByHouse(string hliId , string HouseLineItemType,
                                                            string viewType){
        
        House_Line_Items__c latestHouseLineItem=[Select ID FROM 
                House_Line_Items__c WHERE Related_House__c =:hliId
                AND Line_Item_Type__c =: HouseLineItemType and Status__c NOT IN('Missed', 'Missed Review')
                  and Due_Date__c>=Today AND RecordType.DeveloperName =: viewType order by CreatedDate desc limit 1];
                
        return [Select Task_Name__c,Task_Type__c,Task_Completed__c,BHT_Status__c,Supervisor_Status_chkb__c,Director_Status__c,Related_House_Line_Item__r.Status__c,
                Related_House_Line_Item__r.Staff_Completed_Date__c,
                Related_House_Line_Item__r.Staff_Completed_By__c,
                Related_House_Line_Item__r.Staff_Notes__c,
                Related_House_Line_Item__r.Supervisor_Completed_Date__c,
                Related_House_Line_Item__r.Supervisor_Reviewed_By__c,
                Related_House_Line_Item__r.Suprevisor_Notes__c,
                Related_House_Line_Item__r.Director_Completed_Date__c,
                Related_House_Line_Item__r.Director_Name__c,
                Related_House_Line_Item__r.Director_Notes__c
                FROM 
                Task_Line_Items__c where Related_House_Line_Item__c =: latestHouseLineItem.ID];
    }

    @AuraEnabled
    public static string saveActivityListRecord(string activityList){
        
       
       List<Task_Line_Items__c> lstUpdatedTask = 
                            (List<Task_Line_Items__c>)System.JSON.deserialize(activityList, List<Task_Line_Items__c>.class);
       
        try{
            update lstUpdatedTask;
            return 'Success';
        }
        catch(Exception ex){
            return 'Error ' + ex.getMessage();
        }
        //return 'true';
       
    }
     @AuraEnabled
    public static string completeHouselineItem(string hli,string activityList,string completedBy, string reviewedBy , string AccessType){
        
       List<Task_Line_Items__c> lstUpdatedTask = 
                            (List<Task_Line_Items__c>)System.JSON.deserialize(activityList, List<Task_Line_Items__c>.class);
                            
       // House_Line_Items__c selectedHouseLineItem=new House_Line_Items__c(id=hli);
       House_Line_Items__c selectedHouseLineItem=[Select id,Staff_Completed_Date__c FROM House_Line_Items__c WHERE id=:hli];

       switch on AccessType{
           when 'BHT'{
            selectedHouseLineItem.Status__c='Under Review';
            selectedHouseLineItem.Staff_Completed_By__c = completedBy;
            selectedHouseLineItem.Staff_Completed_Date__c =datetime.now();
            selectedHouseLineItem.Staff_Notes__c = reviewedBy;
           }
           when 'Supervisor'{
            if(selectedHouseLineItem.Staff_Completed_Date__c==null){
                selectedHouseLineItem.Staff_Completed_By__c = completedBy;
                selectedHouseLineItem.Staff_Completed_Date__c =datetime.now();
                selectedHouseLineItem.Staff_Notes__c = reviewedBy;
            }
            
            selectedHouseLineItem.Supervisor_Reviewed_By__c = completedBy;
            selectedHouseLineItem.Supervisor_Completed_Date__c =datetime.now();
            selectedHouseLineItem.Suprevisor_Notes__c = reviewedBy;
             
            selectedHouseLineItem.Status__c='Completed';
           }
           when 'Director'{
            selectedHouseLineItem.Director_Name__c = completedBy;
            selectedHouseLineItem.Director_Completed_Date__c =datetime.now();
            selectedHouseLineItem.Director_Notes__c = reviewedBy;
            selectedHouseLineItem.Status__c='Completed';
           }
       }
      
         
        try{
             update lstUpdatedTask;
            update selectedHouseLineItem;
            return 'Success';
        }
        catch(Exception ex){
            return 'Error ' + ex.getMessage();
        }
        //return 'true';
       
    }

    @AuraEnabled
    public static LIST<AggregateResult> getLineItemsAgainstHouse(string houseId,string viewType, string accessType){

        Set<string> setOfStatus = new Set<string>();
        setOfStatus.add('Incomplete');
        if(accessType.equals('Supervisor')){
            setOfStatus.add('Under Review');
        }

        return [SELECT  COUNT(ID)  TOTALCOUNT , Status__c,
                Line_Item_Type__c FROM House_Line_Items__c
                WHERE RecordType.DeveloperName =: viewType
                AND Related_House__c = :houseId
                AND Status__c IN : setOfStatus
                GROUP BY Status__c,Line_Item_Type__c ORDER BY Status__c desc];
    }  

   /* @AuraEnabled
    public static string getAccessType(){
        
        accessType = 'Supervisor';
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(u.Acess_Type__c.contains('Staff')){
            accessType = 'BHT';
        }          
        return accessType;
    }*/
    
     @AuraEnabled
    public static List<string> getPasswordFromCustomSetting(string AccessType){
        
         System.debug('Current Week #** in **Current Year** '+system.now().format('w'));
        User u = [Select ID, UserName,Facility__c FROM User where ID =: UserInfo.getUserId()];
        List< Application_Password__c >lstApplicationPassword = Application_Password__c.getall().values();
        List<string> lstPassword = new List<string>();
        if(AccessType=='Supervisor')
        for(Application_Password__c appPwd : lstApplicationPassword) {
        
                        
            if(appPwd.Sunshine_Center__c != null && u.Facility__c.indexOf(appPwd.Sunshine_Center__c) != -1 && appPwd.Is_Director__c==false &&  appPwd.Application_Name__c.equals('Cleanliness Checklist') ){
                lstPassword.add(appPwd.Password__c) ;   
            }
           
        }
        else if(AccessType=='Director') {
        for(Application_Password__c appPwd : lstApplicationPassword) {
        
                        
            if(appPwd.Sunshine_Center__c != null && u.Facility__c.indexOf(appPwd.Sunshine_Center__c) != -1 && appPwd.Is_Director__c==true && appPwd.Application_Name__c.equals('Cleanliness Checklist') ){
                lstPassword.add(appPwd.Password__c) ;   
            }
           
        }
        }
       
        return lstPassword;
    }
    
}