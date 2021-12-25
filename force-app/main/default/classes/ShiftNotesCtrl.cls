/*
    controller class for shift notes page
    author Huma Zafar
    Test Class : ShiftNotesTest
*/
public class ShiftNotesCtrl{
    
    public list<Incident_Report__c> lstShiftNotes{get;set;}
    
    public boolean showExistingSN{get;set;}
    
    public boolean showHouseColumn{get;set;}
    
    public DateTime createdDate{get;set;}
    public DateTime startDate {get; set;}
    public string createdBy{get;set;}
    
    public Incident_Report__c ShiftNote{get;set;}
    
    public list<UtlizationReviewOrder__c> lstCreateShiftNotes{get;set;}
    
    public Map<string, List<Incident_Report__c >> mapOfClinicalNotesByweek {get;set;}
    private integer Days;
    public date sdate {get;set;}
    public date edate {get; set;}
    public boolean isCurrentButton { get;set;}
    public boolean isPastButton { get ;set;}
    public boolean isNextButton { get ;set;}
    public date  disChargeDate  { get;set;}
    public date admitDate  { get;set;}
    public List<Date> dateAgainstDays { get;set;}
    /*
    Modified by Zain Abbas
    Adding House feature in incident report record
    for Monarch and Chapters
    */
    public list<SelectOption> listOfHouses {get; set;}
    public string RecType {get; set;}
    public string selectedHouse {get; set;}
    public Sunshine_Center_Id__c scid{get;set;}
    
    //by Zain Abbas for Delete SN functionality
    public string SNid {get; set;}
    
      public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('ShiftNotes');
        
