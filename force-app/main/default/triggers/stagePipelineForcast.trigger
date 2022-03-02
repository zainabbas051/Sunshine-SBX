//Test Class : stagePipelineForcastTest
trigger stagePipelineForcast on Opportunity (before insert, before update) {
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && 
    Trigger_Custom_Setting__c.getValues('Default').Disable_stagePipelineForcast__c == True)
    return;
    
    List<Opportunity> oppList = new List<Opportunity>();
    Id recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId();
    Id msRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
    for(Opportunity o : Trigger.New){
        if(o.RecordTypeId == recTypeId || o.RecordTypeId == msRecTypeId){
            if(trigger.isUpdate){
                if(o.StageName != trigger.oldMap.get(o.id).StageName){
                    oppList.add(o);
                }
            }
            if(trigger.isInsert){
                oppList.add(o);
            }
        }
    }
    
    if(oppList.size()>0){
        Map<Integer,String> erpStageNumberMap = new Map<Integer,String>();
        Map<String,String> erpStageNameMap = new Map<String,String>();
        Map<Integer,String> msStageNumberMap = new Map<Integer,String>();
        Map<String,String> msStageNameMap = new Map<String,String>();
        List<Stage_Forecast_Values__c> sfvList = Stage_Forecast_Values__c.getAll().values();
        
        for(Stage_Forecast_Values__c sfv : sfvList){
            if(sfv.Record_Type__c == 'Elite Rehab Placement')
                erpStageNumberMap.put(integer.valueOf(sfv.Stage_Number__c),sfv.Name);
            if(sfv.Record_Type__c == 'Monarch Shores')
                msStageNumberMap.put(integer.valueOf(sfv.Stage_Number__c),sfv.Name);
            
        }
        
        for(Stage_Forecast_Values__c sfv : sfvList){
            if(sfv.Record_Type__c == 'Elite Rehab Placement'){
                String tempString = '';
                for(Integer i=1;i<=sfv.Stage_Number__c;i++){
                    if(i==1)
                        tempString = erpStageNumberMap.get(i);
                    else
                        tempString = tempString+';'+erpStageNumberMap.get(i);
                }
                
                erpStageNameMap.put(sfv.name,tempString);
            }
            if(sfv.Record_Type__c == 'Monarch Shores'){
                String tempString = '';
                for(Integer i=1;i<=sfv.Stage_Number__c;i++){
                    if(i==1)
                        tempString = msStageNumberMap.get(i);
                    else
                        tempString = tempString+';'+msStageNumberMap.get(i);
                }
                
                msStageNameMap.put(sfv.name,tempString);
            }
        }
        
        for(Opportunity opp : oppList){
            if(opp.RecordTypeId == recTypeId){
                if(opp.StageName != 'Lost Rescue' && opp.StageName != 'Checked Out Early'){
                    if(erpStageNameMap.containsKey(opp.StageName)){
                        if(opp.Stage_Pipeline_Forcast__c == null)
                            opp.Stage_Pipeline_Forcast__c = erpStageNameMap.get(opp.StageName);       
                        else{
                            for(String stageValue : erpStageNameMap.get(opp.StageName).split(';')){
                                if(opp.Stage_Pipeline_Forcast__c.contains(stageValue)==False)
                                    opp.Stage_Pipeline_Forcast__c = opp.Stage_Pipeline_Forcast__c+';'+stageValue;
                            }
                        }
                    }    
                }else{
                    opp.Stage_Pipeline_Forcast__c = opp.Stage_Pipeline_Forcast__c+';'+opp.StageName;
                }
            }
            if(opp.RecordTypeId == msRecTypeId){
                if(opp.StageName != 'Closed' && opp.StageName != 'Internal Transfer' && opp.StageName != 'Transferred To ERP'){
                    if(msStageNameMap.containsKey(opp.StageName)){
                        if(opp.Stage_Pipeline_Forcast__c == null)
                            opp.Stage_Pipeline_Forcast__c = msStageNameMap.get(opp.StageName);       
                        else{
                            for(String stageValue : msStageNameMap.get(opp.StageName).split(';')){
                                if(opp.Stage_Pipeline_Forcast__c.contains(stageValue)==False)
                                    opp.Stage_Pipeline_Forcast__c = opp.Stage_Pipeline_Forcast__c+';'+stageValue;
                            }
                        }
                    }    
                }else{
                    opp.Stage_Pipeline_Forcast__c = opp.Stage_Pipeline_Forcast__c+';'+opp.StageName;
                }
            }
        }
        
    }
}