/*
Test class : CalendarCtrlTest
*/
public class CalendarCtrl{



    public Boolean includeMyEvents {get;set;}

    public list<calEvent> events {get;set;}
     Set<ID> setOfHouseClientChart;
    
      Set<ID> setOfClientChartID;
      public string selectOption {get;set;}
      public string selectHouse {get;set;}
      
      public List<selectoption> houseLst {get;set;} 

    

    //The calendar plugin is expecting dates is a certain format. We can use this string to get it formated correctly

    String dtFormat = 'EEE, d MMM yyyy HH:mm:ss z';
    User currentUser ;
    string SDateTime;
    string EDateTime;
     string RecordTypeName;

    

    //constructor

    public CalendarCtrl() {

        //Default showing my events to on
        
        currentUser = [Select TimeZoneSidKey from User where id =: USerInfo.getUserId() limit 1]; 
         RecordTypeName = ApexPages.currentPage().getParameters().get('rt');
          system.debug('#####' + events);
        includeMyEvents = true;
        SelectOption = 'MyClientChart';
        
           houseLst = new List<SelectOption>();
         houseLst.add(new SelectOption('','--None--'));
        for(Bed_Board_Configuration__c iBed : [Select id ,name,Sunshine_Center__r.Name from Bed_Board_Configuration__c where Sunshine_Center__r.Name=: RecordTypeName
                                                AND House_Name__c != '']){
            
                houseLst.add(new SelectOption(iBed.ID,iBed.Name));
        }
       
      
    }
    
  
    
    //Action method
    public PageReference pageLoad() {

           LoadCalendar();
        if(selectOption == 'UnderReviewDocs'){
            
            
            getTxDcPlans_ReviewPending();
            ClincialEvaluation_ReviewPending();
            //GetGroupSessions_ReviewPending();
            GetGroupIndividualAppointment_PendinReview();
            
            
              return null;
        }
         
   
        getTxDcPlans_Open();
        getTxDcPlans_Active();
        ClincialEvaluation();
        GetGroupSessions();
        GetGroupIndividualAppointment();
        GetUtilizationReview();
        
        system.debug('#####' + events);

      
        return null;

    }
    
     public void LoadCalendar(){
        
        currentUser = [Select TimeZoneSidKey from User where id =: USerInfo.getUserId()]; 
        events = new list<calEvent>();
        if(selectHouse == '') return;
        Set<ID> setOfRoom = new Set<ID>();
        for(Bed_Board_Configuration__c bd : [Select ID from Bed_Board_Configuration__c Where House__c =: selectHouse]){
            
            setOfRoom.add(bd.ID);
        }
        
        
     
        SYSTEM.DEBUG('####' + setOfRoom);
        if(setOfRoom.isEmpty())
          return;
          
        
        Set<ID> setOfBed = new Set<ID>();
        
        for(Bed_Board_Configuration__c iRoom :[Select ID from Bed_Board_Configuration__c Where Room__c IN : setOfRoom]){
            
            setOfBed.add(iRoom.ID);
        }
   
      
        
        if(setOfBed.isEmpty())
            return;
        
         setOfHouseClientChart = new Set<ID>();
        
        for(UtlizationReviewOrder__c util :[Select id,Client_Chart__c,Bed__c from UtlizationReviewOrder__c
                                            where Bed__c IN :setOfBed AND (Status__c =: 'Active' OR Status__c =: 'Future Reservation')]){
                                                
        
                  setOfHouseClientChart.add(util.Client_Chart__c);                                  
        }
       
        setOfClientChartID = new Set<ID>();
        
        if(selectOption == 'MyClinicalCalendar'){
            
            
            for(Client_Chart__c cl : [Select ID from Client_Chart__c where Primary_Therapist__c =: USerInfo.getUserId() AND RecordType.Name =: RecordTypeName AND Client_Status__c =: 'Admitted' AND ID IN :setOfHouseClientChart]){
                setOfClientChartID.add(cl.ID);    
                
            }
        
            return;
        }
        
        for(Client_Chart__c iCl : [Select ID from Client_Chart__c where RecordType.Name =: RecordTypeName AND Client_Status__c =: 'Admitted' AND ID IN :setOfHouseClientChart])
            setOfClientChartID.add(iCl.ID);
        
        
     
        
        
      
    }
    
    
     void getTxDcPlans_ReviewPending(){
        
      
        for(Tx_and_D_C_Plans__c iTxDx : [Select ID,RecordType.Name,Date_Time__c,Date__c,Client_Chart__c, Client_Chart__r.RecordType.Name ,
                        Client_Chart__r.Name, Due_Date_time__c from Tx_and_D_C_Plans__c
                        where Client_Chart__r.RecordType.Name =: RecordTypeName AND Client_Chart__c IN: setOfClientChartID AND 
                        Status__c = 'Review Pending']){
            
            if(iTxDx.Due_Date_time__c != null){
                SDateTime = iTxDx.Due_Date_time__c.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                EDateTime = iTxDx.Due_Date_time__c.addMinutes(20).format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                   
                
                CalEvent cl = new CalEvent();
                cl.title = iTxDx.RecordType.Name +'-'+iTxDx.Client_Chart__r.Name;
                cl.AllDay = false;
                cl.startString = SDateTime;
                cl.endString = EDateTime;
                cl.url = '/apex/TxDcDetailPage?ID=' + iTxDx.Client_Chart__c + '&TXDX='+ iTxDx.ID+'&rt='+EncodingUtil.urlEncode(iTxDx.Client_Chart__r.RecordType.Name, 'UTF-8');
                if(iTxDx.Due_Date_time__c>dateTime.Now())
                    cl.className = 'event-personal';
                else
                    cl.className = 'event-pastdue';
                events.add(cl);
            }
           
        }
        
     
    }
    
