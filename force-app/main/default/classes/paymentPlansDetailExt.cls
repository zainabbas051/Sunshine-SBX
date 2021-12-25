//Test Class : paymentPlansDetailExtTest
public without sharing class paymentPlansDetailExt extends Ctrl_UploadPaymentReceipt  {
    
    private final Payment_Plan__c ppRecord;
    public string modeOfCollections='';
    public string typeOfCollection = '';
    public string RefundRsn='';
    public string Status='';
    public string RefundStatus=''; 
    public string AdmissionStatus='';
    public string BillingStatus='';
    public string Modeofrefund='';
    public string writeOffReason='';
    public string InvStatus='';
    public string ClosedRsn='';
    public boolean approvalPopupFlag=False;
    public boolean rejectionPopupFlag=False;
    public boolean refundrejectionFlag=False;
    public boolean closeinvFlag=False;
    public string approvalComments{get;set;}
    public string rejectionComments{get;set;}
    public boolean readOnlyFlag{get;set;}
    public id uploadDocumentIndex{get;set;}
    public id liDeleteIndex{get;set;}
    public id liEditIndex{get;set;}
    public Decimal liAmount{get;set;}
    public id liSaveIndex{get;set;}
    public id ciEditIndex{get;set;}
    public id ciSaveIndex{get;set;}
    public id ciDeleteIndex{get;set;}
    public id riEditIndex{get;set;}
    public id riSaveIndex{get;set;}
    public id riDeleteIndex{get;set;}
    public id risubmitrefundIndex{get;set;}
    public id ricloserefundIndex{get;set;} 
    public id riadmissionIndex{get;set;}
    public id ribillingindex{get;set;} 
    public id rirejectindex{get;set;}
    public id ip1stinvindex{get;set;}
    public id ipinv1sentindex{get;set;}
    public id ip2ndinvindex{get;set;}
    public id ipinv2sentindex{get;set;}
    public id ip3rdinvindex{get;set;}
    public id ipinv3sentindex{get;set;}
    public id ipcloseinvIndex{get;set;}
    public id ipaddinvindex{get;set;}
    public id selectedAuthInfoId{get;set;}
    public boolean editPaymentPlan{get;set;}
    public string bodyContent {get;set;}
    public string cashCollectionResponsible {get;set;}
    public string suffix{get;set;}
    public string PPLIRsuffix{get;set;}
    public string sunshinecenter{get;set;}
    public Payment_Plan_Line_Items__c paymentPlanLineItemObj {get;set;}
    public string ResponsiblePerson {get;set;}
    public string emailofResponsiblePerson {get;set;}
    public string actualSelectedValue {get;set;}
   
     public list<SelectOption> lstOfCardOption{
        get{
            if(lstOfCardOption == null){
                lstOfCardOption = new List<SelectOption>();
            }
            return lstOfCardOption;
        }set;
    }
    public string selectedCard {get;set;}
    
    public paymentPlansDetailExt(ApexPages.StandardController stdController) {
        this.ppRecord = (Payment_Plan__c)stdController.getRecord();
        //ppRecordId = ApexPages.currentPage().getParameters().get('id');
        
        approvalComments = '';
        rejectionComments = '';
        readOnlyFlag = True;
        editPaymentPlan = False;
        loadData(); 
        createPdfUrl(); 
        
        Payment_Plan__c tempPP = [select id, Name, Opportunity__r.Name, Opportunity__r.Sunshine_Center__r.Name from Payment_Plan__c where id=: ApexPages.currentPage().getParameters().get('id')];
        suffix = label.Production_or_Sanbox+'/'+tempPP.Opportunity__r.Sunshine_Center__r.Name+'/'+tempPP.Opportunity__r.Name+'/Payment Plan Documents/'+tempPP.Name+'/Invoice Process Request/';  
        suffix = suffix.replace('\'', '');

        sunshinecenter=tempPP.Opportunity__r.Sunshine_Center__r.Name;
        paymentPlanLineItemObj = new Payment_Plan_Line_Items__c();
    }
    
    void createPdfUrl(){
        
        PageReference pdf = Page.Invoice_Process;
        pdf.getParameters().put('id',ApexPages.currentPage().getParameters().get('id'));
        Blob body;
        try {
            body = pdf.getContentAsPDF();
            bodyContent =  EncodingUtil.base64Encode(body);
          //bodyContent = body;
        } catch (VisualforceException e) {
            body = Blob.valueOf('Error : ' + e);
        }
    }
    
    public string baseurl{
        get{
            return URL.getSalesforceBaseUrl().toExternalForm()+'/apex/paymentPlanDetail?id=';
        }set;
    }
    
    public id currentUserId{
        get{
            return userInfo.getUserId();
        }set;
    }
    
    
    public boolean editPaymentPlanFlag{
        get{
            return editPaymentPlan;
        }set;
    }
    
    public boolean displayApprovalPopup{
        get{
            return approvalPopupFlag;
        }set;
    }
    
    public void approvePopup(){
        approvalPopupFlag = True;
    }
    
    public void approvePopupCancel(){
        approvalPopupFlag = False;
    }
    
    public boolean displayRejectionPopup{
        get{
            return rejectionPopupFlag;
        }set;
    }
    
    public void rejectPopup(){
        rejectionPopupFlag = True;
    }
    
    public void rejectPopupCancel(){
        rejectionPopupFlag = False;
    }
    
     public boolean displayRefundPopup{
        get{
            return refundrejectionFlag;
        }set;
    }
    
    public void refundrejectPopup(){
        refundrejectionFlag= True;
    }
    
    public void refundPopupCancel(){
        refundrejectionFlag = False;
    }
    
    public boolean displaycloseinvPopup{
        get{
            return closeinvFlag;
        }set;
    }
    
    public void closeinvoicepopup(){
        closeinvFlag = True;
    }
    
    public void closeinvPopupCancel(){
        closeinvFlag = False;
    }
    
    public List<SelectOption> getModeOfCollectionType() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None--','--None--'));
            options.add(new SelectOption('Cash','Cash'));
            options.add(new SelectOption('Cheque','Cheque'));
            options.add(new SelectOption('Direct Deposit','Direct Deposit'));
            options.add(new SelectOption('Debit/Credit Card','Debit/Credit Card'));
        return options;
    }
    public String getmodeOfCollections() {
        return modeOfCollections;
    }
    public void setmodeOfCollections(String modeOfCollections) {
        this.modeOfCollections = modeOfCollections;
    }
    
   
    
    public List<SelectOption> getTypeOfCollectionS() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None--','--None--'));
            options.add(new SelectOption('Deductible','Deductible'));
            options.add(new SelectOption('Out of Pocket','Out of Pocket'));
            options.add(new SelectOption('Copays','Copays'));
            options.add(new SelectOption('Pharmacy','Pharmacy'));
            options.add(new SelectOption('Cash Pay','Cash Pay'));
            options.add(new SelectOption('Extension','Extension'));
            options.add(new SelectOption('Housing','Housing'));
             options.add(new SelectOption('Rx/Housing','Rx/Housing'));
            options.add(new SelectOption('PTM Claims','PTM Claims'));
            options.add(new SelectOption('Journal Entry','Journal Entry'));
            
        return options;
    }
    public String gettypeOfCollection() {
        return typeOfCollection;
    }
    public void settypeOfCollection(String typeOfCollection) {
        this.typeOfCollection = typeOfCollection;
    }
    
    public List<SelectOption> getWriteOffReasons() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None--','--None--'));
            options.add(new SelectOption('Financial Hardship','Financial Hardship'));
            options.add(new SelectOption('No Contact','No Contact'));
        return options;
    }
    public String getwriteOffReason() {
        return writeOffReason;
    }
    public void setwriteOffReason(String writeOffReason) {
        this.writeOffReason = writeOffReason;
    }
    
    public List<SelectOption> getStatusValues() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None--','--None--'));
            options.add(new SelectOption('Open','Open'));
            options.add(new SelectOption('Direct Deposit Pending','Direct Deposit Pending'));
            options.add(new SelectOption('Card Declined','Card Declined'));
            options.add(new SelectOption('Closed','Closed'));
        return options;
    }
    public String getStatus() {
        return Status;
    }
    public void setStatus(String status) {
        this.Status = status;
    }
    
    public pageReference uploadDocument(){
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/uploadDocuments_PaymentPlans?id='+uploadDocumentIndex);
        return pr;
    }
    
    public pageReference uploadPaymentReceipts(){
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/uploadDocuments_PaymentPlansCollections?id='+uploadDocumentIndex);
        return pr;
    }
    
    public pageReference uploadRefundReceipts(){
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/uploadDocuments_PaymentPlansRefund?id='+uploadDocumentIndex);
        return pr;
    }
    
    public boolean approvalUser{
        get{
            if(userInfo.getUserId() == label.Lynelle_Smith_Id || userInfo.getUserId() == label.AubreyHowell_ID || userInfo.getUserId()==label.Zoobeez_Fatima_User_Id || userInfo.getUserId() == label.Luis_User_ID || userInfo.getUserId() == label.Naveen_User_Id || userInfo.getUserId() == label.Tahil_User_Id || userInfo.getUserId() == label.Joshua_User_Id){
                return true;
            }
            return false;
        }set;
    }
    
    public boolean paymentProcessingUser{
        get{
            if(userInfo.getUserId() == label.Lynelle_Smith_Id ||userInfo.getUserId() == label.AubreyHowell_ID || userInfo.getUserId()==label.Zoobeez_Fatima_User_Id || userInfo.getUserId() == label.Luis_User_ID || userInfo.getUserId() == label.Naveen_User_Id || userInfo.getUserId() == label.Tahil_User_Id || userInfo.getUserId() == label.Tori_User_Id || userInfo.getUserId() == label.Brandi_User_Id || userInfo.getUserId() == label.Joshua_User_Id){
                return true;
            }
            return false;
        }set;
    }
    
    public boolean overWriteUser{
        get{
            if(userInfo.getUserId() == label.Lynelle_Smith_Id ||userInfo.getUserId() ==label.AubreyHowell_ID || userInfo.getUserId()==label.Zoobeez_Fatima_User_Id || userInfo.getUserId() == label.Luis_User_ID || userInfo.getUserId() == label.Naveen_User_Id || userInfo.getUserId() == label.Tahil_User_Id || userInfo.getUserId() == label.Tom_Kearns_Id){
                return true;
            }
            return false;
        }set; 
    }
    
    public void editPaymentPlanMethod(){
        editPaymentPlan = True;
    }
    
    public void savePaymentPlanMethod(){
        try{
            editPaymentPlan = False;
            update ppRecord;
        }
        catch(DMLException de) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, de.getDmlMessage(0)));
          //  return NULL;
        }
        catch(Exception e) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, e.getMessage()));
          //  return NULL;
        }
      /*  catch(exception e){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,e.getMessage()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage() + e.getLineNumber()));
        }*/
    }
    
    public pageReference addLineItem(){
        Payment_Plan_Line_Items__c tempPPLI = new Payment_Plan_Line_Items__c();
        tempPPLI.Payment_Plan__c = ApexPages.currentPage().getParameters().get('id');
        insert tempPPLI;
        boolean updateFlag=False;
        Payment_Plan__c tempPP = new Payment_Plan__c();
        for(Payment_Plan__c pp : [Select id, Approval_Status__c from Payment_Plan__c where id=: ApexPages.currentPage().getParameters().get('id')]){
            tempPP = pp;
            if(pp.Approval_Status__c == 'Approved'){
                updateFlag = True;
                tempPP.Approval_Status__c = 'Not Submitted';
                tempPP.Status__c = 'Open';
            }
        }
        if(updateFlag == True)
            update tempPP;
        
        //decimal tempDecimal;
        //Date tempDate;
        //lineItem li = new lineItem(tempPPLI.id, tempPPLI.Payment_Plan__c, null, tempDecimal, tempDate, True, tempDate, 'Open', '', '','','','','',False,'','',False);
        //lineItemList.add(li);
        
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/PaymentPlanDetail?id='+tempPP.id);
        return pr;
        
    }
    
    public void deleteLineItem(){
        try{
            integer listIndex = 0;
            integer tempIndexToDelete = 0;
            for(lineItem ppli : lineItemList){
                system.debug(liDeleteIndex);//This gives us the index of the record we would like to delete from the UI
                system.debug(ppli.li_id);
                system.debug(listIndex);
                if(liDeleteIndex == ppli.li_id){
                    tempIndexToDelete = listIndex;
                    break;
                }
                listIndex++;
            }
            system.debug(tempIndexToDelete);
            lineItemList.remove(tempIndexToDelete);
            Payment_Plan_Line_Items__c tempPPLI = new Payment_Plan_Line_Items__c(id = liDeleteIndex);
            delete tempPPLI;
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
        }   
    }
    
    public void editLineItem(){
        if(liEditIndex != null){
            for(lineItem li : lineItemList){
                if(li.li_id == liEditIndex){
                    setStatus(li.status);
                    if(li.designatedModeOfCollection != '')
                        setmodeOfCollections(li.designatedModeOfCollection);
                    else
                        setmodeOfCollections('--None--');
                    if(li.typeOfCollection != '')
                        settypeOfCollection(li.typeOfCollection);
                    else
                        settypeOfCollection('--None--');
                    if(li.writeOffReason != '')
                        setwriteOffReason(li.writeOffReason);
                    else
                        setwriteOffReason('--None--');
                    li.readOnly=False;
                    break;
                }
            }
        }
    }
     public void sendCashCollectionEmail(){}
    
    public void ProcessCard(){
         
         
        try{  
        
        system.debug('$$$$$$' + liSaveIndex );
          system.debug('$$$$$$' + liAmount);
        if(liSaveIndex == null) return;
        
        
        if(cardInformationList.isEmpty()) return;
        
        
        Card_Information__c iCard = [select id, Card_Number__c, Name_On_Card__c, Expiration_Month__c, Expiration_Year__c, CVV__c, AWS_Link__c, 
                                       Billing_Address__c, Billing_City__c, Billing_State__c, Billing_Zip__c, Payment_Plan_Authorization_URL__c, 
                                       Card_Approved__c, Credit_Card_Authorization_Ext1__c, Credit_Card_Authorization_Ext2__c from Card_Information__c
                                        where Id = : selectedCard.split(';')[0] limit 1];

        
      
      Integer currentYear = System.Today().year(); 
      Integer currentMonth = System.Today().month();
      String str = iCard.Expiration_Year__c;
            if(str.length()==2){
            str='20'+iCard.Expiration_Year__c;
            }
      Integer cardYear = Integer.valueof(str);
      Integer cardMonth = Integer.valueof(iCard.Expiration_Month__c);
      if(cardYear< currentYear || ( cardMonth<currentMonth && cardYear== currentYear)){
      
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Invalid Card Expiration Month-Year'));
      
      }
      else{
     PaymentAuthorization pp= NEW PaymentAuthorization(liSaveIndex,iCard ,liAmount,sunshinecenter);
        
        
        system.debug('ggggg' + cardInformationList[0]);
       
       string jsonRequest = pp.JSONReq;
       
         system.debug('ggggg' + jsonRequest);
         system.debug('ggggg' + pp.JSONReq);
       string jsonRespone = pp.GetPaymentAuthorization();
       string amount=String.valueOf(liAmount.format());
       updateRecordLineItemAfterResponse(liSaveIndex,amount,jsonRequest,jsonRespone,iCard);
      // UploadPaymentQuery(liSaveIndex,selectedAuthInfoId);
       
       UploadPaymentQuery(liSaveIndex);
      
      // UploadPaymentQuery('a0C3C0000054Lyj','a2w3C000000J67e');
       createPPLIReceiptUrl();
       createUrl();

         system.debug('ggggg' + callJs );
       //loadData();
        }
        }
        catch(Exception e){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage() + e.getLineNumber()));
        }
    }
    
    
    void updateRecordLineItemAfterResponse(string lineItemId,string totalAmounnt,string jsonRequest,string jsonRespone,Card_Information__c ci){

            Authorize_Net_Transaction_Info__c authObj = new Authorize_Net_Transaction_Info__c();
            authObj.Payment_Plan_Line_Items__c = lineItemId;
            authObj.Outbound_API_JSON__c = jsonRequest;
            authObj.Inbound_API_Response__c = jsonRespone;
            

            AuthorizeNetResponse responseObj = AuthorizeNetResponse.parse(jsonRespone);
            system.debug('ggggggg' + responseObj );
           Payment_Plan_Line_Items__c paymentLine = new Payment_Plan_Line_Items__c();
           paymentline.Id = lineItemId;
           paymentline.Actual_Mode_of_Collection__c = 'Debit/Credit Card';
           paymentline.Card_Information__c= ci.id;
           paymentline.Collection_Reference_ID__c=responseObj.transactionResponse.transId;
           string responseCode=responseObj.transactionResponse.responseCode;
           paymentline.Card_Transaction_Message__c='';
           switch on responseCode {
                when '1' {       
                    paymentline.Card_Transaction_Status__c='Approved';
   
                    paymentline.Status__c = 'Closed';
                    paymentline.Closed_Date__c = date.Today();
                    authObj.Total_Amount__c=totalAmounnt;
                    authObj.Authorization_Code__c=responseObj.transactionResponse.authCode;
                    authObj.Transaction_ID__c=responseObj.transactionResponse.transId;
                    authObj.Transaction_Type__c='Authorization w/ Auto Capture';
                    authObj.Card_Number__c=responseObj.transactionResponse.accountNumber;
                    authObj.Submit_Date_Time__c= string.valueOfGmt(system.now());
                    authObj.Transaction_Status__c='Captured';
                    authObj.Card_Type__c= responseObj.transactionResponse.accountType;
                }   
                when '2' {      
                    paymentline.Card_Transaction_Status__c='Declined';
                }
                when '3' {       
                    paymentline.Card_Transaction_Status__c='Error';
                }
                when '4' {       
                    paymentline.Card_Transaction_Status__c='Held for Review';
                }
            }
           
           if(responseObj.transactionResponse.errors != null && responseObj.transactionResponse.errors.isEmpty() == false)
               paymentline.Card_Transaction_Message__c = responseObj.transactionResponse.errors[0].errorText;
           System.debug('___________'+responseObj.transactionResponse.responseCode);
          // paymentline.Card_Transaction_Status__c = responseObj.messages.message[0].text;
           insert authObj;
           update paymentline;
           selectedAuthInfoId = authObj.id;
           
    }
    
    public void saveLineItem(){
        
        system.debug('^^^^' + paymentPlanLineItemObj.Id);
        if(paymentPlanLineItemObj.Id != null){
            for(lineItem li : lineItemList){
                if(li.li_id == paymentPlanLineItemObj.Id){
                    Payment_Plan_Line_Items__c ppli = new Payment_Plan_Line_Items__c(id = li.li_id);
                    ppli.Email_Address_of_Person_Responsible__c = paymentPlanLineItemObj.Email_Address_of_Person_Responsible__c;
                    ppli.Name_of_Person_Responsible__c = paymentPlanLineItemObj.Name_of_Person_Responsible__c;
                    system.debug('%%%%' + modeOfCollections );
                   
                      system.debug('%%%%' + modeOfCollections );
                   
                    if(Status == 'Closed'){
                        li.actualModeOfCollection = modeOfCollections;
                        li.writeOffReason = writeOffReason;
                        if(checkRequiredFieldsCloseLineItem(li) == False){
                            break;
                        }else{
                            ppli.Status__c = Status;
                            ppli.Closed_Date__c = date.Today();
                        }
                    }else if(Status == 'Direct Deposit Pending' ){
                        ppli.Status__c = Status;
                        ConnectApi.FeedItem fi = (ConnectApi.FeedItem)ConnectApiHelper.postFeedItemWithMentions(null, li.pp_id, '{'+li.opp_owner_id+'}, A Direct Deposit Payment as Part of the Payment Plan for the Amount of '+li.amount+' is Pending to Come in with the due date of : '+li.dueDate+', Please contact the Client with this regard');
                    }else if(Status == 'Card Declined'){
                        ppli.Status__c = Status;
                        ConnectApi.FeedItem fi = (ConnectApi.FeedItem)ConnectApiHelper.postFeedItemWithMentions(null, li.pp_id, '{'+li.opp_owner_id+'}, The Card on file for the Payment Plan for the Amount of '+li.amount+' with the due date of : '+li.dueDate+', HAS BEEN DECLINED, Please contact the Client with this regard');
                    }else{
                        ppli.Status__c = Status;
                    }
                    li.readOnly = True;
                    ppli.Amount_For_Collection__c = li.amount;
                    ppli.Due_Date__c = li.dueDate;
                    
                    if(ppRecord.Approval_Status__c != 'Approved'){
                        if(modeOfCollections != '--None--')
                            ppli.Designated_Mode_of_Collection__c = modeOfCollections;
                        else 
                            ppli.Designated_Mode_of_Collection__c = '';
                    }
                
                    if(ppRecord.Approval_Status__c == 'Approved'){
                        if(modeOfCollections != '--None--')
                            ppli.Actual_Mode_of_Collection__c = modeOfCollections;
                        else
                            ppli.Actual_Mode_of_Collection__c = '';
                    }
                    
                    ppli.Collection_Reference_ID__c = li.collectionReferenceId;
                    ppli.Collector_Notes__c = li.collectorNotes;
                    if(typeOfCollection != '--None--')
                        ppli.Type_of_Collection__c = typeOfCollection;
                    else
                        ppli.Type_Of_Collection__c ='';   
                    ppli.Write_Off__c = li.writeOff;
                    if(writeOffReason != '--None--')
                        ppli.Write_Off_Reason__c = writeOffReason;
                    else
                        ppli.Write_Off_Reason__c = '' ;
                    try{
                         if((actualSelectedValue == 'Cash' ||   ppli.Actual_Mode_of_Collection__c == 'Cash')){
                         system.debug('++status'+Status);
                         system.debug('++ppli.Status__c'+ppli.Status__c);
                         ppli.Status__c='Confirmation Pending';
                    }
                        system.debug('++status'+Status);
                         system.debug('++ppli.Status__c'+ppli.Status__c);
                        update ppli;
                    }
                    
                   /* catch(exception e){
                        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,e.getMessage()));
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage() + e.getLineNumber()));
                    }*/
                    
                    catch(DMLException de) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, de.getDmlMessage(0)));
            //return NULL;
        }
        catch(Exception e) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, e.getMessage()));
           // return NULL;
        }
                    break;
                }
            }
            loadData();
        }
    }
    
    public PageReference addCardInfo(){
        Card_Information__c tempci = new Card_Information__c();
        tempci.Payment_Plan__c = ApexPages.currentPage().getParameters().get('id');
        insert tempci;
        boolean updateFlag=False;
        Payment_Plan__c tempPP = new Payment_Plan__c();
        for(Payment_Plan__c pp : [Select id, Approval_Status__c from Payment_Plan__c where id=: ApexPages.currentPage().getParameters().get('id')]){
            tempPP = pp;
            if(pp.Approval_Status__c == 'Approved'){
                updateFlag = True;
                tempPP.Approval_Status__c = 'Not Submitted';
                tempPP.Status__c = 'Open';
            }
        }
        if(updateFlag == True)
            update tempPP;
        
        
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/PaymentPlanDetail?id='+tempPP.id);
        return pr;
    }
                
    public void editCardInformation(){
        if(ciEditIndex != null){
            for(cardInformation ci : cardInformationList){
                if(ci.ci_id == ciEditIndex){
                    ci.readOnly=False;
                    break;
                }
            }
        }
    }
    
    public void saveCardInformation(){
        if(ciSaveIndex != null){
            for(cardInformation ci : cardInformationList){
                if(ci.ci_id == ciSaveIndex){
                    ci.readOnly = True;
                    Card_Information__c c = new Card_Information__c(id = ci.ci_id);
                    c.Card_Number__c = ci.cardNumber;
                    c.Name_on_Card__c= ci.nameOnCard;
                    c.Expiration_Month__c = ci.expirationMonth;
                    c.Expiration_Year__c = ci.expirationYear;
                    c.CVV__c = ci.cvvNumber;
                    c.Billing_Address__c = ci.billingAddress;
                    c.Billing_City__c = ci.billingCity;
                    c.Billing_State__c = ci.billingState;
                    c.Billing_Zip__c = ci.billingZip;
                    try{
                        update c;
                       }catch(exception e){
                       // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,e.getMessage()));
                       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage() + e.getLineNumber()));
                    }
                    
                    break;
                }
            }
            loadData();
        }
    }
    
    
    public pageReference addRefundInfo(){
        Payment_Plan_Refund_Request__c tempPPRR = new Payment_Plan_Refund_Request__c();
        tempPPRR.Payment_Plan__c = ApexPages.currentPage().getParameters().get('id');
       //system.debug('Refund_Status__c'+tempPPRR.Refund_Status__c); 
        tempPPRR.Refund_Requested_By__c = UserInfo.getUserId();
        tempPPRR.Refund_Requested_Date_Time__c = datetime.now();
        insert tempPPRR;
        
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/PaymentPlanDetail?id='+tempPPRR.Payment_Plan__c);
        return pr;
        }
     
        
   public void editRefundRequest(){
        
        if(riEditIndex != null){
            for(refundInfo ri : refundInfoList){
                 if(ri.ri_id == riEditIndex){
                  setRefundStatus(ri.Refundstatus);
                  
                  if(ri.RefundReason!= '')
                        setRefundRsn(ri.RefundReason);
                    else
                        setRefundRsn('--None--');
                  
                  setAdmissionStatus(ri.Admissionstatus);
                  
                  setBillingStatus(ri.Billingstatus);
                  
                  if(ri.ModeofRefund!= '')
                        setModeofrefund(ri.ModeofRefund);
                    else
                        setRefundRsn('--None--');
                  
                  setModeofrefund(ri.ModeofRefund);   
                    ri.readOnly=False;
                    break;
                }
            }
        }
    }
       
       
       public void saveRefundinfo(){
        if(riSaveIndex != null){
            for(refundInfo ri : refundInfoList){
                if(ri.ri_id == riSaveIndex){
                    ri.readOnly = True;
                    Payment_Plan_Refund_Request__c pprr = new Payment_Plan_Refund_Request__c (id = ri.ri_id);
                    pprr.Refund_Amount__c = ri.RefundAmt;
                    if(RefundRsn != '--None--')
                            pprr.Refund_Reason__c = RefundRsn;
                    else 
                            pprr.Refund_Reason__c = '';
                            
                      pprr.Refund_Reference_Number__c = ri.ReferenceNum;
                      
                      if(Modeofrefund!= '--None--')
                            pprr.Mode_of_Refund__c = Modeofrefund;  
                      else 
                            pprr.Mode_of_Refund__c = '';           
                      
                    try{
                        update pprr;
                       
                    }catch(exception e){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,e.getMessage()));
                    }
                    
                    break;
                }
            }
            loadData();
        }
    }    
    
    
     public void deleteRefundinfo(){
        try{
            integer listIndex = 0;
            integer tempIndexToDelete = 0;
            for(refundInfo ri : refundInfoList){
                if(riDeleteIndex == ri.ri_id){
                    tempIndexToDelete = listIndex;
                    break;
                }
                listIndex++;
            }
           // system.debug(tempIndexToDelete);
            refundInfoList.remove(tempIndexToDelete);
            Payment_Plan_Refund_Request__c tempRI = new Payment_Plan_Refund_Request__c(id = riDeleteIndex);
            delete tempRI ;
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
        }   
    } 
    
   public void closeRefundApproval(){
        if(ricloserefundIndex!= null){
            for(refundInfo ri : refundInfoList){
                if(ri.ri_id == ricloserefundIndex){
                    if(checkRequiredFieldsCloseRefund(ri) == False){
                        break;
                    }else{
                    Payment_Plan_Refund_Request__c pprr = new Payment_Plan_Refund_Request__c (id = ricloserefundIndex);
                    pprr.Refund_Status__c = 'Closed';
                    pprr.Refund_Processed_By__c = userInfo.getUserId();
                    pprr.Refund_Process_Date__c = date.today();
                    ri.readOnly=False;
                    
                    try{
                    
                        update pprr;
                        ConnectApi.FeedItem fi = (ConnectApi.FeedItem)ConnectApiHelper.postFeedItemWithMentions(null, ApexPages.currentPage().getParameters().get('id'), '{'+userInfo.GetUserId()+'} has closed this Refund Request.');
            
                    }catch(exception e){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,e.getMessage()));
                    }
                    
                    break;
                }
                }
            }
            loadData();
        }
    }    
    
      
    public void submitForRefundApproval(){
    if(risubmitrefundIndex != null){
      for(refundInfo ri : refundInfoList){
        if(ri.ri_id == risubmitrefundIndex){
          if(checkRequiredFieldsRefundForApproval(ri) == False){
            break;
        }else{        
        
            
            Payment_Plan_Refund_Request__c pprr = new Payment_Plan_Refund_Request__c (id = risubmitrefundIndex);     
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting Refund Request for Approval.');
            req1.setObjectId(risubmitrefundIndex);
            
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(userinfo.getuserid());
            
            List<Id> nextApprovers = new List<Id>();
            //nextApprovers.add((ID)label.Lynelle_Smith_Id);
           nextApprovers.add((ID)label.Luis_User_ID);

            //The User to which the Approval Request is directed.
            req1.setNextApproverIds(nextApprovers);
            
            // Submit the record to specific process and skip the criteria evaluation
            req1.setProcessDefinitionNameOrId('Payment_Plan_Refund_Approval_Process');
            req1.setSkipEntryCriteria(true);
            
            pprr.Refund_Status__c = 'Submitted for Approval';
            pprr.Admissions_Approval_Status__c = 'Under Processing';
            pprr.Billing_Approval_Status__c = 'Under Processing';
            try{
                // Submit the approval request for the Refund
                Approval.ProcessResult result = Approval.process(req1);
                System.assert(result.isSuccess());      
                System.assertEquals(
                   'Pending', result.getInstanceStatus(),
                   'Instance Status'+result.getInstanceStatus());
                update pprr;
                ConnectApi.FeedItem fi = (ConnectApi.FeedItem)ConnectApiHelper.postFeedItemWithMentions(null, ApexPages.currentPage().getParameters().get('id'), '{'+(ID)label.Lauryn_Blaum_Id+'} {'+(ID)label.Matthew_Orme_Id+'} {'+(ID)label.Joshua_User_Id +'}, This Refund Request Has Been Submitted for Approval. Please kindly review it and Approve it.');
            }catch(exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,e.getMessage()));  
            } } } }
        loadData();
       
    }}
          
    public void admissionapprove(){
        if(riadmissionIndex!= null){
            ProcessInstance pi = new ProcessInstance();
            if(!Test.isRunningTest()){


            pi = [SELECT Id, (SELECT Id, ActorId, ProcessInstanceId FROM Workitems) 
                FROM ProcessInstance WHERE TargetObjectId =: riadmissionIndex AND Status =: 'Pending'];
             }   
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments(approvalComments);
            req2.setAction('Approve');
            req2.setNextApproverIds(new Id[] {(ID)label.Brandi_User_Id});
            req2.setWorkitemId(pi.Workitems[0].id);
            
            try{
                Approval.ProcessResult result2 =  Approval.process(req2);
                ConnectApi.FeedItem fi = (ConnectApi.FeedItem)ConnectApiHelper.postFeedItemWithMentions(null, ApexPages.currentPage().getParameters().get('id'), '{'+userInfo.GetUserId()+'} from Admissions has completed first Level of Approval the requested Refund Request, {'+(ID)label.Brandi_User_Id +'}, Please kindly review it and Approve it from Billing Perspective.');
            
            }
            catch(exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,e.getMessage()));  
            }
          
            loadData();
        }
    }   
          
    public void Billingapprove(){
        if(ribillingindex!= null){
           
            ProcessInstance pi = new ProcessInstance();
            pi = [SELECT Id, (SELECT Id, ActorId, ProcessInstanceId FROM Workitems) 
                FROM ProcessInstance WHERE TargetObjectId =:ribillingindex AND Status =: 'Pending'];
            
            Approval.ProcessWorkitemRequest req3 = new Approval.ProcessWorkitemRequest();
            req3.setComments('Billing Approved');
            req3.setAction('Approve');
            req3.setWorkitemId(pi.Workitems[0].id);
            
            try{
                Approval.ProcessResult result2 =  Approval.process(req3);
                ConnectApi.FeedItem fi = (ConnectApi.FeedItem)ConnectApiHelper.postFeedItemWithMentions(null, ApexPages.currentPage().getParameters().get('id'), '{'+userInfo.GetUserId()+'} from Billing has completed Second Level of Approval on this Refund Request. {'+(ID)label.Tim_Armstrong_ID +'} Please kindly process this Refund Request.');
            
               }
             catch(exception e){
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,e.getMessage()));  
             }
          
             loadData();
        }
    }   
      
      
      public pageReference rejectrefund(){
         string ppRecordId = ApexPages.currentPage().getParameters().get('id');
        if(rirejectindex != null){
        
        
        
        if(rejectionComments == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Please type in the Rejection Comments, before Clicking on Reject Refund'));
            return null;
        }
               
        ProcessInstance pi = new ProcessInstance();
        pi = [SELECT Id, (SELECT Id, ActorId, ProcessInstanceId FROM Workitems) 
                FROM ProcessInstance WHERE TargetObjectId =:rirejectindex AND Status =: 'Pending'];  
            
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments(rejectionComments);
        req2.setAction('Reject');
        req2.setWorkitemId(pi.Workitems[0].id);
        
        // Submit the request for approval
        try{
            Approval.ProcessResult result2 =  Approval.process(req2);
            ConnectApi.FeedItem fi = (ConnectApi.FeedItem)ConnectApiHelper.postFeedItemWithMentions(null, ApexPages.currentPage().getParameters().get('id'), '{'+userInfo.GetUserId()+'} Rejected this Refund Request with the following reason : '+rejectionComments);
            
            }catch(exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,e.getMessage()));  
        } }
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/PaymentPlanDetail?id='+ppRecordId);
            return pr;
   }  
   
   
    public pageReference addInvProcess(){
         String message='';  
        Boolean tempflag = false;
        if(InvProcessReqList.size()>0){
            for(invProcess ipr : InvProcessReqList){
                if(ipr.Invstatus!='Closed'){
                    tempflag = true;
                   // system.debug('invstatus:::' +ipr.invstatus);
                   // system.debug('tempflag'+tempflag);
                }
            } 
        }
        If (tempflag == false){ 
            Invoice_Process_Request__c tempIPR = new Invoice_Process_Request__c();
            tempIPR.Payment_Plan__c = ApexPages.currentPage().getParameters().get('id');
            
            insert tempIPR;
            
            PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/PaymentPlanDetail?id='+tempIPR.Payment_Plan__c);
            return pr;
        }else{
            message='Please make sure all previous Rows are in Closed Status to create a new Invoice Process Row!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        return null;
    } 
        
        
         
         public void invistsent(){
           
           if(ipinv1sentindex != null){
            Invoice_Process_Request__c tempIPR = new Invoice_Process_Request__c(id = ipinv1sentindex);
            tempIPR.Invoice_Process_Status__c = 'First Invoice Sent';
            tempIPR.First_Invoice_Sent_By__c =  UserInfo.getUserId();
            tempIPR.First_Invoice_Sent_Date__c = date.today();
            tempIPR.First_Invoice_Sent__c = true;
            update tempIPR;
            }
           loadData();
         } 
         
        public void inv2ndsent(){
           
           if(ipinv2sentindex!= null){
            Invoice_Process_Request__c tempIPR = new Invoice_Process_Request__c(id = ipinv2sentindex);
            tempIPR.Invoice_Process_Status__c = 'Second Invoice Sent';
            tempIPR.Second_Invoice_Sent_By__c =  UserInfo.getUserId();
            tempIPR.Second_Invoice_Sent_Date__c = date.today();
            tempIPR.Second_Invoice_Sent__c = true;
            update tempIPR;
            }
           loadData();
         } 
         
         public void inv3rdsent(){
           
           if(ipinv3sentindex!= null){
            Invoice_Process_Request__c tempIPR = new Invoice_Process_Request__c(id = ipinv3sentindex);
            tempIPR.Invoice_Process_Status__c = 'Third Invoice Sent';
            tempIPR.Third_Invoice_Sent_By__c =  UserInfo.getUserId();
            tempIPR.Third_Invoice_Sent_Date__c = date.today();
            tempIPR.Third_Invoice_Sent__c = true;
            update tempIPR;
            }
           loadData();
         } 
             
         public pageReference closeinvoice(){
           string ppRecordId = ApexPages.currentPage().getParameters().get('id');
           
           if(ipcloseinvIndex != null){
            Invoice_Process_Request__c tempIPR = new Invoice_Process_Request__c(id = ipcloseinvIndex);
            tempIPR.Invoice_Process_Status__c = 'Closed';
            if(ClosedRsn!= '--None--')
                tempIPR.Closed_Reason__c = ClosedRsn;  
            else 
                tempIPR.Closed_Reason__c = '';     
           
            update tempIPR;
             
         }    
           PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/PaymentPlanDetail?id='+ppRecordId);
            return pr;
          }
         
         
    public list<lineItem> lineItemList{
        get{
            if(lineItemList == null){
                lineItemList = new List<lineItem>();
            }
            return lineItemList;
        }set;
    }
    
    public list<cardInformation> cardInformationList{
        get{
            if(cardInformationList == null){
                cardInformationList = new List<cardInformation>();
            }
            return cardInformationList;
        }set;
    }
    
     public list<refundInfo> refundInfoList{
        get{
            if(refundInfoList == null){
                refundInfoList = new List<refundInfo>();
            }
            return refundInfoList;
        }set;
    }
    
     public list<invProcess> InvProcessReqList{
        get{
            if(InvProcessReqList== null){
                InvProcessReqList= new List<invProcess>();
            }
            return InvProcessReqList;
        }set;
    }
    
  
    
    public void loadData(){
        string ppRecordId = ApexPages.currentPage().getParameters().get('id');
        lstOfCardOption = new List<SelectOption>();
        lstOfCardOption.add(new SelectOption('0','--chose one option--'));
        if(lineItemList.size()>0)    
            lineItemList.clear();
        
        if(cardInformationList.size()>0)
            cardInformationList.clear();
        
        if(refundInfoList.size()>0)
            refundInfoList.clear();    
        
        if(InvProcessReqList.size()>0)
            InvProcessReqList.clear();        
            
       
        if(ppRecordId != null){
            for(Payment_Plan_Line_Items__c ppli : [select id,Card_Transaction_Status__c,Amount_For_Collection__c, Due_Date__c, Status__c, Closed_Date__c, Assigned_To__r.Name, Actual_Mode_of_Collection__c, Designated_Mode_of_Collection__c, Collection_Reference_ID__c, Collector_Notes__c, Payment_Plan__c, Payment_Plan__r.Opportunity__r.OwnerId, Payment_Receipt_URL__c, Write_Off__c, Write_Off_Reason__c, Type_of_Collection__c, Line_Item_Approved__c,Card_Transaction_Message__c,Email_Address_of_Person_Responsible__c,Name_of_Person_Responsible__c from Payment_Plan_Line_Items__c where Payment_Plan__c =: ppRecordId ORDER BY Due_Date__c]){
                lineItem li = new lineItem(ppli.id,ppli.Payment_Plan__c ,ppli.Payment_Plan__r.Opportunity__r.OwnerId ,ppli.Amount_For_Collection__c, ppli.Due_Date__c, True, ppli.Closed_Date__c, ppli.Status__c, ppli.Assigned_To__r.Name, ppli.Designated_Mode_of_Collection__c, ppli.Actual_Mode_of_Collection__c, ppli.Collector_Notes__c, ppli.Collection_Reference_ID__c, ppli.Payment_Receipt_URL__c, ppli.Write_Off__c, ppli.Write_Off_Reason__c, ppli.Type_of_Collection__c, ppli.Line_Item_Approved__c,ppli.Card_Transaction_Status__c,ppli.Card_Transaction_Message__c,ppli.Name_of_Person_Responsible__c,ppli.Email_Address_of_Person_Responsible__c);
                lineItemList.add(li);
            }
            for(Card_Information__c ci : [select id, Card_Number__c, Name_On_Card__c, Expiration_Month__c, Expiration_Year__c, CVV__c, AWS_Link__c, Billing_Address__c, Billing_City__c, Billing_State__c, Billing_Zip__c, Payment_Plan_Authorization_URL__c, Card_Approved__c, Credit_Card_Authorization_Ext1__c, Credit_Card_Authorization_Ext2__c from Card_Information__c where Payment_Plan__c =: ppRecordId]){
                cardInformation c = new cardInformation(ci.id, ci.card_Number__c, ci.CVV__c, ci.Expiration_Month__c, ci.Expiration_Year__c, ci.Name_On_Card__c, ci.AWS_Link__c, True, ci.Billing_Address__c, ci.Billing_City__c, ci.Billing_State__c, ci.Billing_Zip__c, ci.Payment_Plan_Authorization_URL__c,ci.Card_Approved__c,ci.Credit_Card_Authorization_Ext1__c,ci.Credit_Card_Authorization_Ext2__c);
                cardInformationList.add(c);
                if(ci.Card_Number__c != null)
                  
                    lstOfCardOption.add(new SelectOption(ci.ID,ci.Card_Number__c));

               
            }
            for(Payment_Plan_Refund_Request__c pprr : [select id, Admissions_Approval_Status__c, Billing_Approval_Status__c, Mode_of_Refund__c, Refund_Amount__c, Refund_Process_Date__c, Refund_Processed_By__r.Name, Refund_Reason__c, Refund_Receipt_URL__c, Refund_Reference_Number__c, Refund_Requested_By__r.name, Refund_Requested_Date_Time__c, Refund_Status__c from Payment_Plan_Refund_Request__c where Payment_Plan__c =: ppRecordId]){
                refundInfo r = new refundInfo(pprr.id, pprr.Refund_Requested_By__r.name, pprr.Refund_Amount__c, pprr.Refund_Reason__c,pprr.Refund_Requested_Date_Time__c, pprr.Refund_Status__c, pprr.Admissions_Approval_Status__c, pprr.Billing_Approval_Status__c, pprr.Refund_Process_Date__c, pprr.Refund_Processed_By__r.Name, pprr.Mode_of_Refund__c, pprr.Refund_Reference_Number__c, pprr.Refund_Receipt_URL__c, True);
                refundInfoList.add(r);
                
            }         
            for(Invoice_Process_Request__c pipr: [select id, Name, Invoice_Process_Status__c, Closed_Reason__c, First_Invoice_Generated_By__r.name, First_Invoice_Generated_Date__c, First_Invoice_Sent_By__r.name, First_Invoice_Sent_Date__c, Second_Invoice_Generated_By__r.name, Second_Invoice_Generated_Date__c, Second_Invoice_Sent_By__r.name, Second_Invoice_Sent_Date__c, Third_Invoice_Generated_By__r.name, Third_Invoice_Generated_Date__c, Third_Invoice_Sent_By__r.name, Third_Invoice_Sent_Date__c, First_Invoice_Generated__c, First_Invoice_Sent__c, Second_Invoice_Generated__c, Second_Invoice_Sent__c, Third_Invoice_Generated__c, Third_Invoice_Sent__c, First_Invoice_URL__c, Second_Invoice_URL__c, Third_Invoice_URL__c from Invoice_Process_Request__c where Payment_Plan__c =: ppRecordId]){
                invProcess ip = new invProcess(pipr.id, pipr.Name, pipr.Invoice_Process_Status__c, pipr.Closed_Reason__c, pipr.First_Invoice_URL__c, pipr.First_Invoice_Generated_By__r.name, pipr.First_Invoice_Generated_Date__c, pipr.First_Invoice_Sent_By__r.name, pipr.First_Invoice_Sent_Date__c, pipr.Second_Invoice_URL__c, pipr.Second_Invoice_Generated_By__r.name, pipr.Second_Invoice_Generated_Date__c, pipr.Second_Invoice_Sent_By__r.name,pipr.Second_Invoice_Sent_Date__c, pipr.Third_Invoice_URL__c, pipr.Third_Invoice_Generated_By__r.name, pipr.Third_Invoice_Generated_Date__c, pipr.Third_Invoice_Sent_By__r.name, pipr.Third_Invoice_Sent_Date__c , pipr.First_Invoice_Generated__c, pipr.First_Invoice_Sent__c, pipr.Second_Invoice_Generated__c, pipr.Second_Invoice_Sent__c, pipr.Third_Invoice_Generated__c, pipr.Third_Invoice_Sent__c , True);
                InvProcessReqList.add(ip);
                
            }       
          
        }
    }
    
    public pageReference submitForApproval(){
        if(checkRequiredFieldsSubmitForApproval() == False){
            return null;
        }else{
            string ppRecordId = ApexPages.currentPage().getParameters().get('id');
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting Payment Plan for Approval.');
            req1.setObjectId(ppRecordId);
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(userinfo.getuserid());
            
            List<Id> nextApprovers = new List<Id>();
           // nextApprovers.add((ID)label.Lynelle_Smith_Id);
           nextApprovers.add((ID)label.Joshua_User_Id);
            // The User to which the Approval Request is directed.
            req1.setNextApproverIds(nextApprovers);
            
            // Submit the record to specific process and skip the criteria evaluation
            req1.setProcessDefinitionNameOrId('Payment_Plan_Approval_Process');
            req1.setSkipEntryCriteria(true);
            // Submit the approval request for the account
            try{
                Approval.ProcessResult result = Approval.process(req1);
                
                Payment_Plan__c tempPP = new Payment_Plan__c(id = ppRecordId, Approval_Status__c = 'Under Processing');
                Approval.UnlockResult ulrList = Approval.unlock(tempPP, false);
                update tempPP;
                
                ConnectApi.FeedItem fi = (ConnectApi.FeedItem)ConnectApiHelper.postFeedItemWithMentions(null, ppRecordId, '{'+(ID)label.Lauryn_Blaum_Id+'} {'+(ID)label.Matthew_Orme_Id+'} {'+(ID)label.Joshua_User_Id +'}, This Payment Plan Has Been Submitted for Approval. Please kindly review it and Approve it.');
            }catch(exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,e.getMessage()));  
            }
            PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/PaymentPlanDetail?id='+ppRecordId);
            return pr;
            }
        //return null;
    }
    
    public pageReference approvePaymentPlan(){
        string ppRecordId = ApexPages.currentPage().getParameters().get('id');
        
        if(approvalComments == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Please type in the Approval Comments, before Clicking on Approve Payment Plan'));
            return null;
        }
        
        ProcessInstance pi = new ProcessInstance();
        try{
        pi = [SELECT Id, (SELECT Id, ActorId, ProcessInstanceId FROM Workitems) 
            FROM ProcessInstance WHERE TargetObjectId =: ppRecordId AND Status =: 'Pending'];
            
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments(approvalComments);
        req2.setAction('Approve');
        // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(pi.Workitems[0].id);
        // Submit the request for approval
        
            Approval.ProcessResult result2 =  Approval.process(req2);
            
            Payment_Plan__c tempPP = new Payment_Plan__c(id = ppRecordId, Approval_Status__c = 'Approved', Status__c = 'Active');
            Approval.UnlockResult ulrList = Approval.unlock(tempPP, false);
            update tempPP;
            
            
            
            
        }catch(exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,e.getMessage()));  
        }
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/PaymentPlanDetail?id='+ppRecordId);
        return pr;
    }
    
    public pageReference rejectPaymentPlan(){
        string ppRecordId = ApexPages.currentPage().getParameters().get('id');
        
        if(rejectionComments == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Please type in the Rejection Comments, before Clicking on Reject Payment Plan'));
            return null;
        }
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        ProcessInstance pi = new ProcessInstance();
        try{       pi = [SELECT Id, (SELECT Id, ActorId, ProcessInstanceId FROM Workitems) 
            FROM ProcessInstance WHERE TargetObjectId =: ppRecordId AND Status =: 'Pending'];
        
            
        
        req2.setComments(rejectionComments);
        req2.setAction('Reject');
        // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(pi.Workitems[0].id);
        // Submit the request for approval
        }
        catch(exception e){}
        try{
            Approval.ProcessResult result2 =  Approval.process(req2);
            
            Payment_Plan__c tempPP = new Payment_Plan__c(id = ppRecordId, Approval_Status__c = 'Rejected');
            update tempPP;
        }catch(exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,e.getMessage()));  
        }
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/PaymentPlanDetail?id='+ppRecordId);
        return pr;
    }
    
     public boolean checkRequiredFieldsSubmitForApproval(){
        String message='';      
        Boolean success=true;
        decimal totalAddedAmount = 0;
        For(lineItem li : lineItemList){
            if(li.amount != null)
                totalAddedAmount = totalAddedAmount + li.amount;
            
            if(li.dueDate < ppRecord.Start_Date__c){
                success=false;
                message='Please make sure a Due Date added in all Payment Plan Line Items is Greater Than Payment Plan Start Date!!';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
            
            if(li.dueDate == null){
                success=false;
                message='Please make sure a Due Date has been added in all Payment Plan Line Items!!';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            } 
            
            if(li.designatedModeOfCollection == '' || li.designatedModeOfCollection == null){
                success=false;
                message='Please sure to select a Designated Mode of Collection on all Payment Plan Line Items!!';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            } 
            if(li.typeOfCollection == null || li.typeOfCollection == ''){
                success=false;
                message='Please sure to select a Type of Collection on all Payment Plan Line Items!!';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
        }
        
        if(totalAddedAmount != ppRecord.Total_Amount_To_Be_Collected__c){
            success=false;
            message='Please Make Sure the Sum of Amount added in all Payment Plan Line Items is equal to Total Amount To Be Collected mentioned on the Payment Plan!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        
        return success;
    }
    
    public boolean checkRequiredFieldsCloseLineItem(lineItem liRecord){
        String message='';      
        Boolean success=true;
        decimal totalAddedAmount = 0;
        
        if(liRecord.actualModeOfCollection == '' || liRecord.actualModeOfCollection == null || liRecord.actualModeOfCollection == '--None--'){
            success=false;
            message='Please Make Sure the Actual Mode of Collection has been selected in the Payment Plan Line Item You Are Trying to CLOSE!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        
        if(liRecord.writeOff == True && (liRecord.writeOffReason == '--None--' || liRecord.writeOffReason == '')){
            success=false;
            message='Please Make Sure Write Off Reason has been selected in the Payment Plan Line Item You Are Trying to CLOSE!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        
        if(liRecord.actualModeOfCollection != 'Cash' && ((liRecord.collectionReferenceId == '' || liRecord.collectionReferenceId == null) && liRecord.writeOff == False)){
            success=false;
            message='Please Make Sure the Collection Reference ID has been selected in the Payment Plan Line Item You Are Trying to CLOSE!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        
        return success;
    }
    
    public boolean checkRequiredFieldsCloseRefund(refundInfo riRecord){
        String message='';      
        Boolean success=true;
        decimal totalAddedAmount = 0;
        
        if(riRecord.ModeofRefund == '' || riRecord.ModeofRefund == null){
            success=false;
            message='Please Make Sure the Mode of Refund has been selected in the Refund Request Line Item You Are Trying to CLOSE!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        
        if(riRecord.ReferenceNum == '' || riRecord.ReferenceNum == null){
            success=false;
            message='Please Make Sure Refund Reference Number has been punched in the Refund Request Line Item You Are Trying to CLOSE!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        
        if(riRecord.RefundReceiptLink == '' || riRecord.RefundReceiptLink == null){
            success=false;
            message='Please Make Sure the Refund Receicept has been uploaded in the Refund Request Line Item You Are Trying to CLOSE!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        
        return success;
    }
    
    
      public boolean checkRequiredFieldsRefundForApproval(refundInfo riRecord){
        String message='';      
        Boolean success=true;
        if(riRecord.RefundAmt == Null || riRecord.RefundAmt == 0.00){
            success=false;
            message='Please sure to Enter a Refund Amount on all Refund Request Line Items!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
         }
            
        if(riRecord.RefundReason == null || riRecord.RefundReason == ''){
            success=false;
            message='Please sure to select a Reason of Refund on all Refund Request Line Items!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
                
      return success;
    }
    
     
    
     public List<SelectOption> getRefundReasonType() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None--','--None--'));
            options.add(new SelectOption('Did not admit','Did not admit'));
            options.add(new SelectOption('ACA','ACA'));
            options.add(new SelectOption('Courtesy Billing','Courtesy Billing'));
            options.add(new SelectOption('Other','Other'));
        return options;
    }
    public String getRefundRsn() {
        return RefundRsn;
    }
    public void setRefundRsn(String RefundRsn) {
        this.RefundRsn = RefundRsn;
    }
    
     public List<SelectOption> getAdmissionstatusValues() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None--','--None--'));
            options.add(new SelectOption('Not Submitted','Not Submitted'));
            options.add(new SelectOption('Under Processing','Under Processing'));
            options.add(new SelectOption('Approved','Approved'));
            options.add(new SelectOption('Rejected','Rejected'));
        return options;
    }
    public String getAdmissionStatus() {
        return AdmissionStatus;
    }
    public void setAdmissionStatus(String Admissionstatus) {
        this.AdmissionStatus = AdmissionStatus;
    }
    
      public List<SelectOption> getBillingstatusValues() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None--','--None--'));
            options.add(new SelectOption('Not Submitted','Not Submitted'));
            options.add(new SelectOption('Under Processing','Direct Deposit Pending'));
            options.add(new SelectOption('Approved','Approved'));
            options.add(new SelectOption('Rejected','Rejected'));
        return options;
    }
    public String getBillingStatus() {
        return BillingStatus;
    }
    public void setBillingStatus(String Billingstatus) {
        this.BillingStatus= BillingStatus;
    }
    
    public List<SelectOption> getModeofRefundValues() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None--','--None--'));
            options.add(new SelectOption('Cash','Cash'));
            options.add(new SelectOption('Check','Check'));
            options.add(new SelectOption('Direct Deposit','Direct Deposit'));
            options.add(new SelectOption('Credit / Debit Card','Credit / Debit Card'));
            options.add(new SelectOption('Journal Entry','Journal Entry'));
        return options;
    }
    public String getModeofrefund() {
        return Modeofrefund;
    }
    public void setModeofrefund(String ModeofRefund) {
        this.Modeofrefund = Modeofrefund;
    }
    
    public List<SelectOption> getRefundstatusValues() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None--','--None--'));
            options.add(new SelectOption('Open','Open'));
            options.add(new SelectOption('Rejected','Rejected'));
            options.add(new SelectOption('Submitted for Approval','Submitted for Approval'));
            options.add(new SelectOption('Approved by Admissions Only','Approved by Admissions Only'));
            options.add(new SelectOption('Approved by Admission & Billing','Approved by Admission & Billing'));
            options.add(new SelectOption('Closed','Closed'));
        return options;
    }
    public String getRefundStatus() {
        return Status;
    }
    public void setRefundStatus(String Refundstatus) {
        this.RefundStatus = Refundstatus;
    }
    
     public List<SelectOption> getInvstatusValues() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None--','--None--'));
            options.add(new SelectOption('Open','Open'));
            options.add(new SelectOption('First Invoice Sent','First Invoice Sent'));
            options.add(new SelectOption('First Invoice Generated','First Invoice Generated'));
            options.add(new SelectOption('Second Invoice Sent','Second Invoice Sent'));
            options.add(new SelectOption('Second Invoice Generated','Second Invoice Generated'));
            options.add(new SelectOption('Third Invoice Sent','Third Invoice Sent'));
            options.add(new SelectOption('Third Invoice Generated','Third Invoice Generated'));
            options.add(new SelectOption('Closed','Closed'));
        return options;
    }
    public String getInvStatus() {
        return Status;
    }
    public void setInvStatus(String Invstatus) {
        this.InvStatus = Invstatus;
    }
    
     public List<SelectOption> getClosedrsnValues() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None--','--None--'));
            options.add(new SelectOption('All Invoices Sent','All Invoices Sent'));
            options.add(new SelectOption('Heard Back From Client','Heard Back From Client'));
        return options;
    }
    public String getClosedRsn() {
        return Status;
    }
    public void setClosedRsn(String Closedrsn) {
        this.ClosedRsn = Closedrsn;
    }
    
    public void saveDetails(){
    
       paymentPlanLineItemObj.Status__c='Confirmation Pending';
       paymentPlanLineItemObj.Send_Confirmation_Email__c=true;
        update paymentPlanLineItemObj;
        loadData();
        
    }
    
    public void refreshPickList(){
    
    }
    
    
    public class lineItem{
        public string li_id{get;set;}
        public id pp_id{get;set;}
        public id opp_owner_id{get;set;}
        public decimal amount{get;set;}
        public date dueDate{get;set;}
        public boolean readOnly{get;set;}
        public date closedDate{get;set;}
        public string status {get;set;}
        public string assignedTo{get;set;}
        public string designatedModeOfCollection{get;set;}
        public string actualModeOfCollection{get;set;}
        public string collectorNotes{get;set;}
        public string collectionReferenceId{get;set;}
        public string paymentReceiptLink{get;set;}
        public Boolean writeOff{get;set;}
        public string writeOffReason{get;set;}
        public string typeOfCollection{get;set;}
        public Boolean isApproved{get;set;}
        public string CardTransactionStatus {get;set;}
        public string CardTransactionMessage {get;set;}
        public string ResponsiblePerson {get;set;}
         public string emailofResponsiblePerson {get;set;}
        
        
        public lineItem(string li_id, string pp_id, String opp_owner_id, decimal amount, date dueDate, boolean readOnly, date closedDate, String status, String assignedTo, String designatedModeOfCollection,String actualModeOfCollection,String collectorNotes,String collectionReferenceId, String paymentReceiptLink, Boolean writeOff, String writeOffReason, String typeOfCollection, Boolean isApproved, string CardTransactionStatus, string CardTransactionMessage, string ResponsiblePerson,string emailofResponsiblePerson ){
            this.li_id = li_id;
            this.pp_id = pp_id;
            this.opp_owner_id = opp_owner_id;
            this.amount = amount;
            this.dueDate = dueDate;
            this.readOnly = readOnly;
            this.closedDate = closedDate;
            this.status = status;
            this.assignedTo = assignedTo;
            this.designatedModeOfCollection = designatedModeOfCollection;
            this.actualModeOfCollection = actualModeOfCollection;
            this.collectorNotes = collectorNotes;
            this.collectionReferenceId = collectionReferenceId;
            this.paymentReceiptLink = paymentReceiptLink;
            this.writeOff = writeOff;
            this.writeOffReason = writeOffReason;
            this.typeOfCollection = typeOfCollection;
            this.isApproved = isApproved;
            this.CardTransactionStatus  = CardTransactionStatus ;
            this.CardTransactionMessage  = CardTransactionMessage ;
            this.ResponsiblePerson=ResponsiblePerson;
            this.emailofResponsiblePerson=emailofResponsiblePerson;
            
        }
    }
    
    public class cardInformation{
        public id ci_id{get;set;}
        public string cardNumber{get;set;}
        public decimal cvvNumber{get;set;}
        public string expirationMonth{get;set;}
        public string expirationYear{get;set;}
        public string nameOnCard{get;set;}
        public string billingAddress{get;set;}
        public string billingCity{get;set;}
        public string billingState{get;set;}
        public string billingZip{get;set;}
        public string awsLink{get;set;}
        public string paymentPlanAuthorizationLink{get;set;}
        public string CreditCardAuthorizationExt1Link{get;set;}
        public string CreditCardAuthorizationExt2Link{get;set;}
        public boolean readOnly{get;set;}
        public Boolean isApproved{get;set;}
        public cardInformation(string ci_id, string cardNumber, decimal cvvNumber, string expirationMonth, String expirationYear, 
                               string nameOnCard, string awsLink, boolean readOnly, String billingAddress, String billingCity,
                               String billingState, String billingZip, String paymentPlanAuthorizationLink,
                               Boolean isApproved, string CreditCardAuthorizationExt1Link, string CreditCardAuthorizationExt2Link){
            this.ci_id = ci_id;
            this.cardNumber = cardNumber;
            this.cvvNumber = cvvNumber;
            this.expirationMonth = expirationMonth;
            this.expirationYear = expirationYear;
            this.nameOnCard = nameOnCard;
            this.awsLink = awsLink;
            this.readOnly = readOnly;
            this.billingAddress = billingAddress;
            this.billingCity = billingCity;
            this.billingState = billingState;
            this.billingZip = billingZip;
            this.isApproved = isApproved;
            this.paymentPlanAuthorizationLink = paymentPlanAuthorizationLink;
            this.CreditCardAuthorizationExt1Link = CreditCardAuthorizationExt1Link;
            this.CreditCardAuthorizationExt2Link = CreditCardAuthorizationExt2Link;
        }
    }
    
     public class refundInfo{
       public id ri_id{get;set;} 
       public string currentuser{get;set;}
       public boolean readOnly{get;set;}
       public decimal RefundAmt{get;set;}
       public string RefundReason{get;set;}
       public datetime Refundrequestdt{get;set;}
       public string Refundstatus {get;set;}
       public string Admissionstatus {get;set;}
       public string Billingstatus {get;set;}
       public datetime RefundDate{get;set;}
       public string Refundprocessedby {get;set;}
       public string ModeofRefund{get;set;}
       public string ReferenceNum{get;set;}
       public string RefundReceiptLink{get;set;}
       
       public refundInfo(string ri_id, string currentuser, decimal RefundAmt, string RefundReason, datetime Refundrequestdt, String Refundstatus, string Admissionstatus,
                                string Billingstatus, datetime RefundDate, string Refundprocessedby,  
                               String ModeofRefund, String ReferenceNum, string RefundReceiptLink, boolean readOnly){
            this.ri_id = ri_id;
            this.currentuser = currentuser;
            this.RefundAmt = RefundAmt;
            this.RefundReason = RefundReason;
            this.Refundrequestdt = Refundrequestdt;
            this.Refundstatus = Refundstatus;
            this.Admissionstatus = Admissionstatus;
            this.Billingstatus = Billingstatus;
            this.RefundDate = RefundDate;
            this.Refundprocessedby = Refundprocessedby;
            this.ModeofRefund = ModeofRefund;
            this.ReferenceNum = ReferenceNum;
            this.RefundReceiptLink = RefundReceiptLink;
            this.readOnly = readOnly;
            
            }
       
     }
    
      public class invProcess {
       public id ip_id{get;set;} 
       public string ip_name{get;set;}
       public boolean readOnly{get;set;}
       public string Invstatus{get;set;}
       public string Closedrsn{get;set;}
       public string Invoice1Link{get;set;}
       public string Inv1genratedby{get;set;}  
       public date Invoice1date{get;set;}
       public string Inv1Sentby{get;set;}  
       public date Inv1sentdate{get;set;}
       public string Invoice2Link{get;set;}
       public string Inv2genratedby{get;set;}  
       public date Invoice2date{get;set;}
       public string Inv2Sentby{get;set;}  
       public date Inv2sentdate{get;set;}
       public string Invoice3Link{get;set;} 
       public string Inv3genratedby{get;set;}  
       public date Invoice3date{get;set;}
       public string Inv3Sentby{get;set;}  
       public date Inv3sentdate{get;set;}
       public Boolean Inv1genratedcheck{get;set;}
       public Boolean Inv1sentcheck{get;set;}
       public Boolean Inv2genratedcheck{get;set;}
       public Boolean Inv2sentcheck{get;set;}
       public Boolean Inv3genratedcheck{get;set;}
       public Boolean Inv3sentcheck{get;set;}
       public invProcess(string ip_id, String ip_name, string Invstatus, string Closedrsn, string Invoice1Link, string Inv1genratedby, date Invoice1date, string Inv1Sentby, date Inv1sentdate, 
                          string Invoice2Link, string Inv2genratedby, date Invoice2date, string Inv2Sentby, date Inv2sentdate, string Invoice3Link, string Inv3genratedby,
                          date Invoice3date, string Inv3Sentby, date Inv3sentdate, boolean Inv1genratedcheck, boolean Inv1sentcheck, boolean Inv2genratedcheck, boolean Inv2sentcheck,boolean Inv3genratedcheck, boolean Inv3sentcheck, boolean readOnly){
            this.ip_id = ip_id;
            this.ip_name = ip_name;
            this.Invstatus = Invstatus;
            this.Closedrsn= Closedrsn; 
            this.readOnly = readOnly;
            this.Invoice1Link = Invoice1Link;
            this.Inv1genratedby = Inv1genratedby;
            this.Invoice1date = Invoice1date;
            this.Inv1Sentby = Inv1Sentby;
            this.Inv1sentdate = Inv1sentdate;
            this.Invoice2Link = Invoice2Link;
            this.Inv2genratedby = Inv2genratedby;
            this.Invoice2date = Invoice2date;
            this.Inv2Sentby = Inv2Sentby;
            this.Inv2sentdate = Inv2sentdate;
            this.Invoice3Link = Invoice3Link;
            this.Inv3genratedby = Inv3genratedby;
            this.Invoice3date = Invoice3date;
            this.Inv3Sentby = Inv3Sentby;
            this.Inv3sentdate = Inv3sentdate;
            this.Inv1genratedcheck = Inv1genratedcheck;
            this.Inv1sentcheck = Inv1sentcheck;
            this.Inv2genratedcheck = Inv2genratedcheck;
            this.Inv2sentcheck = Inv2sentcheck;
            this.Inv3genratedcheck = Inv3genratedcheck;
            this.Inv3sentcheck = Inv3sentcheck;
            }
            
         }      
}