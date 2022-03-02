//Test Class : paymentPlansDetailExtTest
trigger paymentPlanLineItemClose on Task (after insert, after update){
    
    list<Id> ppliIdList = new list<Id>();
    list<Payment_Plan_Line_Items__c> ppliUpdateList = new List<Payment_Plan_Line_Items__c>();
    for(Task t : Trigger.New){
        if(trigger.isInsert){
            if(t.status == 'Completed' && t.Payment_Plan_Line_Items__c != null){
                ppliIdList.add(t.Payment_Plan_Line_Items__c);
            }
        }else{
            if(t.status == 'Completed' && t.Payment_Plan_Line_Items__c != null && trigger.oldmap.get(t.id).status != t.status){
                ppliIdList.add(t.Payment_Plan_Line_Items__c);
            }
        }
    }
    
    if(ppliIdList.size()>0){
        for(Payment_Plan_Line_Items__c ppli : [Select id, Status__c, Closed_Date__c from Payment_Plan_Line_Items__c where id IN: ppliIdList]){
            if(ppli.Status__c != 'Closed'){
                ppli.Status__c = 'Closed';
                ppli.Closed_Date__c = date.Today();
                ppliUpdateList.add(ppli);
            }
        }
    }
    
    if(ppliUpdateList.size()>0){
        update ppliUpdateList;
    }
}