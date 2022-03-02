//Test Class : paymentPlansDetailExtTest
trigger approvalTrigger on Payment_Plan__c (after update){
    
    list<id> plIdList = new List<Id>();
    List<Task> taskInsertList = new List<Task>();
    List<Payment_Plan__c> plUpdateList = new List<Payment_Plan__c>();
    List<Payment_Plan_Line_Items__c> ppliUpdateList = new List<Payment_Plan_Line_Items__c>();
    list<Card_Information__c> ciUpdateList = new List<Card_Information__c>();
    
    Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Payment Plans').getRecordTypeId();
    
    for(Payment_Plan__c pl : Trigger.New){
        if(pl.Approval_Status__c == 'Approved' && trigger.oldMap.get(pl.id).Approval_Status__c != pl.Approval_Status__c){
            plIdList.add(pl.id);
        }
    }
    
    if(plIdList.size()>0){
        for(id plid : plIdList){
            Payment_Plan__c pli = new Payment_Plan__c(id = plid, Status__c = 'Active');
            plUpdateList.add(pli);
        }
        
        for(Payment_Plan_Line_Items__c ppli : [Select id, Payment_Plan__c, Payment_Plan__r.Name, Payment_Plan__r.Opportunity__c, Due_Date__c, Assigned_To__c, Line_Item_Approved__c from Payment_Plan_Line_Items__c where Payment_Plan__c IN: plIdList AND Line_Item_Approved__c =: FALSE]){
            Task t = new Task();
            t.OwnerId = label.Nick_User_Id;
            t.ActivityDate = ppli.Due_Date__c;
            t.status = 'Not Started';
            t.whatId = ppli.Payment_Plan__r.Opportunity__c;
            t.Payment_Plan__c = ppli.Payment_Plan__c;
            t.Payment_Plan_Line_Items__c = ppli.id;
            t.subject = 'Cash Collection Task Related to Payment Plan : '+ppli.Payment_Plan__r.Name;
            t.recordTypeId = recTypeId;
            taskInsertList.add(t);
            
            ppli.Assigned_To__c = label.Nick_User_Id;
            ppli.Line_Item_Approved__c = True;
            ppliUpdateList.add(ppli);
            
        }
      
        for(Card_Information__c ci : [Select id, Card_Approved__c from Card_Information__c where Payment_Plan__c IN: plIdList AND Card_Approved__c =: FALSE]){
            ci.Card_Approved__c = TRUE; 
            ciUpdateList.add(ci);
    }
    
  
  }      
    
    if(taskInsertList.size()>0){
        insert taskInsertList;
    }
    
    if(plUpdateList.size()>0){
        update plUpdateList;
    }
    
    if(ppliUpdateList.size()>0){
        update ppliUpdateList;
    }
    
       if(ciUpdateList.size()>0){
        update ciUpdateList;
    }
}