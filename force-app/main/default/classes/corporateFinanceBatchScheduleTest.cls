@isTest()
private class corporateFinanceBatchScheduleTest{
    
    public Static testmethod void test_ClaimToVOB_Class(){
        test.startTest();
           
           corporateFinanceBatchSchedule m = new corporateFinanceBatchSchedule();
           String sch = '20 30 8 10 2 ?';
           String jobID = system.schedule('CorporateFinanceJobs', sch, m);
           
        test.StopTest();
             
    }

}