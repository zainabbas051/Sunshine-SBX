/*
Author : Danish
Date : 6/6/2018
Description : Schd class to update the status 
Test Class : EfaxParseCtrl_Test
*/
global class EfaxStatusBatchSchd implements Schedulable {
    
    global void execute(SchedulableContext sc) {
         DataBase.executeBatch(new EfaxStatusBatch() , 10);
    }
}