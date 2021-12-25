global class sendCGdashboardEmailBatch_Schd implements Schedulable {
 global void execute(SchedulableContext sc) {

     
     Database.executeBatch(new sendCGdashboardEmailBatch());

     
 }


 
}