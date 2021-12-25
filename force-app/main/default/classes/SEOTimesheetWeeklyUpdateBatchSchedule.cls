//Test Class : SEOTimesheetUpdateBatchScheduleTest
global class SEOTimesheetWeeklyUpdateBatchSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      SEOTimesheetWeeklyUpdateBatch b = new SEOTimesheetWeeklyUpdateBatch();
      database.executebatch(b);
   }
}