//Test Class : updateOpportunityReferenceTest
trigger updateOpportunityReference on Client_KIPU_Snapshot__c (after insert) {
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && 
    Trigger_Custom_Setting__c.getValues('Default').Disable_updateOpportunityReference__c == True)
    return;
    
    list<String> kipuMRNList = new List<String>();
    Set<Opportunity> oppUpdateSet = new Set<Opportunity>();
    List<Opportunity> oppUpdateList = new List<Opportunity>();
    List<Client_KIPU_Snapshot__c> cksUpdateList = new List<Client_KIPU_Snapshot__c>();
    List<Client_KIPU_Snapshot__c> cksDeleteList = new List<Client_KIPU_Snapshot__c>();
    Map<String,Opportunity> kipuMRNOppIdMap = new Map<String,Opportunity>();
    
    for(Client_KIPU_Snapshot__c cks : Trigger.New){
        if(cks.KIPU_MRN__c != '' && cks.KIPU_MRN__c != null){
            kipuMRNList.add(cks.KIPU_MRN__c);
        }
    }
    
    if(kipuMRNList.size()>0){
        for(Opportunity opp : [Select Id, StageName, CloseDate, KIPU_MRN__c from Opportunity where KIPU_MRN__c IN: kipuMRNList]){
            kipuMRNOppIdMap.put(opp.KIPU_MRN__c,opp);
        }
    }
    if(kipuMRNOppIdMap.keySet().size()>0){
        for(Client_KIPU_Snapshot__c cks : Trigger.New){
            if(cks.KIPU_MRN__c != '' && cks.KIPU_MRN__c != null){
                if(kipuMRNOppIdMap.containsKey(cks.KIPU_MRN__c)){//Only If we find an opportunity with KIPU MRN
                    //We will only keep the Client KIPU Snapshots for Opportunities with Stage of Admitted or Discharged and if the Snapshot Dat >= Opp Close Date
                    if((kipuMRNOppIdMap.get(cks.KIPU_MRN__c).StageName == 'Admitted' || kipuMRNOppIdMap.get(cks.KIPU_MRN__c).StageName == 'Discharged') && cks.Snapshot_Date__c >= kipuMRNOppIdMap.get(cks.KIPU_MRN__c).CloseDate){
                        Client_KIPU_Snapshot__c cks_temp = new Client_KIPU_Snapshot__c(id = cks.id, Related_Opportunity__c = kipuMRNOppIdMap.get(cks.KIPU_MRN__c).id);
                        if(cks.UR_Level_of_Care_Temp__c != null){
                            cks_temp.Current_UR_Level_of_Care__c = Utilities_KIPU_Snapshots.getCurrentURLoc(cks.UR_Level_of_Care_Temp__c);
                        }
                        if(cks.Bed_Information_Temp__c != null){
                            if(cks.Bed_Information_Temp__c.contains('|')){
                                List<String> bedInfo = cks.Bed_Information_Temp__c.split('|');
                                //cks_temp.House_Room_Number__c = bedInfo[0];
                                //cks_temp.Bed__c = bedInfo[1];
                            }
                        }
                        cksUpdateList.add(cks_temp);
                        if(cks.Discharge_Date_Time__c != null || cks.Primary_Therapist__c != null || cks.Case_Manager__c != null){
                            Opportunity opp_Temp = new Opportunity(id=kipuMRNOppIdMap.get(cks.KIPU_MRN__c).id);
                            //opp_Temp.KIPU_Discharge_Date__c = cks.Discharge_Date_Time__c;
                            //opp_Temp.KIPU_Primary_Therapist__c = cks.Primary_Therapist__c;
                            //opp_Temp.KIPU_Case_Manager__c = cks.Case_Manager__c;
                            oppUpdateSet.add(opp_Temp);
                        }
                    }else{//If Related Opportunities Stage is NOT Admitted or Discharged and if the Snapshot Dat < Opp Close Date, just delete the snapshot
                        Client_KIPU_Snapshot__c cks_temp = new Client_KIPU_Snapshot__c(id = cks.id);
                        cksDeleteList.add(cks_temp);
                    }
                }else{//If No Opportunity with KIPU MRN is Found
                    Client_KIPU_Snapshot__c cks_temp = new Client_KIPU_Snapshot__c(id = cks.id);
                    if(cks.UR_Level_of_Care_Temp__c != null){
                        cks_temp.Current_UR_Level_of_Care__c = Utilities_KIPU_Snapshots.getCurrentURLoc(cks.UR_Level_of_Care_Temp__c);
                    }
                    if(cks.Bed_Information_Temp__c != null){
                        if(cks.Bed_Information_Temp__c.contains('|')){
                            List<String> bedInfo = cks.Bed_Information_Temp__c.split('|');
                            //cks_temp.House_Room_Number__c = bedInfo[0];
                            //cks_temp.Bed__c = bedInfo[1];
                        }
                    }
                    cksUpdateList.add(cks_temp);
                        
                }
            }
        }
    }
    //If No Opportunity with KIPU MRN is Found for any of the Snapshots being Inserted
    if(kipuMRNOppIdMap.keySet().size()==0 && kipuMRNList.size()>0){
        for(Client_KIPU_Snapshot__c cks : Trigger.New){
            Client_KIPU_Snapshot__c cks_temp = new Client_KIPU_Snapshot__c(id = cks.id);
            if(cks.UR_Level_of_Care_Temp__c != null){
                cks_temp.Current_UR_Level_of_Care__c = Utilities_KIPU_Snapshots.getCurrentURLoc(cks.UR_Level_of_Care_Temp__c);
            }
            if(cks.Bed_Information_Temp__c != null){
                if(cks.Bed_Information_Temp__c.contains('|')){
                    List<String> bedInfo = cks.Bed_Information_Temp__c.split('|');
                    //cks_temp.House_Room_Number__c = bedInfo[0];
                    //cks_temp.Bed__c = bedInfo[1];
                }
            }
            cksUpdateList.add(cks_temp);
        }
    }
    if(cksUpdateList.size()>0){
        update cksUpdateList;
    }
    
    if(oppUpdateSet.size()>0){
        oppUpdateList.addAll(oppUpdateSet);
        update oppUpdateList;
    }
    if(cksDeleteList.size()>0){
        delete cksDeleteList;
    }
}