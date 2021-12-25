//Test class : uploadDocuments_MedicalAttachmentsTest
public class uploadDocuments_MedicalAttachments{
    public Medical__c MDRecord;
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


    public uploadDocuments_MedicalAttachments(ApexPages.StandardController controller) {
        RecordTypeID= ApexPages.CurrentPage().getParameters().get('rtID');
        ID RecordID =   ApexPages.CurrentPage().getParameters().get('id');
		rtype = apexPages.currentPage().getParameters().get('rt')!=null ? apexPages.currentPage().getParameters().get('rt'):'';
		
        MDRecord = [SELECT Id, Name, Client_Chart__c ,RecordType.Name,Client_Chart__r.name, RecordTypeId, Attachment1_Id_URl__c, Attachment2_Id_URl__c,
                    Attachment3_Id_URl__c, Attachment4_Id_URl__c, Attachment5_Id_URl__c, Attachment6_Id_URl__c, 
                    Attachment7_Id_URl__c, Attachment8_Id_URl__c, Attachment9_Id_URl__c, Attachment10_Id_URl__c 
                    FROM Medical__c where Id =: RecordID];
       
        clRecord = [select Id, Name, Opportunity__c, Treatment_Center__r.Name from Client_Chart__c where Id =: MDRecord.Client_Chart__c ] ; 
        statusUpload = 'Pending';
        bucket = awsBucket__c.getInstance('FREEPU');
        RecordTypeName = MDRecord.RecordType.Name;
        
        //Retrieve List of document type
        List <Documents_Type__c> listDocType = [select id, Name, Is_Active__c, Is_Required__c, Object_API_Name__c from Documents_Type__c 
                                                where Object_API_Name__c = 'Medical__c' and Is_Active__c = true ORDER BY id ASC ];

        
        //List of Already attached document
        setExistingAttachments = new set<String>();
        if(MDRecord.Attachment1_Id_URl__c!= null){
            setExistingAttachments.add('Medical Attachment1'); 
        }
        
        if(MDRecord.Attachment2_Id_URl__c!= null){
            setExistingAttachments.add('Medical Attachment2'); 
        }
        
        
        if(MDRecord.Attachment3_Id_URl__c!= null){
            setExistingAttachments.add('Medical Attachment3'); 
        }
        
        if(MDRecord.Attachment4_Id_URl__c!= null){
            setExistingAttachments.add('Medical Attachment4'); 
        }
        
        if(MDRecord.Attachment5_Id_URl__c!= null){
            setExistingAttachments.add('Medical Attachment5'); 
        }
        
        if(MDRecord.Attachment6_Id_URl__c!= null){
            setExistingAttachments.add('Medical Attachment6'); 
        }
        
        if(MDRecord.Attachment7_Id_URl__c!= null){
            setExistingAttachments.add('Medical Attachment7'); 
        }
        
        if(MDRecord.Attachment8_Id_URl__c!= null){
            setExistingAttachments.add('Medical Attachment8'); 
        }
        
        if(MDRecord.Attachment9_Id_URl__c!= null){
            setExistingAttachments.add('Medical Attachment9'); 
        }
        
        if(MDRecord.Attachment10_Id_URl__c!= null){
            setExistingAttachments.add('Medical Attachment10'); 
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
        suffix = label.Production_or_Sanbox+'/'+clRecord.Treatment_Center__r.Name+'/'+clRecord.Name+'/Medical/'+RecordTypeName+'/'+MDRecord.id+'/Attachments';

        

        


    }
    
    public pageReference cancelCustom(){
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/MedicalHomeEditPage?id='+clRecord.id+'&rtId='+RecordTypeID+'&mcid='+MDRecord.id+'&rt='+rtype);
        
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
       
       Medical__C tempCL =[SELECT Id, Name, Client_Chart__c ,Client_Chart__r.name, RecordTypeId, Attachment1_Id_URl__c, Attachment2_Id_URl__c,
                           Attachment3_Id_URl__c, Attachment4_Id_URl__c, Attachment5_Id_URl__c, Attachment6_Id_URl__c, 
                           Attachment7_Id_URl__c, Attachment8_Id_URl__c, Attachment9_Id_URl__c, Attachment10_Id_URl__c 
                           FROM Medical__c where Id =:dc.id];

        
         
        
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