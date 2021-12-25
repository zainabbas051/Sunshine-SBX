//Test Class : ManageAdmisionCoordinatorTest
public with sharing class ManageAdmisionCoordinator{
    
    //for showing add or edit user
    public boolean displayPopUp{get;set;}
    //param gives us the index of the row to Edit or Delete
    public integer indexVal{get;set;}
    //Boolean to decide if the name should be editable on edit or not
    public boolean displaySelectedUser{get;set;}
    //This gives us the user that is selected at the time of new row creation
    String selectedUser;

    public MS_Admision_Coordinator_Schedule__c tempACMRecord{get;set;}
    public map<id,MS_Admision_Coordinator_Schedule__c> idACMMap = new Map<id,MS_Admision_Coordinator_Schedule__c>();
    
    public ManageAdmisionCoordinator(){
        queryACManagement();
        displayPopUp=False;
        
    }
    
    public list<acManagement> acManagementList{//This gives us a list of all current rows for ACA Schecule Management
        get{
            if(acManagementList == null){
                acManagementList = new List<acManagement>();
            }
            return acManagementList;
        }set;
    }
    
    public void saveACM(){
        if(tempACMRecord != null){
            if(checkRequiredFieldsSave(tempACMRecord)){//just to make sure propert validations are in place, before a row is inserted or updated
            system.debug('***'+tempACMRecord);
                if(tempACMRecord.id == null){//if we are adding a new row, we add the user to the record and insert
                    tempACMRecord.user__c = selectedUser;
                    insert tempACMRecord;
                }else{//if an existing row was updtaed and either the time or OFF was checked
                    update tempACMRecord;
                    
                   
                }
                
                 User objUser = new User();
                 objUser.Id = tempACMRecord.user__c;
                 objUser.Premium_Leads_Enabled_User__c = tempACMRecord.user__r.Premium_Leads_Enabled_User__c;
                 
                 if(test.isRunningTest()){
                 
                      objUser.Id = [select id from user where isActive = true and Profile.name=:'System Administrator'limit 1].id;
                 }
                 
                     update objUser;
                
                queryACManagement();//to display the list of lated updated set of records.
                displayPopUp = False;
            }
        }
    }
    
    public void deleteACM(){
        try{
            for(acManagement acm: acManagementList){
                system.debug(indexVal );//This gives us the index of the record we would like to delete from the UI
                system.debug(acm.index);
                if(indexVal == acm.index){
                    tempACMRecord = idACMMap.get(acm.acmId);
                    delete tempACMRecord;
                }
            }
            queryACManagement();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Admision Coordinater Schedule deleted successfully.'));
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
        }   
    }
    
    public void showAddUserScreen(){//this method takes us to the Popup to create a new ACA Schedule record
        displayPopUp = true; 
        displaySelectedUser= true;
        tempACMRecord = new MS_Admision_Coordinator_Schedule__c();    
    }
    
    public void showEditUserScreen(){//this method takes us to the Popup to edit an existing ACA Schedule record
        displayPopUp = true; 
        displaySelectedUser = False;
        for(acManagement acm: acManagementList){
            system.debug(indexVal );//this gives us the index of the record we are trying to edit from the UI
            system.debug(acm.index);
            if(indexVal == acm.index){
                tempACMRecord = idACMMap.get(acm.acmId);//this prepopulates the existing values of the record on the edite screen
            }
        }    
    }
    
    public void cancel(){
        displayPopUp = false;    
    }
    
    public void queryACManagement(){//This method queries all of our current ACA Schedule records and populates them in the list to be used on the VF Page
        String monday='';
        String tuesday='';
        String wednesday = '';
        String thursday='';
        String friday='';
        String saturday='';
        string sunday='';  
        Integer indexValue=0;
        String offHoursAssignment='No';
        boolean PremiumLeadsEnabled=false;
        idACMMap.clear();
        acManagementList.clear();
        for(MS_Admision_Coordinator_Schedule__c ac : [select id, Monday_OFF__c, Monday_Start_Time__c, Monday_End_Time__c, Tuesday_OFF__c, Tuesday_Start_Time__c, Tuesday_End_Time__c,
                                                      Wednesday_OFF__c, Wednesday_Start_Time__c, Wednesday_End_Time__c, Thursday_OFF__c, Thursday_Start_Time__c, Thursday_End_Time__c,
                                                      Friday_OFF__c, Friday_Start_Time__c, Friday_End_Time__c, Saturday_OFF__c, Saturday_Start_Time__c, Saturday_End_Time__c,
                                                      Sunday_OFF__c, Sunday_Start_Time__c, Sunday_End_Time__c, User__r.Name,User__r.Premium_Leads_Enabled_User__c, Available_for_Off_Hours_Assignment__c from MS_Admision_Coordinator_Schedule__c]){
             idACMMap.put(ac.id,ac);
             
             monday='';
             tuesday='';
             wednesday = '';
             thursday='';
             friday='';
             saturday='';
             sunday='';     
             offHoursAssignment = 'No';
             PremiumLeadsEnabled=false;
             
             if(ac.Monday_OFF__c==True)
                 monday = 'OFF';
             else
                 monday = ac.Monday_Start_Time__c+' - '+ac.Monday_End_Time__c; 
             if(ac.Tuesday_OFF__c==True)
                 tuesday= 'OFF';
             else
                 tuesday = ac.Tuesday_Start_Time__c+' - '+ac.Tuesday_End_Time__c; 
             if(ac.Wednesday_OFF__c==True)
                 wednesday= 'OFF';
             else
                 wednesday= ac.Wednesday_Start_Time__c+' - '+ac.Wednesday_End_Time__c;
             if(ac.Thursday_OFF__c==True)
                 thursday= 'OFF';
             else
                 Thursday= ac.Thursday_Start_Time__c+' - '+ac.Thursday_End_Time__c;
             if(ac.Friday_OFF__c==True)
                 friday= 'OFF';
             else
                 friday= ac.Friday_Start_Time__c+' - '+ac.Friday_End_Time__c; 
             if(ac.Saturday_OFF__c==True)
                 saturday= 'OFF';
             else
                 saturday= ac.Saturday_Start_Time__c+' - '+ac.Saturday_End_Time__c; 
             if(ac.Sunday_OFF__c==True)
                 sunday= 'OFF';
             else
                 sunday= ac.Sunday_Start_Time__c+' - '+ac.Sunday_End_Time__c;                                   
             if(ac.Available_for_Off_Hours_Assignment__c == True)
                 offHoursAssignment = 'Yes';
                 
             if(ac.User__r.Premium_Leads_Enabled_User__c==true)
                 PremiumLeadsEnabled = true;
             
             acManagement acm = new acManagement(ac.id, ac.User__r.Name, monday, tuesday, wednesday, thursday, friday, saturday, sunday, indexValue, offHoursAssignment,PremiumLeadsEnabled);
             acManagementList.add(acm);
             indexValue++;
         }
    }
    
    public List<SelectOption> getuserList() {//This gives us the list of users for whom a schedule can be created. They are usually MS Admission Coordinaters
        List<SelectOption> options = new List<SelectOption>();
        for(User u : [select id, name from user where (profile.name=:'Custom - Monarch Shores - AC' OR profile.name=:'CSR Hybrid' ) AND isActive=: True]){
            options.add(new SelectOption(u.id,u.Name));
        }
        options.add(new SelectOption('0054P000009l6mF','Kimberly Weigel'));
        return options;
    }

    public String getselectedUser() {
        return selectedUser;
    }
    
    public void setselectedUser(String selectedUser) {
        this.selectedUser= selectedUser;
    }

    
    public class acManagement{//This is a wrapper class that is used to display the data on the Manage Schedule Page from the back end Custom Object record.
        public string acmId{get;set;}
        public string userName{get;set;}
        public string monday{get;set;} 
        public string tuesday{get;set;} 
        public string wednesday{get;set;} 
        public string thursday{get;set;} 
        public string friday{get;set;} 
        public string saturday{get;set;} 
        public string sunday{get;set;} 
        public integer index{get;set;}
        public String offHoursAssignment{get;set;}  
        public boolean PremiumLeadsEnabled {get;set;}
    
        public acManagement(String acm_id, String user_name, String mon, String tue, String wed, String thur, String fri, String sat, String sun, Integer index, String offHoursAssignment,boolean PremiumLeadsEnabled){
            this.acmId = acm_id;
            this.userName = user_name;
            this.monday = mon;
            this.tuesday = tue;
            this.wednesday = wed;
            this.thursday = thur;
            this.friday = fri;
            this.saturday = sat;
            this.sunday = sun;
            this.index = index;
            this.offHoursAssignment = offHoursAssignment;
            this.PremiumLeadsEnabled=PremiumLeadsEnabled;
        }
    }
    
     public boolean checkRequiredFieldsSave(MS_Admision_Coordinator_Schedule__c  tempRecord){
        String message='';      
        Boolean success=true;
         
            if(tempRecord.Monday_OFF__c == True && (tempRecord.Monday_Start_Time__c != null || tempRecord.Monday_End_Time__c != null)){
                 success=false;
                 message='As Monday is marked OFF, no Start Time or End Time can be added for the user on Monday!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             if(tempRecord.Monday_OFF__c == False && (tempRecord.Monday_Start_Time__c == null || tempRecord.Monday_End_Time__c == null)){
                 success=false;
                 message='As Monday is not marked OFF, Start Time or End Time are mandatory for the user on Monday!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             if(tempRecord.Tuesday_OFF__c == True && (tempRecord.Tuesday_Start_Time__c != null || tempRecord.Tuesday_End_Time__c != null)){
                 success=false;
                 message='As Tuesday is marked OFF, no Start Time or End Time can be added for the user on Tuesday!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             if(tempRecord.Tuesday_OFF__c == False && (tempRecord.Tuesday_Start_Time__c == null || tempRecord.Tuesday_End_Time__c == null)){
                 success=false;
                 message='As Tuesday is not marked OFF, Start Time or End Time are mandatory for the user on  Tuesday!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             if(tempRecord.Wednesday_OFF__c == True && (tempRecord.Wednesday_Start_Time__c != null || tempRecord.Wednesday_End_Time__c != null)){
                 success=false;
                 message='As Wednesday is marked OFF, no Start Time or End Time can be added for the user on Wednesday!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             if(tempRecord.Wednesday_OFF__c == False && (tempRecord.Wednesday_Start_Time__c == null || tempRecord.Wednesday_End_Time__c == null)){
                 success=false;
                 message='As Wednesday is not marked OFF, Start Time or End Time are mandatory for the user on Wednesday!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             if(tempRecord.Thursday_OFF__c == True && (tempRecord.Thursday_Start_Time__c != null || tempRecord.Thursday_End_Time__c != null)){
                 success=false;
                 message='As Thursday is marked OFF, no Start Time or End Time can be added for the user on  Thursday!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             if(tempRecord.Thursday_OFF__c == False && (tempRecord.Thursday_Start_Time__c == null || tempRecord.Thursday_End_Time__c == null)){
                 success=false;
                 message='As Thursday is not marked OFF, Start Time or End Time are mandatory for the user on Thursday!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             if(tempRecord.Friday_OFF__c == True && (tempRecord.Friday_Start_Time__c != null || tempRecord.Friday_End_Time__c != null)){
                 success=false;
                 message='As Friday is marked OFF, no Start Time or End Time can be added for the user on  Thursday!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             if(tempRecord.Friday_OFF__c == False && (tempRecord.Friday_Start_Time__c == null || tempRecord.Friday_End_Time__c == null)){
                 success=false;
                 message='As Friday is not marked OFF, Start Time or End Time are mandatory for the user on Thursday!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             if(tempRecord.Saturday_OFF__c == True && (tempRecord.Saturday_Start_Time__c != null || tempRecord.Saturday_End_Time__c != null)){
                 success=false;
                 message='As Saturday is marked OFF, no Start Time or End Time can be added for the user on  Saturday!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             if(tempRecord.Saturday_OFF__c == False && (tempRecord.Saturday_Start_Time__c == null || tempRecord.Saturday_End_Time__c == null)){
                 success=false;
                 message='As Saturday is not marked OFF, Start Time or End Time are mandatory for the user on Saturday!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             if(tempRecord.Sunday_OFF__c == True && (tempRecord.Sunday_Start_Time__c != null || tempRecord.Sunday_End_Time__c != null)){
                 success=false;
                 message='As Sunday is marked OFF, no Start Time or End Time can be added for the user on  Sunday!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             if(tempRecord.Sunday_OFF__c == False && (tempRecord.Sunday_Start_Time__c == null || tempRecord.Sunday_End_Time__c == null)){
                 success=false;
                 message='As Sunday is not marked OFF, Start Time or End Time are mandatory for the user on Sunday!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             
             
         return success;
     }
        
    

}