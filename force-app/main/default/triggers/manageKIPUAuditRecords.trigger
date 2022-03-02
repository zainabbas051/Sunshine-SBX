//Test Class : KIPUChartAudit_Test
trigger manageKIPUAuditRecords on Opportunity (after update){
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && 
    Trigger_Custom_Setting__c.getValues('Default').Disable_manageKIPUAuditRecords__c == True)
    return;
    
    list<KIPU_Chart_Audit__c> auditInsertList = new List<KIPU_Chart_Audit__c>();
    list<KIPU_Audit_Week_Line_Item__c> wliDeleteList = new List<KIPU_Audit_Week_Line_Item__c>();
    list<Id> oppIdList = new List<Id>();
    list<Opportunity> oppUpdateList = new List<Opportunity>();
    for(Opportunity opp : Trigger.new){
        if(opp.StageName == 'Admitted' && Trigger.oldMap.get(opp.id).StageName != opp.StageName && opp.KIPU_Chart_Audit_Created__c == False){
            KIPU_Chart_Audit__c audit = new KIPU_Chart_Audit__c();
            audit.Opportunity__c = opp.id;
            auditInsertList.add(audit);
            
            opportunity o = new Opportunity(id=opp.id);
            o.KIPU_Chart_Audit_Created__c = True;
            oppUpdateList.add(o);
        }
        if(opp.StageName == 'Discharged' && Trigger.oldMap.get(opp.id).StageName != opp.StageName){
            oppIdList.add(opp.id);//We need to check if any Week Line Item has been added for any of the Audit Records Post the Discharge Date
        }
    }
    
    if(oppIdList.size()>0){
        for(KIPU_Audit_Week_Line_Item__c wli : [Select id, week_start_date__c, week_End_Date__c, KIPU_Chart_Audit__c, KIPU_Chart_Audit__r.Discharge_Date__c from KIPU_Audit_Week_Line_Item__c where KIPU_Chart_Audit__r.Opportunity__c IN: oppIdList]){
            if(wli.Week_Start_Date__c > wli.KIPU_Chart_Audit__r.Discharge_Date__c){//Checking to see if a Week Line Item has been added for any Audit Records Beyond the Current Week of the Discharge Date
                wliDeleteList.add(wli);
            }
        }
    }
    
    if(auditInsertList.size()>0){
        insert auditInsertList;
    }
    
    if(wliDeleteList.size()>0){
        delete wliDeleteList;
    }
    
    if(oppUpdateList.size()>0){
        update oppUpdateList;
    }
}