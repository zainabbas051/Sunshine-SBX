global  class PaymentLineItemCreation_Schd implements Schedulable  {
    global void execute(SchedulableContext sc) {

     
        //  Database.executeBatch(new CGDashboardUpdatedBatch());
        PaymentLineItemCreation_Batch shn = new PaymentLineItemCreation_Batch('contact.admissions@sunshinebh.com'); 
             database.executeBatch(shn );
          
      }
}