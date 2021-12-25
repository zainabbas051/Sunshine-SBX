global class MyFutureClass {
  
  @future 
  Public static void leadAssignmentMethod(Map<id,id> leadIdQueueIdMap, Map<Id,String> leadIdOwnerNameMap, Map<id,string> leadIdQueueNameMap) {
      
       Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail = false;
        dlo.EmailHeader.triggerOtherEmail = false;
        dlo.EmailHeader.triggerAutoResponseEmail = false; 
        list<lead> leadUpdate = new list<Lead>();
        list<Lead_Helper__c> leadHelperInsert = new list<Lead_Helper__c>();
        
        for(Lead l : [Select id, OwnerId, Time_Lead_Qualified__c, Closer_Queue_User_Name__c from Lead where id IN: leadIdQueueIdMap.KeySet()]){
            l.OwnerId = leadIdQueueIdMap.get(l.id);
            l.Time_Lead_Qualified__c = dateTime.Now();
            l.Closer_Queue_User_Name__c = leadIdOwnerNameMap.get(l.id);
            leadUpdate.add(l);
            Lead_Helper__c lh = new Lead_Helper__c();
            lh.Time_Lead_Qualified__c = dateTime.now();
            lh.Lead_Id__c = l.id;
            lh.Lead_Owner__c = leadIdQueueNameMap.get(l.id);
            leadHelperInsert.add(lh);
        }
          
      if(leadUpdate.size()>0){
          database.update(leadUpdate,dlo);
          insert leadHelperInsert;
      }  
  }
  
  @future 
  Public static void leadAssignmentMethod(Map<id,id> leadIdQueueIdMap ) {
      
       Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail = false;
        dlo.EmailHeader.triggerOtherEmail = false;
        dlo.EmailHeader.triggerAutoResponseEmail = false; 
        list<lead> leadUpdate = new list<Lead>();
        //list<Lead_Helper__c> leadHelperInsert = new list<Lead_Helper__c>();
        
        for(Lead l : [Select id, OwnerId from Lead where id IN: leadIdQueueIdMap.KeySet()]){
            l.OwnerId = leadIdQueueIdMap.get(l.id);
            leadUpdate.add(l);
        }
          
      if(leadUpdate.size()>0){
          database.update(leadUpdate,dlo);
          
      }  
  }
  
}