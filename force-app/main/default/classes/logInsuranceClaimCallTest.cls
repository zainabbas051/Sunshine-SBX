@isTest(seeAllData=true)
private class logInsuranceClaimCallTest{

    Public static Opportunity opp;
    Public static Insurance_Information__c ii;
    Public static Account a;
    Public static Account insuranceProvider;
    Public static Account sunshineCenter;
    Public Static Case c;
    public static profile adminProfile;
    public static awsBucket__c AmazonBucketValue;

    
    public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US');
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
    
    public Static void createSampleData(){
        
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        insuranceProvider = new Account();
        insuranceProvider.Name = 'United Healthcare';
        insuranceProvider.Type = 'Insurance Provider';
        insert insuranceProvider;
        
        sunshineCenter = new Account();
        sunshineCenter.Name = 'Monarch Shores';
        sunshineCenter.Type = 'Internal Center';
        insert sunshineCenter;
        
        opp = new Opportunity();
        opp.Name = 'test opp';
        opp.Account = a;
        opp.Selected_Treatment_Center__c = a.id;
        opp.Closing_Agent__c = userAdmin.id;
        opp.Amount = 999;
        opp.StageName = 'Paid';
        opp.CloseDate = date.Today();
        opp.recordTypeId = recTypeIdOpp;
        opp.Test_Class_Checkbox__c  = true;
        opp.Cash_Client__c = False;
        opp.Insurance_Providers__c = 'Spectra';
        opp.Insurance_Provider__c = insuranceProvider.id;
        opp.Sunshine_Center__c = sunshineCenter.id;
        insert opp;
        
        ii = new Insurance_Information__c();
        ii.Opportunity__c = opp.id;
        ii.Insurance_Status__c = 'Primary';
        insert ii;
        
        AmazonBucketValue = new awsBucket__c();
        AmazonBucketValue.name='FREEPU';
        AmazonBucketValue.accessKeyId__c='testAcess';
        AmazonBucketValue.secretAccessKey__c='secretKey';
        AmazonBucketValue.Bucket__c='freepu';
      //  insert AmazonBucketValue;
        
        c = new Case();
        c.Opportunity__c = opp.id;
        c.Bill_Date__c = date.today();
        c.Bill_From_Date__c = date.today().addDays(-5);
        c.Bill_To_Date__c = date.today();
        c.Billed_Amount__c = 1500;
        c.Appeal_for_Adjustment_Requested__c = False;
        insert c;
        
        Provider_Dispute__c sobj = new Provider_Dispute__c(
          Name = '111',                                                                                                                                                     // Provider Dispute Name
          Status__c = 'Received',                                                                                                                                             // Status
          
          Type_of_Mail_Used__c = 'Regular Mail',                                                                                                                              // Type of Mail Used
          Communication_Sent_Date_Time_Stamp__c = Datetime.Now(),                                                                                // Communication Sent/Received Date Time
          Related_Case__c = c.id,                                                                                                                                // Related Case
          Other_Name__c = '111',                                                                                                                                              // Other Name
          Letter_Origin__c = 'Insurance Provider'  ,
          RecordTypeId =  Schema.SObjectType.Provider_Dispute__c.getRecordTypeInfosByName().get('Insurance Provider Reply').getRecordTypeId()                                                                                                                        // Letter Origin
          );
         insert sobj;
     }
    
