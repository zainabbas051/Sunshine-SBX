//test class : SendEmailConfirmation_CtrlTest
trigger closeTask on Payment_Plan_Line_Items__c (before insert,before update,after insert, after update) {
    
    
    if(trigger.isBefore){
        HousingPPLIService.updateKipuChart(trigger.new);
        return;
    }
    
    list<id> ppliIdList = new List<Id>();
    list<task> taskUpdateList = new List<task>();
    
    for(Payment_Plan_Line_Items__c ppli : Trigger.New){
        if(trigger.isInsert){
       
            if(ppli.Status__c == 'Closed'){
                ppliIdList.add(ppli.id);
            }
        }else{
            if(ppli.Status__c == 'Closed' && trigger.oldMap.get(ppli.id).Status__c != ppli.Status__c){
                ppliIdList.add(ppli.id);
            }
        }
    }
    
    if(ppliIdList.size()>0){
        for(Task t : [Select id, Status from Task where Payment_Plan_Line_Items__c IN: ppliIdList]){
            if(t.status != 'Completed'){
                t.Status = 'Completed';
                taskUpdateList.add(t);
            }
        }
    }
    
    if(taskUpdateList.size()>0){
        update taskUpdateList;
    }
}