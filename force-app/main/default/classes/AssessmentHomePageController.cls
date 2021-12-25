/*
    controller class for AssessmentHomeComponent    
    @author: Huma Zafar
    
    @author : Danish Faroq
    @Description: create two seperate pages 
*/
//Test Class : AssessmentHomePageControllerTest
public with sharing class AssessmentHomePageController {
        
        public boolean displayMainPage{get;set;}
        
        public list<Assessment_IR_Tools__c> lstAssessments {get;set;}
        
        public list<RecordType> lstRecordTypes{get;set;}
        
        public string SelectedOption {get; set;}
        
        public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('Assessments');
        
        if( visibleTab.Button_Access_Type__c != null && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
        }
        
        Assessment_IR_Tools__c  newARtool;
        
        id ccId;
        
        public AssessmentHomePageController(){
            
                ccId = ApexPages.CurrentPage().getParameters().get('id');
                
                loadAssessments();
                getRecordTypes();
                
               
        }
        
        void loadAssessments(){
                lstAssessments = new list<Assessment_IR_Tools__c>();
                lstAssessments = [select id, RecordType.Name, Status__c,Client_Chart__c,
                                Staff_Closed_Date__c,Staff_Signed_User__c,Due_Date_Time__c  from Assessment_IR_Tools__c            
                                where Client_Chart__c =:ccId order by ID desc];
        }
        
        void getRecordTypes(){
             
             List<RecordType> lstRec =  [SELECT Id,Name FROM RecordType WHERE SobjectType='Assessment_IR_Tools__c' and IsActive = true order by name];
             lstRecordTypes = new List<RecordType>();
             //change in order according to JIRA Ticket 26-01-2018
             if(lstRec.size()>6)
                 lstRecordTypes.add(lstRec.get(6));
             if(lstRec.size()>4)
                 lstRecordTypes.add(lstRec.get(4));
             if(lstRec.size()>5)
                 lstRecordTypes.add(lstRec.get(5));
             if(lstRec.size()>7)
                 lstRecordTypes.add(lstRec.get(7));
             if(lstRec.size()>3)
                 lstRecordTypes.add(lstRec.get(3));
             if(lstRec.size()>0)
                 lstRecordTypes.add(lstRec.get(0));
             if(lstRec.size()>1)
                 lstRecordTypes.add(lstRec.get(1));
             if(lstRec.size()>2)
                 lstRecordTypes.add(lstRec.get(2));
             if(lstRec.size()>8)
                 lstRecordTypes.add(lstRec.get(8));
                 if(lstRec.size()>9)
                 lstRecordTypes.add(lstRec.get(9));
             //lstRecordTypes = [SELECT Id,Name FROM RecordType WHERE SobjectType='Assessment_IR_Tools__c'];
        }
     
       public void SaveNewAssesmentRecords(){
        
            SelectedOption = SelectedOption.subString(0,SelectedOption.length() - 1);
            List<Assessment_IR_Tools__c  > lstOfNewnewARtool = new List<Assessment_IR_Tools__c  >();
            Assessment_IR_Tools__c  newARtool;
            for(string value : SelectedOption.split(',')){
                newARtool= new Assessment_IR_Tools__c ();
                newARtool.Client_Chart__c = ccId;
                newARtool.RecordTypeID = Schema.SObjectType.Assessment_IR_Tools__c.getRecordTypeInfosByName().get(value).getRecordTypeId();
                   newARtool.Status__c ='Open';
               // newARtool.Name =  recordType.name;
                lstOfNewnewARtool.add(newARtool);
            }
            insert  lstOfNewnewARtool;
            //bind the list again to get the latest records;
            loadAssessments();
        }
        
      public void SaveAssementAllRecords(){
        
        List<Assessment_IR_Tools__c  > lstOfNewAssesment = new List<Assessment_IR_Tools__c  >();
        for(RecordType recordType : lstRecordTypes ){
            
             newARtool= new Assessment_IR_Tools__c ();
                newARtool.Client_Chart__c = ccId;
                newARtool.RecordTypeID = Schema.SObjectType.Assessment_IR_Tools__c.getRecordTypeInfosByName().get(recordType.name).getRecordTypeId();
                newARtool.Status__c ='Open';
               // newARtool.Name =  recordType.name;
                lstOfNewAssesment .add(newARtool);
        }
        
        insert  lstOfNewAssesment ;
        //bind the list again to get the latest records;
        loadAssessments();
        
    }
            
}