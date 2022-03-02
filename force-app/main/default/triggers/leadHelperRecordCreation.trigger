//Test Class : LeadHelperBatchTest
trigger leadHelperRecordCreation on Lead (after insert, after update) {
    List<Lead_Helper__c> leadHelperInsertList = new List<Lead_Helper__c>();
    
    for(Lead l : Trigger.New){
        if(
            (Trigger.isUpdate && (l.ownerId == Label.Unassigned_Queue_ID || l.OwnerId == Label.ERP_Call_Queue_ID) && l.ownerId != trigger.OldMap.get(l.id).OwnerId)
            ||
            (Trigger.isInsert && (l.ownerId == Label.Unassigned_Queue_ID || l.OwnerId == Label.ERP_Call_Queue_ID))
        ){
            Lead_Helper__c lh = new Lead_Helper__c();
            lh.Lead_Id__c = l.id;
            lh.Time_Unassigned_ERP_Queue_Lead_Created__c = dateTime.Now();
            lh.Unassigned_or_ERP_Queue_Lead__c = True;
            leadHelperInsertList.add(lh);
        }
        if(Trigger.isUpdate && l.ownerId == Label.Intake_Queue_ID && l.ownerId != trigger.OldMap.get(l.id).OwnerId || Trigger.isInsert && l.ownerId == Label.Intake_Queue_ID){
            Lead_Helper__c lh = new Lead_Helper__c();
            lh.Lead_Id__c = l.id;
            lh.Intake_Queue_Lead_Flag__c = True;
            lh.Time_Lead_Assigned_To_Intake_Queue__c = DateTime.Now();
            leadHelperInsertList.add(lh);
        }
    }
    
    if(leadHelperInsertList.size()>0){
        insert leadHelperInsertList;
    }
}