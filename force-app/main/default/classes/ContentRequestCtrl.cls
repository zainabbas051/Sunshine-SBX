//controller class for ContentRequest VF page.
//test class ContentRequestCtrlTest
public class ContentRequestCtrl{
    
    private OUTREACH_ACCOUNT__c acc;
    private id accId ;
    
    public Content_Request__c CR{get;set;}
    
    public ContentRequestCtrl(){
    
        accId = system.CurrentPageReference().getParameters().get('id');
        
        acc = [select id, Category__c, Sub_Category__c,Prospect_URL__c,Status__c,Contact_Email_Address__c,Contact_Phone_Number__c ,
        Email_Address_Used_to_Initiate_Contact__c,Assigned_Writer_on_Outreach_Account__c, General_Guidelines_For_Website__c from OUTREACH_ACCOUNT__c where id =:accId ];

        CR = new Content_Request__c();
        CR.Category__c = acc.Category__c;
        CR.Sub_Category__c = acc.Sub_Category__c;                
        CR.Prospect_URL__c = acc.Prospect_URL__c;
        CR.Status__c = 'Content Request in Progress';
        CR.Writer_Status__c = 'Open';
        CR.Contact_Email_Address__c = acc.Contact_Email_Address__c;
        CR.Contact_Phone_Number__c = acc.Contact_Phone_Number__c ;
        CR.Email_Address_Used_to_Initiate_Contact__c = acc.Email_Address_Used_to_Initiate_Contact__c ;
        CR.Related_Outreach_Account__c = acc.id;
        CR.General_Guidelines_For_Website__c = acc.General_Guidelines_For_Website__c;
        if(acc.Assigned_Writer_on_Outreach_Account__c!=null){
            CR.Writer_Status__c = 'In Progress';
            cr.Assigned_Writer__c= acc.Assigned_Writer_on_Outreach_Account__c;
        }
        //CR.Assigned_Writer__c
       
    }
    
    public PageReference SaveRecord(){
        try{
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