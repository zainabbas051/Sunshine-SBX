global class CGDashboardUpdatedBatch_2_Schd implements Schedulable {
 global void execute(SchedulableContext sc) {

     
   //  Database.executeBatch(new CGDashboardUpdatedBatch());
        CGDashboardUpdatedBatch shn = new CGDashboardUpdatedBatch(System.Label.CGDashboard_ID_2); 
        database.executeBatch(shn );
     
 }


 
}