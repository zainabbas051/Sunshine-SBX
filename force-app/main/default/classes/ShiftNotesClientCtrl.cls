/*
    controller class for shift notes client page
    author Huma Zafar
    test : ShiftNotesTest
*/
public class ShiftNotesClientCtrl{
        
    
    public list<UtlizationReviewOrder__c> lstCreateShiftNotes{get;set;}
    
    public map<string,list<UtlizationReviewOrder__c>> mapShiftNotes{get;set;}
    
    id ClientChartId;
    
    public boolean isCurrentButton { get;set;}
    public boolean isPastButton { get ;set;}
    public boolean isNextButton { get ;set;}
    public date sdate {get;set;}
    public date edate {get; set;}
    public date  disChargeDate  { get;set;}
    public date admitDate  { get;set;}
    private integer Days;
    public Sunshine_Center_Id__c scid{get;set;}
    public List<Date> dateAgainstDays { get;set;}
    public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('ShiftNotesFS');
        
        if( visibleTab.Button_Access_Type__c != null && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    public ShiftNotesClientCtrl(){
    
        ClientChartId = system.CurrentPageReference().getParameters().get('id');
        Days = 0;
        GetClientChart();
         isCurrentButton = true;//disbale
        isPastButton = false; //enable
        isNextButton  = true; //disable
        dateAgainstDays  = new  List<Date>();
        getCurrentWeek();
        
        String rt = ApexPages.CurrentPage().getParameters().get('rt');
        scid = Sunshine_Center_Id__c.getValues(rt);
        
    }
    private void ShowByWeekDay(){
    
         mapShiftNotes = new map<string,list<UtlizationReviewOrder__c>>();
        
         mapShiftNotes.put('Sunday' , new List<UtlizationReviewOrder__c> {});
         mapShiftNotes.put('Monday' , new List<UtlizationReviewOrder__c > {});
         mapShiftNotes.put('Tuesday' , new List<UtlizationReviewOrder__c> {});
         mapShiftNotes.put('Wednesday' , new List<UtlizationReviewOrder__c> {});
         mapShiftNotes.put('Thursday' , new List<UtlizationReviewOrder__c> {});
         mapShiftNotes.put('Friday' , new List<UtlizationReviewOrder__c> {});
         mapShiftNotes.put('Saturday' , new List<UtlizationReviewOrder__c> {});
         
         for(UtlizationReviewOrder__c cl : lstCreateShiftNotes){
            
            if(mapShiftNotes.containsKey(cl.Day_of_Week__c))
                mapShiftNotes.get(cl.Day_of_Week__c).add(cl);
            else
                mapShiftNotes.put(cl.Day_of_Week__c , new List<UtlizationReviewOrder__c> { cl });
                
        }
    }
    
     void GetClientChart(){
        
        Client_Chart__c cl = [Select ID , Admit_Date_Time__c,Discharge_Date_Time__c from  Client_Chart__c where ID =: ClientChartId];
        admitDate = cl.Admit_Date_Time__c.date();
        disChargeDate = cl.Discharge_Date_Time__c.date();
    }
    
    public void getCurrentWeek(){
         Days = 0;
        
        Date dt = Date.Today();
        Date tempDate = dt.toStartOfWeek().addDays(6);
        DateTime endDate = DateTime.newInstance(tempDate.year(), tempDate.month(), tempDate.day(), 23, 59, 59);
        
        lstCreateShiftNotes = [select id, Incident_Report__c, Client_Chart__c,Client_Chart__r.Name ,Shift_Notes__c , Incident_Report__r.CreatedBy.Name,
        Incident_Report__r.CreatedDate , Incident_Report__r.Status__c , Incident_Report__r.Staff_Image_URL__c, 
        Incident_Report__r.Staff_Signed_User__c, Incident_Report__r.Staff_Closed_Date__c, Day_of_Week__c, Incident_Report__r.House__r.House_Name__c
        from UtlizationReviewOrder__c where Client_Chart__c =:ClientChartId 
        and Incident_Report__r.RecordType.Name = 'Shift Note' and Incident_Report__r.Status__c =: 'Closed' 
        and (CreatedDate >=:dt.toStartofWeek() and CreatedDate<=: endDate) order by Incident_Report__r.CreatedDate desc];
        
        sdate = dt.toStartOfWeek();
        edate = endDate.Date() ;
        FillDateAgainstDays(sdate,edate);
        
        isCurrentButton = true;//disable
        isNextButton =true; //disable
        isPastButton = false; //enable
        ShowByWeekDay();
    }
    
    public void getPreviousWeek(){
    
         Days -= 7;
        Date dt = Date.Today().addDays(Days);
        Date tempDate = dt.toStartOfWeek().addDays(6);
        DateTime endDate = DateTime.newInstance(tempDate.year(), tempDate.month(), tempDate.day(), 23, 59, 59);
         isNextButton   = false; //enable
        
        lstCreateShiftNotes = [select id, Incident_Report__c, Client_Chart__c,Client_Chart__r.Name ,Shift_Notes__c , Incident_Report__r.CreatedBy.Name,
                            Incident_Report__r.CreatedDate , Incident_Report__r.Status__c , Incident_Report__r.Staff_Image_URL__c, 
                                Incident_Report__r.Staff_Signed_User__c, Incident_Report__r.Staff_Closed_Date__c, Day_of_Week__c, Incident_Report__r.House__r.House_Name__c
                                from UtlizationReviewOrder__c where Client_Chart__c =:ClientChartId 
                                and Incident_Report__r.RecordType.Name = 'Shift Note' and Incident_Report__r.Status__c =: 'Closed' 
                                and (CreatedDate >=:dt.toStartofWeek() and CreatedDate<=: endDate) order by Incident_Report__r.CreatedDate desc];
        
          sdate = dt.toStartOfWeek();
         edate = endDate.Date() ;
         FillDateAgainstDays(sdate,edate);
         
         if(admitDate >= dt.toStartOfWeek()){
            isPastButton = true; // disabled the button
            system.debug('test$$$$$$$$' + admitDate );
       }
         ShowByWeekDay();
        
           if(disChargeDate  > Date.Today().toStartOfWeek()){
              isCurrentButton = false; // enable 
            }
          else{
               isCurrentButton = true; // disable 
            
          }
          
         if(disChargeDate < eDate) isNextButton   = true; // disable
       
       if(disChargeDate < sdate  ){
            
            isPastButton = false; //enable
            isCurrentButton = true; // disable
            getPreviousWeek();
            
            
        }    
        
     
       
    }
    
    
    
    public void GetNextWeek(){
      
        Days += 7;
        Date dt = Date.Today().AddDays(Days);
        Date tempDate = dt.toStartOfWeek().addDays(6);
        DateTime endDate = DateTime.newInstance(tempDate.year(), tempDate.month(), tempDate.day(), 23, 59, 59);
        
        lstCreateShiftNotes = [select id, Incident_Report__c, Client_Chart__c, Client_Chart__r.Name ,Shift_Notes__c , Incident_Report__r.CreatedBy.Name,
        Incident_Report__r.CreatedDate , Incident_Report__r.Status__c , Incident_Report__r.Staff_Image_URL__c, 
        Incident_Report__r.Staff_Signed_User__c, Incident_Report__r.Staff_Closed_Date__c, Day_of_Week__c, Incident_Report__r.House__r.House_Name__c
        from UtlizationReviewOrder__c where Client_Chart__c =:ClientChartId 
        and Incident_Report__r.RecordType.Name = 'Shift Note' and Incident_Report__r.Status__c =: 'Closed'
        and (CreatedDate >=:dt.toStartofWeek() and CreatedDate<=: endDate) order by Incident_Report__r.CreatedDate desc];
        
     
        
        sdate = dt.toStartOfWeek();
        edate = endDate.date() ;
        FillDateAgainstDays(sdate,edate);
        
        ShowByWeekDay();
        
          system.debug('test########' + admitDate );
        if(admitDate <= dt.toStartOfWeek()){
            isPastButton = false; // enable the button
         
       }
       
       if(disChargeDate  > Date.Today().toStartOfWeek()){
            isCurrentButton = false; // enable 
        }
        else{
           isCurrentButton = true; // disable 
        }
        
       if((Days  >= 0) || (disChargeDate < edate) ) {
           
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
          
}