    public Static testmethod void insuranceCaseViewExt(){
         test.startTest();
         system.runAs(userAdmin){
            createSampleData();
            
            ApexPages.currentPage().getParameters().put('id', opp.id);
           
            logInsuranceClaimCall licc = new logInsuranceClaimCall();
            licc.loadCaseDate();
            logInsuranceClaimCall licc2 = new logInsuranceClaimCall();
            licc2.loadLabRequestCaseDate();
            
            
            
            List<case> openCase = licc.openCaseList;
            List<Case> pendingCase = licc.pendingPaymentCaseList;
            list<Case> appealCase = licc.pendingAdjustmentCaseList;
            List<Case> closedCase = licc.closedCaseList;
            
            Boolean Flag1 = licc.displayOpenCasesList;
            Boolean Flag2 = licc.displayClosedCaseList;
            Boolean Flag3 = licc.displayPendingAdjustmentCaseList;
            Boolean Flag4 = licc.displayPendingPaymentCaseList;
            Boolean Flag5 = licc.displayeEditCase;
            Boolean Flag6 = licc.displayPaymentPendingCase;
            Boolean Flag7 = licc.displayPendingPaymentDocumentUpload;
            Boolean Flag8 = licc.displayAdjustmentCase;
            Boolean Flag9 = licc.displayPendingAdjustmentDocumentUpload;
            
            String var1 = licc.subscriberId;
            string var2 = licc.patientName;
            string var3 = licc.insuranceProvider;
            string var4 = licc.dateOfBirth;
            string var5 = licc.intakeAgent;
            string var6 = licc.collector;
            
            List<SelectOption> openStatus = licc.getOpenCaseNewStatuses();
            List<SelectOption> appealStatus = licc.getAppealCaseNewStatuses();
            
            licc.caseIdValue = c.id;
            
            PageReference pr1 = licc.cancel();
            PageReference pr2 = licc.showCase();
            PageReference pr3 = licc.createNewCase();
            PageReference pr4 = licc.cancelinsuranceCase();
            
            licc.showEditUserScreen();
            
            licc.tempCaseRecord = c;
            licc.saveCaseLog();
            
            //Testing the scenario where New Call is Logged and the Case Status is Processing
            licc.setOpenCaseNewStatus('Processing');
            licc.insuranceAgentName = 'Naveen';
            licc.insuranceAgentReferenceNumber = '1234';
            licc.saveCaseLog();
            
            //Testing the scenario where New Call is Logged and the Case Status is Data Missing in Claim
            licc.setOpenCaseNewStatus('Data Missing in Claim');
            licc.saveCaseLog();
            
            licc.notesForDMCR = 'Test';
            licc.faxNumber = '1234';
            licc.saveCaseLog();
            
            //Testing the scenario where New Call is Logged and the Case Status is Requesting Medical Records
            licc.setOpenCaseNewStatus('Requesting Medical Records');
            licc.notesForMRR = '';
            licc.Status = 'Open';
            licc.faxNumber = '';
            licc.saveCaseLog();
             
            licc.notesForMRR = 'Test';
            licc.faxNumber = '1234';
            licc.saveCaseLog();
            licc.mrr= new Insurance_Claim_Medical_Records_Request__c();
            licc.mrr.Notes_By_Requester__c = licc.notesForMRR;
            licc.mrr.Related_Case__c = licc.tempCaseRecord.id;
            licc.mrr.Status__c = 'Open';
            licc.mrr.Fax_Number__c = licc.faxNumber;
            licc.mrr.Mailing_Address__c = licc.mailingAddress;
            
            //Testing the scenario where New Call is Logged and the Case Status is Payment Scheduled
            licc.setOpenCaseNewStatus('Payment Scheduled');
            licc.saveCaseLog();
            licc.setOpenCaseNewStatus('Courtesy Bill');
            licc.saveCaseLog();
            licc.setOpenCaseNewStatus('Correction Sent');
            licc.saveCaseLog();
             licc.setOpenCaseNewStatus('Underpaid');
            licc.saveCaseLog();
             licc.setOpenCaseNewStatus('Provider Dispute');
            licc.saveCaseLog();
             licc.setOpenCaseNewStatus('Deductible');
            licc.saveCaseLog();
             licc.setOpenCaseNewStatus('Payment Scheduled');
            licc.saveCaseLog();
              licc.setOpenCaseNewStatus('Requesting Medical Records');
            licc.saveCaseLog();
            
            licc.tempCaseRecord.Collection_Reference__c = '1234';
            licc.tempCaseRecord.Collected_Amount__c = 800;
            licc.saveCaseLog();
            
            c.Appeal_for_Adjustment_Requested__c = True;
            update c;
            licc.tempCaseRecord = c;
            
            //Testing the scenario where New Call is Logged and the Case Status is Appeal for Adjustment Requested
            licc.saveCaseLog();
            
            licc.tempCaseRecord.Collection_Reference__c = '1234';
            licc.tempCaseRecord.Collected_Amount__c = 800;
            licc.saveCaseLog();
            
            //Testing the scenario where New Call is Logged and the Case Status is Adjustment in Progress
            licc.setappealCaseNewStatus('Adjustment in Progress');
            licc.saveCaseLog();
            
            licc.tempCaseRecord.Adjustment_Reference__c = '1234';
            licc.tempCaseRecord.Adjustment_Amount__c = 800;
            licc.saveCaseLog();

            licc.addFedexReq();
            
            
            licc.addInvProcess();
            licc.piptmsentindex = [Select id from PTM_Invoice_Process__c limit 1].id; 
            licc.ptminvsent();
            
            licc.addInvProcessLabRequest();

            id userId = licc.currentUserId;
            String baseurl = licc.baseurl;
            Boolean isDisplayingPtmInvoiceList = licc.displayPtminvoiceList;
            String openCaseNewStatus = licc.getopenCaseNewStatus();
            String appealCaseNewStatuses = licc.getappealCaseNewStatus();
            
            licc.frEditIndex = licc.fedexReqList[0].fr_id;
            licc.saveFedexRequest();
            licc.editFedexRequest();
            licc.frSentIndex = licc.fedexReqList[0].fr_id;
            licc.sentFedexRequest();

        }
         test.StopTest();
             
      }
      
