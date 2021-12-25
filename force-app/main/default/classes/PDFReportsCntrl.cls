public class PDFReportsCntrl {
    
    public ID clientChartID {get;set;}
    public String SelectedIds{get;set;}
    public string pdfMergeName{get;set;}
    
    
    Public PDFReportsCntrl(){
        clientChartID = ApexPages.currentPage().getParameters().get('Id');
    }
    
    public List<Intake_Forms__c> getIntakeForms(){
        return [SELECT Id,Name, RecordTypeId, RecordType.Name FROM Intake_Forms__c WHERE Status__c = 'Closed' and Client_Chart__c =:clientChartID];
    }
    
    public List<Clinical_Evaluation__c> getClinicalEvaluations(){
        return [SELECT Id,Name, RecordTypeId, RecordType.Name FROM Clinical_Evaluation__c WHERE Status__c IN ('Closed','In Progress') and Client_Chart__c =:clientChartID];
    }
    
     public List<Clinical_Evaluation_2__c> getClinicalEvaluations2(){
        return [SELECT Id,Name, RecordTypeId, RecordType.Name FROM Clinical_Evaluation_2__c WHERE Client_Chart__c =:clientChartID];
    }
    
    public List<Clinical_Evaluation_3__c> getClinicalEvaluations3(){
        return [SELECT Id,Name, RecordTypeId, RecordType.Name FROM Clinical_Evaluation_3__c WHERE HP_Status__c IN ('Closed','In Progress') and recordtype.developerName NOT IN ('History_And_Physical','Phsych_Evaluation') and Client_Chart__c =:clientChartID];
    }
    
    public List<Medical__c> getMedicals(){
        return [SELECT Id,Name, RecordTypeId, RecordType.Name,LA_Title__c FROM Medical__c WHERE Status__c IN ('Closed','In Progress') and Client_Chart__c =:clientChartID];
    }
    
    public List<Clinical_Evaluation_3__c> getHistoryPhysical(){
        return [SELECT Id,Name, RecordTypeId, RecordType.Name FROM Clinical_Evaluation_3__c WHERE HP_Status__c IN ('Closed','In Progress') and recordtype.developerName IN ('History_And_Physical','Phsych_Evaluation') and Client_Chart__c =:clientChartID];
    }
    
    public List<Clinical_Evaluation__c> getPsycEvaluation(){
        return [select id, name, RecordTypeId,RecordType.Name, Status__c, Client_Chart__r.Name, Client_Chart__c,
                (select id, SignedBy__c, HP_Status__c, Staff_Closed_Date__c, Staff_Signature_URL_Closed__c ,Client_Image_Url_Closed__c, Staff_Signed_User_Closed__c from Clinical_Evaluations_3__r) from Clinical_Evaluation__c
                                        where Client_Chart__c =:clientChartId AND recordtype.Name = 'Phsych Evaluation'];
    }
    
    public List<Clinical_Note__c> getClinicalNotes(){
        return [SELECT Id,Name, RecordTypeId, RecordType.Name FROM Clinical_Note__c WHERE Status__c IN ('Closed','In-Progress') and Client_Chart__c =:clientChartID];
    }
    
    public List<Tx_and_D_C_Plans__c> getTXDC(){
        return [SELECT Id,Name, RecordTypeId, RecordType.Name FROM Tx_and_D_C_Plans__c WHERE Status__c IN ('Closed','In Use') and Client_Chart__c =:clientChartID];
    }
    
    public List<Recurring_Assessment__c> getRecurringAssessments(){
        return [SELECT Id,Name, RecordTypeId, RecordType.Name FROM Recurring_Assessment__c WHERE Status__c = 'Closed' and Client_Chart__c =:clientChartID];
    }
    
    public List<Order__c> getMeds(){
        return [SELECT Id,Name FROM Order__c WHERE Status__c IN ('Under Review','Pending Pharmacy', 'Active', 'Under Review - Discontinue', 'Inactive') and Client_Chart__c =:clientChartID];
    }
    
    public List<Assessment_IR_Tools__c> getAssessmentIR(){
        return [SELECT Id,Name, RecordTypeId, RecordType.Name FROM Assessment_IR_Tools__c WHERE Status__c = 'Complete' and Client_Chart__c =:clientChartID];
    }
    
     public List<UtlizationReviewOrder__c> getIncidentReport(){
        return [SELECT Id, Incident_Report__r.Id,Incident_Report__r.name,Incident_Report__r.RecordTypeId,Incident_Report__r.RecordType.Name FROM UtlizationReviewOrder__c WHERE Client_Chart__c =:clientChartID and Incident_Report__r.Status__c = 'Complete'];
    }
    
    public List<Utilization_Review__c> getUtilizationReview(){
        return [SELECT Id,Name, RecordTypeId, RecordType.Name FROM Utilization_Review__c WHERE Status__c = 'Complete' and Client_Chart__c =:clientChartID AND RecordType.Name = 'Utilization Review'];
    }
    
     public List<PHI_Log__c > getPHILog(){
        return [SELECT Id,Name, RecordTypeId, RecordType.Name FROM PHI_Log__c WHERE Status__c IN ('Closed','Active','In Active') and Client_Chart__c =:clientChartID];
    }
    
    private void buildJson(List<string> listSelectedIds){
        
        
        List<pdf_urls> listUrls = new List<pdf_urls>();
        listUrls = buildPDFURLs(listSelectedIds, listUrls);
        
        
        PDFURLS pdfurljson = new PDFURLS(System.UserInfo.getName(),
                                       string.valueOf(Date.today()),
                                       'Chapters Capistrano',
                                        listUrls);
        
        System.debug('JSON:: ' + JSON.serialize(pdfurljson));
        
        string result = postJSON(JSON.serialize(pdfurljson));
        
        System.debug('res:: ' + result);
        
        RequestResult res = (RequestResult )JSON.deserialize(result,RequestResult.class);
        
        PDF_Merge__c pdfM = new PDF_Merge__c(Name=pdfMergeName,
                                              Requester_Name__c =System.UserInfo.getName(),
                                              Client_Chart__c = clientChartID,
                                              Requested_Date__c = Date.today(),
                                              Status__c = 'Pending',
                                              Requested_JSON__c = JSON.serialize(pdfurljson),
                                              Request_ID__c = res.Request_ID);
        insert pdfM;
        
      
        
        
    }
    
    public PageReference postIds(){
        

        
        List<String> listSelectedIds = (List<String>)JSON.deserialize(SelectedIds, List<string>.class);
        
        buildJson(listSelectedIds);
        
        PageReference pr = new PageReference('/apex/PDFReportsHome?Id='+clientChartID);
        
        return pr;
    }
    
    public List<pdf_urls> buildPDFURLs(List<string> listSelectedIds, List<pdf_urls> listUrls){
            
        for(String str: listSelectedIds){
            List<String> listStr = str.split('-');
            string objectName = listStr[0];
            string recId = listStr[1];
            string rtId = listStr[2];
            string rtName = listStr[3];
            
            if(objectName.Equals('Face Sheet'))
                listUrls.add(new pdf_urls('/FaceSHeetHomePagePDF?ID='+clientChartID+'&Intake='+recId));
            if(objectName.Equals('Consents'))
                listUrls.add(new pdf_urls('/IntakePageDetail_PDF?ID='+clientChartID+'&Intake='+recId));
            else if(objectName.Equals('Clinical Evaluations')){
                if(rtName == 'Phsych Evaluation')
                    listUrls.add(new pdf_urls('/PsychEvaluation2PDF?ID='+clientChartID+'&ceId='+recId+'&type='+rtName));
                else if(rtName == 'History And Physical')
                    listUrls.add(new pdf_urls('/CE_HP2PDF?ID='+clientChartID+'&ceId='+recId+'&type='+rtName));
                 else if(rtName == 'Bio')
                     listUrls.add(new pdf_urls('/ClinicalEvaluationDetailPagePDF?ID='+clientChartID+'&ceId='+recId+'&type=Bio-Psychosocial Assessment'));
                else
                    listUrls.add(new pdf_urls('/ClinicalEvaluationDetailPagePDF?ID='+clientChartID+'&ceId='+recId+'&type='+rtName));
            }
            else if(objectName.equals('Medicals')){
                 if(rtName == 'Phsych Evaluation')
                    listUrls.add(new pdf_urls('/PsychEvaluation2PDF?ID='+clientChartID+'&ceId='+recId+'&type='+rtName));
                else if(rtName == 'History And Physical')
                    listUrls.add(new pdf_urls('/CE_HP2PDF?ID='+clientChartID+'&ceId='+recId+'&type='+rtName));
                else
                    listUrls.add(new pdf_urls('/MedicalHomeEditPagePDF?ID='+clientChartID+'&mcid='+recId+'&rtId='+rtId));
            }
            else if(objectName.equals('Clinical Notes'))
                listUrls.add(new pdf_urls('/ClinicalNotesDetailPDF?ID='+clientChartID+'&clNID='+recId));
            else if(objectName.equals('TXDC'))
                listUrls.add(new pdf_urls('/TxDcDetailPagePDF?ID='+clientChartID+'&TXDX='+recId));
            else if(objectName.equals('RA')){
                if(rtName == 'Vital Signs')
                    listUrls.add(new pdf_urls('/VitalSignsPDF?ID='+clientChartID+'&vsId='+recId));
                else if(rtName =='CIWA')
                    listUrls.add(new pdf_urls('/CIWAPDF?ID='+clientChartID+'&ciId='+recId));
                else if(rtName =='COWS')
                    listUrls.add(new pdf_urls('/COWSPDF?ID='+clientChartID+'&coId='+recId));
                else if(rtName =='BMI')
                    listUrls.add(new pdf_urls('/BMIPDF?ID='+clientChartID+'&bmId='+recId));
                else if(rtName =='Blood Glucose')
                    listUrls.add(new pdf_urls('/BloodGlucosePDF?ID='+clientChartID+'&gId='+recId));
                else if(rtName =='Wellness Check')
                    listUrls.add(new pdf_urls('/WellnessPDF?ID='+clientChartID+'&wcId='+recId));
            }
            else if(objectName.equals('MEDS'))
                listUrls.add(new pdf_urls('/MedsPDF?ID='+clientChartID+'&orderid='+recId ));
            else if(objectName.equals('AIR'))
                listUrls.add(new pdf_urls('/AssesmentDetailPagePDF?ID='+clientChartID+'&IR='+recId ));
            else if(objectName.equals('Incident Report'))
                listUrls.add(new pdf_urls('/ContractDetailPagePDF?ID='+clientChartID+'&cid='+recId ));
            else if(objectName.equals('Utilization Review'))
                listUrls.add(new pdf_urls('/utilizationreviewpdf?id='+clientChartID+'&UtilId='+recId));
                else if(objectName.equals('PHI'))
                listUrls.add(new pdf_urls('/PHILogDetailPDF?id='+clientChartID+'&PHIID='+recId));
        }
        
        return listUrls;
    }
    
    
    private string postJSON(string reqJSON){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://hr.addictionnetwork.com/api/v1/pdf_merge');
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        req.setBody(reqJSON);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        system.debug('#res='+res);
        system.debug('#resB='+res.getBody());
        return res.getBody();
    }
    
    public class PDFURLS{

        public string Requester {get;set;}
        public string RequestedDate {get;set;}
        public string Sunshine_Center_Name{get;set;}
        public List<pdf_urls> PDF_URLs {get;set;}
        
        public PDFURLS(string Requester, string RequestedDate, string Sunshine_Center_Name,List<pdf_urls> PDF_URLs){
            this.Requester = Requester;
            this.RequestedDate = RequestedDate;
            this.Sunshine_Center_Name = Sunshine_Center_Name;
            this.PDF_URLs = PDF_URLs;
        }
    }
    
    public class pdf_urls{
        public string url{get;set;}
        
        public pdf_urls(string url_x){
            if(Label.Production_or_Sanbox == 'Production'){
                this.url = 'http://addictionnetwork.force.com/SHPDFMerge'+url_x;
            }else{
                this.url = 'http://sandboxsh-addictionnetwork.cs68.force.com/SHPDFMerge'+url_x;
            }
            
        }
    }
    
    public Class RequestResult{
        public string Request_ID{get;set;}
    }
}