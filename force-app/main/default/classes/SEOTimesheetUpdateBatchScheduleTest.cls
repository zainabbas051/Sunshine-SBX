@isTest()
private class SEOTimesheetUpdateBatchScheduleTest{
    
    public Static testmethod void test_SEOTimesheet(){
        test.startTest();
           
           SEOTimesheetWeeklyUpdateBatchSchedule m = new SEOTimesheetWeeklyUpdateBatchSchedule();
           String sch = '20 30 8 10 2 ?';
           String jobID = system.schedule('SEOTimeSheetUpdateJob', sch, m);
           
        test.StopTest();
             
    }

}