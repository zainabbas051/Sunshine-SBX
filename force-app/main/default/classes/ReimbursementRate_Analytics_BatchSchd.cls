//Test Class : ReimbursementRate_Batches_Test
global class ReimbursementRate_Analytics_BatchSchd implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        ReimbursementRate_Analytics_Batch b = new ReimbursementRate_Analytics_Batch();
        database.executebatch(b, 5);
    }
}