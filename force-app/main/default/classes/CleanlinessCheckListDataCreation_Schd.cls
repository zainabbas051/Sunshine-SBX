global class CleanlinessCheckListDataCreation_Schd implements Schedulable {
    
    static Map<string,List<Cleanliness_Checklist_Task_Mapping__mdt>> mapOfCleanlinessChk;
    global void execute(SchedulableContext SC) {

        //update previous line item and update
        getPreviousMissedLineItem();
        createNewLineItem();
    }


    public  static void getPreviousMissedLineItem(){

        List<House_Line_Items__c> lstHouselineitem = [Select ID,Status__c
                                                        FROM House_Line_Items__c
                                                        WHERE Due_Date__c < TODAY AND Status__c IN ('Incomplete','Under Review')];
        
        if(lstHouselineitem.isEmpty()) return;
        
        for(House_Line_Items__c iLineItem : lstHouselineitem){
            
            if(iLineItem.Status__c.equals('Incomplete')){
                iLineItem.Status__c = 'Missed';
                continue;
            }
            if(iLineItem.Status__c.equals('Under Review'))
            iLineItem.Status__c = 'Missed Review';
        }
        
        System.enqueueJob(new DMLRecord_Qeuable(lstHouselineitem,'Update'));
       
    }

    public  static void createNewLineItem(){

        FINAL STRING DAILY_REC_TYPE = Schema.getGlobalDescribe().get('House_Line_Items__c').getDescribe().getRecordTypeInfosByDeveloperName().get('Daily_Line_Item').getRecordTypeId();
        FINAL STRING WEEKLY_REC_TYPE = Schema.getGlobalDescribe().get('House_Line_Items__c').getDescribe().getRecordTypeInfosByDeveloperName().get('Weekly_Line_Item').getRecordTypeId();
        FINAL STRING DIRECTOR_REC_TYPE = Schema.getGlobalDescribe().get('House_Line_Items__c').getDescribe().getRecordTypeInfosByDeveloperName().get('Director_Review').getRecordTypeId();
       
        
        List<Cleanliness_Checklist_Task_Mapping__mdt> lstCleanlinessCheckLlst = [Select Sunshine_Center__c,
                                                                                 Task_Frequency__c,Task_Name__c,
                                                                                 Task_Type__c FROM Cleanliness_Checklist_Task_Mapping__mdt where Task_Type__c != ''];
        
    
        mapOfCleanlinessChk  = new Map<string,list<Cleanliness_Checklist_Task_Mapping__mdt>>();
                                                           
        for(Cleanliness_Checklist_Task_Mapping__mdt iCk : lstCleanlinessCheckLlst){

            if(mapOfCleanlinessChk.containsKey(iCk.Task_Frequency__c)){
                mapOfCleanlinessChk.get(iCk.Task_Frequency__c).add(iCk);
                continue;
            }
            mapOfCleanlinessChk.put(iCk.Task_Frequency__c, new List<Cleanliness_Checklist_Task_Mapping__mdt>{ iCk} );
        }
        
        boolean isWeekly = mapOfCleanlinessChk.containsKey('Weekly');
        boolean isDaily = mapOfCleanlinessChk.containsKey('Daily');
        
        Map<string,List<Cleanliness_Checklist_Task_Mapping__mdt>> mapOfCleanlinessChkDaily 
                                                        = new Map<string,list<Cleanliness_Checklist_Task_Mapping__mdt>>(); 
        Map<string,List<Cleanliness_Checklist_Task_Mapping__mdt>> mapOfCleanlinessChkWeekly
                                                        = new Map<string,list<Cleanliness_Checklist_Task_Mapping__mdt>>();  
        for(Cleanliness_Checklist_Task_Mapping__mdt iCk : lstCleanlinessCheckLlst){

            if(iCk.Task_Frequency__c=='Daily'){
            if(mapOfCleanlinessChkDaily.containsKey(iCk.Task_Type__c)){
                mapOfCleanlinessChkDaily.get(iCk.Task_Type__c).add(iCk);
                continue;
            }
            mapOfCleanlinessChkDaily.put(iCk.Task_Type__c, new List<Cleanliness_Checklist_Task_Mapping__mdt>{ iCk} );
            continue;
            }
            if(iCk.Task_Frequency__c=='Weekly'){
             if(mapOfCleanlinessChkWeekly.containsKey(iCk.Task_Type__c)){
                mapOfCleanlinessChkWeekly.get(iCk.Task_Type__c).add(iCk);
                continue;
            }
            mapOfCleanlinessChkWeekly.put(iCk.Task_Type__c, new List<Cleanliness_Checklist_Task_Mapping__mdt>{ iCk} );
                 }
        }

        List<Cleanliness_Checklist_House_Mapping__mdt> lstCleanlinessHouseLlst = [Select Sunshine_Center__c,
                                                                                  Mapping_Type__c,Mapping_Name__c,House_Name__c
                                                                                  FROM Cleanliness_Checklist_House_Mapping__mdt];

        Set<string> setOfHouseName = new Set<string>();
        Map<string,List<Cleanliness_Checklist_House_Mapping__mdt>> mapOfHouseMapping
                                        = new Map<string,List<Cleanliness_Checklist_House_Mapping__mdt>>();

        for(Cleanliness_Checklist_House_Mapping__mdt iCk : lstCleanlinessHouseLlst){
           
            if(mapOfHouseMapping.containsKey(iCk.House_Name__c)){
                mapOfHouseMapping.get(iCk.House_Name__c).add(iCk);
                continue;
            }
            mapOfHouseMapping.put(iCk.House_Name__c, new List<Cleanliness_Checklist_House_Mapping__mdt>{ iCk} );
        }
            
           // mapOfHouseMapping.put(iCk.House_Name__c,iCk);
        

        List<House__c> lstHouse = [SELECT ID , Name FROM House__c
                                    WHERE NAME IN : mapOfHouseMapping.keySet()];
        
        
        if(lstHouse.isEmpty()) return;

        List<House_Line_Items__c> lstHouselineitemNew = new List<House_Line_Items__c>();

        for(House__c iHouse : lstHouse){
            for(Cleanliness_Checklist_House_Mapping__mdt icc: mapOfHouseMapping.get(iHouse.Name)){
            if(mapOfCleanlinessChkDaily.ContainsKey(icc.Mapping_Type__c))
            lstHouselineitemNew.add(createHouseLineItem(icc,iHouse,DAILY_REC_TYPE,Date.TODAY()));//DAILY
             //weekly record
             
            if(Datetime.now().format('E') == Label.WeeklyData_Creation_Day){
                if(mapOfCleanlinessChkWeekly.ContainsKey(icc.Mapping_Type__c))
                    lstHouselineitemNew.add(createHouseLineItem(icc,iHouse,WEEKLY_REC_TYPE,Date.TODAY().AddDays(7)));//WEEKLY
                    lstHouselineitemNew.add(createHouseLineItem(icc,iHouse,DIRECTOR_REC_TYPE,Date.TODAY().AddDays(7))); // DIRECTOR
                }    
            }
        }

        insert lstHouselineitemNew;

        List<Task_Line_Items__c> lstTaskLineitemNew = new List<Task_Line_Items__c>();

        
        for(House_Line_Items__c iHouseLineItem : lstHouselineitemNew){
            
            if(iHouseLineItem.RecordtypeId.equals(DAILY_REC_TYPE) && isDaily){//Daily
                
                createDailyTask(iHouseLineItem,lstTaskLineitemNew,false); // Daily task for Daily House
                continue;
                
            }
            if(isWeekly && Datetime.now().format('E') == Label.WeeklyData_Creation_Day && 
                                            iHouseLineItem.RecordtypeId.equals(WEEKLY_REC_TYPE)){
               
               createWeeklyTask(iHouseLineItem,lstTaskLineitemNew,false); // Weekly task for Weekly House
                continue;
            }

            if(Datetime.now().format('E') == Label.WeeklyData_Creation_Day && 
                                            iHouseLineItem.RecordtypeId.equals(DIRECTOR_REC_TYPE)){
                
                createDailyTask(iHouseLineItem,lstTaskLineitemNew,true); // Daily Task for Director Rec
                system.debug('***tasks'+lstTaskLineitemNew);
                createWeeklyTask(iHouseLineItem,lstTaskLineitemNew,true); // Weekly Task for Director Rec
                system.debug('***tasks'+lstTaskLineitemNew);
                
            }
        }
        if(!lstTaskLineitemNew.isEmpty())
            insert lstTaskLineitemNew;

    }

    private static void createWeeklyTask(House_Line_Items__c iHouseLineItem,
                                List<Task_Line_Items__c> lstTaskLineitemNew,
                                boolean isDirector){
        string taskName='';
        for(Cleanliness_Checklist_Task_Mapping__mdt iTaskList : mapOfCleanlinessChk.get('Weekly')){
            taskName=iTaskList.Task_Name__c;
           
            if(iTaskList.Task_Type__c==iHouseLineItem.Line_Item_Type__c)
                lstTaskLineitemNew.add(new Task_Line_Items__c(Related_House_Line_Item__c = iHouseLineItem.ID,
                                                            Task_Name__c = taskName,
                                                            Task_Type__c = 'Weekly'
                ));
        }
    }

    private static void createDailyTask(House_Line_Items__c iHouseLineItem,
                                List<Task_Line_Items__c> lstTaskLineitemNew,
                                boolean isDirector){
        string taskName='';
        for(Cleanliness_Checklist_Task_Mapping__mdt iTaskList : mapOfCleanlinessChk.get('Daily')){
            taskName=iTaskList.Task_Name__c;
            
            if(iTaskList.Task_Type__c == iHouseLineItem.Line_Item_Type__c)
                lstTaskLineitemNew.add(new Task_Line_Items__c(Related_House_Line_Item__c = iHouseLineItem.ID,
                                                            Task_Name__c = taskName,
                                                            Task_Type__c = 'Daily'
                ));
        }
    }

    private static House_Line_Items__c createHouseLineItem(Cleanliness_Checklist_House_Mapping__mdt icc,
                                     House__c iHouse,string recordTypeDevName,
                                     Date dt){
        system.debug('**week number**'+system.now().format('w'));
        return new House_Line_Items__c(Status__c = 'Incomplete',
        Related_House__c = iHouse.ID,
        Line_Item_Type__c =  icc.Mapping_Type__c,
        Bedroom_Number__c=icc.Mapping_Name__c,
        Bathroom_Number__c=icc.Mapping_Name__c,
        Due_Date__c = dt,
        Week_of_year__c =system.now().format('w'),
        
        RecordtypeId = recordTypeDevName);
    }
}