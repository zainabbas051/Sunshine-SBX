//Test Class : ReimbursementRate_Batches_Test
global class ReimbursementRate_Analytics_BatchOldSchd implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        ReimbursementRate_Analytics_Batch_Old b = new ReimbursementRate_Analytics_Batch_Old();
        database.executebatch(b, 75);
    }
}