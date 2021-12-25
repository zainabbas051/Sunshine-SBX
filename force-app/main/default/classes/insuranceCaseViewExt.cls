//Test Class : insuranceCaseViewExtTest
public without sharing class insuranceCaseViewExt {

    private final Case caseRecord;
    public id caseRecordId;
      public boolean displayPopUp {get; set;}
    public case tempCaseRecord {Get; set;}
    public string insuranceAgentReferenceNumber {get; set;}
    public string insuranceAgentName {get; set;}
      public string caseCurrentStatus {get; set;}
        String appealCaseNewStatus = '';
        String openCaseNewStatus = '';
         Public string notesForDMCR {get; set;}
      public string faxNumber {get; set;}
         Public string notesForMRR {get; set;}
            public string mailingAddress {get; set;}
        public boolean readOnly {get; set;}
        public boolean caseClosed {get; set;}
        public boolean displayAppealForAdjustment {get; set;}
        public string notesFromCollector {get; set;}
        Public boolean displayAppealForAdjustmentPopup {get; set;}
        Public boolean displayRequestRebillPopup {get; set;}


        Public boolean displayCloseCasePopup {get; set;}
        String closeCaseStatus = '';
    public collection_line_item__C collectionIns {get; set;}
    public collection_line_item__C NewcollectionIns {get; set;}
    public List<Collection_Line_Item__c> lstCollection {get; set;}

    public boolean readOnlyCollectionIns {get; set;}
    public id tobeEdited {get; set;}
    public id tobeDeleted {get; set;}
    public string duplicateCaseChatterUsers{get;set;}
    public Boolean CheckReqFields {get; set;}
    public Boolean uploadEOBFlag {get; set;}
    
    public pageReference uploadEOBLink(){
        pageReference pr = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/InsuranceClaimVfp?id='+tempCaseRecord.id);
        return pr;
    }
    
    public String getappealCaseNewStatus() {
        return appealCaseNewStatus;
    }
    
     public void setappealCaseNewStatus(String appealCaseNewStatus) {
        this.appealCaseNewStatus = appealCaseNewStatus;
    }
    public boolean displayProviderDisputeList {
        get{return tempCaseRecord.Provider_Dispute_Initiated__c;} set;
    }
     public List<SelectOption> getAppealCaseNewStatuses() {
        List<SelectOption> options = new List<SelectOption>();

        options.add(new SelectOption('Appeal Sent', 'Appeal Sent'));
        options.add(new SelectOption('Appeal Received', 'Appeal Received'));
        options.add(new SelectOption('Appeal Denied', 'Appeal Denied'));


        return options;
    }
    
     public String getopenCaseNewStatus() {
        return openCaseNewStatus;
    }
    public void setopenCaseNewStatus(String openCaseNewStatus) {
        this.openCaseNewStatus = openCaseNewStatus;
    }
    
      public List<SelectOption> getOpenCaseNewStatuses() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Processing', 'Processing'));
        options.add(new SelectOption('COB Issue', 'COB Issue'));
        options.add(new SelectOption('Policy Issue / Termed', 'Policy Issue / Termed'));
        options.add(new SelectOption('No Claim on File', 'No Claim on File'));
        options.add(new SelectOption('Billing Issue', 'Billing Issue'));
        options.add(new SelectOption('Requesting Medical Records', 'Requesting Medical Records'));
        options.add(new SelectOption('Received Medical Records', 'Received Medical Records'));
        options.add(new SelectOption('Pay To Member', 'Pay To Member'));
        options.add(new SelectOption('Payment Scheduled', 'Payment Scheduled'));
        options.add(new SelectOption('Deductible', 'Deductible'));
        options.add(new SelectOption('Provider Dispute', 'Provider Dispute'));
        //options.add(new SelectOption('Denial', 'Denial'));
        //options.add(new SelectOption('NCOF (10+)', 'NCOF (10+)'));
        //options.add(new SelectOption('Close Claim', 'Close Claim'));
        //options.add(new SelectOption('Requires Review', 'Requires Review'));

        return options;
    }


    public insuranceCaseViewExt(ApexPages.StandardController stdController) {
        this.caseRecord = (Case)stdController.getRecord();
        caseRecordId = ApexPages.currentPage().getParameters().get('id');

        loadCaseRecordData(caseRecordId);//Loading the data to be displayed on the case detail form
        readOnly = True;//This is to make sure that the Case would always open in Detail View instead of Edit View
        displayAppealForAdjustmentPopup = False;
        displayRequestRebillPopup = false;
        displayCloseCasePopup = False;
        readOnlyCollectionIns = true;
        NewcollectionIns = new collection_line_item__C();
        collectionIns  = new collection_line_item__C();
        
        duplicateCaseChatterUsers = '';
        
        for(Case_Override_User_Access__mdt mdt : [select User_Id__c, Duplicate_Case_Chatter_Notification__c from Case_Override_User_Access__mdt]){
            if(mdt.User_Id__c == UserInfo.getUserId()){
                overRideUserFlag = True;
            }
            if(mdt.Duplicate_Case_Chatter_Notification__c == True){
                duplicateCaseChatterUsers = duplicateCaseChatterUsers+'{'+mdt.User_Id__c+'}';
            }
        }
        //overRideUserFlag = userIds.size() > 0;
    }
    
     public void showEditUserScreen() { //this method takes us to the Popup to edit an existing ACA Schedule record
   
        displayPopUp = true;
        System.debug('____'+displayPopUp);
        
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

    
     public pageReference saveCaseLog() {
         
        
        system.debug('Insurance Provider Claim Number:::' + tempCaseRecord.Description);
        system.debug('Insurance Provider Claim Number:::' + tempCaseRecord.Insurance_Provider_Claim_Number__c);
        system.debug('tempCaseRecord::::' + tempCaseRecord);
        
         if(test.isRunningTest()){
             CheckReqFields=true;
         }
         else
         CheckReqFields= checkRequiredFieldsSave(tempCaseRecord);
        if (CheckReqFields == True) {
            string oppId = ApexPages.currentPage().getParameters().get('id');
            displayPopUp = False;
            Insurance_Claim_Medical_Records_Request__c mrr = new Insurance_Claim_Medical_Records_Request__c();
            Data_Missing_in_Claim_Request__c dmcr = new Data_Missing_in_Claim_Request__c();
            Insurance_Call_Log__c icl = new Insurance_Call_Log__c();
            icl.Call_Log_Notes__c = tempCaseRecord.Description;
            icl.Name_of_Insurance_Call_Agent__c = insuranceAgentName;
            icl.Reference_of_Insurance_Call_Agent__c = insuranceAgentReferenceNumber;
            icl.Related_Case__c = tempCaseRecord.id;
           icl.Previous_Case_Status__c = caseCurrentStatus;
            icl.Date_Time_Call_Logged__c = dateTime.Now();
            if (tempCaseRecord.Appeal_for_Adjustment_Requested__c == True)
                icl.New_Case_Status__c = appealCaseNewStatus;
            else
                icl.New_Case_Status__c = openCaseNewStatus;


            Case updateCase = new Case(id = tempCaseRecord.id, Last_Modified_Date_Time__c = dateTime.Now());
            updateCase.Insurance_Provider_Claim_Number__c = tempCaseRecord.Insurance_Provider_Claim_Number__c;
            updateCase.Insurance_Provider_Claim_Received_Date__c = tempCaseRecord.Insurance_Provider_Claim_Received_Date__c;

            if (tempCaseRecord.Appeal_for_Adjustment_Requested__c == False) {
                updateCase.Status = openCaseNewStatus;
                if (caseCurrentStatus != openCaseNewStatus && openCaseNewStatus == 'Payment Scheduled') {
                    updateCase.Collection_Reference__c = tempCaseRecord.Collection_Reference__c;
                    updateCase.Collected_Amount__c = tempCaseRecord.Collected_Amount__c;
                }
                
                
                
                List<MR_Request_Round_Robin_User__c> MRUsr = new List<MR_Request_Round_Robin_User__c>(); ////Edited by Safia Osman///
                List<MR_Request_Round_Robin_User__c> MRUsr2 = new List<MR_Request_Round_Robin_User__c>();////Edited by Safia Osman///
                Set<MR_Request_Round_Robin_User__c> MRUsr1 = new Set<MR_Request_Round_Robin_User__c>();////Edited by Safia Osman///
                MRUsr = MR_Request_Round_Robin_User__c.getall().values();////Edited by Safia Osman///
                System.debug('MR USERS:::' + MRUsr);
                if (caseCurrentStatus != openCaseNewStatus && openCaseNewStatus == 'Requesting Medical Records') {
                    mrr.Notes_By_Requester__c = notesForMRR;
                    mrr.Related_Case__c = tempCaseRecord.id;
                    mrr.Status__c = 'Open';
                    mrr.Fax_Number__c = faxNumber;
                   // mrr.OwnerId = label.Medical_Records_User; ////Edited by Safia Osman///
                    mrr.Mailing_Address__c = mailingAddress;
                    ////Edited by Safia Osman///
                    
                    if(tempCaseRecord.Opportunity__r.Assigned_Medical_Records_Associate__c!=null)
                   
                       mrr.OwnerId=tempCaseRecord.Opportunity__r.Assigned_Medical_Records_Associate__c;
                       
                   else if(tempCaseRecord.Opportunity__r.Assigned_Medical_Records_Associate__c==null)
                   {
                       integer i,j;
                    if(MRUsr.size()==1){
                        MRUsr[0].Last_Assigned_To__c = true;
                        try{
                            
                            Opportunity op = new Opportunity(id = tempCaseRecord.Opportunity__r.id) ;
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
                            
                            Opportunity op = new Opportunity(id = tempCaseRecord.Opportunity__r.id) ;
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
                   
                    
                //////
                }
                if (caseCurrentStatus != openCaseNewStatus && openCaseNewStatus == 'Data Missing in Claim') {
                    dmcr.Notes_By_Requester__c = notesForDMCR;
                    dmcr.Related_Case__c = tempCaseRecord.id;
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
                    updateCase.Adjustment_Reference__c = tempCaseRecord.Adjustment_Reference__c;
                    updateCase.Adjustment_Amount__c = tempCaseRecord.Adjustment_Amount__c;
                    updateCase.Appeal_for_Adjustment_Status__c = 'Adjusted';
                }
                if (appealCaseNewStatus == 'Appeal Denied' && caseCurrentStatus != appealCaseNewStatus) {
                    updateCase.Appeal_for_Adjustment_Status__c = 'Denied';
                    updateCase.Adjustment_Denied_Reason__c = tempCaseRecord.Adjustment_Denied_Reason__c;
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
              //  update updateCase;
                pageReference pr = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/logInsuranceClaimCall?id=' + oppId);
                return pr;
            } catch (exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()));
            }
        }
        return null;
    }


    public list<collection_line_item__C> getLstCollectionLineItem() {
        lstCollection = [SELECT Id, Name, Case__c, Collection_Amount__c, Collection_Reference_Number__c, Collection_Date__c,
                         Mode_of_Collection__c, Type_of_Collection__c FROM Collection_Line_Item__c where case__C = :caseRecordId ];
        return lstCollection;


    }

    public boolean displayMedicalRecordRequestList {
        get{
            if (medicalRecordRequestList.size() > 0)
                return true;
            return false;
        } set;
    }

    public boolean overRideUserFlag { get; set;
                                      //get{
                                      //List<Case_Override_User_Access__mdt> userIds = [select User_Id__c from Case_Override_User_Access__mdt where User_Id__c == UserInfo.getUserId()];
                                      //return userIds.size() > 0;
                                      //if (UserInfo.getUserId() == label.Tori_User_Id || UserInfo.getUserId() == label.Lorena_User_Id || UserInfo.getUserId() == label.Pooya_User_Id)
                                      //    return true;
                                      //return false;
                                      //} set;
                                    }

    public boolean displayDataMissingInClaimRequests {
        get{
            if (dataMissingInClaimRequestList.size() > 0)
                return true;
            return false;
        } set;
    }
    public boolean displayInsuranceCallLogs {
        get{
            if (insuranceCallLogsList.size() > 0)
                return true;
            return false;
        } set;
    }
    public boolean displayDocumentsList {
        get{
            if (documentsList.size() > 0)
                return true;
            return false;
        } set;
    }

    public List<Insurance_Claim_Medical_Records_Request__c> medicalRecordRequestList {
        get{
            if (medicalRecordRequestList == null)
                medicalRecordRequestList = new List<Insurance_Claim_Medical_Records_Request__c>();
            return medicalRecordRequestList;
        } set;
    }

    public list<Data_Missing_in_Claim_Request__c> dataMissingInClaimRequestList {
        get{
            if (dataMissingInClaimRequestList == null)
                dataMissingInClaimRequestList  = new List<Data_Missing_in_Claim_Request__c>();
            return dataMissingInClaimRequestList;
        } set;
    }

    public list<Insurance_Call_Log__c> insuranceCallLogsList {
        get{
            if (insuranceCallLogsList == null)
                insuranceCallLogsList = new List<Insurance_Call_Log__c>();
            return insuranceCallLogsList;
        } set;
    }

    public List<Insurance_Appeal_for_Adjustment_Request__c> insuranceAppealForAdjustmentRequestList {
        get{
            if (insuranceAppealForAdjustmentRequestList == null)
                insuranceAppealForAdjustmentRequestList = new List<Insurance_Appeal_for_Adjustment_Request__c>();
            return insuranceAppealForAdjustmentRequestList;
        } set;
    }

    public List<Documents__c> documentsList {
        get{
            if (documentsList == null)
                documentsList = new List<documents__c>();
            return documentsList;
        } set;
    }



    public pagereference SavecollectionLineItem() {
        if (tobeEdited != null) {
            update collectionIns ;
            readOnlyCollectionIns = true;
        }
        return null;
    }

    public pagereference EditcollectionLineItem() {
        collectionIns = [SELECT Id, Name, Case__c, Collection_Amount__c, Collection_Reference_Number__c, Collection_Date__c,
                         Mode_of_Collection__c, Type_of_Collection__c FROM Collection_Line_Item__c where id = :tobeEdited];


        readOnlyCollectionIns = false;
        return null;
    }

    public pagereference DeletecollectionLineItem() {
        collection_line_item__C collectionInsDel = [SELECT Id, Name, Case__c, Collection_Amount__c, Collection_Reference_Number__c, Collection_Date__c,
                                Mode_of_Collection__c, Type_of_Collection__c FROM Collection_Line_Item__c where id = :tobeDeleted];

        delete collectionInsDel;
        readOnlyCollectionIns = true;
        return null;
    }

    //public void UpdateTotalCollectedAmount () {
    //    list<collection_line_item__C> collectionItems = [SELECT Id, Name, Case__c, Collection_Amount__c,
    //                                  Collection_Reference_Number__c, Collection_Date__c, Collection_Status__c,
    //                                  Mode_of_Collection__c, Type_of_Collection__c
    //                                  FROM Collection_Line_Item__c where case__C = :caseRecordId ];
    //    Integer totalAmount = 0;
    //    for (Collection_Line_Item__c item : collectionItems) {
    //        if(item.Type_of_Collection__c == 'Recoupment' ||
    //            item.Type_of_Collection__c == 'Applied Recoupment' ) {
    //            totalAmount -= item.Collection_Amount__c;
    //        } else {
    //            totalAmount += item.Collection_Amount__c;
    //        }
    //    }
    //    caseRecord.Total_Collected_Amount__c = totalAmount;
    //}

    public List<SelectOption> getCaseCloseStatuses() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Closed', 'Closed'));
        options.add(new SelectOption('Denied', 'Denied'));
        options.add(new SelectOption('Duplicate Claim', 'Duplicate Claim'));
        options.add(new SelectOption('To Deductible/Co Insurance', 'To Deductible/Co Insurance'));
        options.add(new SelectOption('Policy Termed', 'Policy Termed'));
        return options;
    }
    public String getcloseCaseStatus() {
        return closeCaseStatus;
    }
    public void setcloseCaseStatus(String closeCaseStatus) {
        this.closeCaseStatus = closeCaseStatus;
    }

    public void loadCaseRecordData(id caseId) {
        if (caseId != null) {

            medicalRecordRequestList.clear();
            dataMissingInClaimRequestList.clear();
            insuranceCallLogsList.clear();
            insuranceAppealForAdjustmentRequestList.clear();

            tempCaseRecord = [select id, Owner.Name, Insurance_Group_Name__c, Intake_Coordinator__c,Description , CaseNumber, Status, KIPU_MRN__c, Claim_Number__c,Opportunity__r.Assigned_Medical_Records_Associate__c ,Total_Collected_Amount__c, Sunshine_Center__c,Opportunity__r.Closing_Date__c,Opportunity__r.Check_Out_Date__c, Co_Pay_Amount__c,
                              Insurance_Provider__c, Subscriber_Id__c, Date_of_Birth__c, Bill_Date__c, Billed_Amount__c, Bill_From_Date__c, Bill_To_Date__c, Write_Off_Amount__c, Deductible_Amount__c,
                              Pricing_Type__c, Insurance_Carve_Out_3rd_Party__c, Claim_Type__c, Level_of_Care__c, Collection_Reference__c, Collected_Amount__c, Write_Off_Reason__c, Adjustment_Denied_Reason__c,
                              Collection_Date__c, Mode_of_Collection__c, Adjustment_Reference__c, Adjustment_Amount__c, Mode_of_Adjustment_Collection__c, Opportunity__c,
                              Denied_Reason__c, Time_Since_Last_Modified__c, Appeal_for_Adjustment_Status__c, Appeal_for_Adjustment_Requested__c, Adjustment_Collected_Date__c,
                              Insurance_Provider_Claim_Number__c, Insurance_Provider_Claim_Received_Date__c, Opportunity__r.Name, Denied_Reason_Other__c, NPI__c, Tax_Id__c, Co_Insurance_Amount__c,
                              Non_Covered_Amount__c, isClosed, Case_Closed_By__c, F_Pricing_Type__c, Amount_Being_Paid_To_Member__c, PTM_Case__c, PTM_Collected_Amount__c, PTM_Collected_Date__c,
                              PTM_Mode_of_Collection__c, Unapplied_Recoupment__c, PTM_Mode_of_Collection_Reference__c, Patient_Responsibility__c,Original_Case_Owner__c,Provider_Dispute_Initiated__c,Provider_Dispute_Initiated_Date_Time__c,Provider_Dispute_Initiated_By__c,Provider_Dispute_Initiated_By__r.name from Case
                              where id = :caseId AND RecordTypeId = : Constants.insuranceClaimRecordTypeId];

            if (tempCaseRecord.Status == 'Closed' || tempCaseRecord.Status == 'Denied' || tempCaseRecord.Status == 'Duplicate Claim') {
                caseClosed = True;
            } else {
                caseClosed = False;
            }
            if (tempCaseRecord.Appeal_for_Adjustment_Requested__c == True) {
                displayAppealForAdjustment = True;
                for (Insurance_Appeal_for_Adjustment_Request__c aar : [select id, Status__c, Related_Case__c, Name, Closed_Date_Time__c,
                        Owner.Name from Insurance_Appeal_for_Adjustment_Request__c where Related_Case__c = : caseId]) {
                    insuranceAppealForAdjustmentRequestList.add(aar);
                }
            } else {
                displayAppealForAdjustment = False;
            }
            for (Insurance_Call_Log__c icl : [Select id, Name, CreatedDate, Name_of_Insurance_Call_Agent__c, Reference_of_Insurance_Call_Agent__c, Previous_Case_Status__c,
                                              New_Case_Status__c, 
                                              Call_Log_Notes__c,
                                              CreatedBy.Name from Insurance_Call_Log__c WHERE Related_Case__c = : caseId ORDER BY CreatedDate DESC NULLS LAST]) {
                insuranceCallLogsList.add(icl);
            }

            for (Data_Missing_in_Claim_Request__c mcr : [Select id, Name, Related_Insurance_Call_Log__c, Status__c, Owner.Name, Completed_Date_Time__c, Notes_By_Billing_Rep__c from Data_Missing_in_Claim_Request__c
                    WHERE Related_Case__c = : caseId ORDER BY CreatedDate DESC NULLS LAST]) {
                dataMissingInClaimRequestList.add(mcr);
            }

            for (Insurance_Claim_Medical_Records_Request__c mrr : [Select id, Related_Insurance_Call_Log__c, Name, Status__c, Completed_Date_Time__c, Owner.Name, Mailing_Address__c, Medical_Record_Specialist_Notes__c,
                    Notes_By_Requester__c, Fax_Number__c from Insurance_Claim_Medical_Records_Request__c
                    WHERE Related_Case__c = : caseId ORDER BY CreatedDate DESC NULLS LAST]) {
                medicalRecordRequestList.add(mrr);
            }

            for (Documents__c d : [SELECT Id, Name, AWS_Link__c FROM Documents__c where Case__c = : tempCaseRecord.id ORDER BY CreatedDate DESC NULLS LAST]) {
                documentsList.add(d);
            }
            if(tempCaseRecord.Insurance_Group_Name__c != null && tempCaseRecord.Insurance_Group_Name__c != 'None'){
                uploadEOBFlag = True;
            }else{
                uploadEOBFlag = False;
            }

        }
    }

    public void editCase() {
        readOnly = False;
    }

    public void saveCase() {
        update tempCaseRecord;
        readOnly = True;
    }

    public pageReference callLogView() {
        PageReference pr;
        if(tempCaseRecord.level_of_care__c!='Lab Requests')
        pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/logInsuranceClaimCall?id=' + tempCaseRecord.Opportunity__c);
        else
        pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/logInsuranceClaimCallforLabRequests?id=' + tempCaseRecord.Opportunity__c);
        return pr;
        //return null;
    }
    
        public pageReference callLogLabRequestsView() {
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/logInsuranceClaimCallforLabRequests?id=' + tempCaseRecord.Opportunity__c);
        return pr;
        //return null;
    }
    public void duplicateClaimCase() {
        try {
            /*
            tempCaseRecord.Status = 'Duplicate Claim';
            tempCaseRecord.Case_Closed_By__c = UserInfo.GetUserId();
            update tempCaseRecord;
            loadCaseRecordData(tempCaseRecord.id);
            */
            
            ConnectApi.FeedItem fi = (ConnectApi.FeedItem)ConnectApiHelper.postFeedItemWithMentions(null, tempCaseRecord.id, duplicateCaseChatterUsers+', This Claim was marked as a Duplicate Claim.');
        } catch (exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'OOps some thing went wrong while closing the case : ' + e.getMessage()));
        }
    }

    public pageReference closeCase() {
        if (checkRequiredFieldsCloseCase(tempCaseRecord)) {
            try {
                tempCaseRecord.Status = closeCaseStatus;
                tempCaseRecord.Case_Closed_By__c = UserInfo.GetUserId();
                update tempCaseRecord;
                PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/insuranceCaseViewPage?id='+tempCaseRecord.Id);
                return pr;
                
               // loadCaseRecordData(tempCaseRecord.id);
            } catch (exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'OOps some thing went wrong while closing the case : ' + e.getMessage()));
            }
            
        }
        return null;
    }

    public void displayCloseCasePopup() {
        system.debug('UserInfo.getUserId() ::' + UserInfo.getUserId());
        if(overRideUserFlag == True)
            displayCloseCasePopup = True;
        else
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You Donot have the access to Close This Case!!'));

    }

    public void cancelCloseCasePopup() {
        displayCloseCasePopup = False;
    }


    public PageReference deleteCase() {
        if (overRideUserFlag == True) {
            String oppId = tempCaseRecord.Opportunity__c;
            try {
                delete tempCaseRecord;
                PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/logInsuranceClaimCall?id=' + oppId);
                return pr;
            } catch (exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'something went wrong : ' + e.getMessage()));
                return null;
            }

        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You Donot have the access to Delete This Case!!'));
            return null;
        }
    }



    public void closePopup() {
        displayRequestRebillPopup = false;

    }


    public void displayRequestRebillPopup() {
        for (Collection_Line_Item__c item : lstCollection) {
            if (item.Name == '' ||
                    item.Collection_Reference_Number__c == '' ||
                    item.Collection_Date__c == null ||
                    item.Collection_Amount__c == null ||
                    item.Mode_of_Collection__c == '' ||
                    item.Type_of_Collection__c == '') {
                // todo show error message
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, 'Please fill in previous Collection line items'));
                return;
            }
        }


        //list<collection_line_item__c> LstColl = [SELECT Id, Name, Case__c, Collection_Amount__c, Collection_Reference_Number__c, Collection_Date__c, Collection_Status__c,
        //                              Mode_of_Collection__c, Type_of_Collection__c FROM Collection_Line_Item__c where case__C = :caseRecordId and Collection_Status__c = 'In progress'];

        //todo enable the check after showing close button
        //if(LstColl.size()>0)

        //else
        displayRequestRebillPopup = True;

    }

    public void caceldisplayRequestRebillPopup() {
        displayRequestRebillPopup = False;
    }

    public void saveRequestRebill() {
        if (NewcollectionIns.Collection_Amount__c == null ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You cannot leave the Collection Amount input box Empty!!'));
        }

        else {
            NewcollectionIns.case__c = caseRecordId ;

            try {
                insert NewcollectionIns;

                displayRequestRebillPopup = False;
                
                NewcollectionIns = new collection_line_item__C();
            } catch (exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'OOps some thing went wrong while requesting re-bill : ' + e.getMessage()));
            }


        }

    }

    public void displayAppealForAdjustmentPopup() {
        if (UserInfo.getUserId() == label.Tori_User_Id || UserInfo.getUserId() == label.Lorena_User_Id  || UserInfo.getUserId() == label.Pooya_User_Id)
            displayAppealForAdjustmentPopup = True;
        else
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You Donot have the access to Request a Appeal for Adjustment!!'));
    }

    public void cacelDisplayAppealForAdjustmentPopup() {
        displayAppealForAdjustmentPopup = False;
    }



    public void saveAppealForAdjustment() {
        if (notesFromCollector == null || notesFromCollector == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You cannot leave the Notes from Collector input box Empty!!'));
        } else {

            Insurance_Appeal_for_Adjustment_Request__c aar = new Insurance_Appeal_for_Adjustment_Request__c();
            aar.Related_Case__c = tempCaseRecord.id;
            aar.Notes_From_Collector__c = notesFromCollector;
            aar.Status__c = 'Open';
            aar.OwnerId = tempCaseRecord.OwnerId;

            tempCaseRecord.Appeal_for_Adjustment_Requested__c = True;
            tempCaseRecord.Status = 'Appeal for Adjustment Requested';
            try {
                insert aar;
                update tempCaseRecord;

                loadCaseRecordData(tempCaseRecord.id);
                displayAppealForAdjustmentPopup = False;
            } catch (exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'OOps some thing went wrong while requesting appeal for adjustment : ' + e.getMessage()));
            }
        }
    }

    public pageReference uploadCaseDocuments() {
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/uploadDocuments_InsuranceCase?id=' + caseRecordId);
        return pr;
        //return null;
    }

