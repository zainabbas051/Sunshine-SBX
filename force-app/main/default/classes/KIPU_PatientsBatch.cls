global class KIPU_PatientsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{

    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        string query = '';
        return Database.getQueryLocator([select id, CloseDate, Sunshine_Center_Name__c, Name from Opportunity]);
    }
    
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        map<String,list<Opportunity>> mapSCOpptys = new map<string,list<Opportunity>>();
        
        list<Opportunity> lstUpdateOpportunity = new list<Opportunity>();
        
        for(Opportunity o : (list<Opportunity>)scope){
            
            if(mapSCOpptys.containsKey(o.Sunshine_Center_Name__c)){
                list<Opportunity> templst = mapSCOpptys.get(o.Sunshine_Center_Name__c);
                templst.add(o);                
            }
            else{
                mapSCOpptys.put(o.Sunshine_Center_Name__c, new list<Opportunity>{o});
            }
        }
        for(string sunshineCenter : mapSCOpptys.keyset()){
            Sunshine_Center_Id__c SC = Sunshine_Center_Id__c.getValues(sunshineCenter );
            
            string TodayDate = Datetime.now().formatGMT('YYYYMMdd'); 
                
            HttpResponse response = KIPUIntegrationUtil.callKIPUAPI('/api/patients/admissions?app_id='+SC.KIPU_Access_ID__c+'&phi_level=low&start_date='+TodayDate +'&end_date='+TodayDate , '', '', sunshineCenter ,'GET');
            
            string data = '{"patients":[{"casefile_id":"46:9e71116c-7ad2-4d51-a848-7786abc76901","first_name":"test","middle_name":"","last_name":"opp","dob":"","admission_date":"'+Datetime.now()+'","discharge_date":"2019-06-21T04:00:00.000Z","mr_number":"","payment_method_category":null,"created_at":"2019-05-22T17:44:01.348Z","last_updated_at":"2019-05-22T17:44:01.669Z","diagnosis_codes":null,"insurance_company":null,"phone":""}]}';
            
            if(response !=null){
            System.debug('MYDEBUG: RESPONSE STRING: ' + response.toString());
            System.debug('MYDEBUG: RESPONSE STATUS: '+response.getStatus());
            System.debug('MYDEBUG: STATUS_CODE:'+response.getStatusCode());
            System.debug('MYDEBUG: BODY:'+response.getBody());
            data = response.getBody();
            }
            
            
                
            KIPU_APIs_Wrappers.PatientsData wd = (KIPU_APIs_Wrappers.PatientsData)JSON.deserializeStrict(data,KIPU_APIs_Wrappers.PatientsData.class);
            system.debug(wd);
            
            for(KIPU_APIs_Wrappers.PatientData pd : wd.patients){
                
                string name  = '';
                if(pd.first_name == '')
                    name = pd.last_name;
                else
                    name = pd.first_name + ' ' + pd.last_name;
                    
                system.debug(name);
                
                for(Opportunity opp : mapSCOpptys.get(sunshineCenter)){
                    system.debug(opp.CloseDate);
                    system.debug(pd.admission_date);
                    if(opp.CloseDate == Date.valueof(pd.admission_date) && opp.Name == name ){
                        //lstUpdateOpportunity.add(new Opportunity(id = opp.id, KIPU_Case_File_ID__c = pd.casefile_id, 
                        //KIPU_Status__c= 'Complete'));
                    }
                }
            }            
        }  
        if(lstUpdateOpportunity.size()>0)
            update lstUpdateOpportunity;
    }
    
    global void finish(Database.BatchableContext BC){
    }
}