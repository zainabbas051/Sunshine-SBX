/*
Test class : CalendarCtrl_OperationsTest
*/
public class CalendarCtrl_Operations{



    public Boolean includeMyEvents {get;set;}

    public list<calEvent> events {get;set;}
    public string selectHouse {get;set;}
    public List<selectoption> houseLst {get;set;} 
    Set<ID> setOfHouseClientChart;
   
    User currentUser ;
    string SDateTime;
    string EDateTime;
     string RecordTypeName;
     
      //AWS
    public string accessKeyId {
        get;
        set;
    }
    public string secretAccessKey {
        get;
        set;
    }
    public string OrgName {
        get;
        set;
    }
    
   
     final string AWSURL;

    

    //constructor

    public CalendarCtrl_Operations() {

        //Default showing my events to on
        	accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        
        
        currentUser = [Select TimeZoneSidKey from User where id =: USerInfo.getUserId() limit 1]; 
          system.debug('#####' + events);
        includeMyEvents = true;
        RecordTypeName = ApexPages.currentPage().getParameters().get('rt');
        
      //Edited by Safia Osman  
        houseLst = new List<SelectOption>();
         houseLst.add(new SelectOption('','--None--'));
        for(Bed_Board_Configuration__c iBed : [Select id ,name,Sunshine_Center__r.Name from Bed_Board_Configuration__c where Sunshine_Center__r.Name=: RecordTypeName
                                                AND House_Name__c != '']){
            
                houseLst.add(new SelectOption(iBed.ID,iBed.Name));
        }
      
         
        
          
       
    }
    
    
    void getRecurringAssesment(){
        
     
        
     
        for(Recurring_Assessment__c iRc : [Select id,createdDate,name,recordtype.DeveloperName,recordtype.name,Client_Chart__c,
                                        Client_Chart__r.RecordType.Name,Client_Chart__r.Name, Time_Due__c
                                        from Recurring_Assessment__c where Status__c != 'Closed' 
                                        AND Client_Chart__r.RecordType.Name =: RecordTypeName AND 
                                        Client_Chart__c IN: setOfHouseClientChart AND Client_Chart__r.Client_Status__c =: 'Admitted']){
             SYSTEM.DEBUG('####' + iRc);
            if(iRc.Time_Due__c != null){
                SDateTime = iRc.Time_Due__c.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                EDateTime = iRc.Time_Due__c.AddMinutes(20).format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                
                CalEvent cl = new CalEvent();
                cl.title = iRc.recordtype.name+'-'+iRc.Client_Chart__r.Name;
                cl.AllDay = false;
                cl.startString = SDateTime;
                cl.endString = EDateTime;
                cl.ClientChartID = iRc.Client_Chart__c;
                
                if(iRc.RecordType.DeveloperName == 'Vital_Signs')
                    cl.url = '/apex/VitalSignsVfp?ID='+iRc.Client_Chart__c;
                
                if(iRc.RecordType.DeveloperName == 'CIWA')
                    cl.url = '/apex/CIWAVfp?id='+iRc.Client_Chart__c;
                
                if(iRc.RecordType.DeveloperName == 'COWS')
                    cl.url = '/apex/COWSVFp?id='+iRc.Client_Chart__c;
                
                if(iRc.RecordType.DeveloperName == 'Detox_Check')
                    cl.url = '/apex/DetoxCheck?id='+iRc.Client_Chart__c;
                
                if(iRc.RecordType.DeveloperName == 'Blood_Glucose')
                    cl.url = '/apex/BloodGlucoseVfp?id='+iRc.Client_Chart__c;
                
                if(iRc.RecordType.DeveloperName == 'BMI')
                    cl.url = '/apex/BMIVFP?id='+iRc.Client_Chart__c;
                    
                 if(iRc.RecordType.DeveloperName == 'Wellness_Check')
                    cl.url = '/apex/WellnessCheck?id='+iRc.Client_Chart__c;
                
                cl.url = cl.url+'&rt='+EncodingUtil.urlEncode(iRc.Client_Chart__r.RecordType.Name, 'UTF-8');    
                if(iRc.Time_Due__c>dateTime.now()){
                    cl.className = 'event-personal';
                }else{
                    cl.className = 'event-pastdue';
                }
                events.add(cl);
            }
        }
    }
    
    
    void getIntakeRecords(){
        
          
         integer i =0;
         for(Intake_Forms__c iRc : [Select id,createdDate,name,recordtype.name,Client_Chart__c, 
         Client_Chart__r.RecordType.Name,Client_Chart__r.Name, Due_Date_Time__c
         from Intake_Forms__c where Status__c != 'Closed' AND Status__c != 'Active' AND Client_Chart__r.RecordType.Name =: RecordTypeName 
         AND Client_Chart__c IN: setOfHouseClientChart AND Client_Chart__r.Client_Status__c =: 'Admitted']){
           
           system.debug('%%%%%%%' );
            //SDateTime = iRc.createdDate.AddDays(i).format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
            //EDateTime = iRc.createdDate.AddDays(i).AddHours(3).format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
            i++;   
            
            if(iRc.Due_Date_Time__c != null){
            
                SDateTime = iRc.Due_Date_Time__c.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                EDateTime = iRc.Due_Date_Time__c.AddMinutes(30).format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                
                
                CalEvent cl = new CalEvent();
                cl.title = iRc.Client_Chart__r.Name+'-'+iRc.recordtype.name;
                cl.AllDay = false;
                cl.startString = SDateTime;
                cl.endString = EDateTime;
                cl.url = '/apex/IntakePageDetail?ID='+iRc.Client_Chart__c+'&Intake='+iRc.ID+'&rt='+EncodingUtil.urlEncode(iRc.Client_Chart__r.RecordType.Name, 'UTF-8');
                
                if(iRc.Due_Date_Time__c>dateTime.now()){
                    cl.className = 'event-personal';
                }else{
                    cl.className = 'event-pastdue';
                }
                events.add(cl);
                //cl.className = 'event-pastdue';
            }
        }
        
    }
    
    
    void getDrugScreen_Urine(){
        
        for(Medical__c iRc : [Select id,createdDate,name,recordtypeId,recordtype.name,Client_Chart__c,Client_Chart__r.RecordType.Name,Client_Chart__r.Name, Due_Date_Time__c from Medical__c where Status__c != 'Closed' AND (RecordType.Name = 'BAC and Drug Screen' OR RecordType.Name = 'Urine Pregnancy Test') AND Client_Chart__r.RecordType.Name =: RecordTypeName AND Client_Chart__c IN: setOfHouseClientChart AND Client_Chart__r.Client_Status__c =: 'Admitted']){
           
            //SDateTime = iRc.createdDate.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
            //EDateTime = iRc.createdDate.AddMinutes(10).format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                
            if(iRc.Due_Date_Time__c != null){
                SDateTime = iRc.Due_Date_Time__c.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                EDateTime = iRc.Due_Date_Time__c.AddMinutes(30).format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                
                
                CalEvent cl = new CalEvent();
                cl.title = iRc.recordtype.name+'-'+iRc.Client_Chart__r.Name;
                cl.AllDay = false;
                cl.startString = SDateTime;
                cl.endString = EDateTime;
                cl.url = '/apex/MedicalHomeEditPage?ID='+iRc.Client_Chart__c+'&rtId='+iRc.recordTypeId+'&mcid='+iRc.ID+'&editValue=0&rt='+EncodingUtil.urlEncode(iRc.Client_Chart__r.RecordType.Name, 'UTF-8');
                if(iRc.Due_Date_Time__c>dateTime.now()){
                    cl.className = 'event-personal';
                }else{
                    cl.className = 'event-pastdue';
                }
                events.add(cl);
            }
        }
        
    }
    
