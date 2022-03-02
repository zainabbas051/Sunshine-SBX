//Test Class : KIPUChartAudit_Test
trigger createFirstWeekLineItem on KIPU_Chart_Audit__c (after insert){
    
    list<KIPU_Audit_Week_Line_Item__c> kwiInsertList = new List<KIPU_Audit_Week_Line_Item__c>();
    
    for(KIPU_Chart_Audit__c audit : Trigger.New){
        KIPU_Audit_Week_Line_Item__c kwi = new KIPU_Audit_Week_Line_Item__c();
        kwi.KIPU_Chart_Audit__c = audit.id;
        if(audit.Admission_Date__c.toStartOfWeek() == audit.Admission_Date__c)
            kwi.Week_Start_Date__c = audit.Admission_Date__c.toStartOfWeek().addDays(-6);// To Start of week Gives Sunday, so we will add one day to start our week from corresponding Monday
        else
            kwi.Week_Start_Date__c = audit.Admission_Date__c.toStartOfWeek().addDays(1);
        kwi.Week_End_Date__c = kwi.Week_Start_Date__c.addDays(6);
        kwi.Number_of_Clinical_Progress_Note__c = 0;
        kwi.Number_of_Medical_Progress_Note__c = 0;
        kwi.Number_of_Outside_Contact__c = 0;
        kwiInsertList.add(kwi);
    }
    
    if(kwiInsertList.size()>0){
        insert kwiInsertList;
    }
    
    KipuChartAuditPPLIService.updateRelatedPPLI(Trigger.New);
}