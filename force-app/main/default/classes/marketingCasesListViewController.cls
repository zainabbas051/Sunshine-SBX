//Test Class : marketingCasesListViewControllerTest
Public without sharing class marketingCasesListViewController{
    
    public marketingCasesListViewController(){
        caseStatus = 'Open';
        redirectCaseId = '';
        loadData();
    }
    
    
    public list<caseDataWrapper> caseDataWrapperList{
        get{
            if(caseDataWrapperList == null){
                caseDataWrapperList = new List<caseDataWrapper>();
            }
            return caseDataWrapperList;
        }set;
    }
    
    public String redirectCaseId{get;set;}
    
    String caseStatus = '';
    
    public void loadData(){
        if(caseStatus != ''){
            caseDataWrapperList.clear();
            String caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Marketing Support Case').getRecordTypeId();
            for(Case c : [Select id, CaseNumber, Status, Type, Source_Website__c, CreatedDate, ClosedDate, SuppliedName from Case where Status=: caseStatus AND RecordTypeId =: caseRecordTypeId]){
                caseDataWrapper cdw = new caseDataWrapper();
                cdw.caseNumber = c.CaseNumber;
                cdw.caseId = c.id;
                cdw.caseStatus = c.Status;
                cdw.caseType = c.Type;
                cdw.caseSourceWebsite = c.Source_Website__c;
                cdw.caseCreatedTime = c.CreatedDate;
                if(c.ClosedDate != null){
                    cdw.caseClosedTime = c.ClosedDate;
                }
                cdw.caseReportedBy = c.SuppliedName;
                caseDataWrapperList.add(cdw);    
            }
        }
    }
    
    public pageReference caseDetailRedirect(){
        if(redirectCaseId == ''){
            return null;
        }else{
            PageReference pageRef = new PageReference('/apex/marketingCasesPage?id='+redirectCaseId);
            return pageRef;
        }
    }
    
    public List<SelectOption> getStatus() {
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Open','Open'));
         options.add(new SelectOption('Closed','Closed'));
         options.add(new SelectOption('In-Progress','In-Progress'));
         options.add(new SelectOption('Pending Information From Requester','Pending Information From Requester'));
         return options;
     }
            
    public String getcaseStatus() {
        return caseStatus;
    }
    
    public void setcaseStatus(String caseStatus) {
        this.caseStatus = caseStatus;
    }
    
    
    Public class caseDataWrapper{
        
        public string caseNumber{get;set;}
        public string caseId{get;set;}
        public string caseStatus{get;set;}
        public string caseType{get;set;}
        public string caseSourceWebsite{get;set;}
        public DateTime caseCreatedTime{get;set;}
        public DateTime caseClosedTime{get;set;}
        public string caseReportedBy{get;set;}
        public caseDataWrapper(){
        
        }
    }
    
}