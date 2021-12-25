//Test Class : VOBOpportunityUpdateBatchScheduleTest
global class VOBOpportunityUpdateBatchSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      VOBOpportunityUpdateBatch b = new VOBOpportunityUpdateBatch();
      database.executebatch(b,100);
   }
}