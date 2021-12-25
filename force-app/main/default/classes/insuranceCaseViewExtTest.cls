@isTest
private class insuranceCaseViewExtTest {

    public Static ApexPages.StandardController caseController;
    public Static ApexPages.StandardController caseController1;

    Public static Opportunity opp;
    Public static Insurance_Information__c ii;
    Public static Account a;
    Public static Account insuranceProvider;
    Public static Account sunshineCenter;
    Public Static Case c;
    Public Static Case c1;
    public static collection_line_item__C colIns;
    public static collection_line_item__C colIns1;

    public Static insuranceCaseViewExt caseViewExt;
    public Static insuranceCaseViewExt caseViewExt1;

    public static profile adminProfile;
    public static Documents_Type__c dt1;
    public static Documents_Type__c dt2;
        
    public static User userAdmin {
        get{
            if (userAdmin == null ) {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName = 'LastTest', alias = 'FLast',
                email = 'test@key.net', communityNickname = 'test0101019', TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', ProfileId = adminProfile.Id ,
                LanguageLocaleKey = 'en_US');
                insert userAdmin;
            }
            return userAdmin;
        }
        set;
    }

    public Static void createSampleData() {
        awsBucket__c aws = new awsBucket__c();
        aws.accessKeyId__c =  'AKIAIKHBOKKMOFRNX5XQ';
        aws.secretAccessKey__c = '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';
        aws.Bucket__c = 'freepu';
        aws.Name = 'FREEPU';
        insert aws;

        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();

        dt1 = new Documents_Type__c();
        dt1.Name = 'Explanation of Benefits';
        dt1.Is_Active__c = True;
        dt1.Is_Required__c = True;
        insert dt1;

        dt2 = new Documents_Type__c();
        dt2.Name = 'Office Ally Confirmation Receipt';
        dt2.Is_Active__c = True;
        dt2.Is_Required__c = True;
        insert dt2;

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

        c = new Case();
        c.Opportunity__c = opp.id;
        c.Bill_Date__c = date.today();
        c.Bill_From_Date__c = date.today().addDays(-5);
        c.Bill_To_Date__c = date.today();
        c.Billed_Amount__c = 1500;
        //c.Co_Pay_Amount__c = 200;
        //c.Deductible_Amount__c = 100;
        //c.Collected_Amount__c = 1000;
        c.Appeal_for_Adjustment_Status__c = 'Appeal Denied';
        c.RecordTypeId = Constants.insuranceClaimRecordTypeId;

        insert c;

        c1 = new Case();
        c1.Opportunity__c = opp.id;
        c1.Co_Pay_Amount__c = 200;
        insert c1;

        colIns = new collection_line_item__C();
        colIns.case__c = c1.id;
        insert colIns;

        colIns1 = new collection_line_item__C();
        colIns1.case__c = c1.id;
        insert colIns1;
    }

    public Static testmethod void insuranceCaseViewExt() {
        test.startTest();
        system.runAs(userAdmin) {
            createSampleData();

            ApexPages.currentPage().getParameters().put('id', c.id);
            caseController = new ApexPages.StandardController(c);

            MR_Request_Round_Robin_User__c m = new MR_Request_Round_Robin_User__c(Name = 'Erin Gyimah',User_Id__c = '0050P000006oHwWQAU',Last_Assigned_To__c =false);
            insert m;
            
            m = new MR_Request_Round_Robin_User__c(Name = 'Safia Osman',User_Id__c = '0050P0000075sXBQAY',Last_Assigned_To__c =true);
            insert m;
            
            caseViewExt = new insuranceCaseViewExt(caseController);

            caseViewext.loadCaseRecordData(c.Id);
            boolean Flag1 = caseViewExt.displayMedicalRecordRequestList;
            Boolean Flag2 = caseViewExt.displayDataMissingInClaimRequests;
            Boolean Flag3 = caseViewExt.displayInsuranceCallLogs;
            Boolean Flag4 = caseViewExt.displayDocumentsList;
            Boolean Flag5 = caseViewExt.overRideUserFlag;
            List<Insurance_Claim_Medical_Records_Request__c> mrr = caseViewExt.medicalRecordRequestList;

            list<Data_Missing_in_Claim_Request__c> mcr = caseViewExt.dataMissingInClaimRequestList;
            list<Insurance_Call_Log__c> icl = caseViewExt.insuranceCallLogsList;
            List<Insurance_Appeal_for_Adjustment_Request__c> aar = caseViewExt.insuranceAppealForAdjustmentRequestList;
            List<Documents__c> d = caseViewExt.documentsList;
            caseViewExt.uploadEOBLink();
            caseViewExt.editCase();
            caseViewExt.saveCase();
            caseViewExt.cacelDisplayAppealForAdjustmentPopup();
            caseViewExt.displayAppealForAdjustmentPopup();
            List<SelectOption> openStatus = caseViewExt.getOpenCaseNewStatuses();
            List<SelectOption> appealStatus = caseViewExt.getAppealCaseNewStatuses();
            PageReference pr1 = caseViewExt.callLogView();
            PageReference pr2 = caseViewExt.uploadCaseDocuments();
            PageReference pr3 = caseViewExt.callLogLabRequestsView();
            caseViewExt.closeCase();

            caseViewExt.notesFromCollector = 'Test Notes';
            caseViewExt.saveAppealForAdjustment();

            //Checking Additional Close Case Validation in case Appeal for Adjustment is Requested
            c.Appeal_for_Adjustment_Requested__c = True;
            c.Appeal_for_Adjustment_Status__c = 'Appeal Sent';
            update c;


            caseViewExt.tempCaseRecord.Appeal_for_Adjustment_Requested__c = True;
            caseViewExt.tempCaseRecord.Appeal_for_Adjustment_Status__c = 'Appeal Sent';
            caseViewExt.tempCaseRecord.Collected_Amount__c = 12;
            //Checking Additional Close Case Validation in case All Required Documents are not yet uploaded
            Documents__c doc = new Documents__c();
            doc.Name = 'Explanation of Benefits';
            insert doc;
            caseViewExt.documentsList.add(doc);

            caseViewExt.closeCase();

            caseViewExt.tempCaseRecord.Appeal_for_Adjustment_Requested__c = True;
            caseViewExt.tempCaseRecord.Appeal_for_Adjustment_Status__c = 'Adjusted';
            caseViewExt.closeCase();
            
            caseViewExt.displayCloseCasePopup();
            caseViewExt.cancelCloseCasePopup();

            List<SelectOption> tempList = caseViewExt.getCaseCloseStatuses();
            caseViewExt.setcloseCaseStatus('Appeal Denied');
            String var = caseViewExt.getcloseCaseStatus();
       
            caseViewExt.tempCaseRecord = c;
            caseViewExt.saveCaseLog();
            caseViewExt.displayPopUp=true;
            caseViewExt.caseCurrentStatus= caseViewExt.getopenCaseNewStatus();
            
            //Testing the scenario where New Call is Logged and the Case Status is Processing
            caseViewExt.setOpenCaseNewStatus('Processing');
            caseViewExt.insuranceAgentName = 'Naveen';
            caseViewExt.insuranceAgentReferenceNumber = '1234';
            caseViewExt.tempCaseRecord.Appeal_for_Adjustment_Requested__c = false;
            caseViewExt.saveCaseLog();
            
            //Testing the scenario where New Call is Logged and the Case Status is Data Missing in Claim
            caseViewExt.setOpenCaseNewStatus('Data Missing in Claim');
            caseViewExt.saveCaseLog();
            
            caseViewExt.notesForDMCR = 'Test';
            caseViewExt.faxNumber = '1234';
            caseViewExt.saveCaseLog();
            
            //Testing the scenario where New Call is Logged and the Case Status is Requesting Medical Records
            caseViewExt.setOpenCaseNewStatus('Requesting Medical Records');
            caseViewExt.faxNumber = '';
            caseViewExt.saveCaseLog();
            
            caseViewExt.notesForMRR = 'Test';
            caseViewExt.faxNumber = '1234';
            caseViewExt.saveCaseLog();
            
            //Testing the scenario where New Call is Logged and the Case Status is Payment Scheduled
            caseViewExt.setOpenCaseNewStatus('Payment Scheduled');
            caseViewExt.saveCaseLog();
              
            //Testing the scenario where New Call is Logged and the Case Status is Adjustment in Progress
            caseViewExt.setappealCaseNewStatus('Adjustment in Progress');
            caseViewExt.saveCaseLog();
            
            caseViewExt.tempCaseRecord.Collection_Reference__c = '1234';
            caseViewExt.tempCaseRecord.Collected_Amount__c = 800;
            
            caseViewExt.saveCaseLog();

            caseViewExt.closeCase();
             caseViewExt.showEditUserScreen();

            caseViewExt.duplicateClaimCase();
            list<collection_line_item__C> Lstcoll =  caseviewExt.getLstCollectionLineItem();
            caseviewExt.SavecollectionLineItem();
            caseViewExt.deleteCase();
            caseViewExt.closePopup();
            caseviewExt.tobeEdited = colins.id;
            // caseviewExt.SavecollectionLineItem();
            caseViewExt.tobeDeleted = colIns1.id;
            caseViewExt.EditcollectionLineItem();
            caseViewExt.DeletecollectionLineItem();
            caseViewExt.NewcollectionIns = colIns;
            caseViewExt.collectionIns = colIns1;

            caseViewext.displayRequestRebillPopup();
            caseviewExt.caceldisplayRequestRebillPopup();
            
            //caseviewExt.NewcollectionIns.Collecti.on_Amount__c = 12;
            caseViewExt.saveRequestRebill();
            caseViewExt.InitiateProvierDispute();
            
            caseViewExt.insuranceAgentName = null;
             caseViewExt.insuranceAgentReferenceNumber= null;
            
            caseViewExt.checkRequiredFieldsSave(c1);
            caseViewExt.overRideUserFlag = true;
            caseViewExt.deleteCase();
            caseViewExt.closePopup();
             String openCaseNewStatus = caseViewExt.getopenCaseNewStatus();
            String appealCaseNewStatuses = caseViewExt.getappealCaseNewStatus();
        }
        test.StopTest();

    }




}