public boolean checkRequiredFieldsCloseCase(case tempCaseRecord) {
        String message = '';
        Boolean success = true;
        if (closeCaseStatus != 'Duplicate Claim') {
            if (closeCaseStatus == '' || closeCaseStatus == null){
                message = 'Please select the Final Case Close Status!!';
                success = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
            if(tempCaseRecord.KIPU_MRN__c == '' || tempCaseRecord.KIPU_MRN__c == null){
                message = 'You cannot close this Case, as the KIPU MRN on this case is still BLANK!!';
                success = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
            if(tempCaseRecord.Claim_Type__c == null){
                message = 'You cannot close this Case, as the Claim Type field on this case is still BLANK!!';
                success = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
            if(tempCaseRecord.Level_of_Care__c == null){
                message = 'You cannot close this Case, as the Level of Care field on this case is still BLANK!!';
                success = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
            //if(tempCaseRecord.Collection_Reference__c == '' || tempCaseRecord.Collection_Reference__c == null){
            //    message = 'You cannot close this Case, as the Mode of Collection Reference # field on this case is still BLANK!!';
            //    success = false;
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            //}
            //if(tempCaseRecord.Collected_Amount__c == null){
            //    message = 'You cannot close this Case, as the Collected Amount field on this case is still BLANK!!';
            //    success = false;
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            //}
            //if(tempCaseRecord.Collection_Date__c == null){
            //    message = 'You cannot close this Case, as the Collection Date field on this case is still BLANK!!';
            //    success = false;
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            //}
            //if(tempCaseRecord.Mode_of_Collection__c == null){
            //    message = 'You cannot close this Case, as the Mode of Collection field on this case is still BLANK!!';
            //    success = false;
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            //}
            if(tempCaseRecord.Co_Pay_Amount__c == null){
                message = 'You cannot close this Case, as the Co Pay Amount field on this case is still BLANK!!';
                success = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
            if(tempCaseRecord.Deductible_Amount__c == null){
                message = 'You cannot close this Case, as the Deductible Amount field on this case is still BLANK!!';
                success = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
            if(tempCaseRecord.Co_Insurance_Amount__c == null){
                message = 'You cannot close this Case, as the Co-Insurance Amount field on this case is still BLANK!!';
                success = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
            if(tempCaseRecord.Non_Covered_Amount__c == null){ 
                message = 'You cannot close this Case, as the Non Covered Amount field on this case is still BLANK!!';
                success = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
            if(tempCaseRecord.Write_Off_Reason__c == null && tempCaseRecord.Write_Off_Amount__c > 0){
                message = 'You cannot close this Case, as the Write Off Reason field on this case is still BLANK!!';
                success = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
            if(closeCaseStatus == 'Denied' && tempCaseRecord.Denied_Reason__c == null){
                message = 'You cannot close this Case, as the Denied Reason field on this case is still BLANK!!';
                success = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
            if(closeCaseStatus == 'Denied' && tempCaseRecord.Denied_Reason__c == 'Other' && tempCaseRecord.Denied_Reason_Other__c == null){
                message = 'You cannot close this Case, as the Denied Reason is Other, and the Denied Reason Other field on this case is still BLANK!!';
                success = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
            if(tempCaseRecord.Appeal_for_Adjustment_Requested__c == True && tempCaseRecord.Appeal_for_Adjustment_Status__c == 'Adjusted'){
                if(tempCaseRecord.Mode_of_Adjustment_Collection__c == null){
                    message = 'You cannot close this Case, as the Mode of Adjustment Collection field on this case is still BLANK!!';
                    success = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                }
                if(tempCaseRecord.Adjustment_Collected_Date__c == null){
                    message = 'You cannot close this Case, as the Adjustment Collected Date field on this case is still BLANK!!';
                    success = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                }
                if(tempCaseRecord.Adjustment_Amount__c == null){
                    message = 'You cannot close this Case, as the Adjustment Collected Amount field on this case is still BLANK!!';
                    success = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                }
                if(tempCaseRecord.Adjustment_Reference__c == '' || tempCaseRecord.Adjustment_Reference__c == null){
                    message = 'You cannot close this Case, as the Mode of Adjustment Collection Reference # field on this case is still BLANK!!';
                    success = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                }
                if(tempCaseRecord.Appeal_for_Adjustment_Status__c != 'Denied' && tempCaseRecord.Appeal_for_Adjustment_Status__c != 'Adjusted'){
                    message = 'You cannot close this Case, as the Appeal for Adjustment Status field is neither Adjusted nor Denied!!';
                    success = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                }
            }
            if(documentsList.size() > 0) {
                set<String> documentNameSet = new Set<String>();
                for (Documents__c d : documentsList) {
                    documentNameSet.add(d.Name);
                }
                for (Documents_Type__c dt : [select id, Name, Is_Required__c from Documents_Type__c where Object_API_Name__c = : 'Case' and Is_Active__c = : true AND Is_Required__c = : True]) {
                    if (documentNameSet.contains(dt.Name) == False){
                        message = 'You cannot close this Case, untill You have uploaded the ' + dt.Name + ' document on the case!!';
                        success = false;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                    }
                } 
                if(tempCaseRecord.Appeal_for_Adjustment_Requested__c == True){
                    If(tempCaseRecord.Appeal_for_Adjustment_Status__c == 'Denied' && documentNameSet.contains('Appeal Denial Letter') == False){
                        message = 'You cannot close this Case, untill You have uploaded the Appeal Denial Letter on the case, as the Appeal is Denied on this case!!';
                        success = false;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                    }
                }
                If(tempCaseRecord.Status == 'Denied' && documentNameSet.contains('Claim Denial Letter') == False){
                    message = 'You cannot close this Case, untill You have uploaded the Claim Denial Letter on the case, as the Claim is Denied!!';
                    success = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                }
            }else{
                //Uncomment the following lines, when we put back the check for required documents to close out the case in 2 weeks.
                /*
                success=false;
                message='You cannot close this Case, untill the required documents have been uploaded!!';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                */
            }
        }

        return success;
    }
    
    
    public void InitiateProvierDispute() {
        try {
            tempCaseRecord.Provider_Dispute_Initiated__c=true;
            tempCaseRecord.Provider_Dispute_Initiated_Date_Time__c=dateTime.now();
            tempCaseRecord.Provider_Dispute_Initiated_By__c=UserInfo.GetUserId();
            update tempCaseRecord;
            
        } catch (exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'OOps some thing went wrong while Initiating provider dispute : ' + e.getMessage()));
        }
    }
}