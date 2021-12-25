/*
    controller class for clinicalnotes_nursingprogressnotes vf component. its a record type of 
    Clinical Notes object.
    @author: Huma Zafar
    test class : ClinicalNotesDetailCtrlTest
*/
public with sharing class clinicalnotes_nursingprogressnotes {
    
   
    public Client_Chart__c cc{get;set;}
    id noteId;
    public string ClinicalNoteIDVar {get;set;}
    public boolean EditPage{get;set;}
    public string rtype {get; set;}
    public User u {
        
        get {
            
            return [Select ID, UserName,Acess_Type__c, Has_Overwrite_Access__c FROM User where ID =: UserInfo.getUserId()];
        }
        
        set;
    }
    
     public Clinical_Note__c cNote{
         get;
         set;
        
     }
    
  
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
        
    public clinicalnotes_nursingprogressnotes(){
        
       noteId = (ApexPages.CurrentPage().getParameters().get('clNID') != null) ? ApexPages.CurrentPage().getParameters().get('clNID') : ClinicalNoteIDVar;
        EditPage =    (ApexPages.CurrentPage().getParameters().get('edit') != null)? true : false;
        rtype = ApexPages.CurrentPage().getParameters().get('rt') != null? ApexPages.CurrentPage().getParameters().get('rt'):'';
        cc = [select id, Treatment_Center__c, Name, SSN__c from Client_Chart__c 
            where id=: ApexPages.CurrentPage().getParameters().get('ID')];
        
        cNote = [select id  , Nursing_Progress_Comments__c,Status__c,Start_Date_Time__c ,End_Date_Time__c from Clinical_Note__c            
            where id=: noteId];
            
        
      
       
           
            
    }
    
    
     public Pagereference submit(){
          upsert cNote;
         PageReference pr = new PageReference('/apex/ClinicalNotesDetail');
            pr.getParameters().put('ID',cc.ID);
            pr.getParameters().put('clNID',noteId);
            pr.getParameters().put('rt',rtype);
            pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
            return pr;
    }
}