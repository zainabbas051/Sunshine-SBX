/*
  @purpose: scheduler class of MedsUpdateMARsStatusBatch 
  @author: Huma Zafar
*/
global class MedsUpdateMARsStatusSchedule implements Schedulable {
  
  global void execute(SchedulableContext SC) {
    MedsUpdateMARsStatusBatch b = new MedsUpdateMARsStatusBatch ();
    database.executebatch(b);    
  }
}