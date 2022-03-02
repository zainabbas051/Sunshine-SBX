//Test Class : insertUpdateKUPUBillableItemsTest
trigger insertUpdateKUPUBillableItems on KIPU_Billable_Items_Temp__c (after insert){
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && 
    Trigger_Custom_Setting__c.getValues('Default').Disable_insertUpdateKUPUBillableItems__c == True)
    return;
    
    Set<Date> kbiDateSet = new Set<Date>();
    Set<String> kbiMRNSet = new Set<String>();
    Set<Id> kipuSnapshotIdSet = new Set<Id>();
    Map<String,Id> kipuSnapshotIDMap = new Map<String,Id>();
    Map<Id,List<KIPU_Billable_Items__c>> snapshotBillableItemsListMap = new Map<Id,List<KIPU_Billable_Items__c>>();
    List<KIPU_Billable_Items__c> kbiUpdateList = new List<KIPU_Billable_Items__c>();
    List<KIPU_Billable_Items__c> kbiInsertList = new List<KIPU_Billable_Items__c>();
    List<KIPU_Billable_Items_Temp__c> kbitUpdateList = new List<KIPU_Billable_Items_Temp__c>();
    
    for(KIPU_Billable_Items_Temp__c kbi : Trigger.New){
        if((kbi.Appointment__c!= null || kbi.Evaluation_Template_ID__c != null || kbi.Session__c != null) && kbi.KIPU_MRN__c != null && kbi.Start_Date__c != null){
            Date myDate = date.newinstance(kbi.Start_Date__c.year(), kbi.Start_Date__c.month(), kbi.Start_Date__c.day());
            kbiDateSet.add(myDate);
            kbiMRNSet.add(kbi.KIPU_MRN__c);
        }
        if(kbi.Speciment_ID__c != null && kbi.KIPU_MRN__c != null && kbi.Collected__c != null){
            kbiDateSet.add(kbi.Collected__c);
            kbiMRNSet.add(kbi.KIPU_MRN__c);
        }    
    }
    
     system.debug('kbiDateSet size ::::'+kbiDateSet.size());
    system.debug('kbiMRNSet size ::::'+kbiMRNSet.size());
    
    system.debug('kbiDateSet ::::'+kbiDateSet);
    system.debug('kbiMRNSet ::::'+kbiMRNSet);
    
    if(kbiDateSet.size()>0 && kbiMRNSet.size()>0){
        for(Client_KIPU_Snapshot__c cks : [Select id, KIPU_MRN__c, Snapshot_Date__c from Client_KIPU_Snapshot__c where KIPU_MRN__c IN: kbiMRNSet AND Snapshot_Date__c IN: kbiDateSet]){
            
            system.debug('Map Key ::::'+cks.Snapshot_Date__c+'--'+cks.KIPU_MRN__c);
            kipuSnapshotIDMap.put(cks.Snapshot_Date__c+'--'+cks.KIPU_MRN__c,cks.id);
            kipuSnapshotIdSet.add(cks.id);
        }
    }
    
    if(kipuSnapshotIdSet.size()>0){
        for(KIPU_Billable_Items__c kbi : [Select id, Name, Appointment__c,Authorizations__c,Client_KIPU_Snapshot__c,Collected__c,Completed_At__c,Duration__c,End_Date__c,Evaluation__c,
                                          KIPU_MRN__c,Lab_Test__c,Provider__c,Scheduled_By__c,Session__c,Signed_By__c,Specimen_Source__c,Speciment_ID__c,Start_Date__c,Status__c,
                                          Topic__c,Vendor__c, Evaluation_Template_ID__c from KIPU_Billable_Items__c where Client_KIPU_Snapshot__c IN: kipuSnapshotIdSet]){
            
            if(snapshotBillableItemsListMap.containsKey(kbi.Client_KIPU_Snapshot__c)){
                List<KIPU_Billable_Items__c> tempList = new List<KIPU_Billable_Items__c>();
                tempList = snapshotBillableItemsListMap.get(kbi.Client_KIPU_Snapshot__c);
                tempList.add(kbi);
                snapshotBillableItemsListMap.put(kbi.Client_KIPU_Snapshot__c,tempList);
            }else{
                List<KIPU_Billable_Items__c> tempList = new List<KIPU_Billable_Items__c>();
                tempList.add(kbi);
                snapshotBillableItemsListMap.put(kbi.Client_KIPU_Snapshot__c,tempList);
            }        
        }
    }
    
    if(kipuSnapshotIDMap.keySet().size()>0){
        for(KIPU_Billable_Items_Temp__c kbit : Trigger.New){
            if((kbit.Appointment__c!= null || kbit.Evaluation_Template_ID__c != null || kbit.Session__c != null) && kbit.KIPU_MRN__c != null && kbit.Start_Date__c != null){
                DateTime myDate = dateTime.newinstance(kbit.Start_Date__c.year(), kbit.Start_Date__c.month(), kbit.Start_Date__c.day(), kbit.Start_Date__c.Hour(), kbit.Start_Date__c.Minute(),0);
                if(kipuSnapshotIDMap.containsKey(myDate.date()+'--'+kbit.KIPU_MRN__c)){
                    KIPU_Billable_Items__c kbi_temp = new KIPU_Billable_Items__c();
                    if(snapshotBillableItemsListMap.containsKey(kipuSnapshotIDMap.get(myDate.date()+'--'+kbit.KIPU_MRN__c))){
                        Boolean updateFlag = False;
                        for(KIPU_Billable_Items__c kbi : snapshotBillableItemsListMap.get(kipuSnapshotIDMap.get(myDate.date()+'--'+kbit.KIPU_MRN__c))){
                            if(kbi.Start_Date__c != null){
                                DateTime myDate2 = dateTime.newinstance(kbi.Start_Date__c.year(), kbi.Start_Date__c.month(), kbi.Start_Date__c.day(), kbi.Start_Date__c.Hour(), kbi.Start_Date__c.Minute(),0);
                                if(kbit.Appointment__c!= null && kbi.Name+'--'+myDate2+'--'+kbi.KIPU_MRN__c == kbit.Appointment__c+'--'+myDate+'--'+kbit.KIPU_MRN__c){
                                    //update KBI Record with KBIT Record Values
                                    kbi_temp = Utilities_KIPUBillableItemsTemp.KIPUBillableItems_Create(kbit,kipuSnapshotIDMap.get(myDate.date()+'--'+kbit.KIPU_MRN__c));
                                    kbi_temp.id = kbi.id;
                                    kbiUpdateList.add(kbi_temp);
                                    KIPU_Billable_Items_Temp__c kbit_temp = new KIPU_Billable_Items_Temp__c(id = kbit.id, Client_KIPU_Snapshot__c = kipuSnapshotIDMap.get(myDate.date()+'--'+kbit.KIPU_MRN__c));
                                    kbitUpdateList.add(kbit_temp);
                                    updateFlag = True;    
                                }
                                if(kbit.Evaluation_Template_ID__c!= null && kbi.Evaluation_Template_ID__c != null && kbi.Evaluation_Template_ID__c +'--'+myDate2+'--'+kbi.KIPU_MRN__c == kbit.Evaluation_Template_ID__c +'--'+myDate+'--'+kbit.KIPU_MRN__c){
                                    
                                    //update KBI Record with KBIT Record Values
                                    kbi_temp = Utilities_KIPUBillableItemsTemp.KIPUBillableItems_Create(kbit,kipuSnapshotIDMap.get(myDate.date()+'--'+kbit.KIPU_MRN__c));
                                    kbi_temp.id = kbi.id;
                                    kbiUpdateList.add(kbi_temp);
                                    KIPU_Billable_Items_Temp__c kbit_temp = new KIPU_Billable_Items_Temp__c(id = kbit.id, Client_KIPU_Snapshot__c = kipuSnapshotIDMap.get(myDate.date()+'--'+kbit.KIPU_MRN__c));
                                    kbitUpdateList.add(kbit_temp);
                                    updateFlag = True;    
                                }
                                if(kbit.Session__c!= null && kbi.Name+'--'+myDate2+'--'+kbi.KIPU_MRN__c == kbit.Session__c+'--'+myDate+'--'+kbit.KIPU_MRN__c){
                                    //update KBI Record with KBIT Record Values
                                    kbi_temp = Utilities_KIPUBillableItemsTemp.KIPUBillableItems_Create(kbit,kipuSnapshotIDMap.get(myDate.date()+'--'+kbit.KIPU_MRN__c));
                                    kbi_temp.id = kbi.id;
                                    kbiUpdateList.add(kbi_temp);
                                    KIPU_Billable_Items_Temp__c kbit_temp = new KIPU_Billable_Items_Temp__c(id = kbit.id, Client_KIPU_Snapshot__c = kipuSnapshotIDMap.get(myDate.date()+'--'+kbit.KIPU_MRN__c));
                                    kbitUpdateList.add(kbit_temp);
                                    updateFlag = True;    
                                }
                            }
                        }
                        if(updateFlag == False){
                            //Insert KBIT Record
                            kbi_temp = Utilities_KIPUBillableItemsTemp.KIPUBillableItems_Create(kbit,kipuSnapshotIDMap.get(myDate.date()+'--'+kbit.KIPU_MRN__c));
                            kbiInsertList.add(kbi_temp);
                            KIPU_Billable_Items_Temp__c kbit_temp = new KIPU_Billable_Items_Temp__c(id = kbit.id, Client_KIPU_Snapshot__c = kipuSnapshotIDMap.get(myDate.date()+'--'+kbit.KIPU_MRN__c));
                            kbitUpdateList.add(kbit_temp);   
                        }
                    }else{
                        //Insert KBIT Record
                        kbi_temp = Utilities_KIPUBillableItemsTemp.KIPUBillableItems_Create(kbit,kipuSnapshotIDMap.get(myDate.date()+'--'+kbit.KIPU_MRN__c));
                        kbiInsertList.add(kbi_temp);
                        KIPU_Billable_Items_Temp__c kbit_temp = new KIPU_Billable_Items_Temp__c(id = kbit.id, Client_KIPU_Snapshot__c = kipuSnapshotIDMap.get(myDate.date()+'--'+kbit.KIPU_MRN__c));
                        kbitUpdateList.add(kbit_temp);
                    }
                }
            }
            if(kbit.Speciment_ID__c != null && kbit.KIPU_MRN__c != null && kbit.Collected__c != null){
                if(kipuSnapshotIDMap.containsKey(kbit.Collected__c+'--'+kbit.KIPU_MRN__c)){
                    KIPU_Billable_Items__c kbi_temp = new KIPU_Billable_Items__c();
                    if(snapshotBillableItemsListMap.containsKey(kipuSnapshotIDMap.get(kbit.Collected__c+'--'+kbit.KIPU_MRN__c))){
                        Boolean updateFlag = False;
                        for(KIPU_Billable_Items__c kbi : snapshotBillableItemsListMap.get(kipuSnapshotIDMap.get(kbit.Collected__c+'--'+kbit.KIPU_MRN__c))){
                            if(kbi.Speciment_ID__c+'--'+kbi.Collected__c+'--'+kbi.KIPU_MRN__c == kbit.Speciment_ID__c+'--'+kbit.Collected__c+'--'+kbit.KIPU_MRN__c){
                                //update KBI Record with KBIT Record Values
                                kbi_temp = Utilities_KIPUBillableItemsTemp.KIPUBillableItems_Create(kbit,kipuSnapshotIDMap.get(kbit.Collected__c+'--'+kbit.KIPU_MRN__c));
                                kbi_temp.id = kbi.id;
                                kbiUpdateList.add(kbi_temp);
                                KIPU_Billable_Items_Temp__c kbit_temp = new KIPU_Billable_Items_Temp__c(id = kbit.id, Client_KIPU_Snapshot__c = kipuSnapshotIDMap.get(kbit.Collected__c+'--'+kbit.KIPU_MRN__c));
                                kbitUpdateList.add(kbit_temp);
                                updateFlag = True;
                            }
                        }
                        if(updateFlag == False){
                            //Insert KBIT Record
                            kbi_temp = Utilities_KIPUBillableItemsTemp.KIPUBillableItems_Create(kbit,kipuSnapshotIDMap.get(kbit.Collected__c+'--'+kbit.KIPU_MRN__c));
                            kbiInsertList.add(kbi_temp);
                            KIPU_Billable_Items_Temp__c kbit_temp = new KIPU_Billable_Items_Temp__c(id = kbit.id, Client_KIPU_Snapshot__c = kipuSnapshotIDMap.get(kbit.Collected__c+'--'+kbit.KIPU_MRN__c));
                            kbitUpdateList.add(kbit_temp);
                        }
                    }else{
                        //Insert KBIT Record
                        kbi_temp = Utilities_KIPUBillableItemsTemp.KIPUBillableItems_Create(kbit,kipuSnapshotIDMap.get(kbit.Collected__c+'--'+kbit.KIPU_MRN__c));
                        kbiInsertList.add(kbi_temp);
                        KIPU_Billable_Items_Temp__c kbit_temp = new KIPU_Billable_Items_Temp__c(id = kbit.id, Client_KIPU_Snapshot__c = kipuSnapshotIDMap.get(kbit.Collected__c+'--'+kbit.KIPU_MRN__c));
                        kbitUpdateList.add(kbit_temp);
                                 
                    }
                }
            }    
        }
    }
    
    if(kbiInsertList.size()>0)
        insert kbiInsertList;
    
    if(kbiUpdateList.size()>0)
        update kbiUpdateList;
    
    if(kbitUpdateList.size()>0)
        update kbitUpdateList;
            
}