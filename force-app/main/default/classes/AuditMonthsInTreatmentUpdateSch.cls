//Test Class : AuditMonthsInTreatmentUpdateBatch_Test
global class AuditMonthsInTreatmentUpdateSch implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        AuditMonthsInTreatmentUpdateBatch b = new AuditMonthsInTreatmentUpdateBatch();
        database.executebatch(b);
    }
}