     void ClincialEvaluation_ReviewPending(){
        
          for(Clinical_Evaluation_3__c iCu : [Select ID,RecordType.Name, Clinical_Evaluation_2__c, Due_Date_Time__c,Client_Chart__c,Client_Chart__r.Name
                                            from Clinical_Evaluation_3__c where
                                            HP_Status__c = 'Review Pending' AND Client_Chart__c IN: setOfClientChartID]){
              if(iCu.Due_Date_Time__c != null){
                    SDateTime = iCu.Due_Date_Time__c.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                    EDateTime = iCu.Due_Date_Time__c.addMinutes(20).format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                  //     lstJsonStruc.add(new JsonStructure(iCu.ID, iCu.RecordType.Name,SDateTime,EDateTime, iCu.Client_Chart__c ,'ClinicalEvaluationDetailPage','ceId'));
                  
                    CalEvent cl = new CalEvent();
                    cl.title = iCu.RecordType.Name +'-'+iCu.Client_Chart__r.Name;
                    cl.AllDay = false;
                    cl.startString = SDateTime;
                    cl.endString = EDateTime;
                    cl.Url = '/apex/ClinicalEvaluationDetailPage?ID='+iCu.Client_Chart__c+'&ceId='+iCu.Clinical_Evaluation_2__c+'&type='+iCu.RecordType.Name+'&rt='+EncodingUtil.urlEncode(RecordTypeName, 'UTF-8');
                    if(iCu.Due_Date_Time__c>dateTime.now()){
                        cl.className = 'event-personal';
                    }else{
                        cl.className = 'event-pastdue';
                    }
                    events.add(cl);
                    
                }
            }
          
           
        }
    
