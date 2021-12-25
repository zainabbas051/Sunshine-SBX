/*
	@purpose: scheduler class of GroupTherapySessionsBatch
	@author: Huma Zafar
	test class : GroupTherapySessionsBatchTest
*/
global class GroupTherapySessionsSchedule implements Schedulable {
	
	global void execute(SchedulableContext SC) {
		GroupTherapySessionsBatch b = new GroupTherapySessionsBatch();
		database.executebatch(b);		
	}
}