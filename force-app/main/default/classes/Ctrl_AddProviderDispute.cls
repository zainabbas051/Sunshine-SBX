public class Ctrl_AddProviderDispute {
    public string SelectedReasonForProviderDispute {
        get;
        set;
    }
    public string SelectedLetterOrigin {
        get;
        set;
    }
    public Provider_Dispute__c providerDisputeObj {
        get;
        set;
    }
    
    public string SelectedTypeofMail {
        get;
        set;
    }
    
    public string inputFileBlob {get;set;}
    
    public Blob outputFile {get;set;}
    
    public string bodyContent2 {
        get;
        set;
    }
    public string bodyContent {
        get;
        set;
    }
    public string PDisFile {
        get;
        set;
    }
    public boolean callJs {
        get;
        set;
    }
    public string suffix {
        get;
        set;
    }
    public string ProviderDisputeID {
        get;
        set;
    }
    public string Enclosures {
        get;
        set;
    }
    public string OtherLetterBody {
        get;
        set;
    }
    public string OtherBody {get;set;}
    public string PDName {
        get;
        set;
    }
    public string PDId {
        get;
        set;
    }
    public string OtherName {
        get;
        set;
    }
     public string PDLetterOrigin {
        get;
        set;
    }
    public boolean createUrl_boolean {
        get;
        set;
    }


    public string baseurl {
        get {
            return URL.getSalesforceBaseUrl().toExternalForm() + '/apex/insuranceCaseViewPage?id=' + ApexPages.currentPage().getParameters().get('id');
        }
        set;
    }
    public id currentUserId {
        get {
            return userInfo.getUserId();
        }
        set;
    }
    public string InsuranceProviderAddress {
        get;
        set;
    } 
    public List < SelectOption > getReasonsforProviderDispute() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('Medical Necessity Reason', 'Medical Necessity Reason'));
        options.add(new SelectOption('Proof of Timely Filling', 'Proof of Timely Filling'));
       // options.add(new SelectOption('No Authorization on File', 'No Authorization on File'));
        options.add(new SelectOption('Others', 'Others'));

        return options;
    }
    
    public List < SelectOption > getLetterOrigin() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('None', 'None'));
        options.add(new SelectOption('Sunshine BH', 'Sunshine BH'));
        options.add(new SelectOption('Insurance Provider', 'Insurance Provider'));


        return options;
    }
    
     public List < SelectOption > getTypeofMail() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('None', 'None'));
        options.add(new SelectOption('Regular Mail', 'Regular Mail'));
        options.add(new SelectOption('Digital Copy', 'Digital Copy'));

        return options;
    }
    
    
    Boolean success;

    public Ctrl_AddProviderDispute() {
        string caseID = ApexPages.currentPage().getParameters().get('id');
        Case caseObj = [select id, Opportunity__r.Name, Opportunity__r.Sunshine_Center__r.Name, CaseNumber, Claim_Number__c,
                        Opportunity__r.Sunshine_Center__r.BillingStreet, Opportunity__r.Sunshine_Center__r.BillingCity, 
                        Opportunity__r.Sunshine_Center__r.BillingState, Opportunity__r.Sunshine_Center__r.BillingPostalCode 
                        from Case where id =: caseID];
        //suffix = label.Production_or_Sanbox + '/' + caseObj.Opportunity__r.Sunshine_Center__r.Name + '/' + caseObj.Opportunity__r.Name + '/Provider Disputes/';
        suffix = label.Production_or_Sanbox + '/' + caseObj.Opportunity__r.Sunshine_Center__r.Name + '/' + caseObj.Opportunity__r.Name + '/Case Number : ' + caseObj.CaseNumber + '/Provider Dispute Letters/';
        success = true;
        
     /*   if(caseObj.Opportunity__r.Sunshine_Center__r.Name == 'Chapters Capistrano'){
            OtherBody = '<table width="100%"><tr><td><table style="float:left;"><tr><td><img src="{!URLFOR($Resource.Chapters_Logo)}" height="100" width="115"/></td></tr></table></td><td><table style="float:right;"><tr><td>{!caseObj.Opportunity__r.Sunshine_Center__r.Name }</td></tr><tr><td>{!caseObj.Opportunity__r.Sunshine_Center__r.BillingStreet},</td></tr><tr><td style="white-space: nowrap;">{!caseObj.Opportunity__r.Sunshine_Center__r.Name.BillingCity}, {!caseObj.Opportunity__r.Sunshine_Center__r.Name.BillingState}, {!caseObj.Opportunity__r.Sunshine_Center__r.Name.BillingPostalCode}</td></tr></table></td></tr></table>'; 
        }
        if(caseObj.Opportunity__r.Sunshine_Center__r.Name == 'Monarch Shores'){
        
        }
        if(caseObj.Opportunity__r.Sunshine_Center__r.Name == 'Willowsprings Recovery'){
            OtherBody = '<table width="100%"><tr><td><table style="float:left;"><tr><td><img src="{!URLFOR($Resource.Willow_Logo)}" height="100" width="115"/></td></tr></table></td><td><table style="float:right;"><tr><td>'+caseObj.Opportunity__r.Sunshine_Center__r.Name+'</td></tr><tr><td>'+caseObj.Opportunity__r.Sunshine_Center__r.BillingStreet+',</td></tr><tr><td style="white-space: nowrap;">'+caseObj.Opportunity__r.Sunshine_Center__r.BillingCity+', '+caseObj.Opportunity__r.Sunshine_Center__r.BillingState+', '+caseObj.Opportunity__r.Sunshine_Center__r.BillingPostalCode+'</td></tr></table></td></tr></table>'; 
        }
 */
    }
    public PageReference RedirectToOtherReason() {

        PageReference retURL = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Page_NewProviderDispute_OtherReason?id=' + ApexPages.currentPage().getParameters().get('id') + '&pd_id=' + PDId);
        retURL.setRedirect(true);
        return retURL;

    }
    Public void createProviderDisputeUrl() {

        CreateProviderDispute();
        if(success)
           createUrl_boolean = true;

    }

    public void CreateUrl() {

        PageReference pdf;
        if(SelectedLetterOrigin== 'Sunshine BH'){
        try {
            if (SelectedReasonForProviderDispute == 'Medical Necessity Reason')
                pdf = Page.page_MedicalNecessityReason1PDF;

            else if (SelectedReasonForProviderDispute == 'Proof of Timely Filling')
                pdf = Page.page_ProofOfTimelyFillingPDF;
            
            else if (SelectedReasonForProviderDispute == 'Others')
                pdf = Page.page_OtherProviderDisputeLetter;

            system.debug('**PDId' + PDId);
            pdf.getParameters().put('id', ApexPages.currentPage().getParameters().get('id'));
            pdf.getParameters().put('pd_id', PDId);

            Blob body;

            if (Test.IsRunningTest()) {
                body = Blob.valueOf('UNIT.TEST');
            } else {
                body = pdf.getContentAsPDF();
            }
            System.debug('++++body' + body);
            bodyContent2 = EncodingUtil.base64Encode(body);
            callJs = true;
        } catch (exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Something went wrong while generating the Provider Dispute Letter PDF : ' + e.getMessage() + e.getLineNumber()));
            createUrl_boolean = false;
            callJs = false;
        }
        }
        if(SelectedLetterOrigin=='Insurance Provider')
        {
            callJs = true;
            
        }


    }
    
    public void CheckFileUpload(){
        String message = '';
        success = true;
         if(SelectedLetterOrigin == 'Insurance Provider')
        {
            
            if(PDisFile=='false'){
                success = false;
                message = 'Empty or Invalid File Selected';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                
            }
        }
        
    }

    public boolean checkRequiredFieldsSave() {
        String message = '';
        success = true;
        system.debug('++file'+PDisFile);
        if(SelectedLetterOrigin=='None'){
            
                success = false;
                message = 'Please Select a Valid Letter Origin';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                createUrl_boolean = false;
                callJs = false;
        }
       
        if (SelectedReasonForProviderDispute == 'Others' ||SelectedLetterOrigin == 'Insurance Provider') {

            if (OtherName == '' || OtherName == null) {
                success = false;
                message = 'Please Enter a Name';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                createUrl_boolean = false;
                callJs = false;
            }
        }
        
         if(SelectedLetterOrigin == 'Insurance Provider')
        {
            if(PDisFile=='false'){
                success = false;
                message = 'Empty or Invalid File Selected';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                createUrl_boolean = false;
                callJs = false;
                
            }
            if(PDisFile!='true'){
                success = false;
                message = 'Please browse and select and a file';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                createUrl_boolean = false;
                callJs = false;
                
            }
            
            
            
            if(SelectedTypeofMail=='None'){
                
                success = false;
                message = 'Please Select Type of Mail';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                createUrl_boolean = false;
                callJs = false;
            }
            
        }

        if(SelectedLetterOrigin != 'Insurance Provider' && SelectedLetterOrigin != 'None' )
        {
        
        if (InsuranceProviderAddress == '' || InsuranceProviderAddress == null) {
            success = false;
            message = 'Insurance Provider Address Field Cannot be Left Blank';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            createUrl_boolean = false;
            callJs = false;
        }
        if (Enclosures == '' || Enclosures == null) {
            success = false;
            message = 'Enclosures Field Cannot be Left Blank';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            createUrl_boolean = false;
            callJs = false;
        }
        
        
        }
        
        
        return success;

    }

    public PageReference CreateProviderDispute() {


        if (checkRequiredFieldsSave() == True ||Test.IsRunningTest() ) {
            try {
                
                if(SelectedLetterOrigin=='Insurance Provider'){
                    SelectedReasonForProviderDispute ='Insurance Provider Reply';
                }
                Id devRecordTypeId = Schema.SObjectType.Provider_Dispute__c.getRecordTypeInfosByName().get(SelectedReasonForProviderDispute).getRecordTypeId();
                system.debug('++++' + devRecordTypeId);
                providerDisputeObj = new Provider_Dispute__c();
                providerDisputeObj.Related_Case__c = ApexPages.currentPage().getParameters().get('id');
                if(SelectedLetterOrigin=='Insurance Provider'){
                     providerDisputeObj.Status__c = 'Received';
                     providerDisputeObj.Type_of_Mail_Used__c=SelectedTypeofMail;
                     providerDisputeObj.Communication_Sent_Date_Time_Stamp__c=DateTime.now();
                }
                
                   
                
                
                if(SelectedLetterOrigin=='Sunshine BH'){
                    providerDisputeObj.Enclosures__c = Enclosures;
                    providerDisputeObj.Insurance_Provider_Address__c=InsuranceProviderAddress;
                    providerDisputeObj.Status__c = 'Not Sent';
                
                
                }
                
                providerDisputeObj.RecordTypeId = devRecordTypeId;
                providerDisputeObj.Other_Name__c = OtherName;
                providerDisputeObj.Letter_Body__c = OtherLetterBody;
                providerDisputeObj.Letter_Origin__c  = SelectedLetterOrigin;

               
                if (SelectedReasonForProviderDispute == 'Others' || SelectedLetterOrigin=='Insurance Provider') {


                    providerDisputeObj.Name = OtherName;
                } else
                    providerDisputeObj.Name = SelectedReasonForProviderDispute;

                insert providerDisputeObj;

                PDId = providerDisputeObj.id;
                PDName = providerDisputeObj.Name;
                PDLetterOrigin = SelectedLetterOrigin;

                system.debug('++++PDId' + PDId);
                system.debug('++++PDName' + PDName);

              /*  if (SelectedReasonForProviderDispute == 'Others') {
                    PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Page_NewProviderDispute_OtherReason?id=' + ApexPages.currentPage().getParameters().get('id') + '&pd_id=' + PDId);
                    return pr;
                }
                */
                
                
                

           } catch (exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Something went wrong while generating the Provider Dispute Record : ' + e.getMessage() + e.getLineNumber()));
                createUrl_boolean = false;
                callJs = false;
            }
        }

        return null;
    }

    public PageReference CancelProcess() {

        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/insuranceCaseViewPage?id=' + ApexPages.currentPage().getParameters().get('id'));
        return pr;
    }



}