    //Update for FREEP-411
    //Commented out as part of Update in logic, where by Supervisor Donot Need to Review Group Sessions. Interns and Counsellors can close out there own Groups    
    /*void GetGroupSessions_ReviewPending(){
        List<Group_Therapy_Session__c> gtsList = new List<Group_Therapy_Session__c>();
        
       
            for(Group_Therapy_Session__c iGrp: [Select id,Name, End_Time__c,Start_Time__c,Date__c ,
                                            RecordType.Name from Group_Therapy_Session__c where Status__c = 'Review Pending' AND 
                                             RecordType.Name =: RecordTypeName AND House__c =: selectHouse]){
                gtsList.add(iGrp);
            }
        
        
        if(!gtsList.isEmpty()){
            for(Group_Therapy_Session__c iGrp: gtsList){
                
                 DateTime sDateT = DateTime.newInstance(iGrp.Date__c.Year(), iGrp.Date__c.Month(), iGrp.Date__c.Day(), integer.valueOf(iGrp.Start_Time__c.split(':')[0]), integer.valueOf(iGrp.Start_Time__c.split(':')[1].split(' ')[0]), 0);
                 DateTime eDateT = DateTime.newInstance(iGrp.Date__c.Year(), iGrp.Date__c.Month(), iGrp.Date__c.Day(), integer.valueOf(iGrp.End_Time__c.split(':')[0]), integer.valueOf(iGrp.End_Time__c.split(':')[1].split(' ')[0]), 0);
                 SDateTime = sDateT.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                 EDateTime = eDateT.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                
                 CalEvent cl = new CalEvent();
                    cl.title = iGrp.Name;
                    cl.AllDay = false;
                    cl.startString = SDateTime;
                    cl.endString = EDateTime;
                    cl.Url = '/apex/SessionGroupDetail?id='+iGrp.ID+'&mode=readOnly&rt='+EncodingUtil.urlEncode(RecordTypeName, 'UTF-8');
                    cl.className = 'event-personal';
                    if(sDateT>DateTime.Now()){
                        cl.className = 'event-personal';
                    }else{
                        cl.className = 'event-pastdue';
                    }
                    events.add(cl);
                                                        
            }
        }
        
    }
    */
     void GetGroupIndividualAppointment_PendinReview(){
        
        
        for(Clinical_Note__c iCl: [Select ID, Client_Chart__r.Name, client_chart__c,RecordType.Name,Start_Date_Time__c from Clinical_Note__c where Client_Chart__c IN : setOfClientChartID AND Status__c = 'Ready for Review']){
            
             if(iCl.Start_Date_Time__c  == null) continue;
             SDateTime = iCl.Start_Date_Time__c.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
             EDateTime = iCl.Start_Date_Time__c.addHours(3).format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
            
             CalEvent cl = new CalEvent();
                cl.title = iCl.RecordType.Name +'-'+iCl.Client_Chart__r.Name;
                cl.AllDay = false;
                cl.startString = SDateTime;
                cl.endString = EDateTime;
                cl.Url = '/apex/ClinicalNotesDetail?ID='+iCl.client_chart__c+'&clNID='+iCl.ID+'&rt='+EncodingUtil.urlEncode(RecordTypeName, 'UTF-8');
                if(iCl.Start_Date_Time__c>DateTime.Now()){
                    cl.className = 'event-personal';
                }else{
                    cl.className = 'event-pastdue';
                }
                events.add(cl);
                                                    
        }
        
    }
    
  
    void getTxDcPlans_Open(){
        
      
        for(Tx_and_D_C_Plans__c iTxDx : [Select ID,RecordType.Name,Date_Time__c,Date__c,Client_Chart__c, Client_Chart__r.RecordType.Name ,Client_Chart__r.Name, Due_Date_time__c from Tx_and_D_C_Plans__c where Client_Chart__r.RecordType.Name =: RecordTypeName AND Client_Chart__c IN: setOfClientChartID AND Status__c != 'Closed' AND Status__c != 'In Use']){
            
            if(iTxDx.Due_Date_time__c != null){
                SDateTime = iTxDx.Due_Date_time__c.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                EDateTime = iTxDx.Due_Date_time__c.addMinutes(20).format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                   
                
                CalEvent cl = new CalEvent();
                cl.title = iTxDx.RecordType.Name +'-'+iTxDx.Client_Chart__r.Name;
                cl.AllDay = false;
                cl.startString = SDateTime;
                cl.endString = EDateTime;
                cl.url = '/apex/TxDcDetailPage?ID=' + iTxDx.Client_Chart__c + '&TXDX='+ iTxDx.ID+'&rt='+EncodingUtil.urlEncode(iTxDx.Client_Chart__r.RecordType.Name, 'UTF-8');
                if(iTxDx.Due_Date_time__c>dateTime.Now())
                    cl.className = 'event-personal';
                else
                    cl.className = 'event-pastdue';
                events.add(cl);
            }
           
        }
        
     
    }
    
