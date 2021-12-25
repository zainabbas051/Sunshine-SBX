global class KIPUPatientsBatchSchd implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        KIPU_PatientsBatch kpb = new KIPU_PatientsBatch ();
        database.executebatch(kpb);
        
    }
}