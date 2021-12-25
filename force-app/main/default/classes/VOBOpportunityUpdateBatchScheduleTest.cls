@isTest()
private class VOBOpportunityUpdateBatchScheduleTest{
    
    public Static testmethod void test_ClaimToVOB_Class(){
        test.startTest();
           
           VOBOpportunityUpdateBatchSchedule m = new VOBOpportunityUpdateBatchSchedule();
           String sch = '20 30 8 10 2 ?';
           String jobID = system.schedule('VOBOpportunityUpdateJOb', sch, m);
           
        test.StopTest();
             
    }

}