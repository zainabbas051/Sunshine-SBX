//Test Class : uploadDocuments_MarketingCaseTest
public without sharing class uploadDocuments_MarketingCaseSnapshots {
    
    public List<docWrapper> setNewAttachments{get; set;} //List of Name of Non-uploaded Documents Type
    public String statusUpload {get;set;}
    public awsBucket__c bucket {get;set;} //Bucket permission set
    public Integer count {get;set;}
    public String suffix {get;set;}
    public string caseId{get;set;}
    public uploadDocuments_MarketingCaseSnapshots() {
        
        statusUpload = 'Pending';
        bucket = awsBucket__c.getInstance('salesforce');
        
        
        //List of document to be uploaded
        setNewAttachments = new List<docWrapper>();        
        count = 1;
        setNewAttachments.add(new docWrapper('Snapshot 1',count++));
        setNewAttachments.add(new docWrapper('Snapshot 2',count++));
        setNewAttachments.add(new docWrapper('Snapshot 3',count++));
        count-- ;
        
        caseId = ApexPages.currentPage().getParameters().get('id');
        
        //Folder Naming Convention
        suffix = label.Production_or_Sanbox+'/Marketing Case Snapshots/'+caseId+'/';
        
    }
    
    public pageReference cancelCustom(){
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/marketingCasesNewCasePage?id='+caseId);
        return pr;
    }
    
    public PageReference validationError()
    {
        String message = Apexpages.currentPage().getParameters().get('message');
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, message);
        ApexPages.addMessage(myMsg);
        return null;
    } 
    
    @RemoteAction
    public static String document_uploaded_true(String auditID){
        return 'Document successfully Uploaded';
        
    }
    
    @RemoteAction
    public static String updateLink(String JSONString)
    {
        docWrapper dc = (docWrapper)System.JSON.deserialize(JSONString,docWrapper.class);
        Documents__c doc = new Documents__c();
        doc.name = dc.name;
        doc.AWS_Link__c =  dc.link;
        doc.Case__c = (ID)dc.id;
        insert doc;
        
        return 'Success';
    }
    
    public class docWrapper {
        public string name {get;set;}
        public string key {get;set;}
        public string javascriptId{get;set;}
        public string link {get;set;}
        public string Id {get;set;}
        public docWrapper(string name,integer jId)
        {
            this.name = name;
            this.javascriptId = 'file' + String.valueOf(jId);
        }
    }
}