     void getTxDcPlans_Active(){
        
        Set<ID> setTask = new Set<ID>();
        Set<ID> setDetoxID = new Set<ID>();
        Map<ID,Detox_Objectives__c> mapTaskID = new Map<ID,Detox_Objectives__c>();
        
        for(Tx_and_D_C_Plans__c iTxDx : [Select ID,RecordType.Name,Date_Time__c,Date__c,Client_Chart__c, Client_Chart__r.RecordType.Name from Tx_and_D_C_Plans__c where Client_Chart__r.RecordType.Name =: RecordTypeName AND Client_Chart__c IN: setOfClientChartID AND Status__c =: 'In Use']){
            setDetoxID.add(iTxDx.ID);
        }
        for(Detox_Objectives__c dtxObj : [Select ID,Master_Problem__r.Tx_and_D_C_Plans__c,Master_Problem__r.Tx_and_D_C_Plans__r.RecordType.Name,Master_Problem__r.Tx_and_D_C_Plans__r.Client_Chart__c,Master_Problem__r.Tx_and_D_C_Plans__r.Client_Chart__r.Name,Master_Problem__c, Tx_and_D_C_Plans__c, 
                                          Tx_and_D_C_Plans__r.Client_Chart__r.Name, Tx_and_D_C_Plans__r.Client_Chart__c, Tx_and_D_C_Plans__r.RecordType.Name from Detox_Objectives__c where Master_Problem__r.Tx_and_D_C_Plans__c IN :setDetoxID OR Tx_and_D_C_Plans__c IN :setDetoxID]){
            mapTaskID.put(dtxObj.ID,dtxObj);
            
        }
       //   system.debug('test$$$$$$'  +setTask);
        for(Task iEvt : [Select ID, WhatID,Subject, RecordType.Name,Status, ActivityDate,CreatedDate from Task where WhatID in : mapTaskID.keySet() AND Status =: 'Open' AND ActivityDate !=: null]){
            system.debug('test$$$$$$');
            Date eDate = iEvt.ActivityDate;
            DateTime eNewDateTime = DateTime.newInstance(eDate.year(),eDate.month(),eDate.day());
            SDateTime = eNewDateTime.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
            EDateTime = eNewDateTime.addMinutes(20).format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
              
            CalEvent cl = new CalEvent();
            if(mapTaskID.get(iEvt.WhatID).Master_Problem__c != null){
                cl.title = 'Target For '+mapTaskID.get(iEvt.WhatID).Master_Problem__r.Tx_and_D_C_Plans__r.RecordType.Name+', for : '+mapTaskID.get(iEvt.WhatID).Master_Problem__r.Tx_and_D_C_Plans__r.Client_Chart__r.Name;
                cl.url = '/apex/TxDcDetailPage?ID=' +mapTaskID.get(iEvt.WhatID).Master_Problem__r.Tx_and_D_C_Plans__r.Client_Chart__c+ '&TXDX='+mapTaskID.get(iEvt.WhatID).Master_Problem__r.Tx_and_D_C_Plans__c+'&rt='+EncodingUtil.urlEncode(RecordTypeName, 'UTF-8');
            }
            if(mapTaskID.get(iEvt.WhatID).Tx_and_D_C_Plans__c != null){
                cl.title = 'Target For '+mapTaskID.get(iEvt.WhatID).Tx_and_D_C_Plans__r.RecordType.Name+', for : '+mapTaskID.get(iEvt.WhatID).Tx_and_D_C_Plans__r.Client_Chart__r.Name;
                cl.url = '/apex/TxDcDetailPage?ID=' +mapTaskID.get(iEvt.WhatID).Tx_and_D_C_Plans__r.Client_Chart__c+ '&TXDX='+mapTaskID.get(iEvt.WhatID).Tx_and_D_C_Plans__c+'&rt='+EncodingUtil.urlEncode(RecordTypeName, 'UTF-8');
            }
            cl.AllDay = false;
            cl.startString = SDateTime;
            cl.endString = EDateTime;
            if(eNewDateTime>dateTime.now()){
                cl.className = 'event-personal';
            }else{
                cl.className = 'event-pastdue';
            }
            events.add(cl);
            
        }
        
        
        
     
    }
    
   
    void ClincialEvaluation(){
        
          for(Clinical_Evaluation__c iCu : [Select ID,RecordType.Name, Due_Date_Time__c,Client_Chart__c,Client_Chart__r.Name from Clinical_Evaluation__c where Client_Chart__r.RecordType.Name =: RecordTypeName AND Status__c != 'Closed' AND Client_Chart__c IN: setOfClientChartID]){
              if(iCu.Due_Date_Time__c != null){
                    SDateTime = iCu.Due_Date_Time__c.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                    EDateTime = iCu.Due_Date_Time__c.addMinutes(20).format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                  //     lstJsonStruc.add(new JsonStructure(iCu.ID, iCu.RecordType.Name,SDateTime,EDateTime, iCu.Client_Chart__c ,'ClinicalEvaluationDetailPage','ceId'));
                  
                    CalEvent cl = new CalEvent();
                    cl.title = iCu.RecordType.Name +'-'+iCu.Client_Chart__r.Name;
                    cl.AllDay = false;
                    cl.startString = SDateTime;
                    cl.endString = EDateTime;
                    cl.Url = '/apex/ClinicalEvaluationDetailPage?ID='+iCu.Client_Chart__c+'&ceId='+iCu.ID+'&type='+iCu.RecordType.Name+'&rt='+EncodingUtil.urlEncode(RecordTypeName, 'UTF-8');
                    if(iCu.Due_Date_Time__c>dateTime.now()){
                        cl.className = 'event-personal';
                    }else{
                        cl.className = 'event-pastdue';
                    }
                    events.add(cl);
                    
                }
            }
          
           
        }
        
    
    void GetGroupSessions(){
        List<Group_Therapy_Session__c> gtsList = new List<Group_Therapy_Session__c>();
        
        if(selectOption == 'MyClinicalCalendar'){
            for(Group_Therapy_Session__c iGrp: [Select id,Name, End_Time__c,Start_Time__c,Date__c ,RecordType.Name from
                                             Group_Therapy_Session__c where Status__c != 'Completed' AND 
                                              RecordType.Name =: RecordTypeName AND OwnerId =: UserInfo.getUserId()
                                              AND House__c =: selectHouse]){
                gtsList.add(iGrp);
            }
        }else{
            for(Group_Therapy_Session__c iGrp: [Select id,Name, End_Time__c,Start_Time__c,Date__c ,
                                            RecordType.Name from Group_Therapy_Session__c where Status__c != 'Completed' AND 
                                             RecordType.Name =: RecordTypeName AND House__c =: selectHouse]){
                gtsList.add(iGrp);
            }
        }
        
        if(!gtsList.isEmpty()){
            for(Group_Therapy_Session__c iGrp: gtsList){
                
                 boolean isPm = false;
                 integer hour = 0 ;
                 hour = integer.valueOf(iGrp.Start_Time__c.split(':')[0]);
                 isPm = iGrp.Start_Time__c.split(':')[1].split(' ')[1] == 'PM';
                 if(isPm && hour != 12)// not made any change for noon hours 
                    hour += 12;
                
                if(!isPm && hour == 12) // for 12 midnight
                    hour = 0;
                    
                 DateTime sDateT = DateTime.newInstance(iGrp.Date__c.Year(), iGrp.Date__c.Month(), iGrp.Date__c.Day(),hour, integer.valueOf(iGrp.Start_Time__c.split(':')[1].split(' ')[0]), 0);
                    
                
                 hour = 0;
                 
                 hour = integer.valueOf(iGrp.End_Time__c.split(':')[0]);
                 isPm = iGrp.End_Time__c.split(':')[1].split(' ')[1] == 'PM';
                  if(isPm && hour != 12)// not made any change for noon hours 
                    hour += 12;
                
                 if(!isPm && hour == 12) // for 12 midnight
                    hour = 0;
                
                 DateTime eDateT = DateTime.newInstance(iGrp.Date__c.Year(), iGrp.Date__c.Month(), iGrp.Date__c.Day(), hour, integer.valueOf(iGrp.End_Time__c.split(':')[1].split(' ')[0]), 0);
                 SDateTime = sDateT.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                 EDateTime = eDateT.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                
                 CalEvent cl = new CalEvent();
                    cl.title = iGrp.Name;
                    cl.AllDay = false;
                    cl.startString = SDateTime;
                    cl.endString = EDateTime;
                    cl.Url = '/apex/SessionGroupDetail?id='+iGrp.ID+'&mode=readOnly&rt='+EncodingUtil.urlEncode(RecordTypeName, 'UTF-8');
                    cl.className = 'event-personal';
                    if(sDateT>DateTime.Now()){
                        cl.className = 'event-personal';
                    }else{
                        cl.className = 'event-pastdue';
                    }
                    events.add(cl);
                                                        
            }
        }
        
    }
    
