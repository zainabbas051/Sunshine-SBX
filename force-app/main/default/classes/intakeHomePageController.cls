/*
test class : IntakePageCtrlTest
*/
global class intakeHomePageController{
    

    public List<Intake_Forms__c > lstIntakeForm {get; set;}
    public List<Intake_Forms__c > lstNewIntakeForm_ClientHandBook {get; set;}
    public boolean IsActive_ClientHandBook {get;set;}
    public boolean IsOpen_ClientHandBook {get;set;}
    ID clientChartID;
    
     public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('Consents');
        
        if(visibleTab.Button_Access_Type__c != null &&  visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    
    
    public intakeHomePageController(){
      
        clientChartID = ApexPages.CurrentPage().getParameters().get('id');
        GetIntakeRecords();
        
    }
    
    void GetIntakeRecords(){
        
        lstIntakeForm  = new List<Intake_Forms__c>();
        List<Intake_Forms__c > lstIntakeForm_Sort  = new List<Intake_Forms__c>();
        IsActive_ClientHandBook = true;
        IsOpen_ClientHandBook = true;
        lstNewIntakeForm_ClientHandBook  =  new List<Intake_Forms__c>();
        
        for(Intake_Forms__c intake : [Select ID , Client_Chart__c, Name, RecordTypeID, RecordType.Name,RecordType.DeveloperName,Closed_Date__c, Signed_User__c,
                            Client_Chart__r.Treatment_Center__r.Name ,Client_Chart__r.Name, status__c, Due_Date_Time__c, Locker_Number_L__r.Name from
                            Intake_Forms__c where Client_Chart__c =: clientChartID order by name ]){
        
            if(intake.RecordType.DeveloperName == 'Client_Personal_Items'){
                   lstNewIntakeForm_ClientHandBook.add(intake);
                   if(intake.status__c == 'Active') 
                        IsActive_ClientHandBook = false;  
                   if(intake.status__c == 'Open')
                        IsOpen_ClientHandBook = false;
                       
                   
            }
            else if(intake.RecordType.DeveloperName == 'Orientation_Check_List' || intake.RecordType.DeveloperName == 'Client_HandBook')
                lstIntakeForm_Sort.add(intake);
            else
                lstIntakeForm.add(intake);
               
        }
        if(!lstIntakeForm_Sort.isEmpty()){
            lstIntakeForm.add(lstIntakeForm_Sort.get(0));
            lstIntakeForm.add(lstIntakeForm_Sort.get(1));
        }
       
    }
    
    public PageReference createClientHandBookRecord(){
        
        ID RecordTypeID = Schema.SObjectType.Intake_Forms__c.getRecordTypeInfosByName().get('Client Personal Items - Cell Phone And Other Valuables Lock-Up').getRecordTypeId();
        Intake_Forms__c intakeForm = new Intake_Forms__c();
        intakeForm.status__c = 'Open';
        intakeForm.RecordTypeID = RecordTypeID;
        intakeForm.Client_Chart__c = clientChartID;
        intakeForm.SignedBy__c ='None';
        intakeForm.Name = 'Client Personal Items - Cell Phone And Other Valuables Lock-Up';
        insert intakeForm;
        
        PageReference pr = new PageReference('/apex/IntakePageDetail');
        pr.getParameters().put('id', clientChartID);
        pr.getParameters().put('Intake', intakeForm.ID);
        pr.setRedirect(true);
        return pr;
        
    }
    
   
    
   
  
   
   

    
}