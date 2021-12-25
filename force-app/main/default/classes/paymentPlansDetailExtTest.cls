@isTest
private class paymentPlansDetailExtTest{
    Public static Account a;
    Public static Opportunity oms;
    Public static Payment_Plan__c ppRecord;
    public static Payment_Plan_Line_Items__c ppli;
    public static Card_Information__c ciRecord;
    public static Payment_Plan_Refund_Request__c pprr;
    public static Invoice_Process_Request__c iprr;
    Public static User u_test;
    public Static Profile adminProfile;
    public Static ApexPages.StandardController paymentPlanController;
    public Static paymentPlansDetailExt ppde;
 
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
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
        
        oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = recTypeIdOpp;
        oms.Account = a;
        oms.Selected_Treatment_Center__c = a.id;
        oms.Closing_Agent__c = userAdmin.id;
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        insert oms;
        
        ppRecord = new Payment_Plan__c();
        ppRecord.Opportunity__c = oms.id;
        ppRecord.Start_Date__c = date.Today();
        ppRecord.Total_Amount_To_Be_Collected__c = 1000;
        ppRecord.Payment_Plan_Type__c = 'Custom';
        insert ppRecord;
        
        ciRecord = new Card_Information__c();
        ciRecord.AWS_Link__c = 'Test';
        ciRecord.Card_Number__c = '1234123412341234';
        ciRecord.CVV__c = 123;
        ciRecord.Expiration_Month__c ='11';
        ciRecord.Expiration_Year__c = '25';
        ciRecord.Name_on_Card__c='John Smith';
        ciRecord.Payment_Plan__c = ppRecord.id;
        insert ciRecord;
        
        pprr = new Payment_Plan_Refund_Request__c();
        pprr.Refund_Receipt_URL__c = 'Test';
        pprr.Refund_Amount__c = 100;
        pprr.Refund_Reason__c = 'Did not admit';
        pprr.Refund_Requested_Date_Time__c = date.Today();
        pprr.Payment_Plan__c = ppRecord.id;
        insert pprr;
        
        iprr = new Invoice_Process_Request__c();
        iprr.Payment_Plan__c = ppRecord.id;
        
        insert iprr;
        
        ppli = new Payment_Plan_Line_Items__c();
        ppli.Payment_Plan__c = ppRecord.id;
        
