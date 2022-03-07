@isTest(seeAllData=true)
public class CGDashboardUpdatedBatchSchd_Test {

     static testMethod void unitTest(){
     
         String sch = '0 0 2 * * ?'; 
         CGDashboardUpdatedBatch_Schd sh1 = new CGDashboardUpdatedBatch_Schd ();
         CGDashboardUpdatedBatch_2_Schd sh2 = new CGDashboardUpdatedBatch_2_Schd ();
         
         system.schedule('Test Territory Check', sch, sh1); 
          system.schedule('Test Territory Check 2', sch, sh2); 
         
         
         
        String sch4 = '0 0 2 * * ?'; 
        PaymentLineItemCreation_Schd sh5 = new PaymentLineItemCreation_Schd();
        system.schedule('PaymentLineItemCreation_Schd', sch, sh2); 
         
         
        CGDashboardUpdatedBatch shn = new CGDashboardUpdatedBatch(System.Label.CGDashboard_ID_2);
        shn.execute(null,null); 
        database.executeBatch(shn );

     
     }

}