/*
Test class : CalendarCtrl_MarsTest
*/

public class CalendarCtrl_Mars{



    public Boolean includeMyEvents {get;set;}

    public list<calEvent> events {get;set;}
    
     public string selectOption {get;set;}
     
       public string selectHouse {get;set;}
      
      public List<selectoption> houseLst {get;set;} 
    
   
    User currentUser ;
    string SDateTime;
    string EDateTime;
    string clientChartID;
    string RecordTypeName;
    
    Set<ID> setOfHouseClientChart;
    

    //constructor

    public CalendarCtrl_Mars() {

        //Default showing my events to on
        selectOption = 'Nursing';
        currentUser = [Select TimeZoneSidKey from User where id =: USerInfo.getUserId() limit 1]; 
          system.debug('#####' + events);
        includeMyEvents = true;
        RecordTypeName = ApexPages.currentPage().getParameters().get('rt');
        
          houseLst = new List<SelectOption>();
          houseLst.add(new SelectOption('','--None--'));
        for(Bed_Board_Configuration__c iBed : [Select id ,name,Sunshine_Center__r.Name from Bed_Board_Configuration__c where Sunshine_Center__r.Name=: RecordTypeName
                                                AND House_Name__c != '']){
            
                houseLst.add(new SelectOption(iBed.ID,iBed.Name));
        }
    }
    
    
    void getEvent_Mars(){
        
        events = new list<calEvent>();
        
        if(selectOption == 'Nursing'){
            
            LoadNursingRecord();
        }
        
        else{
            // Below code commented for Ticket# Freep-379
           // LoadNursingRecord();
            LoadAdmitOrder();
            ClinicaEvaluationRecord_PhsychEvaluation();
            ClinicaEvaluationRecord_History();
        }
        
        
        
        
     
    }
    
    
    void LoadAdmitOrder(){
        
        for(Medical__c iMed : [Select ID ,CreatedDate, Name, RecordType.Name, Client_Chart__c,Client_Chart__r.Name,Client_Chart__r.RecordType.Name,RecordTypeID, Due_Date_Time__c from Medical__c where RecordType.Name = 'Admit Order' AND Client_Chart__r.RecordType.Name =: RecordTypeName AND Status__c != 'Closed' AND Client_Chart__r.Client_Status__c =: 'Admitted'
                                AND Client_Chart__c IN : setOfHouseClientChart]){
              if(iMed.Due_Date_Time__c != null){
                  CalEvent cl = new CalEvent();
                  SDateTime = iMed.Due_Date_Time__c.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                  EDateTime = iMed.Due_Date_Time__c.addMinutes(20).format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                  cl.title = iMed.RecordType.Name + '-'+iMed.Client_Chart__r.Name;
                  cl.AllDay = false;
                  cl.startString = SDateTime;
                  cl.endString = EDateTime;
                  cl.url = '/apex/MedicalHomeEditPage?ID='+ clientChartID+'&mcid='+iMed.ID+'&editValue=0&rtId='+iMed.RecordTypeID+'&rt='+EncodingUtil.urlEncode(iMed.Client_Chart__r.RecordType.Name, 'UTF-8'); 
                  if(iMed.Due_Date_Time__c>dateTime.now()){
                      cl.className = 'event-personal';
                  }else{
                      cl.className = 'event-pastdue';
                  }
                  events.add(cl);
              }
        }
        
    }
    
