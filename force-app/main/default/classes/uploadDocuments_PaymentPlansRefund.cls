//Test Class : uploadDocuments_PPR_Test
public class uploadDocuments_PaymentPlansRefund{
    public Payment_Plan_Refund_Request__c ri;
    public set<String> setExistingAttachments; //List of Name of Uploaded Documents Type
    public List<docWrapper> setNewAttachments{get; set;} //List of Name of Non-uploaded Documents Type
    public String statusUpload {get;set;}
    public awsBucket__c bucket {get;set;} //Bucket permission set
    public Integer count {get;set;}
    public String suffix {get;set;}
    public Opportunity opty {get;set;}
    
    public uploadDocuments_PaymentPlansRefund(ApexPages.StandardController controller) {
        
        ri = [select Id, Name, Payment_Plan__r.Name, Refund_Receipt_URL__c, Payment_Plan__c, Payment_Plan__r.Opportunity__r.Sunshine_Center__r.Name, Payment_Plan__r.Opportunity__r.Name from Payment_Plan_Refund_Request__c where Id =: controller.getId()] ;
        
        //opty = c.Opportunity__r;
        
        statusUpload = 'Pending';
        bucket = awsBucket__c.getInstance('salesforce');
        
        //Retrieve List of document type
        List <Documents_Type__c> listDocType = [select id, Name, Is_Active__c, Is_Required__c, Object_API_Name__c from Documents_Type__c 
                                                where Object_API_Name__c = 'Payment_Plan_Refund_Request__c' and Is_Active__c = true];

        
        //List of Already attached document
        setExistingAttachments = new set<String>();
        if(ri.Refund_Receipt_URL__c != null){
            setExistingAttachments.add('Refund Receipt'); 
        }
        
        //List of document to be uploaded
        setNewAttachments = new List<docWrapper>();        
        if (listDocType != Null && listDocType.size() > 0) {
            count = 1;
            for(Documents_Type__c docType: listDocType) {
                if (!setExistingAttachments.contains(docType.Name)) {
                    setNewAttachments.add(new docWrapper(docType.Name,count++));
                }
            }
            //The following lines add the ability to attach multiple Claim Correspondence and MR Requests records to a particular Claim
            count-- ;
            if(setNewAttachments.size() == 0)
            {
                statusUpload = 'All_Uploaded';
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, 'All Documents have been uploaded.');
                ApexPages.addMessage(myMsg);
            }
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, 'No document type defined.');
            ApexPages.addMessage(myMsg);
        }
        //Folder Naming Convention
        suffix = label.Production_or_Sanbox+'/'+ri.Payment_Plan__r.Opportunity__r.Sunshine_Center__r.Name+'/'+ri.Payment_Plan__r.Opportunity__r.Name+'/Payment Plan Documents/'+ri.Payment_Plan__r.Name+'/Refund Request Documents/'+ri.Name+'/Refund Receipt';
        

    }
    
    public pageReference cancelCustom(){
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/PaymentPlanDetail?id='+ri.Payment_Plan__c);
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
        Payment_Plan_Refund_Request__c tempRI = new Payment_Plan_Refund_Request__c(id = (ID)dc.id);
        if(dc.Name == 'Refund Receipt')
            tempRI.Refund_Receipt_URL__c =  dc.link;
        update tempRI;
        
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