        insert ppli;
       
        
     }
     
     public Static testmethod void paymentPlansDetailExtTest(){
       test.startTest();
       system.runAs(userAdmin){
            createSampleData();
           
           ApexPages.currentPage().getParameters().put('Id', ppRecord.id);
           
           paymentPlanController = new ApexPages.StandardController(ppRecord);
           ppde = new paymentPlansDetailExt(paymentPlanController); 
           
           boolean flag1 = ppde.approvalUser;
           PageReference pr = ppde.submitForApproval();
           
           PageReference pr2 = ppde.submitForApproval();
           
           ppde.liEditIndex = ppli.id;
           ppde.editLineItem();
           
           ppde.liSaveIndex = ppli.id;
           ppde.saveLineItem();
           
           ppde.ciEditIndex = ciRecord.id;
           ppde.editCardInformation();
           
           ppde.ciSaveIndex = ciRecord.id;
           ppde.saveCardInformation();
           
           ppde.editPaymentPlanMethod();
           ppde.savePaymentPlanMethod();
           
           ppli.Designated_Mode_of_Collection__c = 'Direct Deposit';
           ppli.Due_Date__c = date.Today();
           ppli.Amount_For_Collection__c = 1000;
           update ppli;
           
           ppde.loadData();
           PageReference pr4 = ppde.submitForApproval();
           
           ppli.Type_of_Collection__c = 'Deductible';
           update ppli;
           
           ppde.loadData();
           PageReference pr8 = ppde.submitForApproval();
           
           ppde.rejectionComments = 'Reject Comments';
           PageReference pr3 = ppde.rejectPaymentPlan();
           
           PageReference pr6 = ppde.submitForApproval();
           
           ppde.approvalComments = 'Approve Comments';
           PageReference pr5 = ppde.approvePaymentPlan();
           
           PageReference pr7 = ppde.uploadDocument();
           
           List<SelectOption> statusList = ppde.getStatusValues();
           List<SelectOption> modeOfCollectionList = ppde.getModeOfCollectionType();
           
           ppli.Status__c = 'Closed';
           ppde.loadData();
           
           ppde.liSaveIndex = ppli.id;
           ppde.saveLineItem();
           
           ppli.Actual_Mode_of_Collection__c = 'Direct Deposit';
           ppli.Collection_Reference_ID__c = '12345';
           ppli.Collector_Notes__c = 'Test Notes';
           
           ppde.Status = 'Direct Deposit Pending';
           ppde.liSaveIndex = ppli.id;
           ppde.saveLineItem();
           
           ppde.Status = 'Card Declined';
           ppde.liSaveIndex = ppli.id;
           ppde.saveLineItem();
           
           ppde.Status = 'Closed';
           ppde.liSaveIndex = ppli.id;
           ppde.saveLineItem();
           
           boolean flag2 = ppde.displayApprovalPopup;
           boolean flag3 = ppde.displayRejectionPopup;
           
           ppde.approvePopup();
           ppde.approvePopupCancel();
           
           ppde.rejectPopup();
           ppde.rejectPopupCancel();
           
           String var1 = ppde.getmodeOfCollections();
           string var2 = ppde.getStatus();
           Boolean var3 = ppde.editPaymentPlanFlag;
           
           for(Task t : [Select id, status from Task where Payment_Plan_Line_Items__c =: ppli.id LIMIT 1]){
               t.Status = 'Completed';
               update t;
           }
           
           Payment_Plan_Line_Items__c ppli2 = new Payment_Plan_Line_Items__c();
            ppli2.Payment_Plan__c = ppRecord.id;
            insert ppli2;
            
            Task temp = new Task();
            temp.Payment_Plan_Line_Items__c = ppli2.id;
            insert temp;
                        
            ppli2.Status__c = 'Closed';
            update ppli2;
            
            ppde.addLineItem();
            
            ppde.loadData();
            ppde.liDeleteIndex = ppli2.id;
            ppde.deleteLineItem();
            
            Boolean var4 = ppde.paymentProcessingUser;
            
            List<SelectOption> soList1 = ppde.getTypeOfCollectionS();
            ppde.settypeOfCollection('Deductible');
            String var5 = ppde.gettypeOfCollection();
            
            List<SelectOption> soList2 = ppde.getWriteOffReasons();
            ppde.setwriteOffReason('No Contact');
            string var6 = ppde.getwriteOffReason();
            
            string url = ppde.baseurl;
            id uid = ppde.currentUserId;
            boolean a = ppde.displaycloseinvPopup;
            ppde.closeinvoicepopup();
            ppde.closeinvPopupCancel();
            ppde.uploadPaymentReceipts();
            a = ppde.overWriteUser;
            ppde.addCardInfo();
            ppde.admissionapprove();
            ppde.Billingapprove();
            ppde.inv2ndsent();
            ppde.inv3rdsent();
            list<selectoption> lst = ppde.getRefundReasonType();
            url = ppde.getRefundRsn();
            ppde.getModeofrefund();
            ppde.getRefundStatus();
            lst = ppde.getInvstatusValues();
            ppde.getInvStatus();
            lst = ppde.getClosedrsnValues();
            ppde.getClosedRsn();
            
                             
       }       
       test.StopTest();
             
      }
       public Static testmethod void paymentPlansDetailExtTest2(){
       test.startTest();
       system.runAs(userAdmin){
            createSampleData();
           
           ApexPages.currentPage().getParameters().put('Id', ppRecord.id);
           
           paymentPlanController = new ApexPages.StandardController(ppRecord);
           ppde = new paymentPlansDetailExt(paymentPlanController); 
           
          //**Test Code for Refund Requests begin from here
            ppde.riEditIndex = pprr.id;
            ppde.editRefundRequest();
           
            ppde.riSaveIndex = pprr.id;
            ppde.saveRefundinfo();
            
           
           
            ppde.loadData();
            ppde.risubmitrefundIndex = pprr.id;
            ppde.submitForRefundApproval();
            
            ppde.loadData();
            ppde.riadmissionIndex = pprr.id;
           // ppde.admissionapprove();
            
            ppde.loadData();
            ppde.ribillingindex= pprr.id;
           // ppde.Billingapprove();
           
            
            
            PageReference pr10 = ppde.uploadRefundReceipts();
            List<SelectOption> RefundStatusList = ppde.getRefundstatusValues();
            List<SelectOption> ModeofrefundList = ppde.getModeofRefundValues();
            pprr.Mode_of_Refund__c = 'Direct Deposit';
            pprr.Refund_Reference_Number__c = '12345';
                     
            pprr.Refund_Status__c = 'Closed';
            ppde.loadData();
            
            ppde.riSaveIndex = pprr.id;
            ppde.saveRefundinfo();
            
            ppde.loadData();
            ppde.ricloserefundIndex = pprr.id;
            ppde.closeRefundApproval();
            
            ppde.addRefundInfo();
            ppde.ricloserefundIndex = null;
            ppde.closeRefundApproval();
            
            //ppde.loadData();
            ppde.riDeleteIndex = pprr.id;
            ppde.deleteRefundinfo();
            
            List<SelectOption> soList3 = ppde.getBillingstatusValues();
            ppde.settypeOfCollection('Approved');
            String var7 = ppde.getBillingStatus();
            
            List<SelectOption> soList4 = ppde.getAdmissionstatusValues();
            ppde.settypeOfCollection('Approved');
            String var8 = ppde.getAdmissionStatus();
            
            boolean flag5 = ppde.displayRefundPopup;
            ppde.refundrejectPopup();
            ppde.refundPopupCancel();
            
            ppde.rejectionComments = 'Reject Comments';
            PageReference pr9 = ppde.rejectrefund();
            
         //**Test Code for invoice process Requests begin from here
           
            ppde.ipinv1sentindex = iprr.id;
            ppde.invistsent();
            iprr.Invoice_Process_Status__c = 'First Invoice Sent';
            iprr.First_Invoice_Sent_By__c =  UserInfo.getUserId();
            iprr.First_Invoice_Sent_Date__c = date.today();
            iprr.First_Invoice_Sent__c = true;
            update iprr; 
            ppde.loadData(); 
           
            ppde.ipcloseinvIndex = iprr.id;
            ppde.closeinvoice();
             
            iprr.Invoice_Process_Status__c = 'Closed';
            iprr.Closed_Reason__c = 'All Invoices Sent';
            update iprr;
            
            ppde.loadData(); 
            ppde.addInvProcess();
            ppde.liSaveIndex = pprr.id;
            ppde.selectedCard = [Select id from Card_Information__c limit 1].Id;
            ppde.ProcessCard();
            
             
                     
       }       
       test.StopTest();
             
      }
}