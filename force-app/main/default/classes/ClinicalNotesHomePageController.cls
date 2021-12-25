/*
    controller class for ClinicalNotesHomeComponent    
    @author: Huma Zafar
    @test class : ClinicalNotesHomePageControllerTest
*/
public with sharing class ClinicalNotesHomePageController {
    
 
    public string SelectedOption{ get;set;}
    public list<Clinical_Note__c> lstNotes{get;set;}
    
    public list<RecordType> ClinicalRecordOption{get;set;}
    public List<RecordType> lstRecordTypes {get;set;}
    
    public Map<string, List<Clinical_Note__c >> mapOfClinicalNotesByweek {get;set;}
    private integer Days;
    public date sdate {get;set;}
    public date edate {get; set;}
    public boolean isCurrentButton { get;set;}
    public boolean isPastButton { get ;set;}
    public boolean isNextButton { get ;set;}
    public date  disChargeDate  { get;set;}
    public date admitDate  { get;set;}
    public List<Date> dateAgainstDays { get;set;}
    public Decimal BillableHours {get;set;}
    public String DelID{get;set;}
    public boolean IsAdmin{get;set;}
    public ID currentUserID{get;set;}
    public User userObj{get;set;}

    public boolean displayPopUp{get;set;}
    
    id ccId;
    
     public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c,Has_Overwrite_Access__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('ClinicalNotes');
        
        if( visibleTab.Button_Access_Type__c != NULL && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    
    public ClinicalNotesHomePageController(){
     

        userObj = [Select ID, UserName,Acess_Type__c,Has_Overwrite_Access__c FROM User where ID =: UserInfo.getUserId()];
        if(userObj.Acess_Type__c=='Admin'){
            IsAdmin=true;
        }
        else
        IsAdmin=false;
        currentUserID=UserInfo.getUserId();
        
        //system.debug('test2'+profileName);
        mapOfClinicalNotesByweek = new Map<string,List<Clinical_Note__c >>();
        ccId = ApexPages.CurrentPage().getParameters().get('id');
        dateAgainstDays  = new  List<Date>();
        Days = 0;
       // loadNotes();
        GetClientChart();
        getCurrentWeek();
        getClinicalRecordOptions();
     
        
        isCurrentButton = true;//disbale
        isPastButton = false; //enable
        isNextButton  = true; //disable
        
    }
    
    void getClinicalRecordOptions(){
      
        ClinicalRecordOption = [SELECT Id,Name FROM RecordType WHERE SobjectType='Clinical_Note__c' and Name != 'Group Session Notes'];
    }
    
    void GetClientChart(){
        
        Client_Chart__c cl = [Select ID , Admit_Date_Time__c,Discharge_Date_Time__c from  Client_Chart__c where ID =: ccId];
        admitDate = cl.Admit_Date_Time__c.date();
        disChargeDate = cl.Discharge_Date_Time__c.date();
    }
    
   
    public void getCurrentWeek(){
        
         Days = 0;
        isCurrentButton = true;//disable
        isNextButton =true; //disable
        Date dt = Date.Today();
        Date tempDate = dt.toStartOfWeek().addDays(6);
        DateTime endDate = DateTime.newInstance(tempDate.year(), tempDate.month(), tempDate.day(), 23, 59, 59);
     
        
        lstNotes = [select id,CreatedById  ,Start_Date_Time__c, End_Date_Time__c, Attendence__c ,Billable_Hours__c ,Client_Signed_User__c ,Client_Chart__c,RecordType.Name,Client_Chart__r.Admit_Date_Time__c,Client_Chart__r.Discharge_Date_Time__c, Status__c,Date__c, Progress_Note_Type__c, Day_of_Week__c, Staff_Signed_User__c, Staff_Closed_Date__c, Client_Chart__r.Name from Clinical_Note__c 
            where Client_Chart__c =:ccId and Start_Date_Time__c >=: dt.toStartOfWeek() and Start_Date_Time__c <: endDate order by Date__c,Start_Date_Time__c];
         //   string name=[Select CreatedBy.Name from Clinical_Note__c where Client_Chart__c =:ccId and Start_Date_Time__c >=: dt.toStartOfWeek() and Start_Date_Time__c <: endDate][0];
        CalculateHours(lstNotes);
        ShowByWeekDay();
        sdate = dt.toStartOfWeek();
        edate = endDate.Date() ;
        FillDateAgainstDays(sdate,edate);
     
         // System.debug('**'+lstNotes.CreatedBy.Name);
            
        if(admitDate >= sdate )
            isPastButton = true; // disabled the button
        
         if(admitDate <= dt.toStartOfWeek()){
            isPastButton = false; // enable the button
         
       }
        
        if(disChargeDate <= sdate  ){
            
            isPastButton = false; //enable
            isCurrentButton = true; // disable
            getPreviousWeek();
            
        }    
    }
    
    void CalculateHours(List<Clinical_Note__c> aLst){
        BillableHours  = 0;
        
        for(Clinical_Note__c cl : aLst){
            if(cl.RecordType.Name == 'Group Session Notes' || (cl.RecordType.Name == 'Progress Notes' && cl.Attendence__c == 'Attended'))    {
                
                   BillableHours += (cl.Billable_Hours__c == null) ? 0 : cl.Billable_Hours__c;
            }
             
        }
        
    }
    
    public void getPreviousWeek(){
        
        Days -= 7;
        Date dt = Date.Today().AddDays(Days);
        Date tempDate = dt.toStartOfWeek().addDays(6);
        DateTime endDate = DateTime.newInstance(tempDate.year(), tempDate.month(), tempDate.day(), 23, 59, 59);
        
        isNextButton   = false; //enable
      
        lstNotes = [select id,CreatedById,Client_Chart__c,Start_Date_Time__c, End_Date_Time__c, Billable_Hours__c ,Attendence__c,Client_Signed_User__c ,RecordType.Name,Client_Chart__r.Admit_Date_Time__c,Client_Chart__r.Discharge_Date_Time__c, Status__c,Date__c, Progress_Note_Type__c, Day_of_Week__c, Staff_Signed_User__c, Staff_Closed_Date__c, Client_Chart__r.Name from Clinical_Note__c 
            where Client_Chart__c =:ccId and Start_Date_Time__c >=: dt.toStartOfWeek() and Start_Date_Time__c <: endDate order by Date__c,Start_Date_Time__c];
        CalculateHours(lstNotes);
        ShowByWeekDay();
        sdate = dt.toStartOfWeek();
        edate = endDate.Date();
          FillDateAgainstDays(sdate,edate);
       
        system.debug('test########' + admitDate );
        if(admitDate >= dt.toStartOfWeek()){
            isPastButton = true; // disabled the button
            system.debug('test$$$$$$$$' + admitDate );
       }
       
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
      
        lstNotes = [select id,CreatedById , Client_Chart__c,Start_Date_Time__c, End_Date_Time__c,Billable_Hours__c ,Attendence__c,Client_Signed_User__c ,RecordType.Name,Client_Chart__r.Admit_Date_Time__c,Client_Chart__r.Discharge_Date_Time__c, Status__c,Date__c, Progress_Note_Type__c, Day_of_Week__c, Staff_Signed_User__c, Staff_Closed_Date__c, Client_Chart__r.Name from Clinical_Note__c 
                    where Client_Chart__c =:ccId and Start_Date_Time__c  >=: dt.toStartOfWeek() and Start_Date_Time__c <: endDate order by Date__c,Start_Date_Time__c];
        CalculateHours(lstNotes);
        ShowByWeekDay();
        sdate = dt.toStartOfWeek();
        edate = endDate.Date();
        FillDateAgainstDays(sdate,edate);
       
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
    private void ShowByWeekDay(){
        
         mapOfClinicalNotesByweek = new Map<string,List<Clinical_Note__c >>();
         mapOfClinicalNotesByweek.put('Sunday' , new List<Clinical_Note__c > {});
         mapOfClinicalNotesByweek.put('Monday' , new List<Clinical_Note__c > {});
         mapOfClinicalNotesByweek.put('Tuesday' , new List<Clinical_Note__c > {});
         mapOfClinicalNotesByweek.put('Wednesday' , new List<Clinical_Note__c > {});
         mapOfClinicalNotesByweek.put('Thursday' , new List<Clinical_Note__c > {});
         mapOfClinicalNotesByweek.put('Friday' , new List<Clinical_Note__c > {});
         mapOfClinicalNotesByweek.put('Saturday' , new List<Clinical_Note__c > {});
        
        for(Clinical_Note__c cl : lstNotes){
            
            if(mapOfClinicalNotesByweek.containsKey(cl.Day_of_Week__c))
                mapOfClinicalNotesByweek.get(cl.Day_of_Week__c).add(cl);
            else
                mapOfClinicalNotesByweek.put(cl.Day_of_Week__c , new List<Clinical_Note__c > { cl });
                
        }
    }
   
    
   
    
    
    
     public PageReference SaveNewClinicalRecords(){
        
        //The following line was commented by Naveen, have to concur with Danish, if this is needed or not.
        //SelectedOption = SelectedOption.subString(0,SelectedOption.length() - 1);
        List<Clinical_Note__c> lstOfNewClinicalNotes = new List<Clinical_Note__c>();
        Clinical_Note__c newCl;
        
        for(string value : SelectedOption.split(',')){
            newCl = new Clinical_Note__c();
            newCl.Client_Chart__c = ccId; // client chart id
            newCl.RecordTypeID = Schema.SObjectType.Clinical_Note__c.getRecordTypeInfosByName().get(value).getRecordTypeId();
            newCl.Status__c = 'Open';
            newCl.Start_Date_Time__c= DateTime.Now();
            lstOfNewClinicalNotes.add(newCl);
        }
        insert  lstOfNewClinicalNotes;
       
        PageReference pr = new PageReference('/apex/ClinicalNotesDetail');
        pr.getParameters().put('ID',ccId);
        pr.getParameters().put('clNID',lstOfNewClinicalNotes[0].ID);
        pr.getParameters().put('rt',ApexPages.CurrentPage().getParameters().get('rt'));
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        return pr;
    }
    
    
    
    public void DelClinicalNotes() {
    Clinical_Note__c delCn=[select ID from Clinical_Note__c where ID=:DelID];
     Integer index= lstNotes.indexOf(delCn);
    delete delCn;
    Integer count=0;
    for(Clinical_Note__c cn : lstNotes)
    {
        if(cn.ID==delCn.ID)
        {
            break;
            
        }
        count++;
        
    }
    
 
    lstNotes.remove(count);
    ShowByWeekDay();

   // getClinicalRecordOptions();

    }
    public PageReference redirectToAllClinicalNotes(){
        
        PageReference CnAll = new PageReference('/apex/ClinicalNotesViewAll' );
        CnAll.getParameters().put('ID',ccId);
         CnAll.getParameters().put('rt',ApexPages.CurrentPage().getParameters().get('rt'));
        CnAll.setRedirect(true);
        return CnAll;
    }
    
    
    
}