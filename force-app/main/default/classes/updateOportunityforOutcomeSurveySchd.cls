//TestClass:OutcomeSurveySchdTest
global class updateOportunityforOutcomeSurveySchd implements Schedulable {

   global void execute(SchedulableContext sc) {
      updateOportunityforOutcomeSurveyBatch  b = new updateOportunityforOutcomeSurveyBatch (); 
      database.executebatch(b);
   }
}