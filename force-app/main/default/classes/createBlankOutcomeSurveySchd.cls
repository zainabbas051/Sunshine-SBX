//TestClass:OutcomeSurveySchdTest
global class createBlankOutcomeSurveySchd implements Schedulable {

   global void execute(SchedulableContext sc) {
      createBlankOutcomeSurveyBatch  b = new createBlankOutcomeSurveyBatch (); 
      database.executebatch(b);
   }
}