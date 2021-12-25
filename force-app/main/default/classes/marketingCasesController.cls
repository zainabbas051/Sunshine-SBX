//TestClass : marketingCasesControllerTest
Public without sharing class marketingCasesController{
    
    public marketingCasesController(){
        caseNumber = '';
        caseType = '';
        caseStatus = '';
        caseSubject = '';
        caseDescription = '';
        caseSourceURL = '';
        caseSourceWebsite = '';
        caseReportedBy = '';
        caseReportedByEmail = '';
        caseReportedByPhone = '';
        caseReason = '';
        caseResolution = '';
        caseOpenTime = dateTime.Now();
        caseClosedTime = dateTime.Now();
        
        displayDetailPanel = True;
        displayEditPanel = False;
        displayClosePanel = False;
        
        loadData();
    }
    
    String status='';
    String type = '';
    String reason = '';
    
    public string caseNumber{get;set;}
    public string caseType{get;set;}
    public string caseStatus{get;set;}
    public string caseSubject{get;set;}
    public string caseDescription{get;set;}
    public string caseSourceURL{get;set;}
    public string caseSourceWebsite{get;set;}
    public string caseReportedBy{get;set;}
    public string caseReportedByEmail{get;set;}
    public string caseReportedByPhone{get;set;}
    public string caseReason{get;set;}
    public string caseResolution{get;set;}
    public DateTime caseOpenTime{get;set;}
    public DateTime caseClosedTime{get;set;}
    
    public boolean displayDetailPanel{get;set;}
    public boolean displayEditPanel{get;set;}
    public boolean displayClosePanel{get;set;}
    
    public list<Documents__c> snapshotList{
        get{
            if(snapshotList == null){
                snapshotList = new List<Documents__c>();
            }
            return snapshotList;
        }set;
    }
    
    public void loadData(){
        
        Id caseId = apexPages.currentPage().getParameters().get('id');
        if(caseId != null){
            for(Case c : [Select id, CaseNumber, Type, Status, Subject, Description, Source_URL__c, Source_Website__c, SuppliedEmail, SuppliedName, SuppliedPhone, Reason, Marketing_Case_Resolution__c, CreatedDate, ClosedDate from Case where id=:caseId]){
                caseNumber = c.caseNumber;
                caseType = c.Type;
                caseStatus = c.Status;
                caseSubject = c.Subject;
                caseDescription = c.Description;
                caseSourceURL = c.Source_URL__c;
                caseSourceWebsite = c.Source_Website__c;
                caseReportedBy = c.SuppliedName;
                caseReportedByEmail = c.SuppliedEmail;
                caseReportedByPhone = c.SuppliedPhone;
                caseOpenTime = c.CreatedDate;
                if(c.Status=='Closed'){
                    caseReason = c.Reason;
                    caseResolution = c.Marketing_Case_Resolution__c;
                    caseClosedTime = c.ClosedDate;
                }
            }
            for(Documents__c d : [Select id, Name, AWS_Link__c from Documents__c where Case__c=:caseId]){
                snapshotList.add(d);
            }
        }
        
    }
    
    public void editCase(){
        displayDetailPanel = False;
        displayEditPanel = True;
    }
    
    public void closeCase(){
        displayDetailPanel = False;
        displayClosePanel = True;
    }
    
    public void editCaseSave(){
        case c = new Case(id=apexPages.currentPage().getParameters().get('id'));
        c.Status = status;
        c.Type = type;
        try{
            update c;
            loadData();
            displayDetailPanel = True;
            displayEditPanel = False;
        }catch(Exception e){
            
        }
    }
    
    public void closeCaseSave(){
        case c = new Case(id=apexPages.currentPage().getParameters().get('id'));
        c.Status = 'Closed';
        c.Reason = reason;
        c.Marketing_Case_Resolution__c = caseResolution;
        try{
            update c;
            
            loadData();
            sendCloseCaseEmail();
            
            displayDetailPanel = True;
            displayClosePanel = False;
        }catch(Exception e){
        
        }
    }
    
    public List<SelectOption> getStatuses() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Open','Open'));
        options.add(new SelectOption('In-Progress','In-Progress'));
        options.add(new SelectOption('Pending Information From Requester','Pending Information From Requester'));
        
        return options;
    }
 
    public String getstatus() {
        return status;
    }
 
    public void setstatus(String status) {
        this.status = status;
    }
    
    public List<SelectOption> getTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Problem','Problem'));
        options.add(new SelectOption('Feature Request','Feature Request'));
        options.add(new SelectOption('Question','Question'));
        options.add(new SelectOption('Content Error','Content Error'));
        options.add(new SelectOption('Visual Error','Visual Error'));
        options.add(new SelectOption('Suggestion','Suggestion'));
        return options;
    }
 
    public String gettype() {
        return type;
    }
 
    public void settype(String type) {
        this.type = type;
    }
    
    public List<SelectOption> getReasons() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Existing problem','Existing problem'));
        options.add(new SelectOption('New problem','New problem'));
        return options;
    }
 
    public String getreason() {
        return reason;
    }
 
    public void setreason(String reason) {
        this.reason = reason;
    }
    
    
    public void sendCloseCaseEmail(){
        
        list<String> emailRecipientList = new List<String>();
        for(String s : label.marketingCaseEmailRecipientList.split(';')){
            emailRecipientList.add(s);
        }
        emailRecipientList.add(caseReportedByEmail);
        String emailSubject = 'Marketing Case Number : '+caseNumber+', has been Closed';
        String emailBody = 'Hi '+caseReportedBy+',\n\nThe marketing case number : '+caseNumber+', reported by you, has been closed.\n\n The case resolution message on the case is as follows : '+caseResolution+'.\n\nThanks,\nTeam Marketing';
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();         
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setToAddresses(emailRecipientList);
        mail.setSubject(emailSubject);
        mail.setPlainTextBody(emailBody);
        mail.setSaveAsActivity(false);
        mails.add(mail);
        Messaging.sendEmail(mails);
        
    }
        
}