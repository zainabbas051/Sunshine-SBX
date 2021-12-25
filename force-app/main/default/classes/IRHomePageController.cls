/*
    controller class for IncidentReportHomePage
    @author: Huma Zafar
    Test Class : IncidentReportTest
*/
public with sharing class IRHomePageController{
        
    public boolean displayMainPage{get;set;}
    
    public list<Incident_Report__c> lstIncidentReports {get;set;}
    public list<Incident_Report__c> lstReviewIncidentReports {get;set;}
    public list<Incident_Report__c> lstClosedIncidentReports {get;set;}
    public list<Incident_Report__c> lstComplianceIncidentReports {get;set;}
    
    public list<RecordType> lstRecordTypes{get;set;}
    
    public string SelectedOption {get; set;}
    
    Incident_Report__c newARtool;
    
    id ccId;
    
     public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('IncidentReport');
        
        if( visibleTab.Button_Access_Type__c != NULL && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    //By Zain
    public string RecType{get; set;}
    //public string selectedHouse {get; set;}
    public list<SelectOption> listOfHouses {get; set;}
    public Sunshine_Center_Id__c scid{get;set;}
    
    public IRHomePageController(){
        
            ccId = ApexPages.CurrentPage().getParameters().get('id');
            RecType = ApexPages.CurrentPage().getParameters().get('rt');
            //selectedHouse = '';
            
            loadIncidents();
            getRecordTypes();
            scid = Sunshine_Center_Id__c.getValues(RecType);
            /*if(scid.House_Based_Selection__c == True)
            {
                getHousesOnRecordType();
            }*/
            
           
    }
    
    void loadIncidents(){
        id IR_RT = Schema.SObjectType.Incident_Report__c.getRecordTypeInfosByName().get('Incident Report').getRecordTypeId();
            
        String rt = ApexPages.CurrentPage().getParameters().get('rt');      //by Zain 
        Sunshine_Center_Id__c scid = Sunshine_Center_Id__c.getValues(rt);   //by Zain
        String sunshineCenterId = scid != null? scid.Account_id__c :  '';               //by Zain   
            
        lstIncidentReports = new list<Incident_Report__c>();
        lstReviewIncidentReports = new list<Incident_Report__c>();
        lstClosedIncidentReports = new list<Incident_Report__c>();
        lstComplianceIncidentReports = new list<Incident_Report__c>();
          
        list<Incident_Report__c> lstIncidentReportsTemp  = [select id, RecordType.Name, Status__c, Incident_Reported_By__c, Incident_Reported_Date__c,
        Incident_Reviewed_By__c, Incident_Review_Claimed_Date_Time__c, Name_s_of_Individuals_Involved__c, House__r.House_Name__c, Date_Time__c from Incident_Report__c 
        where RecordTypeId =: IR_RT AND Sunshine_Center__r.name =: RecType];
        
        for(Incident_Report__c ir: lstIncidentReportsTemp){
            if(ir.Status__c == 'Open')
                lstIncidentReports.add(ir);
            else if(ir.Status__c=='Under Supervisor Review')
                lstReviewIncidentReports.add(ir);
            else if(ir.Status__c == 'Under Compliance Review')
                lstComplianceIncidentReports.add(ir);
            else
                lstClosedIncidentReports.add(ir);
        }
    }
    
    void getRecordTypes(){
        
         lstRecordTypes = [SELECT Id,Name FROM RecordType WHERE SobjectType='Incident_Report__c' and name ='Incident Report'];
    }
 
    public void SaveNewIncidentRecords(){
    
        String rt = ApexPages.CurrentPage().getParameters().get('rt');                                  //by Zain 
        Sunshine_Center_Id__c scid = Sunshine_Center_Id__c.getValues(rt);                               //by Zain
        String sunshineCenterId = scid != null? scid.Account_id__c :  '';                               //by Zain
        
        //SelectedOption = SelectedOption.subString(0,SelectedOption.length() - 1);
        User userRecord = [Select id, Title from User where id =: UserInfo.getUserId()];
        List<Incident_Report__c> lstOfNewnewARtool = new List<Incident_Report__c>();
        
        Incident_Report__c newARtool = new Incident_Report__c();
        
        newARtool.RecordTypeID = Schema.SObjectType.Incident_Report__c.getRecordTypeInfosByName().get('Incident Report').getRecordTypeId();
        newARtool.Status__c ='Open';
        newARtool.Incident_Reported_By__c = userRecord.id;
        newARtool.Incident_Reported_By_Position__c = userRecord.Title;
        newARtool.Incident_Reported_Date__c = date.Today();
        newARtool.Signedby__c = 'Client';
        newARtool.Sunshine_Center__c = sunshineCenterId != '' ? sunshineCenterId : null;                //by Zain
       // newARtool.House__c = (scid.House_Based_Selection__c == True) ? (selectedHouse != '' ? selectedHouse : null) : null;                             //by Zain
       
       insert newARtool;
       
       system.debug('#newTool='+newARtool);
            
            /*for(string value : SelectedOption.split(',')){
                newARtool= new Incident_Report__c();
                //newARtool.Client_Chart__c = ccId;
                newARtool.RecordTypeID = Schema.SObjectType.Incident_Report__c.getRecordTypeInfosByName().get(value).getRecordTypeId();
               newARtool.Status__c ='Open';
                newARtool.Incident_Reported_By__c = userRecord.id;
                newARtool.Incident_Reported_By_Position__c = userRecord.Title;
                newARtool.Incident_Reported_Date__c = date.Today();
                newARtool.Signedby__c = 'Client';
                newARtool.Sunshine_Center__c = sunshineCenterId;            //by Zain
               // newARtool.Name =  recordType.name;
                lstOfNewnewARtool.add(newARtool);
            }
            insert  lstOfNewnewARtool;*/
            
        //bind the list again to get the latest records;
        loadIncidents();
    }
   
   /*     
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
     */
        
        /*
      public void SaveIncidentAllRecords(){
        
        List<Incident_Report__c> lstOfNewIncidents = new List<Incident_Report__c>();
        for(RecordType recordType : lstRecordTypes ){
            
             newARtool= new Incident_Report__c();
                //newARtool.Client_Chart__c = ccId;
                newARtool.RecordTypeID = Schema.SObjectType.Incident_Report__c.getRecordTypeInfosByName().get(recordType.name).getRecordTypeId();
                newARtool.Status__c ='Open';
               // newARtool.Name =  recordType.name;
                lstOfNewIncidents .add(newARtool);
        }
        
        insert  lstOfNewIncidents ;
        //bind the list again to get the latest records;
        loadIncidents();
        
    }*/
            
}