    void ClinicaEvaluationRecord_PhsychEvaluation(){
        
        
          for(Clinical_Evaluation__c iCl : [Select ID ,CreatedDate, Name, Client_Chart__c,Client_Chart__r.Name,Client_Chart__r.RecordType.Name,RecordTypeID,RecordType.Name, Due_Date_Time__c from Clinical_Evaluation__c where RecordType.Name = 'Phsych Evaluation' AND Client_Chart__r.RecordType.Name =: RecordTypeName AND Status__c != 'Closed' AND Client_Chart__r.Client_Status__c =: 'Admitted'
                                             AND Client_Chart__c IN : setOfHouseClientChart]){
              if(iCl.Due_Date_Time__c != null){
                  CalEvent cl = new CalEvent();
                  SDateTime = iCl.Due_Date_Time__c.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                  EDateTime = iCl.Due_Date_Time__c.addMinutes(20).format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                  cl.title = iCl.RecordType.Name + '-' + iCl.Client_Chart__r.Name;
                  cl.AllDay = false;
                  cl.startString = SDateTime;
                  cl.endString = EDateTime;
                  cl.url = '/apex/PsychEvaluation?ID='+iCl.Client_Chart__c+'&ceId=' + iCl.ID+'&rt='+EncodingUtil.urlEncode(iCl.Client_Chart__r.RecordType.Name, 'UTF-8');
                  if(iCl.Due_Date_Time__c>dateTime.now()){
                      cl.className = 'event-personal';
                  }else{
                      cl.className = 'event-pastdue';
                  }
                  events.add(cl);
              }
        }
        
    }
    
    
    void ClinicaEvaluationRecord_History(){
        
        
          for(Clinical_Evaluation_3__c iCl : [Select ID ,CreatedDate, Name, Client_Chart__c,Client_Chart__r.Name,Client_Chart__r.RecordType.Name,RecordTypeID,RecordType.Name, Due_Date_Time__c from Clinical_Evaluation_3__c where (RecordType.Name = 'History And Physical' OR RecordType.Name = 'Phsych Evaluation') AND Client_Chart__r.RecordType.Name =: RecordTypeName AND HP_Status__c != 'Closed' AND Client_Chart__r.Client_Status__c =: 'Admitted'
                                             AND Client_Chart__c IN : setOfHouseClientChart]){
              if(iCl.Due_Date_Time__c != null){
                  CalEvent cl = new CalEvent();
                  SDateTime = iCl.Due_Date_Time__c.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                  EDateTime = iCl.Due_Date_Time__c.addMinutes(20).format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                  cl.title = iCl.RecordType.Name + '-' + iCl.Client_Chart__r.Name;
                  cl.AllDay = false;
                  cl.startString = SDateTime;
                  cl.endString = EDateTime;
                  cl.url = '/apex/CE_HP?ID='+ clientChartID+'&ceId='+iCl.ID+'&rt='+EncodingUtil.urlEncode(iCl.Client_Chart__r.RecordType.Name, 'UTF-8');
                  if(iCl.Due_Date_Time__c>dateTime.now()){
                      cl.className = 'event-personal';
                  }else{
                      cl.className = 'event-pastdue';
                  }
                  events.add(cl);
              }
        }
        
    }
    
    
    void LoadNursingRecord(){
        
        List<Id> orderIdList = new List<Id>();
        map<ID, List<Event>> mapOfEvent = new map<ID,List<Event>>();
        Map<ID,Order__c> mapOfOrder = new Map<ID,Order__c>();
        
        for(Order__c ord : [Select id,Client_Chart__r.Name,Client_Chart__c ,Client_Chart__r.RecordType.Name,Medical__r.name from order__c where Client_Chart__c  IN : setOfHouseClientChart AND Status__c != 'Inactive'
                             AND ((Taper__c !=: Null AND Taper__r.Dosage_Type__c !=: 'Open Ended') OR (Taper__c =: Null AND PRN__c =: FALSE))]){
            orderIdList.add(ord.id);
            mapOfOrder.put(ord.ID, ord);
        }
        for(Event iVt : [Select id,StartDateTime,EndDateTime,Subject,Description,RecordType.Name ,WhatId, Medicine__r.Name, Strength__c 
                        from event where recordtype.name =: 'MARs' AND (Status__c =: 'Open' OR Status__c =: 'Pending')
                        AND Client_Chart__c  IN : setOfHouseClientChart AND WhatId IN: orderIdList]){
                        
            if(mapOfEvent.ContainsKey(iVt.WhatID)){
                mapOfEvent.get(iVt.WhatID).add(iVt);
            }
            else
                mapOfEvent.put(iVt.WhatID, new List<Event> { iVt } );
        }
        
        
        for(string keys : mapOfEvent.keySet()){
            
            for(Event iVt : mapOfEvent.get(keys))
            {
                Order__c Ord = mapOfOrder.get(iVt.WhatID);
              
                SDateTime = iVt.StartDateTime.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                EDateTime = iVt.EndDateTime.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                   
                
                
                CalEvent cl = new CalEvent();
                //cl.title = Ord.Medical__r.name+'-'+Ord.Client_Chart__r.Name;
                cl.title = iVt.Medicine__r.Name+'-'+iVt.Strength__c+'-'+Ord.Client_Chart__r.Name;
                cl.AllDay = false;
                cl.startString = SDateTime;
                cl.endString = EDateTime;
                cl.url = '/apex/MedsHomePage?ID='+ Ord.Client_Chart__c+'&rt='+EncodingUtil.urlEncode(Ord.Client_Chart__r.RecordType.Name, 'UTF-8');
                if(iVt.StartDateTime>dateTime.now()){
                    cl.className = 'event-personal';
                }else{
                    cl.className = 'event-pastdue';
                }
                events.add(cl);
            }
           
        }
        
    }
    
     
    

    public PageReference pageLoad() {

           Set<ID> setOfRoom = new Set<ID>();
         
         SYSTEM.DEBUG('&&&&' +selectHouse);
         
        for(Bed_Board_Configuration__c bd : [Select ID from Bed_Board_Configuration__c Where House__c =: selectHouse]){
            
            setOfRoom.add(bd.ID);
        }
        
        
     
        SYSTEM.DEBUG('####' + setOfRoom);
        if(setOfRoom.isEmpty())
          return null;
          
        
        Set<ID> setOfBed = new Set<ID>();
        
        for(Bed_Board_Configuration__c iRoom :[Select ID from Bed_Board_Configuration__c Where Room__c IN : setOfRoom]){
            
            setOfBed.add(iRoom.ID);
        }
   
       SYSTEM.DEBUG('####' + setOfBed);
        
        if(setOfBed.isEmpty())
             return null;
        
        setOfHouseClientChart = new Set<ID>();
        
        for(UtlizationReviewOrder__c util :[Select id,Client_Chart__c,Bed__c from UtlizationReviewOrder__c
                                            where Bed__c IN :setOfBed AND (Status__c =: 'Active' OR Status__c =: 'Future Reservation') ]){
                                                
        
                  setOfHouseClientChart.add(util.Client_Chart__c);                                  
        }
     
        getEvent_Mars();
       
        system.debug('#####' + events);

      
        return null;

    }
    
    

   /* public PageReference toggleMyEvents() {

        if(includeMyEvents){

            includeMyEvents = false;

        }

        else{

            includeMyEvents = true;

        }

        pageload();

        return null;

    }*/



    

    //Class to hold calendar event data

    public class calEvent{

        public String title {get;set;}

        public Boolean allDay {get;set;}

        public String startString {get;private set;}

        public String endString {get;private set;}

        public String url {get;set;}

        public String className {get;set;}

    }

}