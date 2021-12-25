//Test Class : AuditMonthsInTreatmentUpdateBatch_Test
global class AuditMonthsInTreatmentUpdateBatch implements Database.Batchable<sObject>{
    
    string query;
    
    global AuditMonthsInTreatmentUpdateBatch(){
        query = 'select id, Admission_Date__c, Discharge_Date__c, Months_In_Treatment__c from KIPU_Chart_Audit__c';
        if(Test.isRunningTest())
            query += ' limit 200';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('test');
        list<KIPU_Chart_Audit__c> audUpdateList = new list<KIPU_Chart_Audit__c>();
        
        for(KIPU_Chart_Audit__c aud : (list<KIPU_Chart_Audit__c>) scope){
            
            if(aud.Admission_Date__c != null && aud.Discharge_Date__c == null){
                if(date.Today().Month() != aud.Admission_Date__c.Month()){
                    aud.Months_In_Treatment__c = monthStringValue(aud.Admission_Date__c,date.Today());
                    audUpdateList.add(aud);  
                }else{
                    aud.Months_In_Treatment__c = monthStringValue(aud.Admission_Date__c,null);
                    audUpdateList.add(aud);  
                }
            }else if(aud.Admission_Date__c != null && aud.Discharge_Date__c != null){
                aud.Months_In_Treatment__c = monthStringValue(aud.Admission_Date__c,aud.Discharge_Date__c);
                audUpdateList.add(aud);  
            } 
           
                                    
        }
        
        if(audUpdateList.size()>0)
            update audUpdateList; 
    
    }
    
    global void finish(Database.BatchableContext BC){

    }
    
    public static string monthStringValue(Date date1, Date date2)
    {
        String tempMonthString = '';
        Map<Integer,String> monthMap = new Map<Integer,String>();
        monthMap.put(1,'JAN');
        monthMap.put(2,'FEB');
        monthMap.put(3,'MAR');
        monthMap.put(4,'APR');
        monthMap.put(5,'MAY');
        monthMap.put(6,'JUN');
        monthMap.put(7,'JUL');
        monthMap.put(8,'AUG');
        monthMap.put(9,'SEP');
        monthMap.put(10,'OCT');
        monthMap.put(11,'NOV');
        monthMap.put(12,'DEC');
        
        if(date1 != null && date2 != null){
            if(date1.Year() == date2.year()){
                for(Integer i=date1.Month();i<=date2.Month();i++){
                    if(tempMonthString == '')
                        tempMonthString = monthMap.get(i)+'_'+date1.Year();
                    else
                        tempMonthString = tempMonthString+';'+monthMap.get(i)+'_'+date1.Year();
                }
            }else{
                for(Integer i=date1.Month();i<=12;i++){
                    if(tempMonthString == ''){
                        tempMonthString = monthMap.get(i)+'_'+date1.Year();
                    }else{
                        tempMonthString = tempMonthString+';'+monthMap.get(i)+'_'+date1.Year();
                    }
                }
                for(integer i=1;i<=date2.Month();i++){
                    tempMonthString = tempMonthString+';'+monthMap.get(i)+'_'+date2.Year();
                }    
            }
            return tempMonthString;
        }
        else if(date1 != null && date2 == null){
            tempMonthString = monthMap.get(date1.Month())+'_'+date1.Year();
            return tempMonthString;
        }
        return null;
    }
}