//Test Class : ManageClosersQueueERPTest
public with sharing class ManageClosersQueueERP{
    
    //for showing add or edit user
    public boolean displayPopUp{get;set;}
    //param gives us the index of the row to Edit or Delete
    public integer indexVal{get;set;}
    //Boolean to decide if the name should be editable on edit or not
    public boolean displaySelectedQueue{get;set;}
    //This gives us the user that is selected at the time of new row creation
   String selectedQueue;

    public ERP_Closer_Queue_Assignment_Schedule__c tempCQRecord{get;set;}
    public map<id,ERP_Closer_Queue_Assignment_Schedule__c> idCQMap = new Map<id,ERP_Closer_Queue_Assignment_Schedule__c>();
    
    public ManageClosersQueueERP(){
        querycqManagement();
        displayPopUp=False;
        
    }
    
    public list<cqManagement> cqManagementList{//This gives us a list of all current rows for ACA Schecule Management
        get{
            if(cqManagementList == null){
                cqManagementList = new List<cqManagement>();
            }
            return cqManagementList;
        }set;
    }
    
    public void saveCQ(){
        if(tempCQRecord != null){
            if(checkRequiredFieldsSave(tempCQRecord)){//just to make sure propert validations are in place, before a row is inserted or updated
                if(tempCQRecord.id == null){//if we are adding a new row, we add the user to the record and insert
                    tempCQRecord.Name = selectedQueue;
                    insert tempCQRecord;
                }else{//if an existing row was updtaed and either the time or OFF was checked
                    update tempCQRecord;
                }
                
                querycqManagement();//to display the list of lated updated set of records.
                displayPopUp = False;
            }
        }
    }
    
    public void deleteCQ(){
        try{
            for(cqManagement cq: cqManagementList){
                system.debug(indexVal );//This gives us the index of the record we would like to delete from the UI
                system.debug(cq.index);
                if(indexVal == cq.index){
                    tempCQRecord = idCQMap.get(cq.cqId);
                    delete tempCQRecord;
                }
            }
            querycqManagement();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Closers Queue Schedule deleted successfully.'));
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
        }   
    }
    
    public void showAddQueueScreen(){//this method takes us to the Popup to create a new CQ Schedule record
        displayPopUp = true; 
        displaySelectedQueue= true;
        tempCQRecord = new ERP_Closer_Queue_Assignment_Schedule__c();    
    }
    
    public void showEditUserScreen(){//this method takes us to the Popup to edit an existing ACA Schedule record
        displayPopUp = true; 
        displaySelectedQueue = False;
        for(cqManagement cq: cqManagementList){
            system.debug(indexVal );//this gives us the index of the record we are trying to edit from the UI
            system.debug(cq.index);
            if(indexVal == cq.index){
                tempCQRecord = idCQMap.get(cq.cqId);//this prepopulates the existing values of the record on the edite screen
            }
        }    
    }
    
    public void cancel(){
        displayPopUp = false;    
    }
    
    public void querycqManagement(){//This method queries all of our current ACA Schedule records and populates them in the list to be used on the VF Page
        String monday='';
        String tuesday='';
        String wednesday = '';
        String thursday='';
        String friday='';
        String saturday='';
        string sunday='';  
        Integer indexValue=0;
        idCQMap.clear();
        cqManagementList.clear();
        for(ERP_Closer_Queue_Assignment_Schedule__c cq : [select id, Monday_OFF__c, Monday_Start_Time__c, Monday_End_Time__c, Tuesday_OFF__c, Tuesday_Start_Time__c, Tuesday_End_Time__c,
                                                      Wednesday_OFF__c, Wednesday_Start_Time__c, Wednesday_End_Time__c, Thursday_OFF__c, Thursday_Start_Time__c, Thursday_End_Time__c,
                                                      Friday_OFF__c, Friday_Start_Time__c, Friday_End_Time__c, Saturday_OFF__c, Saturday_Start_Time__c, Saturday_End_Time__c,
                                                      Sunday_OFF__c, Sunday_Start_Time__c, Sunday_End_Time__c, Name from ERP_Closer_Queue_Assignment_Schedule__c]){
             idCQMap.put(cq.id,cq);
             
             monday='';
             tuesday='';
             wednesday = '';
             thursday='';
             friday='';
             saturday='';
             sunday='';     
             
             if(cq.Monday_OFF__c==True)
                 monday = 'OFF';
             else
                 monday = cq.Monday_Start_Time__c+' - '+cq.Monday_End_Time__c; 
             if(cq.Tuesday_OFF__c==True)
                 tuesday= 'OFF';
             else
                 tuesday = cq.Tuesday_Start_Time__c+' - '+cq.Tuesday_End_Time__c; 
             if(cq.Wednesday_OFF__c==True)
                 wednesday= 'OFF';
             else
                 wednesday= cq.Wednesday_Start_Time__c+' - '+cq.Wednesday_End_Time__c;
             if(cq.Thursday_OFF__c==True)
                 thursday= 'OFF';
             else
                 Thursday= cq.Thursday_Start_Time__c+' - '+cq.Thursday_End_Time__c;
             if(cq.Friday_OFF__c==True)
                 friday= 'OFF';
             else
                 friday= cq.Friday_Start_Time__c+' - '+cq.Friday_End_Time__c; 
             if(cq.Saturday_OFF__c==True)
                 saturday= 'OFF';
             else
                 saturday= cq.Saturday_Start_Time__c+' - '+cq.Saturday_End_Time__c; 
             if(cq.Sunday_OFF__c==True)
                 sunday= 'OFF';
             else
                 sunday= cq.Sunday_Start_Time__c+' - '+cq.Sunday_End_Time__c;                                   
             
             cqManagement cqr = new cqManagement(cq.id, cq.Name, monday, tuesday, wednesday, thursday, friday, saturday, sunday,indexValue);
             cqManagementList.add(cqr);
             indexValue++;
         }
    }
    
    public List<SelectOption> getqueueList() {//This gives us the list of users for whom a schedule can be created. They are usually MS Admission Coordinaters
        List<SelectOption> options = new List<SelectOption>();
        for(group g : [select id, name from Group where type=:'Queue']){
            for(QueueSobject qs : [Select QueueId from QueueSobject Where SobjectType=:'Lead']){
                if(qs.QueueId == g.id){
                    options.add(new SelectOption(g.Name,g.Name));
                }
            }
        }
        return options;
    }

    public String getselectedQueue() {
        return selectedQueue;
    }
    
    public void setselectedQueue(String selectedQueue) {
        this.selectedQueue= selectedQueue;
    }

    
    public class cqManagement{//This is a wrapper class that is used to display the data on the Manage Schedule Page from the back end Custom Object record.
        public string cqId{get;set;}
        public string queueName{get;set;}
        public string monday{get;set;} 
        public string tuesday{get;set;} 
        public string wednesday{get;set;} 
        public string thursday{get;set;} 
        public string friday{get;set;} 
        public string saturday{get;set;} 
        public string sunday{get;set;} 
        public integer index{get;set;}  
    
        public cqManagement(String cq_id, String queue_name, String mon, String tue, String wed, String thur, String fri, String sat, String sun, Integer index){
            this.cqId = cq_id;
            this.queueName= queue_name;
            this.monday = mon;
            this.tuesday = tue;
            this.wednesday = wed;
            this.thursday = thur;
            this.friday = fri;
            this.saturday = sat;
            this.sunday = sun;
            this.index = index;
        }
    }
    
     public boolean checkRequiredFieldsSave(ERP_Closer_Queue_Assignment_Schedule__c  tempRecord){
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