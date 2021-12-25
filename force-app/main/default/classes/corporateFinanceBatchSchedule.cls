//Test Class : corporateFinanceBatchScheduleTest
global class corporateFinanceBatchSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      CorporateFinanceDealsSummarizeBatch2 b = new CorporateFinanceDealsSummarizeBatch2();
      database.executebatch(b);
   }
}