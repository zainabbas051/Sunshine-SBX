global class SendEmailToSubscribersSchd implements Schedulable {
   
   global void execute(SchedulableContext SC) {
      integer batchSize = test.isRunningTest() ? 200 : 5;
      SendEmailToSubscribersBatch b = new SendEmailToSubscribersBatch();
      Database.executeBatch(b, batchSize);
   }
}