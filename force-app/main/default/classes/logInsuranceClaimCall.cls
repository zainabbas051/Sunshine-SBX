//Test Class : logInsuranceClaimCallTest
global without sharing class logInsuranceClaimCall {

    private final opportunity oppRecord;
    public string defaultval2 {get{return 'zoobeez';} set;}

    //for showing add or edit user
    public boolean displayPopUp {get; set;}
    public boolean displayProviderDisputeSentPopUp {get; set;}
    public boolean displayeEditCase {get; set;}
    public boolean displayPaymentPendingCase {get; set;}
    public boolean displayPendingPaymentDocumentUpload {get; set;}
    public boolean displayAdjustmentCase {get; set;}
    public boolean displayPendingAdjustmentDocumentUpload {get; set;}
    //param gives us the id of the row to Edit or Delete
    public Insurance_Claim_Medical_Records_Request__c mrr {get; set;}
    Public string notesForMRR {get; set;}
    Public string notesForDMCR {get; set;}
    public string faxNumber {get; set;}
    public string mailingAddress {get; set;}
    public string caseIdValue {get; set;}
    public Case tempCaseRecord {get; set;}
    public string caseCurrentStatus {get; set;}
    public string insuranceAgentReferenceNumber {get; set;}
    public string insuranceAgentName {get; set;}
    public string subscriberId {get; set;}
    public string patientName {get; set;}
    public date admissionDate{get; set;}
    public date checkoutDate{get; set;}
    public string insuranceProvider {get; set;}
    public string dateOfBirth {get; set;}
    public string intakeAgent {get; set;}
    Public String collector {get; set;}
    Public string npiNumber {get; set;}
    public string taxId {get; set;}
    String openCaseNewStatus = '';
    String appealCaseNewStatus = '';
    public id frEditIndex {get; set;}
    public id frSentIndex {get; set;}
    public string invoiceIdNew {get ; set;}
    public string bodyContent2 {get ; set;}
    public boolean callJs {get; set;}
    public id piptmsentindex {get; set;}
    public string bodyContent {get; set;}
    public string status {get; set;}
    public string Notes_By_Requester {get; set;}

    public list<ProviderDispute> ProviderDisputeList {
        get{
            if (ProviderDisputeList == null) ProviderDisputeList = new List<ProviderDispute>();
            return ProviderDisputeList;
        } set;
    }
    public string SelectedTypeofMail {
        get;
        set;
    }
    
    public string MailTrackingNo {
        get;
        set;
    }
    public id pdsentindex {get; set;}
    public id pddeleteindex {get; set;}
     
    public boolean displayProviderDisputeList {
        get{return caseRecordParam.Provider_Dispute_Initiated__c;} set;
    }

   public Case caseRecordParam{
       get;set;
   }

    public id frSaveIndex {get; set;}
    public string suffix {get; set;}

    public id currentUserId {
        get{
            return userInfo.getUserId();
        } set;
    }

    public string baseurl {
        get{
            return URL.getSalesforceBaseUrl().toExternalForm() + '/apex/logInsuranceClaimCall?id=' + ApexPages.currentPage().getParameters().get('id');
        } set;
    }
    public boolean displayPtminvoiceList {
        get {return CaseList.size() > 0; } set;
    }


    public logInsuranceClaimCall() {
        loadData();
        string  opporID = ApexPages.currentPage().getParameters().get('id');
        List<Opportunity> lstOpp = new list<opportunity>();
        opportunity oppIns;
        if (opporID != null)
            lstOpp  = [select Name, Sunshine_Center__r.Name from opportunity where id = :OpporId];
        if (lstOpp.size() > 0) {
            oppIns = lstOpp.get(0);


            suffix = label.Production_or_Sanbox + '/' + oppIns.Sunshine_Center__r.Name + '/' + oppIns.Name + 'Pay To Member Invoice/PTM_Invoice_Process_Name/';
        }
        List<Case_Override_User_Access__mdt> userIds = [select User_Id__c from Case_Override_User_Access__mdt where User_Id__c = :UserInfo.getUserId()];
        overRideUserFlag = userIds.size() > 0;
    }

    public list<Case> openCaseList {
        get{
            if (openCaseList == null) openCaseList = new List<Case>();
            return openCaseList;
        } set;
    }

    public boolean displayOpenCasesList {
        get{return openCaseList.size() > 0;} set;
    }

    public list<Case> closedCaseList {
        get{
            if (closedCaseList == null) closedCaseList = new List<Case>();
            return closedCaseList;
        } set;
    }
    public boolean displayClosedCaseList {
        get{return closedCaseList.size() > 0;}
    }

    public list<Case> pendingAdjustmentCaseList {
        get{
            if (pendingAdjustmentCaseList == null) pendingAdjustmentCaseList = new List<Case>();
            return pendingAdjustmentCaseList;
        } set;
    }
    public boolean displayPendingAdjustmentCaseList {
        get{return pendingAdjustmentCaseList.size() > 0;} set;
    }

    public list<Case> pendingPaymentCaseList {
        get{
            if (pendingPaymentCaseList == null) pendingPaymentCaseList = new List<Case>();
            return pendingPaymentCaseList;
        } set;
    }
    public boolean displayPendingPaymentCaseList {
        get{
            return pendingPaymentCaseList.size() > 0;
        } set;
    }
    public list<Case> allCasesList {
        get{
            if (allCasesList == null) allCasesList = new List<Case>();
            return allCasesList;
        } set;
    }

    public list<fedexReq> fedexReqList {
        get{
            if (fedexReqList == null) fedexReqList = new List<fedexReq>();
            return fedexReqList;
        } set;
    }

    public list<ptmInv> ptmInvList {
        get{
            if (ptmInvList == null) ptmInvList = new List<ptmInv>();
            return ptmInvList;
        } set;
    }
    
     public list<ptmInv> ptmInvListLabRequest {
        get{
            if (ptmInvListLabRequest == null) ptmInvListLabRequest = new List<ptmInv>();
            return ptmInvListLabRequest;
        } set;
    }
    
    public boolean overRideUserFlag {
        get; set;
    }

public list<case> caseList {
        get{
            if (caseList == null) caseList = new List<case>();
            return caseList;
        } set;
    }

    public List<SelectOption> getOpenCaseNewStatuses() {
        string OptionStr=System.Label.NewCaseStatus;
        String[] arrOptions = OptionStr.split(';');
        List<SelectOption> options = new List<SelectOption>();
        for(string str : arrOptions){
        
         options.add(new SelectOption(str, str));
        }
        



        return options;
    }
    public String getopenCaseNewStatus() {
        return openCaseNewStatus;
    }
    public void setopenCaseNewStatus(String openCaseNewStatus) {
        this.openCaseNewStatus = openCaseNewStatus;
    }


    public List<SelectOption> getAppealCaseNewStatuses() {
        List<SelectOption> options = new List<SelectOption>();

        options.add(new SelectOption('Appeal Sent', 'Appeal Sent'));
        options.add(new SelectOption('Appeal Received', 'Appeal Received'));
        options.add(new SelectOption('Appeal Denied', 'Appeal Denied'));


        return options;
    }
    public String getappealCaseNewStatus() {
        return appealCaseNewStatus;
    }
    
     public List < SelectOption > getTypeofMail() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('None', 'None'));
        options.add(new SelectOption('Regular Mail', 'Regular Mail'));
        options.add(new SelectOption('Digital Copy', 'Digital Copy'));
        options.add(new SelectOption('Mail with Tracking Number', 'Mail with Tracking Number'));

        return options;
    }
    
    public void setappealCaseNewStatus(String appealCaseNewStatus) {
        this.appealCaseNewStatus = appealCaseNewStatus;
    }
    public void loadCaseDate() {
        string oppId = ApexPages.currentPage().getParameters().get('id');
        if (oppId != null) {

            for (Case c : [Select id, Bill_From_Date__c, Bill_To_Date__c, Opportunity__r.Name, Billed_Amount__c, Subscriber_Id__c, Insurance_Provider__c, Insurance_Provider_Claim_Number__c,Opportunity__r.Closing_Date__c,Opportunity__r.Check_Out_Date__c,
                           Date_of_Birth__c, Bill_Date__c, Status, Claim_Number__c, Claim_Type__c, Collection_Reference__c, Description, Intake_Coordinator__c,
                           Adjustment_Reference__c, Adjustment_Amount__c, CaseNumber, Pricing_Type__c, Insurance_Carve_Out_3rd_Party__c, Level_of_Care__c, Insurance_Provider_Claim_Received_Date__c,
                           KIPU_MRN__c, Owner.name, Collected_Amount__c, Collection_Date__c, Co_Pay_Amount__c, Deductible_Amount__c, Total_Collected_Amount__c,Opportunity__r.Assigned_Medical_Records_Associate__c,
                           Appeal_for_Adjustment_Requested__c, Last_Modified_Date_Time__c, NPI__c, Tax_Id__c, Amount_Being_Paid_To_Member__c, PTM_Case__c, Co_Insurance_Amount__c,Original_Case_Owner__c
                           from Case Where Opportunity__c = : oppId AND Status != 'Missing Data Updated In Claims' AND RecordTypeId = : Constants.insuranceClaimRecordTypeId and Level_of_care__c!='Lab Requests' order by Bill_From_Date__c]) {
                subscriberId = c.Subscriber_Id__c;
                patientName = c.Opportunity__r.Name;
                dateOfBirth = c.Date_of_Birth__c;
                insuranceProvider = c.Insurance_Provider__c;
                intakeAgent = c.Intake_Coordinator__c;
                collector = c.owner.Name;
                npiNumber = c.NPI__c;
                taxId = c.Tax_Id__c;
                admissionDate=c.Opportunity__r.Closing_Date__c;
                checkoutDate=c.Opportunity__r.Check_Out_Date__c;
                allCasesList.add(c);
                 String[] arrOpenCaseStatus = System.Label.OpenCaseStatus.split(';');
                 String[] arrClosedCaseStatus = System.Label.ClosedCaseStatus.split(';');
                 String[] arrPendingPaymentCase = System.Label.PendingPaymentCase.split(';');
                 String[] arrPendingAdjustmentCaseStatus = System.Label.PendingAdjustmentCaseStatus.split(';');
                 if(arrOpenCaseStatus.contains(c.Status)) openCaseList.add(c);
                 else if(arrClosedCaseStatus.contains(c.Status)) closedCaseList.add(c);
                 else if(arrPendingPaymentCase.contains(c.Status)) pendingPaymentCaseList.add(c);
                 else if(arrPendingAdjustmentCaseStatus.contains(c.Status)) pendingAdjustmentCaseList.add(c);
            /*   if (c.Status == 'Processing' || c.Status == 'COB Issue' || c.Status == 'Policy Issue / Termed' || c.Status == 'Requesting Medical Records' ||
                        c.status == 'Claim Receipt Confirmation Pending' || c.status == 'Received Medical Records' || c.status == 'Pay To Member' || c.status == 'No Claim on File' || c.status == 'Denial' || c.status == 'Billing Issue' ||c.status == 'Follow Up' ||c.status == 'Courtesy Bill' || c.status == 'Resubmitted' || c.status == 'Void Sent' )
                    openCaseList.add(c);
                if (c.status == 'Closed' || c.Status == 'Denied' || c.Status == 'Duplicate Claim'  || c.status == 'To Deductible/Co Insurance')
                    closedCaseList.add(c);
                if (c.Status == 'Payment Scheduled' || c.Status == 'Negotiation' || c.status == 'Deductible')
                    pendingPaymentCaseList.add(c);
                if (c.status == 'Adjustment in Progress' || c.status == 'Appeal Receipt Confirmation Pending' || c.Status == 'Appeal Under Processing' || c.Status == 'Appeal for Adjustment Requested' || c.Status == 'Appeal Denied'|| c.status == 'Provider Dispute' || c.status == 'Underpaid' || c.status=='Correction Sent')
                    pendingAdjustmentCaseList.add(c); */
            }

        }
    }
    
    
    public void loadLabRequestCaseDate() {
        string oppId = ApexPages.currentPage().getParameters().get('id');
        if (oppId != null) {

            for (Case c : [Select id, Bill_From_Date__c, Bill_To_Date__c, Opportunity__r.Name, Billed_Amount__c, Subscriber_Id__c, Insurance_Provider__c, Insurance_Provider_Claim_Number__c,Opportunity__r.Closing_Date__c,Opportunity__r.Check_Out_Date__c,
                           Date_of_Birth__c, Bill_Date__c, Status, Claim_Number__c, Claim_Type__c, Collection_Reference__c, Description, Intake_Coordinator__c,
                           Adjustment_Reference__c, Adjustment_Amount__c, CaseNumber, Pricing_Type__c, Insurance_Carve_Out_3rd_Party__c, Level_of_Care__c, Insurance_Provider_Claim_Received_Date__c,
                           KIPU_MRN__c, Owner.name, Collected_Amount__c, Collection_Date__c, Co_Pay_Amount__c, Deductible_Amount__c, Total_Collected_Amount__c,Opportunity__r.Assigned_Medical_Records_Associate__c,
                           Appeal_for_Adjustment_Requested__c, Last_Modified_Date_Time__c, NPI__c, Tax_Id__c, Amount_Being_Paid_To_Member__c, PTM_Case__c, Co_Insurance_Amount__c,Original_Case_Owner__c
                           from Case Where Opportunity__c = : oppId AND Status != 'Missing Data Updated In Claims' AND RecordTypeId = : Constants.insuranceClaimRecordTypeId AND Level_of_care__c='Lab Requests' order by Bill_From_Date__c]) {
                subscriberId = c.Subscriber_Id__c;
                patientName = c.Opportunity__r.Name;
                dateOfBirth = c.Date_of_Birth__c;
                insuranceProvider = c.Insurance_Provider__c;
                intakeAgent = c.Intake_Coordinator__c;
                collector = c.owner.Name;
                npiNumber = c.NPI__c;
                taxId = c.Tax_Id__c;
                admissionDate=c.Opportunity__r.Closing_Date__c;
                checkoutDate=c.Opportunity__r.Check_Out_Date__c;
                allCasesList.add(c);
                 String[] arrOpenCaseStatus = System.Label.OpenCaseStatus.split(';');
                 String[] arrClosedCaseStatus = System.Label.ClosedCaseStatus.split(';');
                 String[] arrPendingPaymentCase = System.Label.PendingPaymentCase.split(';');
                 String[] arrPendingAdjustmentCaseStatus = System.Label.PendingAdjustmentCaseStatus.split(';');
                 if(arrOpenCaseStatus.contains(c.Status)) openCaseList.add(c);
                 else if(arrClosedCaseStatus.contains(c.Status)) closedCaseList.add(c);
                 else if(arrPendingPaymentCase.contains(c.Status)) pendingPaymentCaseList.add(c);
                 else if(arrPendingAdjustmentCaseStatus.contains(c.Status)) pendingAdjustmentCaseList.add(c);
            /*   if (c.Status == 'Processing' || c.Status == 'COB Issue' || c.Status == 'Policy Issue / Termed' || c.Status == 'Requesting Medical Records' ||
                        c.status == 'Claim Receipt Confirmation Pending' || c.status == 'Received Medical Records' || c.status == 'Pay To Member' || c.status == 'No Claim on File' || c.status == 'Denial' || c.status == 'Billing Issue' ||c.status == 'Follow Up' ||c.status == 'Courtesy Bill' || c.status == 'Resubmitted' || c.status == 'Void Sent' )
                    openCaseList.add(c);
                if (c.status == 'Closed' || c.Status == 'Denied' || c.Status == 'Duplicate Claim'  || c.status == 'To Deductible/Co Insurance')
                    closedCaseList.add(c);
                if (c.Status == 'Payment Scheduled' || c.Status == 'Negotiation' || c.status == 'Deductible')
                    pendingPaymentCaseList.add(c);
                if (c.status == 'Adjustment in Progress' || c.status == 'Appeal Receipt Confirmation Pending' || c.Status == 'Appeal Under Processing' || c.Status == 'Appeal for Adjustment Requested' || c.Status == 'Appeal Denied'|| c.status == 'Provider Dispute' || c.status == 'Underpaid' || c.status=='Correction Sent')
                    pendingAdjustmentCaseList.add(c); */
            }

        }
    }

    public pageReference cancel() {
        string oppId = ApexPages.currentPage().getParameters().get('id');
        pageReference pr = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/logInsuranceClaimCall?id=' + oppId);
        return pr;
    }
    
     public pageReference cancelinsuranceCase() {
        string oppId = ApexPages.currentPage().getParameters().get('id');
        pageReference pr = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/insuranceCaseViewPage?id=' + oppId);
        return pr;
    }
    public pageReference canceProviderDisputeSent() {
        string oppId = ApexPages.currentPage().getParameters().get('id');
        pageReference pr = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/insuranceCaseViewPage?id=' + oppId);
        return pr;
    }

    public pageReference createNewCase() {
        string oppId = ApexPages.currentPage().getParameters().get('id');
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/newInsuranceClaimCase?oppId=' + oppId);
        return pr;

    }

    public void showEditUserScreen() { //this method takes us to the Popup to edit an existing ACA Schedule record
       System.debug('____'+allCasesList);
        displayPopUp = true;
        
        for (Case c : allCasesList) {
            System.debug('caseIdValue ::::' + caseIdValue);
            System.debug('case id ::::' + c.id);
            if (caseIdValue == c.id) {
                caseCurrentStatus = c.Status;
                tempCaseRecord = c;//this prepopulates the existing values of the record on the edite screen
                tempCaseRecord.Description = '';
                insuranceAgentReferenceNumber = '';
                insuranceAgentName = '';
                break;
            }
             System.debug('******'+tempCaseRecord);
        }
    }

    public void showProviderDisputeSentPopup() { 
       
       SelectedTypeofMail='None';
       MailTrackingNo='';
       displayProviderDisputeSentPopUp = true;
        
    }



    public PageReference showCase() { //this method takes us to the Popup to edit an existing ACA Schedule record
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/insuranceCaseViewPage?id=' + caseIdValue);
        return pr;
    }

    public pageReference saveCaseLog() {
    
        if(caseRecordParam == null && tempCaseRecord!= null)
            caseRecordParam = tempCaseRecord;
            
        System.debug('******'+caseRecordParam);
        System.debug('Insurance Provider Claim Number:::' + caseRecordParam.Description);
        System.debug('Insurance Provider Claim Number:::' + caseRecordParam.Insurance_Provider_Claim_Number__c);
        System.debug('tempCaseRecord::::' + caseRecordParam);

        if (checkRequiredFieldsSave(caseRecordParam) == True) {
            string oppId = ApexPages.currentPage().getParameters().get('id');
            displayPopUp = False;
            mrr = new Insurance_Claim_Medical_Records_Request__c();
    
          
            List<Insurance_Claim_Medical_Records_Request__c> allRelatedInsurance_Claim_Medical_Records_Requests = new List<Insurance_Claim_Medical_Records_Request__c>();
            Data_Missing_in_Claim_Request__c dmcr = new Data_Missing_in_Claim_Request__c();
            Insurance_Call_Log__c icl = new Insurance_Call_Log__c();
            icl.Call_Log_Notes__c = caseRecordParam.Description;
            icl.Name_of_Insurance_Call_Agent__c = insuranceAgentName;
            icl.Reference_of_Insurance_Call_Agent__c = insuranceAgentReferenceNumber;
            icl.Related_Case__c = caseRecordParam.id;
            icl.Previous_Case_Status__c = caseCurrentStatus;
            icl.Date_Time_Call_Logged__c = dateTime.Now();
            if (caseRecordParam.Appeal_for_Adjustment_Requested__c == True)
                icl.New_Case_Status__c = appealCaseNewStatus;
            else
                icl.New_Case_Status__c = openCaseNewStatus;


            Case updateCase = new Case(id = caseRecordParam.id, Last_Modified_Date_Time__c = dateTime.Now());
            updateCase.Insurance_Provider_Claim_Number__c = caseRecordParam.Insurance_Provider_Claim_Number__c;
            updateCase.Insurance_Provider_Claim_Received_Date__c = caseRecordParam.Insurance_Provider_Claim_Received_Date__c;

            if (caseRecordParam.Appeal_for_Adjustment_Requested__c == False) {
                updateCase.Status = openCaseNewStatus;
                if (caseCurrentStatus != openCaseNewStatus && openCaseNewStatus == 'Payment Scheduled') {
                    updateCase.Collection_Reference__c = caseRecordParam.Collection_Reference__c;
                    updateCase.Collected_Amount__c = caseRecordParam.Collected_Amount__c;
                }
                
                List<MR_Request_Round_Robin_User__c> MRUsr = new List<MR_Request_Round_Robin_User__c>(); ////Edited by Safia Osman///
                List<MR_Request_Round_Robin_User__c> MRUsr2 = new List<MR_Request_Round_Robin_User__c>();////Edited by Safia Osman///
                Set<MR_Request_Round_Robin_User__c> MRUsr1 = new Set<MR_Request_Round_Robin_User__c>();////Edited by Safia Osman///
                MRUsr = MR_Request_Round_Robin_User__c.getall().values();////Edited by Safia Osman///
                System.debug('MR USERS:::' + MRUsr);
                if (test.isRunningTest() || (caseCurrentStatus != openCaseNewStatus && openCaseNewStatus == 'Requesting Medical Records')) {
                    mrr.Notes_By_Requester__c = notesForMRR;
                    mrr.Related_Case__c = caseRecordParam.id;
                    mrr.Status__c = 'Open';
                    mrr.Fax_Number__c = faxNumber;
                   // mrr.OwnerId = label.Medical_Records_User; ////Edited by Safia Osman///
                    mrr.Mailing_Address__c = mailingAddress;
                    ////Edited by Safia Osman///
                    
                    if(caseRecordParam.Opportunity__r.Assigned_Medical_Records_Associate__c!=null)
                   
                       mrr.OwnerId=caseRecordParam.Opportunity__r.Assigned_Medical_Records_Associate__c;
                       
                   else if(caseRecordParam.Opportunity__r.Assigned_Medical_Records_Associate__c==null)
                   {
                       integer i,j;
                    if(MRUsr.size()==1){
                        MRUsr[0].Last_Assigned_To__c = true;
                        try{
                            
                            Opportunity op = new Opportunity(id = caseRecordParam.Opportunity__r.id) ;
                            op.Assigned_Medical_Records_Associate__c=MRUsr[0].User_Id__c;
                            update op;
                      
                    
                            }
                            catch (exception e) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()));
                                }
                               
                        mrr.OwnerId =  MRUsr[0].User_Id__c;
                       
                    }
                    else if (MRUsr.size()>1)
                    {
                    for(i = 0; i<MRUsr.size();i++){
                        if(MRUsr[i].Last_Assigned_To__c == true){
                            try{
                            
                            Opportunity op = new Opportunity(id = caseRecordParam.Opportunity__r.id) ;
                            op.Assigned_Medical_Records_Associate__c=MRUsr[i].User_Id__c;
                            
                            update op;
                      
                    
                            }
                            catch (exception e) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()));
                                }
                               
                            mrr.OwnerId =  MRUsr[i].User_Id__c;
                            MRUsr[i].Last_Assigned_To__c = false;
                            MRUsr1.add(MRUsr[i]);
                            j = i + 1;
                            if(j == MRUsr.size()){
                                j = 0;
                          
                             } 
                         }
                     }
                     System.debug('MR USERS[j]:::' + MRUsr[j]);    
                     MRUsr[j].Last_Assigned_To__c = true;
                     MRUsr1.add(MRUsr[j]);
                     if(MRUsr1.size() > 0){
                         MRUsr2.addAll(MRUsr1);
                         update MRUsr2;
                     }
                    }
                   }
                   
                    
                    
                     
                }
                if (caseCurrentStatus != openCaseNewStatus && openCaseNewStatus == 'Data Missing in Claim') {
                    dmcr.Notes_By_Requester__c = notesForDMCR;
                    dmcr.Related_Case__c = caseRecordParam.id;
                    dmcr.Status__c = 'Open';
                    dmcr.Fax_Number__c = faxNumber;
                    dmcr.OwnerId = label.Billing_User;
                }
                if (caseCurrentStatus != openCaseNewStatus && openCaseNewStatus == 'Pay To Member') {
                    updateCase.Amount_Being_Paid_To_Member__c = tempCaseRecord.Amount_Being_Paid_To_Member__c;
                    updateCase.PTM_Case__c = true;
                }

            } else {
                updateCase.Status = appealCaseNewStatus;
                if (appealCaseNewStatus == 'Adjustment in Progress' && caseCurrentStatus != appealCaseNewStatus) {
                    updateCase.Adjustment_Reference__c = caseRecordParam.Adjustment_Reference__c;
                    updateCase.Adjustment_Amount__c = caseRecordParam.Adjustment_Amount__c;
                    updateCase.Appeal_for_Adjustment_Status__c = 'Adjusted';
                }
                if (appealCaseNewStatus == 'Appeal Denied' && caseCurrentStatus != appealCaseNewStatus) {
                    updateCase.Appeal_for_Adjustment_Status__c = 'Denied';
                    updateCase.Adjustment_Denied_Reason__c = caseRecordParam.Adjustment_Denied_Reason__c;
                }
            }

            try {
                insert icl;
                if (mrr.Related_Case__C != null) {
                    mrr.Related_Insurance_Call_Log__c = icl.id;
                    insert mrr;
                }
                if (dmcr.Related_Case__C != null) {
                    dmcr.Related_Insurance_Call_Log__c = icl.id;
                    insert dmcr;
                }
                update updateCase;
                String pageName = ApexPages.currentPage().getParameters().get('currentvfpage');
                pageReference pr = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/'+pageName+'?id=' + oppId);
                return pr;
            } catch (exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()));
            }
        }
        return null;
    }

    public boolean checkRequiredFieldsPDSent() {
        String message = '';
        Boolean success = true;

        if (SelectedTypeofMail == 'None') {
            success = false;
            message = 'Please Select Type of Mail';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        
         if (SelectedTypeofMail == 'Mail with Tracking Number' && (MailTrackingNo==''|| MailTrackingNo==null)) {
            success = false;
            message = 'Please Enter Mail Tracking Number';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        
        return success;
    }

    public boolean checkRequiredFieldsSave(Case tempCaseRecord) {
        String message = '';
        Boolean success = true;

        if (insuranceAgentName == '' || insuranceAgentName == null) {
            success = false;
            message = 'Name of Insurance Call Agent is required to save the Insurance Call Log!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        if (insuranceAgentReferenceNumber == '' || insuranceAgentReferenceNumber == null) {
            success = false;
            message = 'Reference Number of Insurance Call Agent is required to save the Insurance Call Log!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        if (tempCaseRecord.Appeal_for_Adjustment_Requested__c == False) {
            if (openCaseNewStatus == null || openCaseNewStatus == '') {
                success = false;
                message = 'Please Select a New Case Status Values before Saving the Call Log!!';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
            if ((openCaseNewStatus == 'Processing' || openCaseNewStatus == 'Requesting Medical Records') && openCaseNewStatus != caseCurrentStatus && tempCaseRecord.Insurance_Provider_Claim_Number__c == null) {
                success = false;
                message = 'Please Enter the Insurance Provider Claim Number before Saving the Call Log!!';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
            if ((openCaseNewStatus == 'Processing' || openCaseNewStatus == 'Requesting Medical Records') && openCaseNewStatus != caseCurrentStatus && tempCaseRecord.Insurance_Provider_Claim_Received_Date__c == null) {
                success = false;
                message = 'Please Enter the Insurance Provider Claim Received Date before Saving the Call Log!!';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
            if (openCaseNewStatus != '' && caseCurrentStatus != openCaseNewStatus && openCaseNewStatus == 'Data Missing in Claim') {
                if (notesForDMCR == null || notesForDMCR == '') {
                    success = false;
                    message = 'Notes for Data Missing in Claim Request Cannot be Left Blank!!';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                }
                if (faxNumber == null || faxNumber == '') {
                    success = false;
                    message = 'Fax Number cannot be Left Blank!!';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                }
            }
            if (openCaseNewStatus != '' && caseCurrentStatus != openCaseNewStatus && openCaseNewStatus == 'Requesting Medical Records') {
                if (notesForMRR == null || notesForMRR == '') {
                    success = false;
                    message = 'Notes for Medical Records Request Cannot be Left Blank!!';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                }
                if (faxNumber == null || faxNumber == '') {
                    success = false;
                    message = 'Fax Number cannot be Left Blank!!';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                }
                if (mailingAddress == null || mailingAddress == '') {
                    success = false;
                    message = 'Mailing Address cannot be Left Blank!!';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                }

            }

            if (openCaseNewStatus != '' && caseCurrentStatus != openCaseNewStatus && openCaseNewStatus == 'Pay To Member') {
                if (tempCaseRecord.Amount_Being_Paid_To_Member__c == null) return showError('Amount Being Paid To Member Cannot be Left Blank!!');
            }

            if (caseCurrentStatus != openCaseNewStatus && openCaseNewStatus != '' && openCaseNewStatus == 'Payment Scheduled') {
                if (tempCaseRecord.Collection_Reference__c == null || tempCaseRecord.Collection_Reference__c == '') {
                    success = false;
                    message = 'As Payment is Schedule, you cannot leave the Collection Reference Field Blank before saving the Insurance Call Log!!';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                }
                if (tempCaseRecord.Collected_Amount__c == null) {
                    success = false;
                    message = 'As Payment is Schedule, you cannot leave the Collection Amount Field Blank before saving the Insurance Call Log!!';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                }
            }
        } else {
            if (appealCaseNewStatus == '') {
                success = false;
                message = 'Please Select a New Case Status Values before Saving the Call Log!!';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
            if (appealCaseNewStatus == 'Adjustment in Progress' && caseCurrentStatus != appealCaseNewStatus && appealCaseNewStatus != '') {
                if (tempCaseRecord.Adjustment_Reference__c == null || tempCaseRecord.Adjustment_Reference__c == '') return showError('As Adjustment Payment is Schedule, you cannot leave the Adjustment Amount Field Blank before saving the Insurance Call Log!!');
                if (tempCaseRecord.Adjustment_Amount__c == null) return showError('As Adjustment Payment is Schedule, you cannot leave the Adjustment Amount Field Blank before saving the Insurance Call Log!!');
            }
            if (appealCaseNewStatus == 'Appeal Denied' && caseCurrentStatus != appealCaseNewStatus && appealCaseNewStatus != '') if (tempCaseRecord.Adjustment_Denied_Reason__c == null || tempCaseRecord.Adjustment_Reference__c == '') return showError('As Adjustment is Denied, you cannot leave the Appeal Denied Reason Field Blank before saving the Insurance Call Log!!');
            
        }
        return success;
    }

    private boolean showError(String error) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, error));
        return false;
    }

    public pageReference addFedexReq() {
        system.debug('Test123333::');
        String message = '';
        Boolean tempflag = false;
        if (fedexReqList.size() > 0) {
            for (fedexReq fr : fedexReqList) {
                if (fr.status != 'Sent') {
                    tempflag = true;

                }
            }
        }
        If (tempflag == false) {
            Fedex_Envelope_Request__c tempFER = new Fedex_Envelope_Request__c();
            tempFER.Related_Opp__c = ApexPages.currentPage().getParameters().get('id');

            system.debug('related case::' + tempFER.Related_Opp__c);
            insert tempFER;

            system.debug('Fed Request::::' + TempFER);

            PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/logInsuranceClaimCall?id=' + tempFER.Related_Opp__c);
            return pr;
        } else {
            showError('Please make sure all previous Rows are in Sent Status to create a new Fedex Request Row!!');
        }
        return null;
    }

    public void editFedexRequest() {
        if (frEditIndex != null) {
            for (fedexReq fr : fedexReqList) {
                if (fr.fr_id == frEditIndex) {
                    fr.readOnly = False;
                    break;
                }
            }
        }
    }

    public void sentFedexRequest() {
        if (frSentIndex != null) {
            for (fedexReq fr : fedexReqList) {
                if (fr.fr_id == frSentIndex) {
                    Fedex_Envelope_Request__c fer = new Fedex_Envelope_Request__c(id = frSentIndex);
                    if (checkRequiredFieldsSentFedexItem(fr) == False) {
                        break;
                    } else {
                        fer.Status__c = 'Sent';
                        fr.readOnly = False;

                        try {
                            update fer;
                        } catch (exception e) {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm, e.getMessage()));
                        }

                        break;
                    }
                }
            }
            loadData();
        }
    }
    public boolean checkRequiredFieldsSentFedexItem(fedexReq  frRecord) {
        String message = '';
        Boolean success = true;

        if (frRecord.envcreatedt == null ) {
            success = false;
            message = 'Please Make Sure Envelope Created Date has been punched in the  Fedex Request Line Item You Are Trying to CLOSE!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }

        if (frRecord.envsentdt == null ) {
            success = false;
            message = 'Please Make Sure Envelope Sent Date has been punched in the Fedex Request Line Item You Are Trying to CLOSE!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }

        if (frRecord.envtrackingno == null) {
            success = false;
            message = 'Please Make Sure Envelope Tracking # has been punched in the Fedex Request Line Item You Are Trying to CLOSE!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }

        return success;
    }

    public void loadData() {
        string  oppID = ApexPages.currentPage().getParameters().get('id');
        string  caseID = ApexPages.currentPage().getParameters().get('id');


        for (Provider_Dispute__c pd : [SELECT Id, Name, Status__c, CreatedBy.name,CreatedDate,AWS_URL__c,RecordType.name,Communication_Sent_Date_Time_Stamp__c,Letter_Origin__c,Type_of_Mail_Used__c,Outbound_Mail_Tracking_Number__c FROM Provider_Dispute__c WHERE Related_Case__c = : caseID ORDER BY CreatedDate DESC NULLS LAST]) {
            ProviderDispute pdObj = new ProviderDispute(pd.id, pd.Name, pd.Status__c, pd.CreatedBy.name, pd.CreatedDate, pd.AWS_URL__c, True,pd.RecordType.name,pd.Communication_Sent_Date_Time_Stamp__c,pd.Letter_Origin__c,pd.Type_of_Mail_Used__c,pd.Outbound_Mail_Tracking_Number__c);
            Integer index = 0;
            while (index < ProviderDisputeList.size()) {
             
                if (pdObj.pd_id == ProviderDisputeList[index].pd_id ) {
                    ProviderDisputeList.remove(index);
                } else {
                    index++;
                }
            }

            ProviderDisputeList.add(pdObj);
       
        }
        
        if (fedexReqList.size() > 0)
            fedexReqList.clear();

        for (Fedex_Envelope_Request__c fer : [SELECT Id, Name, Envelope_Created_Date__c, Envelope_Sent_Date__c, Envelope_Tracking__c, Status__c FROM Fedex_Envelope_Request__c  WHERE Related_Opp__c = : oppID ORDER BY CreatedDate DESC NULLS LAST]) {
            fedexReq fr = new fedexReq(fer.id, fer.Name, fer.Status__c, fer.Envelope_Created_Date__c, fer.Envelope_Sent_Date__c, fer.Envelope_Tracking__c, True);
            fedexReqList.add(fr);
        }

        for (PTM_Invoice_Process__c pip : [SELECT Id, Name,Is_Lab_Request__c, PTM_Invoice_Status__c, Invoice_Generated_By__r.name, Invoice_Generated_Date__c, Invoice_Sent_By__r.name, Invoice_Sent_Date__c, Invoice_URL__c FROM PTM_Invoice_Process__c WHERE Related_Opp__c = : oppID 
                                            ORDER BY CreatedDate DESC NULLS LAST]) {
                
                if(pip.Is_Lab_Request__c == false){
                    ptmInv pi = new ptmInv(pip.id, pip.Name, pip.PTM_Invoice_Status__c, pip.Invoice_Generated_By__r.name, pip.Invoice_Generated_Date__c, pip.Invoice_Sent_By__r.name, pip.Invoice_Sent_Date__c, pip.Invoice_URL__c, True);
                    // boolean shallAddItem=true;
                    Integer index = 0;
                    while (index < ptmInvList.size()) {
                        //if(ptmInvList.get(index).equals(pi))
                        if (pi.pi_id == ptmInvList[index].pi_id ) {
                            ptmInvList.remove(index);
                        } else {
                            index++;
                        }
                    }
                    //         for(integer index=0;index<ptmInvList.size();index++){
                    // if(pi.pi_id==ptmInvList[index].pi_id && pi.invstatus== ptmInvList[index].invstatus){
                    // shallAddItem=false;
                    //break;
                    // }
                    // }
                    //if(shallAddItem){
                    ptmInvList.add(pi);
                }
                else{
                    
                    ptmInv pi = new ptmInv(pip.id, pip.Name, pip.PTM_Invoice_Status__c, pip.Invoice_Generated_By__r.name, pip.Invoice_Generated_Date__c, pip.Invoice_Sent_By__r.name, pip.Invoice_Sent_Date__c, pip.Invoice_URL__c, True);
                    // boolean shallAddItem=true;
                    Integer index = 0;
                    while (index < ptmInvListLabRequest.size()) {
                        //if(ptmInvList.get(index).equals(pi))
                        if (pi.pi_id == ptmInvListLabRequest[index].pi_id ) {
                            ptmInvListLabRequest.remove(index);
                        } else {
                            index++;
                        }
                    }
                    //         for(integer index=0;index<ptmInvList.size();index++){
                    // if(pi.pi_id==ptmInvList[index].pi_id && pi.invstatus== ptmInvList[index].invstatus){
                    // shallAddItem=false;
                    //break;
                    // }
                    // }
                    //if(shallAddItem){
                    ptmInvListLabRequest.add(pi);
                    
                }
            // }
        }

    for (case c: [select id, PTM_Case__c, status, casenumber,level_of_care__c from case where Opportunity__c = : oppID ]) {
                if (c.PTM_Case__c == True)
                    caselist.add(c);
            }

    }

    public void saveFedexRequest() {
        if (frSaveIndex != null) {
            for (fedexReq fr : fedexReqList) {
                if (fr.fr_id == frSaveIndex ) {
                    fr.readOnly = True;
                    Fedex_Envelope_Request__c fer = new Fedex_Envelope_Request__c(id = frSaveIndex);
                    fer.Envelope_Created_Date__c = fr.envcreatedt ;
                    fer.Envelope_Sent_Date__c = fr.envsentdt;
                    fer.Envelope_Tracking__c = fr.envtrackingno;

                    try {
                        update fer;
                    } catch (exception e) {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm, e.getMessage()));
                    }

                    break;
                }
            }
            loadData();
        }
    }
    
    public pageReference addInvProcessLabRequest(){
        
        String message = '';
        Boolean tempflag = false;
        if (ptmInvListLabRequest.size() > 0) {
            for (ptmInv pi : ptmInvListLabRequest) {
                if (pi.invstatus != 'Invoice Sent') {
                    tempflag = true;
                }
            }
        }
        If (tempflag == false) {
            system.debug(' add invoice para');
            PTM_Invoice_Process__c tempPIP = new PTM_Invoice_Process__c();
            tempPIP.Related_Opp__c = ApexPages.currentPage().getParameters().get('id');
            tempPIP.Is_Lab_Request__c = true;
            insert tempPIP ;
            list<Invoice_Junction__c> invcaselist = new list<Invoice_Junction__c>();
        for (case c: caseList) {
                    if (c.status == 'Pay To Member' && c.level_of_care__c =='Lab Requests') {
                        Invoice_Junction__c invcase = new Invoice_Junction__c();
                        invcase.PTM_Case__c = c.id;
                        invcase.PTM_Invoice_Process__c = tempPIP.id;
                        invcaselist.add(invcase);
                    }
                }
            insert invcaselist;

            PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/logInsuranceClaimCall?id=' + tempPIP.Related_Opp__c);
            return pr;


        } else {
            message = 'Please make sure all previous Rows are in Invoice Sent Status to create a new Invoice Process Row!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }

        return null;
    }

    public pageReference addInvProcess() {
        String message = '';
        Boolean tempflag = false;
        if (ptmInvList.size() > 0) {
            for (ptmInv pi : ptmInvList) {
                if (pi.invstatus != 'Invoice Sent') {
                    tempflag = true;
                }
            }
        }
        If (tempflag == false) {
            system.debug(' add invoice para');
            PTM_Invoice_Process__c tempPIP = new PTM_Invoice_Process__c();
            tempPIP.Related_Opp__c = ApexPages.currentPage().getParameters().get('id');
            tempPIP.Is_Lab_Request__c = false;
            insert tempPIP ;
            list<Invoice_Junction__c> invcaselist = new list<Invoice_Junction__c>();
        for (case c: caseList) {
                    if (c.status == 'Pay To Member' && c.level_of_care__c!='Lab Requests') {
                        Invoice_Junction__c invcase = new Invoice_Junction__c();
                        invcase.PTM_Case__c = c.id;
                        invcase.PTM_Invoice_Process__c = tempPIP.id;
                        invcaselist.add(invcase);
                    }
                }
            insert invcaselist;

            PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/logInsuranceClaimCall?id=' + tempPIP.Related_Opp__c);
            return pr;


        } else {
            message = 'Please make sure all previous Rows are in Invoice Sent Status to create a new Invoice Process Row!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }

        return null;
    }

    Public void createPdfUrl() {
        system.debug('Is create PDF called??');
        PageReference pdf = Page.MS_PTM_Itemized_Stmnt;
        pdf.getParameters().put('id', invoiceIdNew);
        Blob body;

        if (Test.IsRunningTest()) {
            body = Blob.valueOf('UNIT.TEST');
        } else {
            body = pdf.getContentAsPDF();
        }
        bodyContent2 = EncodingUtil.base64Encode(body);
        callJs = true;
    }

    public void ptminvsent() {
        system.debug('piptm value' + piptmsentindex  );
       
        if (piptmsentindex != null) {
            PTM_Invoice_Process__c  tempPIP = new PTM_Invoice_Process__c (id = piptmsentindex);
            tempPIP.PTM_Invoice_Status__c = 'Invoice Sent';
            tempPIP.Invoice_Sent_By__c =  UserInfo.getUserId();
            tempPIP.Invoice_Sent_Date__c = date.today();
            update tempPIP;


        }
        loadData();

    }
    
    
    public pageReference addProviderDisputeProcess() {
        
        String message = '';
        Boolean AddNewFlag = true;
        
        if (ProviderDisputeList.size() > 0) {
            for (ProviderDispute pd : ProviderDisputeList) {
                if (pd.pdstatus == 'Not Sent') {
                    AddNewFlag = false;
                }
            }
        }
        
        If (AddNewFlag == true) {
            String caseID=ApexPages.currentPage().getParameters().get('id');
            PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Page_NewProviderDispute?id=' + caseID);
            return pr;


        } else {
            message = 'Since an Existing Provider Dispute Communication Already Exists in Not Sent Status, you cannot create another one';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        return null;
    }
    
     public void providerDisputesent() {

      if(checkRequiredFieldsPDSent()==true)
      {
       if (pdsentindex != null) {
            Provider_Dispute__c  tempPD = new Provider_Dispute__c (id = pdsentindex);
            tempPD.Status__c = 'Sent';
            tempPD.Communication_Sent_Date_Time_Stamp__c = DateTime.Now();
            tempPD.Outbound_Mail_Tracking_Number__c=MailTrackingNo;
            tempPD.Type_of_Mail_Used__c=SelectedTypeofMail;
            update tempPD;
            displayProviderDisputeSentPopUp = false;

        }
        loadData();
      }
      
        

    }

    public void DeleteproviderDispute() {

       if (pddeleteindex != null) {
            Provider_Dispute__c  tempPD = new Provider_Dispute__c (id = pddeleteindex);
            delete tempPD;
             integer index = 0;
            while (index < ProviderDisputeList.size()) {
             
                if (tempPD.id == ProviderDisputeList[index].pd_id ) {
                    ProviderDisputeList.remove(index);
                } else {
                    index++;
                }
            }

        }
    }
    
    public pageReference uploadEOBLink() {
        
        String caseID=ApexPages.currentPage().getParameters().get('id');
        pageReference pr = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/InsuranceClaimVfp?id='+caseID);
        return pr;
    }





    public class fedexReq {
        public id fr_id {get; set;}
        public string fr_name {get; set;}
        public boolean readOnly {get; set;}
        public date envcreatedt {get; set;}
        public date envsentdt {get; set;}
        public string envtrackingno {get; set;}
        public string status {get; set;}

        public fedexReq(string fr_id, String fr_name, string status, date envcreatedt, date envsentdt, string envtrackingno, boolean readOnly) {
            this.fr_id = fr_id;
            this.fr_name = fr_name;
            this.status = status;
            this.envcreatedt = envcreatedt;
            this.readOnly = readOnly;
            this.envsentdt = envsentdt;
            this.envtrackingno = envtrackingno;
        }
    }


    public class ptmInv {
        public id pi_id {get; set;}
        public string pi_name {get; set;}
        public boolean readOnly {get; set;}
        public string invstatus {get; set;}
        public string invgenratedby {get; set;}
        public date invgenrateddt {get; set;}
        public string invsentby {get; set;}
        public date invsentdt {get; set;}
        public string invurl {get; set;}



        public ptmInv(string pi_id, String pi_name, string invstatus, string invgenratedby, date invgenrateddt, string invsentby, date invsentdt, string invurl, boolean readOnly) {
            this.pi_id = pi_id;
            this.pi_name = pi_name;
            this.invstatus = invstatus;
            this.invgenratedby = invgenratedby;
            this.readOnly = readOnly;
            this.invgenrateddt = invgenrateddt;
            this.invsentby = invsentby;
            this.invsentdt = invsentdt;
            this.invurl = invurl;
        }
    }
    
    public class ProviderDispute {
        public id pd_id {get; set;}
        public string pd_name {get; set;}
        public boolean readOnly {get; set;}
        public string pdstatus {get; set;}
        public string pdcreatedby {get; set;}
        public DateTime pdcreateddt {get; set;}
        public string pdurl {get; set;}
        public string pdRecordType {get; set;}
        public string pdLetterOrigin {get; set;}
        public string pdMailTrackingNumber {get; set;}
        public string pdTypeofMail {get; set;}
        public DateTime pdSentdt {get; set;}


        public ProviderDispute(string pd_id, String pd_name, string pdstatus, string pdcreatedby, DateTime pdcreateddt, string pdurl, boolean readOnly,string pdRecordType,DateTime pdSentdt,string pdLetterOrigin,string pdTypeofMail,string pdMailTrackingNumber) {
            this.pd_id = pd_id;
            this.pd_name = pd_name;
            this.pdstatus = pdstatus;
            this.pdcreatedby = pdcreatedby;
            this.readOnly = readOnly;
            this.pdcreateddt = pdcreateddt;
            this.pdurl = pdurl;
            this.pdRecordType= pdRecordType;
            this.pdLetterOrigin= pdLetterOrigin;
            this.pdSentdt=pdSentdt;
            this.pdMailTrackingNumber=pdMailTrackingNumber;
            this.pdTypeofMail=pdTypeofMail;
        }
    }


}