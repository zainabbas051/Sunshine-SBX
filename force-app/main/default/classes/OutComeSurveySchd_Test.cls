@isTest(seeAllData=true)
public class OutComeSurveySchd_Test {

     static testMethod void unitTest(){
      
        Contact con = new Contact();
        con.Email = 'safia.osman@hotmail.com';
        con.lastName = 'test';
        insert con;
         String sch = '0 0 2 * * ?'; 
         OutComeSurvey_Schd sh1 = new OutComeSurvey_Schd ();
          system.schedule('Test Territory Check', sch, sh1); 
          
           string dashboardConfig = Label.OutComeSurveyDasboard;
        CGDashboardUpdatedBatch shn = new CGDashboardUpdatedBatch(dashboardConfig); 
        database.executeBatch(shn );
           
         
       

     
     }

}