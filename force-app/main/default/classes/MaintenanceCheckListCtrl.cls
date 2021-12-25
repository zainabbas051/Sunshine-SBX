global with sharing class MaintenanceCheckListCtrl {

    @testVisible
    private static string accessType;
   // private static List<String> splittedFacility;
    @auraEnabled public List<Task_Line_Items__c> lstOfTaskLineItem {get;set;}
   
    public MaintenanceCheckListCtrl() {

        
    }

    @AuraEnabled
    global static List<Maintenance_Tasks_LineItem__c> getMaintenanceTaskByHouseId(string houseId,string taskType,string dateFilter,string yearFilter){
        
        string queryFilter = '';
        switch on taskType{
            when 'Monthly'{
                queryFilter = ' AND CALENDAR_MONTH(Due_Date__c) = ' + dateFilter +' AND CALENDAR_YEAR(Due_Date__c) = ' + yearFilter;
            }
            when 'Quarterly'{
                queryFilter = ' AND CALENDAR_QUARTER(Due_Date__c) = ' + dateFilter +' AND CALENDAR_YEAR(Due_Date__c) = ' + yearFilter;
            }
            when 'Yearly'{
                queryFilter = ' AND CALENDAR_YEAR(Due_Date__c) = ' + yearFilter;
            }
        }
        string query = 'SELECT Id,BHT_Status__c, Due_Date__c, Task_Name__c,Status__c,';
               query += ' Related_House__c, Staff_Completed_By__c, Staff_Completed_Date__c, ';
               query += 'Staff_Notes__c, Supervisor_Completed_Date__c, Suprevisor_Notes__c,';
               query += 'Supervisor_Reviewed_By__c, Supervisor_Status__c,Enabled_Task__c from Maintenance_Tasks_LineItem__c ';
               query += 'WHERE Related_House__c =: houseId AND Task_Type__c =: taskType' + queryFilter;
             

        return Database.query(query);
    }
    
    @AuraEnabled
    public static List<House__c> getHouseList(){
        
     System.debug('Current Week #** in **Current Year** '+system.now().format('w'));
       User u = [Select ID, UserName,Facility__c FROM User where ID =: UserInfo.getUserId()];
        List<String> splittedFacility = u.Facility__c.split(';');
        return [Select Id,Name,Sunshine_Center__r.Name from House__c where Sunshine_Center__r.Name IN:splittedFacility  order by Name];
    }
    
    

     @AuraEnabled
    public static string completeHouselineItem(string activityList,string completedBy, string reviewedBy , string AccessType){
        
       List<Maintenance_Tasks_LineItem__c> lstUpdatedTask = 
                            (List<Maintenance_Tasks_LineItem__c>)System.JSON.deserialize(activityList, List<Maintenance_Tasks_LineItem__c>.class);
                            
        
        for(Maintenance_Tasks_LineItem__c iTaskLineItem : lstUpdatedTask){
            switch on AccessType{
                when 'BHT'{
                if(iTaskLineItem.BHT_Status__c == true && iTaskLineItem.Staff_Completed_Date__c == null)
                {
                    iTaskLineItem.Status__c='Under Review';
                    iTaskLineItem.Staff_Completed_By__c = completedBy;
                    iTaskLineItem.Staff_Completed_Date__c =datetime.now();
                    iTaskLineItem.Staff_Notes__c = reviewedBy;
                    }
                }
                when 'Supervisor'{
                    if(iTaskLineItem.Supervisor_Status__c == true && iTaskLineItem.Supervisor_Completed_Date__c== null)
                {
                     
                    iTaskLineItem.Supervisor_Reviewed_By__c = completedBy;
                    iTaskLineItem.Supervisor_Completed_Date__c =datetime.now();
                    iTaskLineItem.Suprevisor_Notes__c = reviewedBy;               
                    iTaskLineItem.Status__c='Completed';
                    }
                }
            }
        }  
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
    public static List<string> getPasswordFromCustomSetting(string AccessType){
        
        User u = [Select ID, UserName,Facility__c FROM User where ID =: UserInfo.getUserId()];
        List< Application_Password__c >lstApplicationPassword = Application_Password__c.getall().values();
        List<string> lstPassword = new List<string>();
        if(AccessType=='Supervisor')
        for(Application_Password__c appPwd : lstApplicationPassword) {
        
                        
            if(appPwd.Sunshine_Center__c != null && u.Facility__c.indexOf(appPwd.Sunshine_Center__c) != -1 && 
                appPwd.Application_Name__c.equals('Maintenance Checklist')){
                lstPassword.add(appPwd.Password__c) ;   
            }
           
        }
        return lstPassword;
    }
    
}