        if( visibleTab.Button_Access_Type__c != NULL && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    
    public ShiftNotesCtrl(){
        
        
        loadSN();
		
		SNid = '';
        showExistingSN = true;
        selectedHouse = '';
        String rt = ApexPages.CurrentPage().getParameters().get('rt');
        RecType = ApexPages.CurrentPage().getParameters().get('rt') != null? ApexPages.CurrentPage().getParameters().get('rt'):'';
        scid = Sunshine_Center_Id__c.getValues(rt);
        //selectedHouse = '';
        listOfHouses = new list<SelectOption>();    //by Zain
        if(scid.House_Based_Selection__c == True)
        {
            showHouseColumn = True;
            getHousesOnRecordType();
        }
             
        else
            showHouseColumn = False;

        ShiftNote = new Incident_Report__c();
        
        mapOfClinicalNotesByweek = new Map<string,List<Incident_Report__c >>();
        
        dateAgainstDays  = new  List<Date>();
        Days = 0;
        getCurrentWeek();
        
        isCurrentButton = true;//disbale
        isPastButton = false; //enable
        isNextButton  = true; //disable
        
    }
    
    private void loadSN(){
        String rt = ApexPages.CurrentPage().getParameters().get('rt');
        lstShiftNotes = [select id,CreatedById, CreatedBy.Name, CreatedDate, Status__c,Staff_Image_Url__c , Staff_Closed_Date__c, House__r.House_Name__c,
        Staff_Signed_User__c from Incident_Report__c
        where RecordType.Name = 'Shift Note' AND Sunshine_Center__r.name=:rt order by CreatedDate desc ];
    }
    
    public pageReference AddNewShiftNote(){
        showExistingSN = false;
        //createdDate = Datetime.now();
        //createdBy = UserInfo.getName();
        String rt = ApexPages.CurrentPage().getParameters().get('rt');
        system.debug('rt ::::'+rt);
        
        
        
        String sunshineCenterId = scid.Account_id__c;

        ShiftNote = new Incident_Report__c();
        ShiftNote.RecordTypeId = Schema.SObjectType.Incident_Report__c.getRecordTypeInfosByName().get('Shift Note').getRecordTypeId();
        ShiftNote.Status__c = 'Open';
        ShiftNote.Sunshine_Center__c = sunshineCenterId;
        
        if(scid.House_Based_Selection__c == True)
            ShiftNote.House__c = selectedHouse;
            
        insert ShiftNote;
        
        ShiftNote = [select id, CreatedDate, CreatedById, Status__c,Staff_Image_Url__c , Staff_Closed_Date__c,
        Staff_Signed_User__c  from Incident_Report__c where id=:ShiftNote.id order by CreatedDate desc];
        
        if(scid.House_Based_Selection__c == True)
        {
            lstCreateShiftNotes = new list<UtlizationReviewOrder__c>();
            
            for(UtlizationReviewOrder__c activeRes: [select id, Client_Chart__c, Bed__c from UtlizationReviewOrder__c
                                                        where Bed__r.Room__r.House__c =: selectedHouse AND
                                                        Client_Chart__r.Client_Status__c = 'Admitted' AND 
                                                        Start_Date_Time__c <= TODAY AND End_Date_Time__c >= TODAY])
            {
                lstCreateShiftNotes.add(new UtlizationReviewOrder__c(Client_Chart__c = activeRes.Client_Chart__c,Incident_Report__c= ShiftNote.id));
            }
            
            if(lstCreateShiftNotes.size() > 0)
                insert lstCreateShiftNotes;
        }
        
        else
        {
            string recordtypeName = system.CurrentPageReference().getParameters().get('rt');
            list<string> RTNames  = recordtypeName.split(';');
            
            list<Client_Chart__c> lstCC = [select id from Client_Chart__c where Client_Status__c = 'Admitted' and 
            RecordType.Name in: RTNames ];
            
            lstCreateShiftNotes = new list<UtlizationReviewOrder__c>();
            
            for(Client_Chart__c cc: lstCC){
                lstCreateShiftNotes.add(new UtlizationReviewOrder__c(Client_Chart__c = cc.id,Incident_Report__c= ShiftNote.id));
            }
           
            insert lstCreateShiftNotes;
        }
        
        system.debug('#HouseId='+selectedHouse);
        pageReference pr = new pageReference('/apex/ShiftNotesDetailPage?SNID='+ShiftNote.id+'&rt='+rt);
        
        return pr;
        

    }
    
    public void getCurrentWeek(){
        String rt = ApexPages.CurrentPage().getParameters().get('rt');
        
        Days = 0;
        isCurrentButton = true;//disable
        isNextButton =true; //disable
        Date dt = Date.Today();
        Date tempDate = dt.toStartOfWeek().addDays(6);
        DateTime endDate = DateTime.newInstance(tempDate.year(), tempDate.month(), tempDate.day(), 23, 59, 59);
        system.debug('___'+dt.toStartOfWeek());
        lstShiftNotes = [select id,CreatedById, CreatedBy.Name, CreatedDate, Status__c,Staff_Image_Url__c , Staff_Closed_Date__c, House__r.House_Name__c, Day_of_Week__c,
        Staff_Signed_User__c from Incident_Report__c
        where RecordType.Name = 'Shift Note' AND Sunshine_Center__r.name=:rt AND CreatedDate >=: dt.toStartOfWeek() AND CreatedDate <: endDate
        order by CreatedDate desc ];
        startDate=dt.toStartOfWeek();
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
        system.debug('___'+dt.toStartOfWeek());
        lstShiftNotes = [select id,CreatedById, CreatedBy.Name, CreatedDate, Status__c,Staff_Image_Url__c , Staff_Closed_Date__c, House__r.House_Name__c, Day_of_Week__c,
        Staff_Signed_User__c from Incident_Report__c
        where RecordType.Name = 'Shift Note' AND Sunshine_Center__r.name=:rt AND CreatedDate>=: dt.toStartOfWeek() AND CreatedDate <: endDate
        order by CreatedDate desc ];
        system.debug('___'+lstShiftNotes);
        startDate=dt.toStartOfWeek();
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
        
        lstShiftNotes = [select id,CreatedById, CreatedBy.Name, CreatedDate, Status__c,Staff_Image_Url__c , Staff_Closed_Date__c, House__r.House_Name__c, Day_of_Week__c,
        Staff_Signed_User__c from Incident_Report__c
        where RecordType.Name = 'Shift Note' AND Sunshine_Center__r.name=:rt AND CreatedDate>=: dt.toStartOfWeek() AND CreatedDate <: endDate
        order by CreatedDate desc ];
        startDate=dt.toStartOfWeek();
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
        
         mapOfClinicalNotesByweek = new Map<string,List<Incident_Report__c >>();
         mapOfClinicalNotesByweek.put('Sunday' , new List<Incident_Report__c > {});
         mapOfClinicalNotesByweek.put('Monday' , new List<Incident_Report__c > {});
         mapOfClinicalNotesByweek.put('Tuesday' , new List<Incident_Report__c > {});
         mapOfClinicalNotesByweek.put('Wednesday' , new List<Incident_Report__c > {});
         mapOfClinicalNotesByweek.put('Thursday' , new List<Incident_Report__c > {});
         mapOfClinicalNotesByweek.put('Friday' , new List<Incident_Report__c > {});
         mapOfClinicalNotesByweek.put('Saturday' , new List<Incident_Report__c > {});
        
        for(Incident_Report__c cl : lstShiftNotes){
           
            
            DateTime dt = cl.CreatedDate;
            datetime CDate = datetime.newInstance(dt.year(), dt.month(), dt.day());
            String day = CDate.format('EEEE');
            System.debug('dayofweek-'+CDate+CDate+day);
            if(CDate>=startDate){
            if(mapOfClinicalNotesByweek.containsKey(day))
                mapOfClinicalNotesByweek.get(day).add(cl);
            else
                mapOfClinicalNotesByweek.put(day , new List<Incident_Report__c > { cl });
            }
                
        }
    }
    
    public void getHousesOnRecordType()
    {
        listOfHouses = new list<SelectOption>();
        
        for(Bed_Board_Configuration__c house: [select id, name, Sunshine_Center__c, Sunshine_Center__r.name,House_Name__c
                                                    from Bed_Board_Configuration__c where House_Name__c != null
                                                    AND House_Name__c != ''  AND Sunshine_Center__r.name =: RecType])
        {
            listOfHouses.add(new SelectOption(house.id, house.House_Name__c));
        }
        
    }
    
    public void deleteSN()
    {
    	Incident_Report__c snDel = new Incident_Report__c();
    	system.debug('ID='+Apexpages.currentPage().getParameters().get('shNId'));
    	SNid = Apexpages.currentPage().getParameters().get('shNId');
    	
    	list <UtlizationReviewOrder__c> lstURO = [select id, Client_Chart__c, Bed__c from UtlizationReviewOrder__c where 
    												Incident_Report__c =: SNid];
    	
    	for(Incident_Report__c ir : lstShiftNotes)
    	{
    		if(ir.id == SNid)
    		{
    			snDel = ir;
    			break;
    		}
    	}
    	
    	try{
    	if(lstURO.size()>0)
    		delete lstURO;
    	if(snDel.id != null)
    		delete snDel;
    		
    	
    	
    	}
    	catch(exception e){}
    	
    	/*pageReference pr = new pageReference('/apex/ShiftNotes');
    	pr.getParameters().put('rt',Apexpages.currentPage().getParameters().get('rt'));
    	pr.setRedirect(true);
    	return pr;*/
    	
    }
    
    
}