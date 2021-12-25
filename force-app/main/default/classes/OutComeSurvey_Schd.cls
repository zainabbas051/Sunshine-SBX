global class OutComeSurvey_Schd implements Schedulable {
 global void execute(SchedulableContext sc) {

     
   //  Database.executeBatch(new CGDashboardUpdatedBatch());
        string dashboardConfig = Label.OutComeSurveyDasboard;
        CGDashboardUpdatedBatch shn = new CGDashboardUpdatedBatch(dashboardConfig); 
        database.executeBatch(shn );
     
 }


 
}