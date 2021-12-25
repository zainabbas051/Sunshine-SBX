@isTest(seeAllData=true)
public class sendCGdashboardEmailBatch_Schd_Test {

     static testMethod void unitTest(){
     
         String sch = '0 0 2 * * ?'; 
         sendCGdashboardEmailBatch_Schd sh1 = new sendCGdashboardEmailBatch_Schd ();
        
         
         system.schedule('Test Territory Check', sch, sh1); 
          
         
         
         
        sendCGdashboardEmailBatch shn = new sendCGdashboardEmailBatch();
        database.executeBatch(shn );

     
     }

}