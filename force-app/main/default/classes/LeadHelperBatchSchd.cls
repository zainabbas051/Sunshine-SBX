//Test Class : LeadHelperBatchSchdTest
global class LeadHelperBatchSchd implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        LeadHelperBatch  lhb = new LeadHelperBatch();
        database.executebatch(lhb);
        
        MedsUpdateMARsStatusBatch  medsBatch = new MedsUpdateMARsStatusBatch();
        database.executebatch(medsBatch);
    }
}