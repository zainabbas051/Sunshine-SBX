global class MarketingDashboard_Schd implements Schedulable {
 global void execute(SchedulableContext sc) {

     delete [select id from attachment where parentID =: Label.MarketingDashboardRecordID];
     Database.executeBatch(new ScheduleMarketingDashboardRefreshBatch());
     
 }


 
}