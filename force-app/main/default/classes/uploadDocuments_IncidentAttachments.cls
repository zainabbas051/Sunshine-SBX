//Test Class : uploadDocuments_IncidentAttachmentsTest
public class uploadDocuments_IncidentAttachments{
    public Incident_Report__c	 IncidentReport;
    public Client_Chart__c clRecord;

    public set<String> setExistingAttachments; //List of Name of Uploaded Documents Type
    public String statusUpload {get;set;}
    public awsBucket__c bucket {get;set;} //Bucket permission set
    public Integer count {get;set;}
    public String suffix {get;set;}
    public Opportunity opty {get;set;}
    public List<docWrapper> setNewAttachments{get; set;} //List of Name of Non-uploaded Documents Type
    public string  RecordTypeID;
    string RecordTypeName;
	public string rtype {get; set;} 


    public uploadDocuments_IncidentAttachments(ApexPages.StandardController controller) {
       // RecordTypeID= ApexPages.CurrentPage().getParameters().get('rtID');
       //ID RecordID =   ApexPages.CurrentPage().getParameters().get('id');
        ID ContractID =   ApexPages.CurrentPage().getParameters().get('cid');
         ID RecordID =   ApexPages.CurrentPage().getParameters().get('id');
		rtype = apexPages.currentPage().getParameters().get('rt')!=null ? apexPages.currentPage().getParameters().get('rt'):'';
		
        IncidentReport = [SELECT Id,Sunshine_Center__c,Sunshine_Center__r.Name,Name,RecordType.Name, RecordTypeId, Attachment1_Id_URl__c, Attachment2_Id_URl__c,
                    Attachment3_Id_URl__c, Attachment4_Id_URl__c, Attachment5_Id_URl__c, Attachment6_Id_URl__c, 
                    Attachment7_Id_URl__c, Attachment8_Id_URl__c, Attachment9_Id_URl__c, Attachment10_Id_URl__c 
                    FROM Incident_Report__c where Id =: RecordID];
       
        //clRecord = [select Id, Name, Opportunity__c, Treatment_Center__r.Name from Client_Chart__c where Id =: Incident_Report__c.Client_Chart__c ] ; 
        statusUpload = 'Pending';
        bucket = awsBucket__c.getInstance('FREEPU');
        RecordTypeName = IncidentReport.RecordType.Name;
        
        //Retrieve List of document type
        List <Documents_Type__c> listDocType = [select id, Name, Is_Active__c, Is_Required__c, Object_API_Name__c from Documents_Type__c 
                                                where Object_API_Name__c = 'Incident_Report__c' and Is_Active__c = true ORDER BY id ASC ];

        
        //List of Already attached document
        setExistingAttachments = new set<String>();
        if(IncidentReport.Attachment1_Id_URl__c!= null){
            setExistingAttachments.add('Incident Attachment 1'); 
        }
        
        if(IncidentReport.Attachment2_Id_URl__c!= null){
            setExistingAttachments.add('Incident Attachment 2'); 
        }
        
        
        if(IncidentReport.Attachment3_Id_URl__c!= null){
            setExistingAttachments.add('Incident Attachment 3'); 
        }
        
        if(IncidentReport.Attachment4_Id_URl__c!= null){
            setExistingAttachments.add('Incident Attachment 4'); 
        }
        
        if(IncidentReport.Attachment5_Id_URl__c!= null){
            setExistingAttachments.add('Incident Attachment 5'); 
        }
        
        if(IncidentReport.Attachment6_Id_URl__c!= null){
            setExistingAttachments.add('Incident Attachment 6'); 
        }
        
        if(IncidentReport.Attachment7_Id_URl__c!= null){
            setExistingAttachments.add('Incident Attachment 7'); 
        }
        
        if(IncidentReport.Attachment8_Id_URl__c!= null){
            setExistingAttachments.add('Incident Attachment 8'); 
        }
        
        if(IncidentReport.Attachment9_Id_URl__c!= null){
            setExistingAttachments.add('Incident Attachment 9'); 
        }
        
        if(IncidentReport.Attachment10_Id_URl__c!= null){
            setExistingAttachments.add('Incident Attachment 10'); 
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
        suffix = label.Production_or_Sanbox+'/'+IncidentReport.Sunshine_Center__r.Name+'/IncidentReport/'+RecordTypeName+'/'+IncidentReport.id+'/Attachments';

        

        


    }
    
    public pageReference cancelCustom(){
         ID ContractID =   ApexPages.CurrentPage().getParameters().get('cid');
         ID RecordID =   ApexPages.CurrentPage().getParameters().get('id');
        string RecordName =   ApexPages.CurrentPage().getParameters().get('rt');
     //   PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ContractDetailPage?id='+ID+'&rtId='+RecordTypeID+'&cid='+IncidentReport.id+'&rt='+rtype);
     //  PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ContractDetailPage?id='+IncidentReport.id+'&rt='+rtype);
       PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ContractDetailPage?id='+ContractID+'&cid='+RecordID+'&rt='+RecordName);
        
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
       // Medical__C tempCL = new Medical__c(id = (ID)dc.id);
       
       Incident_Report__c tempCL =[SELECT Id, Name, RecordTypeId, Attachment1_Id_URl__c, Attachment2_Id_URl__c,
                           Attachment3_Id_URl__c, Attachment4_Id_URl__c, Attachment5_Id_URl__c, Attachment6_Id_URl__c, 
                           Attachment7_Id_URl__c, Attachment8_Id_URl__c, Attachment9_Id_URl__c, Attachment10_Id_URl__c 
                           FROM Incident_Report__c where Id =:dc.id];

        
         
        
        if(tempCL.Attachment1_Id_URl__c== null)
            tempCL.Attachment1_Id_URl__c=  dc.link;
        else if(tempCL.Attachment1_Id_URl__c!= null && tempCL.Attachment2_Id_URl__c== null)
            tempCL.Attachment2_Id_URl__c=  dc.link;
        else if(tempCL.Attachment2_Id_URl__c!= null && tempCL.Attachment3_Id_URl__c== null)
            tempCL.Attachment3_Id_URl__c=  dc.link;
        else if(tempCL.Attachment3_Id_URl__c!= null && tempCL.Attachment4_Id_URl__c== null)
            tempCL.Attachment4_Id_URl__c=  dc.link;
        else if(tempCL.Attachment4_Id_URl__c!= null && tempCL.Attachment5_Id_URl__c== null)
            tempCL.Attachment5_Id_URl__c=  dc.link;
        else if(tempCL.Attachment5_Id_URl__c!= null && tempCL.Attachment6_Id_URl__c== null)
            tempCL.Attachment6_Id_URl__c=  dc.link;
        else if(tempCL.Attachment6_Id_URl__c!= null && tempCL.Attachment7_Id_URl__c== null)
            tempCL.Attachment7_Id_URl__c=  dc.link;
        else if(tempCL.Attachment7_Id_URl__c!= null && tempCL.Attachment8_Id_URl__c== null)
            tempCL.Attachment8_Id_URl__c=  dc.link;
        else if(tempCL.Attachment8_Id_URl__c!= null && tempCL.Attachment9_Id_URl__c== null)
            tempCL.Attachment9_Id_URl__c=  dc.link;
        else if(tempCL.Attachment9_Id_URl__c!= null && tempCL.Attachment10_Id_URl__c== null)
            tempCL.Attachment10_Id_URl__c=  dc.link;
        
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