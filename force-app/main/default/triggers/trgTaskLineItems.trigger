trigger trgTaskLineItems on Task_Line_Items__c (after update) {

    switch on Trigger.operationType{
        when AFTER_UPDATE{
           // TaskLineItem_TriggerHandler.updateHouseLineItem(trigger.NEW);
        }
    }
}