global class MaintenanceCheckListDataCreation_Schd implements Schedulable {
    
    static Map<string,List<Maintenance_Checklist_Task_Mapping__mdt>> mapOfMaintenanceChk;
    global void execute(SchedulableContext SC) {

        createNewLineItem();
    }

    private static Map<string,Integer> monthMap = new Map<string,Integer> {
        'Jan'  => 1,
        'May' => 5,
        'Mar' => 3,
        'Apr' => 4,
        'Jul' => 7,
        'Sep' => 9,
        'Oct' => 10,
        'Nov' => 11
        

    };


  
    public  static void createNewLineItem(){

       
        List<Maintenance_Checklist_Task_Mapping__mdt> lstMaintenanceChk = [Select Due_Day__c,
                                                                                Due_Month__c,Sunshine_Center__c,
                                                                                Task_Frequency__c, Task_Name__c FROM Maintenance_Checklist_Task_Mapping__mdt];
        
    
        mapOfMaintenanceChk  = new Map<string,list<Maintenance_Checklist_Task_Mapping__mdt>>();
                                                           
        for(Maintenance_Checklist_Task_Mapping__mdt iCk : lstMaintenanceChk){

            if(mapOfMaintenanceChk.containsKey(iCk.Sunshine_Center__c)){
                mapOfMaintenanceChk.get(iCk.Sunshine_Center__c).add(iCk);
                continue;
            }
            mapOfMaintenanceChk.put(iCk.Sunshine_Center__c, new List<Maintenance_Checklist_Task_Mapping__mdt>{ iCk} );
        }
       

        List<House__c> lstHouse = [SELECT ID , Name,Sunshine_Center__r.Name FROM House__c
                                  ];
        
        if(lstHouse.isEmpty()) return;

        List<Maintenance_Tasks_LineItem__c> lstTaskLineitemNew = new List<Maintenance_Tasks_LineItem__c>();
        List<Maintenance_Tasks_LineItem__c> lstTaskLineitemNewMSR = new List<Maintenance_Tasks_LineItem__c>();

        for(House__c iHouse : lstHouse){

            if(!mapOfMaintenanceChk.containsKey(iHouse.Sunshine_Center__r.Name)){
                continue;
            }
            createTask(iHouse,mapOfMaintenanceChk.get(iHouse.Sunshine_Center__r.Name),lstTaskLineitemNew);
        }
        
        DateTime seasonStartDate = date.newinstance(date.TODAY().year(),4,1);
        DateTime seasonEndDate = date.newinstance(date.TODAY().year(),11,30);
        List<House__c> MSRHouseId = [SELECT ID FROM House__c where Sunshine_Center__r.Name='Mountain Springs Recovery' limit 1 ];
        if(!MSRHouseId.isEmpty()){
             for(integer i=4;i<=11;i++){
   
                DateTime startDate = date.newinstance(date.TODAY().year(),i,1);
                DateTime endDate = startDate.addMonths(1).addDays(-1);
                
                for(datetime d=startDate; d <= endDate; d=d.addDays(1)){
                if(d.format('EEEE')=='Monday' ||d.format('EEEE')=='Wednesday' || d.format('EEEE')=='Friday')
                {
                    Maintenance_Tasks_LineItem__c mtaskMSR= new Maintenance_Tasks_LineItem__c();
                    system.debug(MSRHouseId);
                    mtaskMSR.Related_House__c = MSRHouseId[0].ID ;
                    mtaskMSR.Task_Name__c= 'Water Pots Plant' ;
                    mtaskMSR.Task_Type__c = 'Monthly';
                    mtaskMSR.Due_Date__c = date.newinstance(d.year(),d.month(),d.day());
                    lstTaskLineitemNewMSR.add(mtaskMSR);
        
                }
             
             }
         }
          insert lstTaskLineitemNewMSR;     
    }
    
    insert lstTaskLineitemNew;
 
    }

    private static void createTask(House__c iHouseObj,
                                List<Maintenance_Checklist_Task_Mapping__mdt> lstMaintenaceLineItem,
                                List<Maintenance_Tasks_LineItem__c> lstTaskLineitemNew){
        integer dateYear = Date.TODAY().year();
        for(Maintenance_Checklist_Task_Mapping__mdt iTaskList : lstMaintenaceLineItem){
            
            if(iTaskList.Task_Frequency__c.equals('Monthly') && iTaskList.Due_Month__c .equals('Every')){
                for(integer index = 1; index <= 12 ; index++){
                    system.debug('%%%'+integer.valueOf(iTaskList.Due_Day__c));    
                    lstTaskLineitemNew.add(new Maintenance_Tasks_LineItem__c(Related_House__c = iHouseObj.ID,
                    Task_Name__c = iTaskList.Task_Name__c,
                    Task_Type__c = iTaskList.Task_Frequency__c,
                    Due_Date__c = date.newinstance(dateYear,index,integer.valueOf(iTaskList.Due_Day__c))));
                    continue;
                }
                continue;
            } 
            
            Date duedate;
            system.debug('%*'+iTaskList.Task_Name__c+'%%%%*'+iTaskList.Due_Month__c+'%%%'+monthMap.get(iTaskList.Due_Month__c)+'%%%%'+ iTaskList.Due_Day__c);
            if(iTaskList.Task_Frequency__c.equals('Seasonally') && iTaskList.Due_Month__c .equals('Every'))
            continue;

            
            lstTaskLineitemNew.add(new Maintenance_Tasks_LineItem__c(Related_House__c = iHouseObj.ID,
            Task_Name__c = iTaskList.Task_Name__c,
            Task_Type__c = iTaskList.Task_Frequency__c,
            Due_Date__c = date.newinstance(dateYear,monthMap.get(iTaskList.Due_Month__c),integer.valueOf(iTaskList.Due_Day__c))));
            continue;       
        }
    }
}