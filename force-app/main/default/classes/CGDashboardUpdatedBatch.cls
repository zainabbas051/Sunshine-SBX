//Test Class:
global class CGDashboardUpdatedBatch implements Database.Batchable < sObject > , Database.AllowsCallouts, Database.Stateful {



     global List < Document > lstAttachment;
     private string dashboardID;

     
     public CGDashboardUpdatedBatch(String DashboardID) {
       this.dashboardID = DashboardID;
   
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {

        return DataBase.getQueryLocator([Select Id from Dashboard where ID =: this.dashboardID]);

    }
    
     global void execute(Database.BatchableContext BC, List < Dashboard > scope) {

        ClsDashBoardUtil.RefreshDashboard(this.dashboardID);
        ClsDashBoardUtil.CreateImageFromDashboard(this.dashboardID,lstAttachment);
      

    }

   
   
    global void finish(Database.BatchableContext BC) {
    
        if(DashboardID.equals(Label.OutComeSurveyDasboard)){
            ClsDashBoardUtil.sendEmail('OutComeSurvey',Label.OutCome_Dashboard_Receipients);
            return;
        
        }


    }

}