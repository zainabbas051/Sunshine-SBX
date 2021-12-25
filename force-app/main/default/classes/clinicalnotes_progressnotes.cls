/*
    controller class for clinicalnotes_progressnotes vf component. its a record type of 
    Clinical Notes object.
    @author: Huma Zafar
    test : ClinicalNotesDetailCtrlTest
*/
public with sharing class clinicalnotes_progressnotes {
    
   
    public Client_Chart__c cc{get;set;}
       id noteId;
    public boolean EditPage{get;set;}
    public string ClinicalNoteIDVar {get;set;}
    string ClinicalNotedID {get;set;}
    public string rtype {get; set;}
    ID clientChartID;
    public User u {
        
        get {
            
            return [Select ID, UserName,Acess_Type__c, Has_Overwrite_Access__c FROM User where ID =: UserInfo.getUserId()];
        }
        
        set;
    }
    
     public Clinical_Note__c cNote{ get;set; }
    
    
     public boolean buttonAccessType{
        
        get {
       
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('ClinicalNotes');
        
        if( visibleTab.Button_Access_Type__c != NULL && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
     
    public clinicalnotes_progressnotes(){
        
       ClinicalNotedID  = ApexPages.CurrentPage().getParameters().get('clNID');
       EditPage =    (ApexPages.CurrentPage().getParameters().get('edit') != null)? true : false;
       clientChartID = ApexPages.CurrentPage().getParameters().get('ID');
       rtype = ApexPages.CurrentPage().getParameters().get('rt') != null? ApexPages.CurrentPage().getParameters().get('rt'):'';
        cc = [select id, Treatment_Center__c, Name, SSN__c from Client_Chart__c 
            where id=: clientChartID ];
            
     cNote = [select id, Absent_Reason__c, Aggressive__c, Agitated__c, Alert__c, Angry__c, Anxious__c, 
            Appropriate__c, Assertive__c, Attended__c, Attention_Seeking__c, Blunted__c, Calm__c, Circumstantial__c, 
            Client_Chart__c, Delusions__c, Disorganized__c, Dissociated__c, End_Date_Time__c, Euphoric__c, 
            Flat__c, Flight_of_Ideas__c, GrandioseInstigating__c, Hallucinations__c, High__c, Hostile__c, 
            Inappropriate__c, In_Denial__c, Individual__c, Insightful__c, Isolative__c, Labile__c, Loose_Association__c,
            Manipulative__c, Medium__c, Motivated__c, Notes__c, Oriented__c, Other__c, Other_Behaviors__c, Other_Mood__c, 
            Other_Type_of_Session__c, Paranoid__c, Progress_noted__c, Progress_Note_Type__c, Refused__c, Resistive__c, 
            Restless__c, Sad_tearful__c, Secretive__c, Somatic__c, Start_Date_Time__c, Status__c, Tangential__c, Low__c,
            Unkempt__c, Withdrawn__c,Attendence__c, Progress_Noted_PL__c from Clinical_Note__c where id=: ClinicalNotedID  ];
            
                      
          
           
         
    }
    
  	public List<SelectOption> getProgressNoted(){
		
		Schema.sObjectType sobject_type = Clinical_Note__c.getSObjectType();
		Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
		Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
		List<Schema.PicklistEntry> pick_list_values = field_map.get('Progress_Noted_PL__c').getDescribe().getPickListValues();
		List<selectOption> options = new List<selectOption>();
		for (Schema.PicklistEntry a : pick_list_values) {
			options.add(new selectOption(a.getLabel(), a.getValue()));
		}
		return options;
	}
    
     public PageReference submit(){
           upsert cNote;
           
           PageReference pr = new PageReference('/apex/ClinicalNotesDetail');
            pr.getParameters().put('ID',clientChartID);
            pr.getParameters().put('clNID',ClinicalNotedID);
            pr.getParameters().put('rt',rtype);
            pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
            return pr;
      
    }
}