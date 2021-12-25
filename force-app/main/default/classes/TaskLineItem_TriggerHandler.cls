public with sharing class TaskLineItem_TriggerHandler {
    
    public static void updateHouseLineItem(List<Task_Line_Items__c> lstTaskLineItem){

        Set<ID> setOfHouseLineitem = new Set<ID>();
        for(Task_Line_Items__c iTask : lstTaskLineItem){
            if(iTask.BHT_Status__c || iTask.Supervisor_Status_chkb__c){
                setOfHouseLineitem.add(iTask.Related_House_Line_Item__c);
            }
        }

        if(!setOfHouseLineitem.isEmpty()){

            User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
            if(u.Acess_Type__c.contains('Staff')){
                List<House_Line_Items__c> lstUpdatedHouselineitem = new List<House_Line_Items__c>();            
                for(House_Line_Items__c iHouse : [SELECT ID,Status__c,Staff_Completed_Date__c,Staff_Completed_By__c,
                                                    (SELECT ID FROM Task_Line_Items__r WHERE
                                                    BHT_Status__c = false)
                                                    FROM House_Line_Items__c WHERE ID IN : setOfHouseLineitem]){
    
                    if(iHouse.Task_Line_Items__r.size() == 0){
                        iHouse.Status__c = 'Under Review';
                        iHouse.Staff_Completed_Date__c = DateTime.Now();
                        iHouse.Staff_Completed_By__c = UserInfo.getName();
                        lstUpdatedHouselineitem.add(iHouse);
                    }
                }
                if(!lstUpdatedHouselineitem.isEmpty()){
                    update lstUpdatedHouselineitem;
                }
                return;
            }
            List<House_Line_Items__c> lstUpdatedHouselineitem = new List<House_Line_Items__c>();            
            for(House_Line_Items__c iHouse : [SELECT ID,Status__c,Supervisor_Completed_Date__c,Supervisor_Reviewed_By__c,
                                                (SELECT ID FROM Task_Line_Items__r WHERE
                                                Supervisor_Status_chkb__c = false)
                                                FROM House_Line_Items__c WHERE ID IN : setOfHouseLineitem]){

                if(iHouse.Task_Line_Items__r.size() == 0){
                    iHouse.Status__c = 'Completed';
                    iHouse.Supervisor_Completed_Date__c = DateTime.Now();
                    iHouse.Supervisor_Reviewed_By__c = UserInfo.getName();
                    lstUpdatedHouselineitem.add(iHouse);
                }
            }
            if(!lstUpdatedHouselineitem.isEmpty()){
                update lstUpdatedHouselineitem;
            }
        }
    }
}