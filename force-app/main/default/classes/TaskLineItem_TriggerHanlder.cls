public with sharing class TaskLineItem_TriggerHanlder {
   
    public static void updateHouseLineItem(List<Task_Line_Items__c> lstTaskLineItem){

        Set<ID> setOfHouseLineitem = new Set<ID>();
        for(Task_Line_Items__c iTask : lstTaskLineItem){
            if(iTask.BHT_Status__c==true || iTask.Supervisor_Status_chkb__c== true){
                setOfHouseLineitem.add(iTask.Related_House_Line_Item__c);
            }
        }

        if(!setOfHouseLineitem.isEmpty()){

            List<House_Line_Items__c> lstUpdatedHouselineitem = new List<House_Line_Items__c>();         
            System.debug('++'+setOfHouseLineitem);   
            for(House_Line_Items__c iHouse : [SELECT ID,Status__c,(SELECT ID,BHT_Status__c,Supervisor_Status_chkb__c FROM Task_Line_Items__r)
                                                FROM House_Line_Items__c WHERE ID IN : setOfHouseLineitem]){
                string Status;
                for(Task_Line_Items__c tli : iHouse.Task_Line_Items__r ){
                
                 if(tli.BHT_Status__c==true && tli.Supervisor_Status_chkb__c==false)
                {
                Status = 'Under Review';
              
                }
                if(tli.BHT_Status__c==true && tli.Supervisor_Status_chkb__c==true)
                Status = 'Completed';
               
                
                }
                
                   system.debug('++'+Status);
                    iHouse.Status__c = Status ;
                    lstUpdatedHouselineitem.add(iHouse);
                
            }
            if(!lstUpdatedHouselineitem.isEmpty()){
              
                update lstUpdatedHouselineitem;
            }

        }
    }
}