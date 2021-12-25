@isTest(seeAllData=true)
public class MarketingDashboardSchd_Test {

     static testMethod void unitTest(){
     
         MarketingDashboard_Schd sh1 = new MarketingDashboard_Schd ();
         String sch = '0 0 2 * * ?'; 
         system.schedule('Test Territory Check', sch, sh1); 
         Database.executeBatch(new ScheduleMarketingDashboardRefreshBatch());
     
     }

}