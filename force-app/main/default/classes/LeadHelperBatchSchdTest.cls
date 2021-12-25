@isTest()
private class LeadHelperBatchSchdTest{
    
    public Static testmethod void LeadHelperBatchSchdTest(){
        test.startTest();
           
           LeadHelperBatchSchd m = new LeadHelperBatchSchd();
           String sch = '20 30 8 10 2 ?';
           String jobID = system.schedule('Lead Helper Plan', sch, m);
           
        test.StopTest();
             
    }

}