        public Static testmethod void insuranceCaseViewExt1(){
         test.startTest();
         system.runAs(userAdmin){
            createSampleData();
            
            ApexPages.currentPage().getParameters().put('id', opp.id);
            
            logInsuranceClaimCall licc = new logInsuranceClaimCall();
            licc.loadCaseDate();
            logInsuranceClaimCall licc2 = new logInsuranceClaimCall();
            licc2.loadLabRequestCaseDate();
            
            
            
            List<case> openCase = licc.openCaseList;
            List<Case> pendingCase = licc.pendingPaymentCaseList;
            list<Case> appealCase = licc.pendingAdjustmentCaseList;
            List<Case> closedCase = licc.closedCaseList;
            
            Boolean Flag1 = licc.displayOpenCasesList;
            Boolean Flag2 = licc.displayClosedCaseList;
            Boolean Flag3 = licc.displayPendingAdjustmentCaseList;
            Boolean Flag4 = licc.displayPendingPaymentCaseList;
            Boolean Flag5 = licc.displayeEditCase;
            Boolean Flag6 = licc.displayPaymentPendingCase;
            Boolean Flag7 = licc.displayPendingPaymentDocumentUpload;
            Boolean Flag8 = licc.displayAdjustmentCase;
            Boolean Flag9 = licc.displayPendingAdjustmentDocumentUpload;
            
            String var1 = licc.subscriberId;
            string var2 = licc.patientName;
            string var3 = licc.insuranceProvider;
            string var4 = licc.dateOfBirth;
            string var5 = licc.intakeAgent;
            string var6 = licc.collector;
            
            List<SelectOption> openStatus = licc.getOpenCaseNewStatuses();
            List<SelectOption> appealStatus = licc.getAppealCaseNewStatuses();
            
            licc.caseIdValue = c.id;
            
            PageReference pr1 = licc.cancel();
            PageReference pr2 = licc.showCase();
            PageReference pr3 = licc.createNewCase();
            PageReference pr4 = licc.cancelinsuranceCase();
            
            licc.showEditUserScreen();
            
            licc.tempCaseRecord = c;
            licc.saveCaseLog();
            
            //Testing the scenario where New Call is Logged and the Case Status is Processing
            licc.setOpenCaseNewStatus('Processing');
            licc.insuranceAgentName = 'Naveen';
            licc.insuranceAgentReferenceNumber = '1234';
            licc.saveCaseLog();
            
            //Testing the scenario where New Call is Logged and the Case Status is Data Missing in Claim
            licc.setOpenCaseNewStatus('Data Missing in Claim');
            licc.saveCaseLog();
            
            licc.notesForDMCR = 'Test';
            licc.faxNumber = '1234';
            licc.saveCaseLog();
            
            //Testing the scenario where New Call is Logged and the Case Status is Requesting Medical Records
            licc.setOpenCaseNewStatus('Requesting Medical Records');
            licc.notesForMRR = '';
            licc.Status = 'Open';
            licc.faxNumber = '';
            licc.saveCaseLog();
             
            licc.notesForMRR = 'Test';
            licc.faxNumber = '1234';
            licc.saveCaseLog();
            licc.mrr= new Insurance_Claim_Medical_Records_Request__c();
            licc.mrr.Notes_By_Requester__c = licc.notesForMRR;
            licc.mrr.Related_Case__c = licc.tempCaseRecord.id;
            licc.mrr.Status__c = 'Open';
            licc.mrr.Fax_Number__c = licc.faxNumber;
            licc.mrr.Mailing_Address__c = licc.mailingAddress;
            
            //Testing the scenario where New Call is Logged and the Case Status is Payment Scheduled
           
              licc.setOpenCaseNewStatus('Requesting Medical Records');
            licc.saveCaseLog();
            
            licc.tempCaseRecord.Collection_Reference__c = '1234';
            licc.tempCaseRecord.Collected_Amount__c = 800;
            licc.saveCaseLog();
            
            c.Appeal_for_Adjustment_Requested__c = True;
            update c;
            licc.tempCaseRecord = c;
            
            //Testing the scenario where New Call is Logged and the Case Status is Appeal for Adjustment Requested
            licc.saveCaseLog();
            
            licc.tempCaseRecord.Collection_Reference__c = '1234';
            licc.tempCaseRecord.Collected_Amount__c = 800;
            licc.saveCaseLog();
            
            //Testing the scenario where New Call is Logged and the Case Status is Adjustment in Progress
            licc.setappealCaseNewStatus('Adjustment in Progress');
            licc.saveCaseLog();
            
            licc.tempCaseRecord.Adjustment_Reference__c = '1234';
            licc.tempCaseRecord.Adjustment_Amount__c = 800;
            licc.saveCaseLog();
            licc.addProviderDisputeProcess();
            licc.pdsentindex = [Select id from Provider_Dispute__c   limit 1].Id;
            licc.providerDisputesent();
            
            licc.addFedexReq();
            licc.frSaveIndex = [Select id from Fedex_Envelope_Request__c limit 1].id;
            licc.saveFedexRequest();
            //licc.frEditIndex = licc.fedexReqList[0].fr_id;
            licc.editFedexRequest();
            licc.sentFedexRequest();
            licc.pddeleteindex = [Select id from Provider_Dispute__c where name = '111' limit 1].id;
            licc.DeleteproviderDispute();
            licc.addInvProcess();
            licc.ptminvsent();
            licc.getTypeofMail();
            licc.checkRequiredFieldsPDSent();
            licc.canceProviderDisputeSent();
            licc.showProviderDisputeSentPopup();
            licc.createPdfUrl();
            licc.uploadEOBLink();
            
           // licc.ProviderDispute p = new licc.ProviderDispute('','','','',Datetime.Now(),'', false,'',null,'','','');
            

            id userId = licc.currentUserId;
            String baseurl = licc.baseurl;
            Boolean isDisplayingPtmInvoiceList = licc.displayPtminvoiceList;
            String openCaseNewStatus = licc.getopenCaseNewStatus();
            String appealCaseNewStatuses = licc.getappealCaseNewStatus();
            

        }
         test.StopTest();
             
      }
}