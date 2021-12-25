/*
    controller class for Past Group Sessions page
    author Safia Osman
    test clas : PastGroupSessionsCtrlTest

*/
public class PastGroupSessionsCtrl{
    
    public list<Group_Therapy_Session__c> lstGroupSessnPast{get;set;}
    Date TodayDate; 
    public string todayDateFormat { get ;set;}
    public boolean showExistingSN{get;set;}
    public DateTime createdDate{get;set;}
    public string createdBy{get;set;}
    public Group_Therapy_Session__c PGSessions{get;set;}
    public Map<string, List<Group_Therapy_Session__c>> mapOfGroupSessionsByweek {get;set;}
    private integer Days;
    public date sdate {get;set;}
    public date edate {get; set;}
    public boolean isCurrentButton { get;set;}
    public boolean isPastButton { get ;set;}
    public boolean isNextButton { get ;set;}
    public date  disChargeDate  { get;set;}
    public date admitDate  { get;set;}
    public List<Date> dateAgainstDays { get;set;}
    public string RecType {get; set;}
    public Sunshine_Center_Id__c scid{get;set;}
    
    
    public PastGroupSessionsCtrl(){
        
         TodayDate  = date.today();
         
         todayDateFormat   = DateTime.newInstance(TodayDate.year(),TodayDate.month(),TodayDate.day()).format('MMMM dd,YYYY'); 
        loadPastGroupSessions();

        
        String rt = ApexPages.CurrentPage().getParameters().get('rt');
        RecType = ApexPages.CurrentPage().getParameters().get('rt') != null? ApexPages.CurrentPage().getParameters().get('rt'):'';
        scid = Sunshine_Center_Id__c.getValues(rt);

        PGSessions = new Group_Therapy_Session__c();
        
        mapOfGroupSessionsByweek = new Map<string,List<Group_Therapy_Session__c >>();
        
        dateAgainstDays  = new  List<Date>();
        Days = 0;
        getCurrentWeek();
        
        isCurrentButton = true;//disbale
        isPastButton = false; //enable
        isNextButton  = true; //disable
        
    }
    
    private void loadPastGroupSessions(){
        String rt = ApexPages.CurrentPage().getParameters().get('rt');
        lstGroupSessnPast = [Select ID, Name,OwnerID,Owner.Name,Programme_Name__c,Rehab_Facility__c,End_Time__c,
                                            Status__c,Start_Time__c,Date__c,Facility_Schedule__c,Group_Leader__c, House__c, House__r.Name,Day_of_Week__c
                                            from Group_Therapy_Session__c where Date__c <: TodayDate order by Date__c,Start_Time__c ];
        system.debug('++++++'+lstGroupSessnPast);
    }
    

    public void getCurrentWeek(){
        String rt = ApexPages.CurrentPage().getParameters().get('rt');
        
        Days = 0;
        isCurrentButton = true;//disable
        isNextButton =true; //disable
        Date dt = Date.Today();
        Date tempDate = dt.toStartOfWeek().addDays(6);
        DateTime endDate = DateTime.newInstance(tempDate.year(), tempDate.month(), tempDate.day(), 23, 59, 59);
    
        lstGroupSessnPast = [Select ID, Name,OwnerID,Owner.Name,Programme_Name__c,Rehab_Facility__c,End_Time__c,
                                            Status__c,Start_Time__c,Date__c,Facility_Schedule__c,Group_Leader__c, House__c, House__r.Name,Day_of_Week__c
                                            from Group_Therapy_Session__c
        where Date__c <: TodayDate and Date__c >=: dt.toStartOfWeek() AND Date__c <=: endDate.date()
        order by Date__c,Start_Time__c ];
        
        ShowByWeekDay();
        sdate = dt.toStartOfWeek();
        edate = endDate.Date();
        FillDateAgainstDays(sdate,edate);
        isPastButton = false; //enable
        isCurrentButton = true; // disable
            
            
           
    }
    