     void LoadHouseClientChart(){
        
         Set<ID> setOfRoom = new Set<ID>();
         
         SYSTEM.DEBUG('&&&&' +selectHouse);
         
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
   
       SYSTEM.DEBUG('####' + setOfBed);
        
        if(setOfBed.isEmpty())
            return;
        
        setOfHouseClientChart = new Set<ID>();
        
        for(UtlizationReviewOrder__c util :[Select id,Client_Chart__c,Bed__c from UtlizationReviewOrder__c
                                            where Bed__c IN :setOfBed AND (Status__c =: 'Active' OR Status__c =: 'Future Reservation')]){
                                                
        
                  setOfHouseClientChart.add(util.Client_Chart__c);                                  
        }
        
        SYSTEM.DEBUG('####' + setOfHouseClientChart);
        
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
                  cl.url = '/apex/MedicalHomeEditPage?ID='+ iMed.Client_Chart__c+'&mcid='+iMed.ID+'&editValue=0&rtId='+iMed.RecordTypeID+'&rt='+EncodingUtil.urlEncode(iMed.Client_Chart__r.RecordType.Name, 'UTF-8'); 
                  if(iMed.Due_Date_Time__c>dateTime.now()){
                      cl.className = 'event-personal';
                  }else{
                      cl.className = 'event-pastdue';
                  }
                  events.add(cl);
              }
        }
        
    }
    
    void ClinicaEvaluationRecord_Face2Face(){
        
        
          for(Clinical_Evaluation__c iCl : [Select ID ,CreatedDate, Name, Client_Chart__c,Client_Chart__r.Name,Client_Chart__r.RecordType.Name,RecordTypeID,RecordType.Name, Due_Date_Time__c from Clinical_Evaluation__c where RecordType.Name = 'Face to Face Evaluation' AND Client_Chart__r.RecordType.Name =: RecordTypeName AND Status__c != 'Closed' AND Client_Chart__r.Client_Status__c =: 'Admitted'
                                             AND Client_Chart__c IN : setOfHouseClientChart]){
              if(iCl.Due_Date_Time__c != null){
                  CalEvent cl = new CalEvent();
                  SDateTime = iCl.Due_Date_Time__c.format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                  EDateTime = iCl.Due_Date_Time__c.addMinutes(20).format('yyyy/MM/dd HH:mm:ss', currentUser.TimeZoneSidKey);
                  cl.title = iCl.RecordType.Name + '-' + iCl.Client_Chart__r.Name;
                  cl.AllDay = false;
                  cl.startString = SDateTime;
                  cl.endString = EDateTime;
                  cl.url = '/apex/ClinicalEvaluationDetailPage?ID='+iCl.Client_Chart__c+'&ceId='+iCl.ID+'&type='+iCl.RecordType.Name+'&rt='+EncodingUtil.urlEncode(RecordTypeName, 'UTF-8');
                  if(iCl.Due_Date_Time__c>dateTime.now()){
                      cl.className = 'event-personal';
                  }else{
                      cl.className = 'event-pastdue';
                  }
                  events.add(cl);
              }
        }
        
    }
    
   /* void ClinicaEvaluationRecord_PhsychEvaluation(){
        
        
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
                  cl.url = '/apex/CE_HP?ID='+ iCl.Client_Chart__c+'&ceId='+iCl.ID+'&rt='+EncodingUtil.urlEncode(iCl.Client_Chart__r.RecordType.Name, 'UTF-8');
                  if(iCl.Due_Date_Time__c>dateTime.now()){
                      cl.className = 'event-personal';
                  }else{
                      cl.className = 'event-pastdue';
                  }
                  events.add(cl);
              }
        }
        
    }
    
    */
    
    void LoadNursingRecord(){
        
        
        List<Id> orderIdList = new List<Id>();
        map<ID, List<Event>> mapOfEvent = new map<ID,List<Event>>();
        
        for(Order__c ord : [Select id from order__c where Client_Chart__c  IN : setOfHouseClientChart AND Status__c != 'Inactive'
                             AND ((Taper__c !=: Null AND Taper__r.Dosage_Type__c !=: 'Open Ended') OR (Taper__c =: Null AND PRN__c =: FALSE))]){
            orderIdList.add(ord.id);
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
        
        
        Map<ID,Order__c> mapOfOrder = new Map<ID,Order__c>();
        
        for(Order__c iOrd : [Select id, Client_Chart__r.Name,Client_Chart__c ,Client_Chart__r.RecordType.Name,Medical__r.name from Order__c where ID in : mapOfEvent.keySet()
                             AND Client_Chart__c IN : setOfHouseClientChart]){
            
            mapOfOrder.put(iOrd.ID, iOrd);
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
    
    
      void GetGroupSessions(){
        List<Group_Therapy_Session__c> gtsList = new List<Group_Therapy_Session__c>();
        
       
            for(Group_Therapy_Session__c iGrp: [Select id,Name, End_Time__c,Start_Time__c,Date__c ,RecordType.Name from Group_Therapy_Session__c where Status__c != 'Completed' 
                                                AND  RecordType.Name =: RecordTypeName AND House__c =: selectHouse]){
                gtsList.add(iGrp);
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
                
                 DateTime sDateT = DateTime.newInstance(iGrp.Date__c.Year(), iGrp.Date__c.Month(), iGrp.Date__c.Day(), hour, integer.valueOf(iGrp.Start_Time__c.split(':')[1].split(' ')[0]), 0);
                 
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

    public PageReference pageLoad() {

      
        events = new list<calEvent>();
     //edited by Safia Osman
     
        LoadHouseClientChart();
        ///////////////////
        getRecurringAssesment();
        getIntakeRecords();
        getDrugScreen_Urine();
        GetGroupSessions();
        LoadNursingRecord();
        LoadAdmitOrder();
        ClinicaEvaluationRecord_Face2Face();
            //ClinicaEvaluationRecord_PhsychEvaluation();
            //ClinicaEvaluationRecord_History();
        system.debug('#####' + events);

      
        return null;

    }
    
    
    
    

    

    //Class to hold calendar event data

    public class calEvent{

        public String title {get;set;}

        public Boolean allDay {get;set;}

        public String startString {get;private set;}

        public String endString {get;private set;}

        public String url {get;set;}

        public String className {get;set;}
        
        public string ClientChartID {get;set;}

    }

}