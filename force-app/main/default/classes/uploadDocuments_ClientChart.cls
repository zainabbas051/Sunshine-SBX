//Test Class : uploadDocuments_ClientChartTest
public class uploadDocuments_ClientChart{
    public Client_Chart__c clRecord;
    public set<String> setExistingAttachments; //List of Name of Uploaded Documents Type
    public List<docWrapper> setNewAttachments{get; set;} //List of Name of Non-uploaded Documents Type
    public String statusUpload {get;set;}
    public awsBucket__c bucket {get;set;} //Bucket permission set
    public Integer count {get;set;}
    public String suffix {get;set;}
    public Opportunity opty {get;set;}
    
    public uploadDocuments_ClientChart(ApexPages.StandardController controller) {
        
        clRecord = [select Id, Name, Opportunity__c, Treatment_Center__r.Name, Client_ID_URL2__c, Client_Image_URL2__c, Client_Insurance_Card_Front_URL__c, Client_Insurance_Card_Back_URL__c from Client_Chart__c where Id =: controller.getId()] ;
        
        statusUpload = 'Pending';
        bucket = awsBucket__c.getInstance('FREEPU');
        
        //Retrieve List of document type
        List <Documents_Type__c> listDocType = [select id, Name, Is_Active__c, Is_Required__c, Object_API_Name__c from Documents_Type__c 
                                                where Object_API_Name__c = 'Client_Chart__c' and Is_Active__c = true];

        
        //List of Already attached document
        setExistingAttachments = new set<String>();
        if(clRecord.Client_ID_URL2__c != null){
            setExistingAttachments.add('Client ID'); 
        }
        if(clRecord.Client_Image_URL2__c != null){
            setExistingAttachments.add('Client Image'); 
        }
        if(clRecord.Client_Insurance_Card_Front_URL__c != null){
            setExistingAttachments.add('Client Insurance Front'); 
        }
        if(clRecord.Client_Insurance_Card_Back_URL__c != null){
            setExistingAttachments.add('Client Insurance Back'); 
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
        suffix = label.Production_or_Sanbox+'/'+(clRecord.Treatment_Center__r.Name == null ? '': clRecord.Treatment_Center__r.Name +'/') +clRecord.Name+'/Client Chart Images/';
        

    }
    
    public pageReference cancelCustom(){
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/FaceSheetHomePage?id='+clRecord.id);
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
        Client_Chart__c tempCL = new Client_Chart__c(id = (ID)dc.id);
        if(dc.Name == 'Client Image')
            tempCL.Client_Image_URL2__c =  dc.link;
        if(dc.Name == 'Client ID')
            tempCL.Client_ID_URL2__c = dc.link;
        if(dc.Name == 'Client Insurance Front')
            tempCL.Client_Insurance_Card_Front_URL__c = dc.link;
        if(dc.Name == 'Client Insurance Back')
            tempCL.Client_Insurance_Card_Back_URL__c = dc.link;  
            
        update tempCL;
        
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