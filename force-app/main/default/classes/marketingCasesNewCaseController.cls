//Test Class : marketingCasesNewCaseControllerTest
Public without sharing class marketingCasesNewCaseController{
    
    
    public marketingCasesNewCaseController(){
        caseSubject = '';
        caseDescription = '';
        caseSourceURL = '';
        caseReportedBy = '';
        caseReportedByEmail = '';
        caseReportedByPhone = '';
        
        if(ApexPages.currentPage().getParameters().get('id') == null){
            displayDetailView = True;
            displayCaseCreateView = False;
        }else{
            displayDetailView = False;
            displayCaseCreateView = True;
        }
        
    }
    
    String type = '';
    String sourceWebsite = '';
    
    public string caseSubject{get;set;}
    public string caseDescription{get;set;}
    public string caseSourceURL{get;set;}
    public string caseReportedBy{get;set;}
    public string caseReportedByEmail{get;set;}
    public string caseReportedByPhone{get;set;}
    public boolean displayDetailView{get;set;}
    public boolean displayCaseCreateView{get;set;}
    
    
    public PageReference createCase(){
        If(checkRequiredFields()){
            Case c = new Case();
            c.Type = type;
            c.Subject = caseSubject;
            c.Description = caseDescription;
            c.Source_URL__c = caseSourceURL;
            c.Source_Website__c = sourceWebsite;
            c.SuppliedName = caseReportedBy;
            c.SuppliedEmail = caseReportedByEmail;
            c.SuppliedPhone = caseReportedByPhone;
            c.Status='Open';
            c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Marketing Support Case').getRecordTypeId();
            insert c;
            
            sendNewCaseEmail(c.id);
            
            PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/uploadDocuments_MarketingCaseSnapshots?id='+c.id);
            return pr;
        }   
        
        return null;
        
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
    
    public List<SelectOption> getWebsites() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Sunshine','Sunshine'));
        options.add(new SelectOption('Sunshine Ads','Sunshine Ads'));
        options.add(new SelectOption('Monarch','Monarch'));
        options.add(new SelectOption('Monarch Ads','Monarch Ads'));
        options.add(new SelectOption('Chapters','Chapters'));
        options.add(new SelectOption('Chapters Ads','Chapters Ads'));
        options.add(new SelectOption('Mountain','Mountain'));
        options.add(new SelectOption('Mountain Ads','Mountain Ads'));
        options.add(new SelectOption('Willow','Willow'));
        options.add(new SelectOption('Willow Ads','Willow Ads'));
        options.add(new SelectOption('Lincoln','Lincoln'));
        options.add(new SelectOption('Lincoln Ads','Lincoln Ads'));
        options.add(new SelectOption('Unknown','Unknown'));
        return options;

    }
 
    public String getsourceWebsite() {
        return sourceWebsite;
    }
 
    public void setsourceWebsite(String sourceWebsite) {
        this.sourceWebsite = sourceWebsite;
    }
    
    public boolean checkRequiredFields() {
        String message = '';
        Boolean success = true;
        if (caseSubject == '' || caseSubject == null){
            message = 'Please Enter the Subject before clicking on Save!!';
            success = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        if(caseDescription == '' || caseDescription == null){
            message = 'Please Enter the Description before clicking on Save!!';
            success = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        if(caseReportedBy == '' || caseReportedBy == null){
            message = 'Please Enter the Case Reported before clicking on Save!!';
            success = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        if(caseReportedByEmail == '' || caseReportedByEmail == null){
            message = 'Please Enter the Case Reported By Email before clicking on Save!!';
            success = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        if(caseReportedByEmail != Null){
             String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
             Pattern p = Pattern.compile(emailRegex);
             Matcher pm = p.matcher(caseReportedByEmail);
             
             
             if(caseReportedByEmail != ''){
                 if(!pm.Matches()){
                     success=false;
                     message='Please enter a valid Reported By Email Address.' ;
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
                 }
             }
         }
        return success;
    }
    
    public void sendNewCaseEmail(String caseId){
        Case tempCase = new Case();
        for(Case c : [Select id, type, Source_Website__c, Source_URL__c, Subject, Description, CaseNumber, SuppliedName, SuppliedEmail from Case where id=:caseId LIMIT 1]){
            tempCase = c;
        }
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();         
        
        
        if(tempCase.CaseNumber != null){
            list<String> marketingEmailRecipientList = new List<String>();
            for(String s : label.marketingCaseEmailRecipientList.split(';')){
                marketingEmailRecipientList.add(s);
            }
            String marketingEmailSubject = 'New Marketing Case Number : '+tempCase.CaseNumber+', has been Created';
            String marketingEmailBody = 'Hi,\n\nA new marketing case number : '+tempCase.CaseNumber+', has been submitted by '+tempCase.SuppliedName+'.\n\n The Case Details are as Follows : \n\n Type : '+tempCase.Type+'\n Source Website :'+tempCase.Source_Website__c+'\n Source URL : '+tempCase.Source_URL__c+'\n Subject : '+tempCase.Subject+'\n Description : '+tempCase.Description+'\n\nPlease log into salesforce, and look up the case accordingly.\n\nThanks';
            
            Messaging.SingleEmailMessage marketingMail = new Messaging.SingleEmailMessage();
        
            marketingMail.setToAddresses(marketingEmailRecipientList);
            marketingMail.setSubject(marketingEmailSubject);
            marketingMail.setPlainTextBody(marketingEmailBody);
            marketingMail.setSaveAsActivity(false);
            mails.add(marketingMail);
            
            list<String> caseCreatorRecipientList = new List<String>();
            caseCreatorRecipientList.add(tempCase.SuppliedEmail);
            String caseCreatorEmailSubject = 'New Marketing Case Number : '+tempCase.CaseNumber+', has been Submitted By you';
            String caseCreatorEmailBody = 'Hi '+tempCase.SuppliedName+',\n\nA new marketing case number : '+tempCase.CaseNumber+', has been submitted by you, and the Marketing team has been notified about it.\n\nThanks\nTeam Marketing';
            
            Messaging.SingleEmailMessage caseCreatorMail = new Messaging.SingleEmailMessage();
        
            caseCreatorMail.setToAddresses(caseCreatorRecipientList);
            caseCreatorMail.setSubject(caseCreatorEmailSubject);
            caseCreatorMail.setPlainTextBody(caseCreatorEmailBody);
            caseCreatorMail.setSaveAsActivity(false);
            mails.add(caseCreatorMail);
            
            Messaging.sendEmail(mails);
        }
        
        
        
    }
     
}