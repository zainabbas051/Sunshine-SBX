//Test Class : AuditWeeklyLineItemCreateBatch_Test
global class AuditWeeklyLineItemCreateSch implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        AuditWeeklyLineItemCreateBatch b = new AuditWeeklyLineItemCreateBatch();
        database.executebatch(b);
    }
}