    public void getPreviousWeek(){
        String rt = ApexPages.CurrentPage().getParameters().get('rt');
        
        Days -= 7;
        isNextButton   = false; //enable
      
        Date dt = Date.Today().AddDays(Days);
        Date tempDate = dt.toStartOfWeek().addDays(6);
        DateTime endDate = DateTime.newInstance(tempDate.year(), tempDate.month(), tempDate.day(), 23, 59, 59);

        lstGroupSessnPast = [Select ID, Name,OwnerID,Owner.Name,Programme_Name__c,Rehab_Facility__c,End_Time__c,
                                            Status__c,Start_Time__c,Date__c,Facility_Schedule__c,Group_Leader__c, House__c, House__r.Name,Day_of_Week__c
                                            from Group_Therapy_Session__c
        where Date__c>=: dt.toStartOfWeek() AND Date__c <=: endDate.date()
        order by Date__c,Start_Time__c ];
        
        ShowByWeekDay();
        sdate = dt.toStartOfWeek();
        edate = endDate.Date();
          FillDateAgainstDays(sdate,edate);
       
        system.debug('test########' + admitDate );
       
       
          isCurrentButton = false; // enable 
         
          isNextButton   = false; // disable
       
          
  
    }
    
    
    public void GetNextWeek(){
        String rt = ApexPages.CurrentPage().getParameters().get('rt');
        
        Days += 7;
        Date dt = Date.Today().AddDays(Days);
        Date tempDate = dt.toStartOfWeek().addDays(6);
        DateTime endDate = DateTime.newInstance(tempDate.year(), tempDate.month(), tempDate.day(), 23, 59, 59);

        lstGroupSessnPast = [Select ID, Name,OwnerID,Owner.Name,Programme_Name__c,Rehab_Facility__c,End_Time__c,
                                            Status__c,Start_Time__c,Date__c,Facility_Schedule__c,Group_Leader__c, House__c, House__r.Name,Day_of_Week__c
                                            from Group_Therapy_Session__c
        where Date__c <: TodayDate and Date__c>=: dt.toStartOfWeek() AND Date__c <=: endDate.date()
        order by Date__c,Start_Time__c ];
        
        ShowByWeekDay();
        sdate = dt.toStartOfWeek();
        edate = endDate.Date();
        FillDateAgainstDays(sdate,edate);
       
       
       
      
       if(Days  >= 0 ) {
           
           isNextButton = true; // disable
           isCurrentButton  = true; //disable
       }
       
       
    }
    
    void FillDateAgainstDays(Date sDate, Date eDate){
        
            dateAgainstDays = new List<date>();
            
            
            dateAgainstDays.add(sDate);
           
     
            for(integer i = 1 ; i<= 6 ; i++){
                   dateAgainstDays.add(sDate.addDays(i));
            }
           
    
    }
    private void ShowByWeekDay(){
        
         mapOfGroupSessionsByweek = new Map<string,List<Group_Therapy_Session__c >>();
         mapOfGroupSessionsByweek.put('Sunday' , new List<Group_Therapy_Session__c > {});
         mapOfGroupSessionsByweek.put('Monday' , new List<Group_Therapy_Session__c > {});
         mapOfGroupSessionsByweek.put('Tuesday' , new List<Group_Therapy_Session__c > {});
         mapOfGroupSessionsByweek.put('Wednesday' , new List<Group_Therapy_Session__c > {});
         mapOfGroupSessionsByweek.put('Thursday' , new List<Group_Therapy_Session__c > {});
         mapOfGroupSessionsByweek.put('Friday' , new List<Group_Therapy_Session__c > {});
         mapOfGroupSessionsByweek.put('Saturday' , new List<Group_Therapy_Session__c > {});
         system.debug('^^^^^^'+lstGroupSessnPast);
        for(Group_Therapy_Session__c cl : lstGroupSessnPast){
            
            if(mapOfGroupSessionsByweek.containsKey(cl.Day_of_Week__c))
                mapOfGroupSessionsByweek.get(cl.Day_of_Week__c).add(cl);
            else
                mapOfGroupSessionsByweek.put(cl.Day_of_Week__c , new List<Group_Therapy_Session__c > { cl });
                
        }
    }
    

    
}