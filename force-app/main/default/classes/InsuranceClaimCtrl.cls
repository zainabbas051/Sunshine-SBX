//Test Class : InsuranceClaimCtrlTest
public class InsuranceClaimCtrl {
    public case c;
    public set<String> setExistingAttachments; //List of Name of Uploaded Documents Type
    public List<docWrapper> setNewAttachments{get; set;} //List of Name of Non-uploaded Documents Type
    public String statusUpload {get;set;}
    public awsBucket__c bucket {get;set;} //Bucket permission set
    public Integer count {get;set;}
    public String suffix {get;set;}
    public Opportunity opty {get;set;}
    
    //Doc Url for parsing
    private string DocUrl{get;set;}
    public string DPDocDataUrl{get;set;}
    
    
    public InsuranceClaimCtrl(ApexPages.StandardController controller){
        c = [select Id, Insurance_Provider__c, Insurance_Group_Name__c, CaseNumber, Opportunity__r.Name, Claim_Number__c, Opportunity__r.Sunshine_Center__r.Name, Opportunity__r.Insurance_Provider__c, (SELECT Id, Name FROM Documents__r), 
            Non_Covered_Amount__c, Co_Pay_Amount__c , Co_Insurance_Amount__c ,Deductible_Amount__c from Case where Id =: controller.getId()] ;
        
        //opty = c.Opportunity__r;
        
        statusUpload = 'Pending';
        bucket = awsBucket__c.getInstance('salesforce');
        
        //Retrieve List of document type
        List <Documents_Type__c> listDocType = [select id, Name, Is_Active__c, Is_Required__c, Object_API_Name__c from Documents_Type__c 
                                                where Object_API_Name__c = 'Case' and Is_Active__c = true];
        
        
        //List of Already attached document
        setExistingAttachments = new set<String>();
        //for(Documents__c doc: c.Documents__r) {
         //   setExistingAttachments.add(doc.name); 
        //}
        
        //List of document to be uploaded
        setNewAttachments = new List<docWrapper>();        
        if (listDocType != Null && listDocType.size() > 0) {
            count = 1;
            /*for(Documents_Type__c docType: listDocType) {
                if (!setExistingAttachments.contains(docType.Name) && docType.Name.contains('Copy of Claim')) {
                    setNewAttachments.add(new docWrapper(docType.Name,count++));
                }
            }*/
            //The following lines add the ability to attach multiple Claim Correspondence and MR Requests records to a particular Claim
            //setNewAttachments.add(new docWrapper('Claim Correspondence',count++));
            //setNewAttachments.add(new docWrapper('MR Request',count++));
            setNewAttachments.add(new docWrapper('Explanation of Benefits*',count++));
            //setNewAttachments.add(new docWrapper('Copy of Payments*',count++));
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
        suffix = label.Production_or_Sanbox+'/'+c.Opportunity__r.Sunshine_Center__r.Name+'/'+c.Opportunity__r.Name+'/Case Number : '+c.CaseNumber+'_Claim Number : '+c.Claim_Number__c+'/Case Documents';
        
    }
    
    public pageReference SaveCustom(){       
        
        update c;
        
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/insuranceCaseViewPage?id='+c.id);
        return pr;
    }
    
    public pageReference cancelCustom(){
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/insuranceCaseViewPage?id='+c.id);
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
        
        return doc.AWS_Link__c;
    }
    
    
    public void callDocParser(){
        DocUrl = ApexPages.currentPage().getParameters().get('dUrl');
        
        String strApiKey = '4de51a63b452eb139e7bc70e76ef95a8982775ae';
        String strParserId = 'llxkithiadjg';
        String strTargetURL = 'https://api.docparser.com/v1/document/fetch/'+strParserId;//'https://api.docparser.com/v1/results/' + strParserId + '/<docpaser_Doc_Id>' ;
        //String strTargetURL = 'https://api.docparser.com/v1/results/' + strParserId + '/df24d696799f6afb368f8466e5edb4af' ;
        
        // send out the request
        HttpRequest req = New HttpRequest();
        req.setHeader('Authorization', 'Basic ' + strApiKey);
        req.setMethod('POST');
        req.setEndpoint(strTargetURL);
        req.setBody('url='+DocUrl);
        Http http = New Http();
        HTTPResponse res;
        if(!Test.isRunningTest())
            res = http.send(req);
        else{
            res=new HttpResponse();
            res.setBody('{"id":"ti123"}');
        }
        
        
        system.debug('res1'+res.getBody());
        DocUploadResult dur = (DocUploadResult)JSON.deserialize(res.getBody(), Docuploadresult.class);
        
        DPDocDataUrl = dur.id;
        
        System.debug('k:: ' + DPDocDataUrl);
    }
    
    public DocumentTableData listTableData {get;set;}
    public PageReference callDocParserResult(){
        
        string dpDocUrl = (DPDocDataUrl!=null)?DPDocDataUrl:ApexPages.currentPage().getParameters().get('recall');
        System.debug('dd::' + DPDocDataUrl);
        
        String strApiKey = '4de51a63b452eb139e7bc70e76ef95a8982775ae';
        String strParserId = 'llxkithiadjg';
        String strTargetURL = 'https://api.docparser.com/v1/results/' + strParserId + '/'+dpDocUrl ;
        
        // send out the request
        HttpRequest req = New HttpRequest();
        req.setHeader('Authorization', 'Basic ' + strApiKey);
        req.setMethod('GET');
        req.setEndpoint(strTargetURL);
        Http http = New Http();
        HTTPResponse res;
        if(!Test.isRunningTest())
            res = http.send(req);
        else{
            res = new HttpResponse(); 
            res.setBody('[{"id_x":"testabc","totals":{"net":"$100"},"table_data":[{"key_0":"Amount 1","Amount 2":"234$"},{"key_0":"$123","key_1":"234$"}]}]');
        }
        
        system.debug('res'+res.getBody());
        
        
        if(res.getBody() != '{"error":"File not yet processed."}'){
        
            statusUpload = 'All_Uploaded';
        List<DocumentData> listDocData = (List<DocumentData>)JSON.deserialize(res.getBody(), List<DocumentData>.Class);
            
        //United HealthCare
        if(c.Insurance_Group_Name__c.replace(' ','') == String.valueOf(InsuranceProvider.UnitedHealthCare) && listDocData[0].table_data[1]!=null) 
            listTableData = listDocData[0].table_data[1];
        
        //Blue Cross Blue Shield
        else if(c.Insurance_Group_Name__c.replace(' ','') == String.valueOf(InsuranceProvider.BlueCrossBlueShield) && listDocData[0].table_data_bcbs[1] != null) 
            listTableData = listDocData[0].table_data_bcbs[1];
     
        makeDataSet(listTableData,c.Insurance_Group_Name__c);
            return null;
        }
        else{
            PageReference pr = new PageReference('/apex/InsuranceClaimVfp?id='+c.Id+'&recall='+dpDocUrl);
            pr.setRedirect(true);
            return pr;
        }
            
    }
    
    Public DataValues dValues{get;set;}
    private void makeDataSet(DocumentTableData dtd,string ip){
        if(ip.replace(' ','') == String.valueOf(InsuranceProvider.UnitedHealthCare)){
            dValues = new DataValues();
            dValues.BilledAmount= dtd.key_7;
            dValues.PaidAmount= dtd.key_8;
            dValues.AllowedAmount = dtd.key_9;
            dValues.WriteOffAmount= dtd.key_10;
            dValues.NotCovered= dtd.key_11;
            dValues.TotalMemberResponsibility= dtd.key_12;
            dValues.CoPayAmount= dtd.key_13;
            dValues.DeductibleAmount= dtd.key_14;
            dValues.CoInsuranceAmount= dtd.key_15;
            dValues.PatientNotCovered= dtd.key_16;
            
            if(!Test.isRunningTest()){
            system.debug('dValues.WriteOffAmount :::::'+dValues.WriteOffAmount);
            system.debug('decimal of dValues.WriteOffAmount :::::'+Decimal.valueOf(dValues.WriteOffAmount.replace('$','').replace(',','')));
            
            
            c.Non_Covered_Amount__c = Decimal.valueOf(dValues.WriteOffAmount.replace('$','').replace(',','')) + Decimal.valueOf(dValues.NotCovered.replace('$','').replace(',',''));
            c.Co_Pay_Amount__c = Decimal.valueOf(dValues.CoPayAmount.replace('$','').replace(',',''));
            c.Co_Insurance_Amount__c = Decimal.valueOf(dValues.CoInsuranceAmount.replace('$','').replace(',',''));
            c.Deductible_Amount__c = Decimal.valueOf(dValues.DeductibleAmount.replace('$','').replace(',',''));
            //Porpable Collection Amount
            c.Collected_Amount__c =  Decimal.valueOf(dValues.PaidAmount.replace('$','').replace(',','')); 
            
            }
            
        }
        
        if(ip.replace(' ','') == String.valueOf(InsuranceProvider.BlueCrossBlueShield)){
            dValues = new DataValues();
            dValues.BilledAmount= dtd.key_6;
            dValues.PaidAmount= dtd.key_11;
            dValues.AllowedAmount = dtd.key_7;
            //dValues.WriteOffAmount= dtd.key_10;
            dValues.NotCovered= dtd.key_12;
            //dValues.TotalMemberResponsibility= dtd.key_12;
            dValues.CoPayAmount= dtd.key_10;
            dValues.DeductibleAmount= dtd.key_9;
            dValues.CoInsuranceAmount= dtd.key_8;
            //dValues.PatientNotCovered= dtd.key_16;
            //
            
            c.Non_Covered_Amount__c = Decimal.valueOf(dValues.NotCovered.replace('$','').replace(',',''));
            c.Co_Pay_Amount__c = Decimal.valueOf(dValues.CoPayAmount.replace('$','').replace(',',''));
            c.Co_Insurance_Amount__c = Decimal.valueOf(dValues.CoInsuranceAmount.replace('$','').replace(',',''));
            c.Deductible_Amount__c = Decimal.valueOf(dValues.DeductibleAmount.replace('$','').replace(',',''));
            c.Collected_Amount__c =  Decimal.valueOf(dValues.PaidAmount.replace('$','').replace(',',''));
            
        }
            
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
    
    public class DocUploadresult{
        public string id{get;set;}
        public string quota_used {get;set;}
        public string quota_left{get;set;}
    }
    
    Public Class DocumentData{
        public string id_x {get;set;}
        public DocumentTotals totals{get;set;}
        public List<DocumentTableData> table_data{get;set;}
        public List<DocumentTableData> table_data_bcbs{get;set;}
    }
    
    Public Class DocumentTotals{
        public string net{get;set;}
        public string tax{get;set;}
        public string total{get;set;}
        public string carriage{get;set;}
        public string confidence{get;set;}
    }
    
    Public Class DocumentTableData{
        public string key_0{get;set;}
        public string key_1{get;set;}
        public string key_2{get;set;}
        public string key_3{get;set;}
        public string key_4{get;set;}
        public string key_5{get;set;}
        public string key_6{get;set;}
        public string key_7{get;set;}
        public string key_8{get;set;}
        public string key_9{get;set;}
        public string key_10{get;set;}
        public string key_11{get;set;}
        public string key_12{get;set;}
        public string key_13{get;set;}
        public string key_14{get;set;}
        public string key_15{get;set;}
        public string key_16{get;set;}
    }
    
    Public enum InsuranceProvider{UnitedHealthCare,BlueCrossBlueShield}
    
    Public class DataValues{
        public string BilledAmount{get;set;}
        public string PaidAmount{get;set;}
        public string AllowedAmount{get;set;}
        public string WriteOffAmount{get;set;}
        public string NotCovered{get;set;}
        public string TotalMemberResponsibility{get;set;}
        public string CoPayAmount{get;set;}
        public string DeductibleAmount{get;set;}
        public string CoInsuranceAmount{get;set;}
        public string PatientNotCovered{get;set;}
        
        
    }  
}