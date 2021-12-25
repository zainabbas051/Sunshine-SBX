//TestClass:updateOportunitySurveySchdTest
global class updateOportunitySurveySchd implements Schedulable {

   global void execute(SchedulableContext sc) {
      updateOportunitySurveyBatch  b = new updateOportunitySurveyBatch (); 
      database.executebatch(b);
   }
}