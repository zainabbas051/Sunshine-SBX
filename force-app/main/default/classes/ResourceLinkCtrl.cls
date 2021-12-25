//controller class for ResourceLink VF page.
//test class ResourceLinkCtrlTest


public class ResourceLinkCtrl {

    private OUTREACH_ACCOUNT__c acc;
    private id accId ;
    public Content_Request__c CR{get;set;}
    public string selectStatus {get;set;}
    
    
    public ResourceLinkCtrl (){
    
        accId = system.CurrentPageReference().getParameters().get('id');
        
        acc = [select id, Category__c, Sub_Category__c,Prospect_URL__c,Status__c,Contact_Email_Address__c,Contact_Phone_Number__c ,
        Email_Address_Used_to_Initiate_Contact__c,Assigned_Writer_on_Outreach_Account__c, General_Guidelines_For_Website__c from OUTREACH_ACCOUNT__c where id =:accId ];
        
        
        
        CR = new Content_Request__c();
        CR.Category__c = acc.Category__c;
        Cr.type__c='Resource Link';
        CR.Sub_Category__c = acc.Sub_Category__c;                
        CR.Prospect_URL__c = acc.Prospect_URL__c;
        CR.Related_Outreach_Account__c = acc.id;
       


    
    
    }
    
    
    public List<SelectOption> getStatusOptions() {
        List<SelectOption> StatusOptions= new List<SelectOption>();
        StatusOptions.add(new SelectOption('','-None-'));
        StatusOptions.add(new SelectOption('Link submitted','Link submitted'));
        StatusOptions.add(new SelectOption('Link Rejected','Link Rejected'));
        StatusOptions.add(new SelectOption('Link Accepted','Link Accepted'));
        StatusOptions.add(new SelectOption('Link Published','Link Published'));
 
        return StatusOptions;
    }
    
     public PageReference SaveRecord(){
        try{
            cr.status__c=selectStatus ;
            insert CR;
            
            PageReference pg = new PageReference('/'+CR.id);
            pg.setredirect(true);
            return pg;
        }
        Catch(exception e){
            return null;
        }
    }
    
    public pageReference cancel(){
        PageReference pg = new PageReference('/'+accId );
        pg.setredirect(true);
        return pg;
    }
    
    
    
    
    
    
    
}