      void GetUtilizationReview(){
          
          Id CRRecordTypeId = Constants.ConcurrentReviewRecordTypeId;
            DateTime SDateTime;
            DateTime EDateTime;
          
          for(Utilization_Review__c ur : [Select ID,RecordType.Name, Next_Review_Date__c, Client_Chart__c, Client_Chart__r.Name, CreatedDate from Utilization_Review__c where Client_Chart__c IN: setOfHouseClientChart AND RecordTypeId =: CRRecordTypeId
                                           AND Status__c = 'Review Pending']){
              if(ur.Next_Review_Date__c != null){
                  
                  SDateTime = dateTime.NewInstance(ur.Next_Review_Date__c.year(),ur.Next_Review_Date__c.month(),ur.Next_Review_Date__c.day(),9,0,0);
                  EDateTime = dateTime.NewInstance(ur.Next_Review_Date__c.year(),ur.Next_Review_Date__c.month(),ur.Next_Review_Date__c.day(),9,20,0);
                
                  
                  CalEvent cl = new CalEvent();
                  cl.title = ur.RecordType.Name+'-'+ur.Client_Chart__r.Name;
                  cl.AllDay = false;
                  cl.startString = string.valueOf(SDateTime);
                  cl.endString = string.valueOf(EDateTime);
                  cl.Url = '/apex/UtilizationReviewHomePage?ID='+ur.Client_Chart__c+'&rt='+EncodingUtil.urlEncode(RecordTypeName, 'UTF-8');
                  if(EDateTime>dateTime.now()){
                      cl.className = 'event-personal';
                  }else{
                      cl.className = 'event-pastdue';
                  }
                  events.add(cl);
              }
          }  
          
          
    }
        
    
    void GetGroupIndividualAppointment(){
        
        
        for(Clinical_Note__c iCl: [Select ID, Client_Chart__r.Name, client_chart__c,RecordType.Name,Start_Date_Time__c from Clinical_Note__c where Client_Chart__c IN : setOfClientChartID AND Status__c !=: 'Closed']){
            
             if(iCl.Start_Date_Time__c  == null) continue;
             SDateTime = iCl.Start_Date_Time__c.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
             EDateTime = iCl.Start_Date_Time__c.addHours(3).format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
            
             CalEvent cl = new CalEvent();
                cl.title = iCl.RecordType.Name +'-'+iCl.Client_Chart__r.Name;
                cl.AllDay = false;
                cl.startString = SDateTime;
                cl.endString = EDateTime;
                cl.Url = '/apex/ClinicalNotesDetail?ID='+iCl.client_chart__c+'&clNID='+iCl.ID+'&rt='+EncodingUtil.urlEncode(RecordTypeName, 'UTF-8');
                if(iCl.Start_Date_Time__c>DateTime.Now()){
                    cl.className = 'event-personal';
                }else{
                    cl.className = 'event-pastdue';
                }
                events.add(cl);
                                                    
        }
        
    }
    
   

  /*  public PageReference toggleMyEvents() {

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