//Test Class : Utilities_Analytics_Batches_Test
global class Utilities_Analytics_BatchSchd implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        Utilities_Analytics_AllClosedCasesBatch b = new Utilities_Analytics_AllClosedCasesBatch();
        database.executebatch(b, 75);
    }
}