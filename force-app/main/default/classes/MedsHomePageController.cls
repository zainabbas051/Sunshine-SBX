/*
  controller class for MedsHomeComponent.
    @author: Huma Zafar
    //test class : Meds_ControllersTest
    
    History
    ----------------
    V 1.1 Danish
            
            - Change the logic from email to fax, as we are sending fax to the pharmacy
*/
public with sharing class MedsHomePageController {
    
    //list of orders shown in vf page 
    public list<Order__c> lstOrders {get; set;}
    
    //client chart id from page parameter
    id clientChartId;
    
    //list of mars shown in vf page section
    public list<Event> lstMedications {get; set;}
    public list<Event> lstPRNMedications {get; set;}
    
    //orders shown on click of show all orders button
    public list<Order__c> lstAllOrders {get; set;}
    //order shown on click of show discontinued orders button
    public list<Order__c> lstDiscOrders {get; set;}
    
    //mars record for updating notes - using add notes button
    public Event updateMARs {get; set;}

    //list of mars shown on show all mars button
    public list<Event> lstMARs {get; set;}
    public list<Event> lstPRNMARs {get; set;}
    
    
    //order record shown on vivew order button click
    public Order__c ViewOrderRec {get; set;}
    public Taper__c taper {get; set;}        
    public OrderView orderRec {get; set;}

    //hidden field
    public string SelectedSignedOption {
        get;
        set;
    }
    public string ImageUrlAddress {
        get;
        set;
    }

    //AWS
    public string accessKeyId {
        get;
        set;
    }
    public string secretAccessKey {
        get;
        set;
    }
    public string OrgName {
        get;
        set;
    }
    //administer/refuse multiple mars
    public list<wrapperMARs> lstWrapperMARs{get;set;}
    public list<wrapperMARs> lstWrapperPRNMARs {get;set;}
    public boolean multiplemars{get;set;}
    public boolean disableCheckboxes{get;set;}
    public boolean staffSignReqd{get;set;}
    
    //public id orderIdView{get;set;}
    final string AWSURL;
    private User userObj;
    
    //booleans for hiding and showing popups
    public Boolean viewPopupBoolean {get; set;}
    public boolean AllOrders {get; set;}
    public boolean discOrders {get; set;}
    public boolean AllMARS {get; set;}
    public boolean editOrderPopup{get;set;}
    
    public boolean administered {get; set;}
    
    Map<ID,Contact> mapOfContact; //v1.1
    
    //page parameter
    string rtparam;
    
    public boolean IsSuccess {get ;set;} //v1.1


    public boolean buttonAccessType {

        get {

            User u = [Select ID, UserName, Acess_Type__c FROM User where ID = : UserInfo.getUserId()];
            if (!string.isNotBlank(u.Acess_Type__c))
                return false;

            TabViews__c visibleTab = TabViews__c.getValues('Meds');

            if ( visibleTab.Button_Access_Type__c != null && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;

            return false;
        }
        set;
    }
    
    //properties used in signature url in vf page
    public string SunShineCenterName {get; set;}
    public string ClientName {get; set;}

    //multiple orders sent to pharmacy
    public boolean pharmacyPopup{get;set;}
    private id sendtoPharmacyOrderId;
    
    public string pharmacyEmail{get;set;}
    
    //multiple administration selection list
    public set<string> setSelectedMARs{get;set;}
    
    //send multiple order to pharmacy
    public boolean showmultiorder{get;set;}
    //public list<wrapperOrders> lstwrapperOrders {get;set;}
    
    //list of order lines for editing order
    public list<wrapperOLI> lstwrapperOLI {get;set;}
    
    public MedsHomePageController () {
        
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;

        clientChartId = ApexPages.CurrentPage().getParameters().get('id');
        rtparam = ApexPages.CurrentPage().getParameters().get('rt');

        Client_Chart__c ClientChartObj = [select id, Name, Treatment_Center__r.Name from Client_Chart__c where id = :clientChartId];

        SunShineCenterName = ClientChartObj.Treatment_Center__r.Name;
        ClientName = ClientChartObj.Name;

        updateMARs = new Event();

        setAllBooleanToFalse();
        loadOrders();

        userObj = [select id, name, title from user where id = :UserInfo.getUserID()];
        pharmacyEmail='';

        PageReference cPr = System.currentPageReference();
        if(cPr.getUrl().contains('PDF'))
            showAllMARS();
    }
    
    private void setAllBooleanToFalse(){
        viewPopupBoolean = false;
        AllOrders = false;
        discOrders = false;
        AllMars = false;
        administered = false;
        pharmacyPopup = false;
        multiplemars = false;
        showmultiorder = false;
        disableCheckboxes = false;
        //staffSignReqd = false;
        editOrderPopup = false;
    }
    /*
    //show popup
    public void sendMultipleOrderToPharmacy(){
        setAllBooleanToFalse();
        showmultiorder = true;
        lstwrapperOrders = new list<wrapperOrders>();
        
        for(Order__c ord: lstOrders ){
            if(ord.Pharmacy_Status__c!='Order Received')
                lstwrapperOrders.add(new wrapperOrders(false,ord));
        }
    }
    
    //when send button clicked in popup
    public void sendMultipleOrdersToPharmacy(){
        
        list<Order__c> lstUpdateOrders = new list<Order__c>();
        list<EFax_Log__c> lstfax = new list<EFax_Log__c >();
        try{
            for(wrapperOrders word: lstwrapperOrders){
                if(word.selected){
                    PageReference ref = new PageReference('/apex/MedicinesPDF?orderId=' + word.order.id);
                     
                     //v1.1 start
                    //Blob content = ref.getContent();
                    //string blobContent = EncodingUtil.base64Encode(content);
                    //Contact con = mapOfContact.get(word.pharmacyEmail);
                    //EFax_Log__c eLog = EfaxParseCtrl.EfaxeOutBounReadRequest_Rest(blobContent,'danish.farooq.90@hotmail.com',con.Fax);
                    
                    
                    word.order.Pharmacy_Status__c = 'Order Sent to Pharmacy';
                    word.order.Sent_To_Pharmacy_Date_Time__c = Datetime.now();
                    word.order.Sent_to_Pharmacy_By__c = UserInfo.getUserId();
            
                    lstUpdateOrders.add(word.order);
            
                    
                    //eLog.Order__c = word.order.id;
                    //eLog.Contact__c = con.ID;
                    //eLog.Client_Chart__c = clientChartId;
                    //lstfax.add(eLog);
                }
            }
            if(lstUpdateOrders.size()>0)
                update lstUpdateOrders;
            //if(lstfax.size()>0)
                //insert lstfax ;
            setAllBooleanToFalse();
            loadOrders();
        }
        catch(Exception e){
            system.debug(e.getMessage()+' '+e.getLineNumber());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,e.getMessage()+' '+e.getLineNumber())); 
        }          
    }*/
    
    public PageReference CloseOrderForm() {

        id orderid = system.CurrentPageReference().getParameters().get('orderid');
        //update AssementForm with the user signature
        Order__c ord = new Order__c();
        ord.id = orderid ;

        ord.Doctor_Image_URL__c = AWSURL + ImageUrlAddress;
        ord.Doctor_Signed_User__c = 'Doctor present: ' + userObj.Name + ',' + userObj.Title;
        ord.Doctor_Signed_Date__c = DateTime.newinstance(DateTime.Now().date(), datetime.now().time());
        ord.Signed_By__c = 'All';
        Order__c order = [select id,  Pharmacy_Status__c, Medical_Reconciliation__c ,Order_Type__c,Status__c, Warnings__c
         from Order__c where id = :orderid];
        system.debug(order.Medical_Reconciliation__c);
        if(order.Medical_Reconciliation__c !='Brought In On Admit - Discontinue'){
            if(order.Status__c == 'Under Review - Discontinue' ){
                 ord.Status__c = 'Inactive';
                 ord.Doctor_Image_URL_Disc__c = AWSURL + ImageUrlAddress;
                 ord.Doctor_Signed_User_Disc__c = 'Doctor present: ' + userObj.Name + ',' + userObj.Title;
                 ord.Doctor_Signed_Date_Disc__c = DateTime.newinstance(DateTime.Now().date(), datetime.now().time());
            }
            else if (order.Order_Type__c != 'Action') {
                if (order.Pharmacy_Status__c == 'Order Received' )
                    ord.Status__c = 'Active';
                else
                    ord.Status__c = 'Pending Pharmacy';
            } else {
                if(order.Medical_Reconciliation__c != 'Brought In On Admit - Discontinue')
                ord.Status__c = 'Active';
                else{
                    ord.Status__c = 'Inactive';
                    ord.Discontinue_Date_Time__c = Datetime.now();
                }
            }
        }
        else{
            ord.Status__c = 'Inactive';
            ord.Discontinue_Date_Time__c = Datetime.now();
        }
            
        system.debug( ord.Status__c );
        update ord;
        //return new PageReference('/apex/MedsHomePage?id='+clientChartId );
        return null;
    }
    
    public  List<SelectOption> getPharmacies(){
    
        List<SelectOption> options = new List<SelectOption>();
        list<Contact> lstContacts = [select id,Name,Email,Fax from Contact where Pharmacy__c = true and Account.Name =: rtParam];
        options.add(new SelectOption('-None-','-None-'));  
        mapOfContact = new Map<ID,Contact>();
        for( Contact c : lstContacts ){
            system.debug(c.Fax);
            //v1.1 start
            options.add(new SelectOption(c.ID,c.Name)); 
            mapOfContact.put(c.ID,c);
            //v1.1 end
            
            //pharmacyEmail = c.email;
            //continue;  
        } 
        return options; 
    }
    
    public void sendToPharmacy() {

       setAllBooleanToFalse();
        pharmacyPopup = true;
        
        sendtoPharmacyOrderId = system.CurrentPageReference().getParameters().get('orderId');

    }
    
    public void sendToPharmacyStep2(){
    
       
        PageReference ref = new PageReference('/apex/MedicinesPDF?orderId=' + sendtoPharmacyOrderId );
         
         //v1.1 start
         Blob content = (Test.isRunningTest()?null:ref.getContent());
         string blobContent = Test.isRunningTest()?'':EncodingUtil.base64Encode(content);
        Contact con = mapOfContact.get(pharmacyEmail);
        EFax_Log__c eLog = EfaxParseCtrl.EfaxeOutBounReadRequest_Rest(blobContent,'danish.farooq.90@hotmail.com','Danish',con.Fax);
        
        Order__c ord = new Order__c();
        ord.id = sendtoPharmacyOrderId ;
        ord.Pharmacy_Status__c = 'Order Sent to Pharmacy';
        ord.Sent_To_Pharmacy_Date_Time__c = Datetime.now();
        ord.Sent_to_Pharmacy_By__c = UserInfo.getUserId();

        update ord;

        for (Order__c ordr : lstOrders) {
            if (ordr.id == sendtoPharmacyOrderId ) {
                ordr.Pharmacy_Status__c = 'Order Sent to Pharmacy';
            }
        }
        eLog.Order__c = sendtoPharmacyOrderId;
        eLog.Contact__c = con.ID;
        eLog.Client_Chart__c = clientChartId;
        insert eLog;
        system.debug(sendtoPharmacyOrderId );
        //v1.1 end
        /*Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        if (!test.isRunningTest()) {
            Blob b = ref.getContentAsPDF();
            Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
            efa1.setFileName('Doctors Order for ' + ClientName  + '.pdf');
            efa1.setBody(b);
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});

        }
        system.debug(pharmacyEmail);
        email.setSubject( 'Doctors Order for ' + ClientName );
        email.setToAddresses( new list<string> {pharmacyEmail});
        email.setPlainTextBody('test body');
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        */
        
        pharmacyPopup = false;
    }
    

    public void updatePharmacyStatus() {

        setAllBooleanToFalse();
        id orderId = system.CurrentPageReference().getParameters().get('orderId');

        Order__c tempOrd = [select id, Status__c,Pharmacy_Status__c , Warnings__c from Order__c where id = : orderId];
        if(tempOrd.Pharmacy_Status__c == 'Order Received'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'This order has been already updated to Start Medication, Please kindly refresh the page.'));
            //return;
            /*try{
            throw new DMLException('This order has been already updated to Start Medication, Please kindly refresh the page.');
            }
            catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,e.getmessage()));
            }*/
        }
        else{
            Order__c ord = new Order__c();
            ord.id = orderId;
            ord.Order_Received_From_Pharmacy__c = Datetime.now();
            ord.Pharmacy_Status__c = 'Order Received';
            if (tempOrd.Status__c == 'Pending Pharmacy')
                ord.Status__c = 'Active';
            update ord;

            Order__c order = new Order__c();
    
            for (Order__c ordr : lstOrders) {
                if (ordr.id == orderId) {
    
                    order = ordr;
                }
            }

            //now medicine is received, MARs for this particular order should be created
            if (order.Order_Type__c == 'Manual' && !order.Medical_Reconciliation__c.contains('Discontinue')) {
                Event createMARs = OrderUtil.returnManualMARs(order, clientChartId);
                insert createMARs ;
            } else {
                list<Event> lstCreateMARS = new list<Event>();
    
                List<Order_Line_Item__c> lstTLI = [select id, Day__c,No_of_Refills__c,Order__c,Status__c,Taper_Line_Item__c,
                                                   Dosage_Form__c, Dose__c, Frequency__c, Medicine__c, Route__c, 
                                                    Warning__c from Order_Line_Item__c
                                                   where Order__c = : order.id];
    
    
                for (Order_Line_Item__c TLI : lstTLI) { 
                    if (order.Order_Type__c == 'Standard - Taper' || order.Order_Type__c == 'Custom - Taper' ) {
                        if (TLI.Day__c== 1)
                            lstCreateMARS.Add(OrderUtil.returnStandardMARs(TLI, order, TLI.Warning__c, clientChartId));
                    } else if (order.Order_Type__c == 'Standard - PRN') {
                        lstCreateMARS.add(OrderUtil.returnStandardPRNOTHERMARs(TLI, order, TLI.Warning__c, true, clientChartId));
                    } else if (order.Order_Type__c == 'Standard - Other') {
                        lstCreateMARS.add(OrderUtil.returnStandardPRNOTHERMARs(TLI, order, TLI.Warning__c, false, clientChartId));
                    }
                }
                if (lstCreateMARS.size() > 0)
                    insert lstCreateMARS;
            }
            loadOrders();
        }
    }

    public PageReference CloseRefusedMARs() {
        id orderid = system.CurrentPageReference().getParameters().get('orderid');

        Event existingMARS = [select id, Frequency__c from Event where id = :orderId];
        list<string> freq = existingMARs.Frequency__c.split(' : ');
        FrequencyMapping__c FM = FrequencyMapping__c.getValues(freq[0]);
        Event ord = new Event ();
        ord.id = orderid ;
        if (SelectedSignedOption == 'Staff') {
            ord.Refused_Staff_URL__c = AWSURL + ImageUrlAddress;
            ord.Refused_Staff_Name__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;

            integer minutes = integer.valueof(double.valueof(FM.Interval__c) * (60));

            ord.Pending_Time__c = DateTime.newinstance(DateTime.Now().date(), datetime.now().time()).addMinutes(minutes );
            ord.MARs_Refused__c = DateTime.newinstance(DateTime.Now().date(), datetime.now().time());
            ord.Signed_By__c = 'Staff';
            ord.Status__c = 'Pending';
        }
        update ord;
        //return new PageReference('/apex/MedsHomePage?id='+clientChartId );
        return null;
    }
    
    public void refreshMARS(list<string> lstMARsIDs){
        loadOrders();
        system.debug('orders loaded');
        setSelectedMARs = new set<string>();
        setSelectedMARs.addALL(lstMARsIDs);
        showMultipleMARs();
    }
    
    public PageReference CloseMultipleMARs(){
        string MARsIDs = system.CurrentPageReference().getParameters().get('orderids');
        
        string selectedOpt = system.CurrentPageReference().getParameters().get('option');
        system.debug(selectedOpt );
        system.debug(MARsIDs );
        
        string isAdmin = system.CurrentPageReference().getParameters().get('isAdmin');
        system.debug(isAdmin );
        
        MARsIDs = MARsIDs.replace('[','').replace('"','').replace(']','');
        system.debug(MARsIDs );
        
        list<string> lstMARsIDs = MARsIDs.split(',');        
        system.debug(lstMARsIDs);
        
        Event ord = new Event ();
        list<Event> lstMARs = new list<Event>();
        
        //map of event id and related record
        map<id,Event> mapMARs = new map<id,Event>();
        for(wrapperMARs wM : lstWrapperMARs ){
            mapMARs.put(wM.MARs.id,wM.MARs);
        }
        for(wrapperMARs wM: lstWrapperPRNMARs ){
            mapMARs.put(wM.MARs.id,wM.MARs);
        }
        
        for(string mID : lstMARsIDs){
        
                        
            ord = new Event ();
            ord.id = mID ;
            
            string fileUrl = OrgName+'/'+SunShineCenterName+'/'+ClientName+'/MARs Signatures/'+mID+'/'+mID+'_'+selectedOpt +'.png';
            
            if (selectedOpt == 'Staff'){// && boolean.valueof(isAdmin)) {
                system.debug(mID);
                //system.debug(mapMARs.get(mID).Signed_By__c);
                if(mapMARs.get(mID)!=null ){
                    ord.Doctor_Image_URL__c = AWSURL + fileUrl ;
                    ord.Doctor_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
                    ord.Doctor_Signed_Date__c = DateTime.newinstance(DateTime.Now().date(), datetime.now().time());
                    
                    if(mapMARs.get(mID).Patient_Image_URL__c !=null && ord.Doctor_Image_URL__c!=null){
                        ord.Status__c = 'Administered';
                        ord.MARs_Administered__c = DateTime.now();
                        ord.Signed_By__c = 'All';
                    }
                    else{
                        ord.Signed_By__c = 'Staff';
                    }
                    lstMARs.add(ord);
                }
            }/*            else if (selectedOpt == 'Staff' && !boolean.valueof(isAdmin)) {
                
                list<string> freq = mapMARs.get(mID).Frequency__c.split(' : ');
                FrequencyMapping__c FM = FrequencyMapping__c.getValues(freq[0]);
                
                ord.Refused_Staff_URL__c = AWSURL + fileUrl ;
                ord.Refused_Staff_Name__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
    
                integer minutes = integer.valueof(double.valueof(FM.Interval__c) * (60));
    
                ord.Pending_Time__c = DateTime.newinstance(DateTime.Now().date(), datetime.now().time()).addMinutes(minutes );
                ord.MARs_Refused__c = DateTime.newinstance(DateTime.Now().date(), datetime.now().time());
                ord.Signed_By__c = 'Staff';
                ord.Status__c = 'Pending';
                lstMARs.add(ord);
            }*/
            else if (selectedOpt == 'Patient') {
                //Event e = [select Client_Chart__r.Name from event where id = :mID ];
                if(mapMARs.get(mID)!=null ){
                    ord.Patient_Image_URL__c = AWSURL + fileUrl ;
                    ord.Patient_Signed_User__c = 'Patient present: ' + ClientName;
                    ord.Patient_Signed_Date_Time__c = DateTime.newinstance(DateTime.Now().date(), datetime.now().time());
                    system.debug(ord.Patient_Image_URL__c);
                    system.debug(mapMARs.get(mID).Doctor_Image_URL__c);
                    if(ord.Patient_Image_URL__c !=null && mapMARs.get(mID).Doctor_Image_URL__c!=null){
                        ord.Status__c = 'Administered';
                        ord.MARs_Administered__c = DateTime.now();
                        ord.Signed_By__c = 'All';
                    }
                    else{
                        ord.Signed_By__c = 'Patient';
                    }
                    lstMARs.add(ord);
                }
            }
            
        }
        if(lstMARs.size()>0){
            update lstMARs ;
            refreshMARS(lstMARsIDs);
        }
        return null;
    }
    
    public PageReference CloseMARsForm() {

        id orderid = system.CurrentPageReference().getParameters().get('orderid');
        
        system.debug(orderid );
        Event ord = new Event ();
        ord.id = orderid ;
        if (SelectedSignedOption == 'Staff') {
            ord.Doctor_Image_URL__c = AWSURL + ImageUrlAddress;
            ord.Doctor_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
            ord.Doctor_Signed_Date__c = DateTime.newinstance(DateTime.Now().date(), datetime.now().time());
            ord.Signed_By__c = 'Staff';
        }
        if (SelectedSignedOption == 'Patient') {
            //Event e = [select Client_Chart__r.Name from event where id = :orderid];

            ord.Patient_Image_URL__c = AWSURL + ImageUrlAddress;
            ord.Patient_Signed_User__c = 'Patient present: ' + ClientName;
            ord.Patient_Signed_Date_Time__c = DateTime.newinstance(DateTime.Now().date(), datetime.now().time());
            ord.Status__c = 'Administered';
            ord.MARs_Administered__c = DateTime.now();
            ord.Signed_By__c = 'All';
        }
        try{
            update ord;
            
            
        }
        catch(exception e){
            system.debug(e.getMessage());
        }
        //return new PageReference('/apex/MedsHomePage?id='+clientChartId );
        return null;
    }
    
    
    public void loadOrders() {

        lstMARs = new list<Event>();
        lstPRNMARs = new list<Event>();

        lstOrders = new list<Order__c>();

        lstAllOrders = new list<Order__c>();
        lstDiscOrders = new list<Order__c>();

        lstMedications = new list<Event>();
        lstPRNMedications = new list<Event>();
        
        
        
        TimeZone tz = UserInfo.getTimeZone();
        DateTime dt = DateTime.now();
        dt = dt.addSeconds((tz.getOffset(dt)/1000));
        Date dateVal = date.newinstance(dt.year(), dt.month(), dt.day());
        //Date dateVal = date.valueof(dt);
        system.debug(dateVal );
        lstOrders  = [select id, Status__c, Action__c , Start_Date__c, Name, Order_Type__c, Medicine__c, Taper__c, Medicine__r.Name,
                      Taper__r.Name, Taper__r.Protocol__c, Order_By__c, Order_By__r.Name, Signed_By__c, Doctor_Image_URL__c,
                       Doctor_Signed_Date__c ,Route__c, Complete__c,Order_Name__c,
                      Doctor_Signed_User__c, Owner.FirstName, End_Date__c, Pharmacy_Status__c, Frequency__c, PRN__c, Dose__c, 
                      Duration__c, Medical_Reconciliation__c,Send_To_Pharmacy__c, Warnings__c from Order__c
                      where Status__c <> 'Inactive' //and Status__c <> 'Under Review - Discontinue' 
                      and Client_Chart__c = :clientChartId order by Start_Date__c desc];


        lstMedications = [select id, Medicine__c, Strength__c, Route_of_Delivery__c, Frequency__c, ActivityDate, Description, Staff__c,
                          Status__c, StartDateTime, Medicine__r.Name, WhatId, Is_Administered__c, Signed_By__c , Doctor_Signed_User__c,
                           Doctor_Signed_Date__c,Hide_Button_Date_Time__c,Warning__c,
                          Doctor_Image_URL__c, Patient_Signed_User__c, Patient_Image_URL__c ,  MARs_Refused__c ,                           
                          Patient_Signed_Date_Time__c, Refused_Staff_URL__c , Refused_Staff_Name__c
                          from Event where RecordType.Name = 'MARs' and Status__c <> 'Inactive' and Client_Chart__c=:clientChartId  and
                          Taper_Line_Item__r.Taper__r.Dosage_Type__c<> 'Open Ended' and PRN__c = false //and (StartDateTime = TODAY or
                          //(Status__c = 'Open' and Frequency__c like 'Q% Hours%'
                          // and StartDateTime <=TODAY ))
                           order by  StartDateTime ];
        

        lstPRNMedications = [select id, Medicine__c,  Strength__c, Route_of_Delivery__c, Frequency__c, ActivityDate,  
                            Hide_Button_Date_Time__c, MARs_Refused__c , Refused_Staff_Name__c,Warning__c,
                            Description, Staff__c, Medicine__r.Name, WhatId, Signed_By__c, Doctor_Signed_User__c, Doctor_Signed_Date__c, 
                            Doctor_Image_URL__c, Patient_Signed_User__c, Patient_Image_URL__c ,  Patient_Signed_Date_Time__c, 
                            Refused_Staff_URL__c , Is_Administered__c , 
                            Status__c, Reason__c, StartDateTime from Event where RecordType.Name = 'MARs' and Status__c <> 'Inactive' and
                            (Taper_Line_Item__r.Taper__r.Dosage_Type__c = 'Open Ended' or PRN__c = true)  and Client_Chart__c=:clientChartId 
                            //and  
                            //(StartDateTime = TODAY or 
                            //(Status__c = 'Open' and Frequency__c like 'Q% Hours%' // and StartDateTime <=TODAY
                            //))
                            order by  StartDateTime ];
        
    }

    public void ShowAllOrders() {
        
        setAllBooleanToFalse();
        AllOrders = true;
        
        lstAllOrders = [select id, Start_Date__c, Action__c , Status__c, Name, Discontinue_Date_Time__c, Owner.FirstName,
                        Medicine__r.name,  Order_Type__c ,   Taper__r.Name, Pharmacy_Status__c , Send_To_Pharmacy__c, Warnings__c from Order__c
                        where Client_Chart__c = :clientChartId  order by Start_Date__c desc];
        //return new PageReference('/apex/MedsHomePage?id='+clientChartId );
    }

    public void showDiscOrders() {

        setAllBooleanToFalse();
        discOrders = true;

        lstDiscOrders = [select id, Start_Date__c, Action__c , End_Date__c, Status__c, Name, Discontinue_Date_Time__c, Pharmacy_Status__c,
                         Medicine__r.name,  Order_Type__c , Warnings__c, Taper__r.Name from Order__c
                         where Client_Chart__c = :clientChartId
                                 and Status__c = 'Inactive'];
    }


    public PageReference SubmitMARs() {

        system.debug(updateMARs.id);
        system.debug(updateMARs.Status__c);

        updateMARs.Staff__c = UserInfo.getName();
        update updateMARs;

        PageReference meds = new PageReference('/apex/MedsHomePage?id=' + clientChartId + '&rt=' + rtparam );
        meds.setRedirect(true);
        return meds;
    }

    public void UpdateMARs() {

        setAllBooleanToFalse();
        administered = true;
        
        string passedParam1 = Apexpages.currentPage().getParameters().get('myParam');
        string passedParam2 = system.CurrentPageReference().getParameters().get('myParam');
        string passedParam3 = Apexpages.currentPage().getParameters().get('statusVal');
        system.debug(passedParam1 );
        system.debug(passedParam2 );
        system.debug(passedParam3 );


        updateMARs.Id = Id.valueof(passedParam1 );
        if (passedParam3 != null && passedParam3 != '')
            updateMARs.Status__c = passedParam3 ;

        if (passedParam3 == 'Administered')
            updateMARs.MARs_Administered__c = DateTime.now();
        else if (passedParam3 == 'Refused')
            updateMARs.MARs_Refused__c = DateTime.now();
    }

    public void showAllMARS() {

        setAllBooleanToFalse();
        AllMars = true; 
        
        lstMARs = [select id, Medicine__c, Strength__c, Route_of_Delivery__c, Frequency__c, ActivityDate, Description, Staff__c,
                   Status__c, StartDateTime, Medicine__r.Name, WhatId, Is_Administered__c, Signed_By__c , Doctor_Signed_User__c, 
                   Doctor_Signed_Date__c,Hide_Button_Date_Time__c, Doctor_Image_URL__c, Patient_Signed_User__c, Patient_Image_URL__c ,
                   Patient_Signed_Date_Time__c, MARs_Refused__c , Refused_Staff_URL__c , Refused_Staff_Name__c from Event 
                   where RecordType.Name = 'MARs' and Client_Chart__c=:clientChartId  and
                   Taper_Line_Item__r.Taper__r.Dosage_Type__c<> 'Open Ended' and PRN__c = false order by  StartDateTime ];

        lstPRNMARs = [select id, Medicine__c, Strength__c, Route_of_Delivery__c, Frequency__c, ActivityDate,  Hide_Button_Date_Time__c,
                      Description, Staff__c, Medicine__r.Name, Signed_By__c , Doctor_Signed_User__c, Doctor_Signed_Date__c, 
                      MARs_Refused__c ,Refused_Staff_URL__c , Refused_Staff_Name__c,
                      Doctor_Image_URL__c, Patient_Signed_User__c, Patient_Image_URL__c ,  Patient_Signed_Date_Time__c,                       
                      Status__c, Reason__c, StartDateTime, WhatId, Is_Administered__c  from Event where RecordType.Name = 'MARs' 
                      and Client_Chart__c=:clientChartId and (Taper_Line_Item__r.Taper__r.Dosage_Type__c = 'Open Ended' or PRN__c = true) 
                      order by  StartDateTime ];
    }

    public void showTomorrowsMARS() {

        setAllBooleanToFalse();
        AllMars = true;
        
        TimeZone tz = UserInfo.getTimeZone();
        DateTime dt = DateTime.now().addDays(1);
        dt = dt.addSeconds((tz.getOffset(dt)/1000));
        Date dateVal = date.newinstance(dt.year(), dt.month(), dt.day());
        //Date dateVal = date.valueof(dt);
        
        lstMARs = [select id, Medicine__c, Strength__c, Route_of_Delivery__c, Frequency__c, ActivityDate, Description, Staff__c,
                   Status__c, StartDateTime, Medicine__r.Name, WhatId, Is_Administered__c, Signed_By__c , Doctor_Signed_User__c, 
                   Doctor_Signed_Date__c, Doctor_Image_URL__c, Patient_Signed_User__c, Patient_Image_URL__c , 
                   Patient_Signed_Date_Time__c, MARs_Refused__c , Hide_Button_Date_Time__c, Refused_Staff_URL__c , 
                   Refused_Staff_Name__c   from Event where RecordType.Name = 'MARs' and Status__c <> 'Inactive'  
                   and Client_Chart__c=:clientChartId  and Taper_Line_Item__r.Taper__r.Dosage_Type__c<> 'Open Ended' 
                   and PRN__c = false and StartDateTime=TOMORROW 
                   order by  StartDateTime ];

        lstPRNMARs = [select id, Medicine__c, Strength__c, Route_of_Delivery__c, Frequency__c, ActivityDate,
                      Description, Staff__c, Medicine__r.Name, Signed_By__c , Doctor_Signed_User__c, Doctor_Signed_Date__c,
                      Doctor_Image_URL__c, Patient_Signed_User__c, Patient_Image_URL__c ,  Patient_Signed_Date_Time__c,
                      Refused_Staff_URL__c , Refused_Staff_Name__c, MARs_Refused__c , Hide_Button_Date_Time__c,
                      Status__c, Reason__c, StartDateTime, WhatId, Is_Administered__c  from Event where RecordType.Name = 'MARs' 
                      and Status__c <> 'Inactive'  and Client_Chart__c=:clientChartId  and (
                      Taper_Line_Item__r.Taper__r.Dosage_Type__c = 'Open Ended' or PRN__c = true) and StartDateTime = TOMORROW //DAY_ONLY(StartDateTime) =: dateVal 
                      order by  StartDateTime ];
    }

    public void showYesterdaysMARS() {

        setAllBooleanToFalse();
        AllMars = true;
        
        TimeZone tz = UserInfo.getTimeZone();
        DateTime dt = DateTime.now().addDays(-1);
        dt = dt.addSeconds((tz.getOffset(dt)/1000));
        Date dateVal = date.newinstance(dt.year(), dt.month(), dt.day());
        //Date dateVal = date.valueof(dt);

        lstMARs = [select id, Medicine__c, Strength__c, Route_of_Delivery__c, Frequency__c, ActivityDate, Description, Staff__c,
                   Status__c, StartDateTime, Medicine__r.Name, WhatId, Is_Administered__c, Signed_By__c , Doctor_Signed_User__c, 
                   Doctor_Signed_Date__c, Doctor_Image_URL__c, Patient_Signed_User__c, Patient_Image_URL__c ,  
                   Patient_Signed_Date_Time__c, MARs_Refused__c , Hide_Button_Date_Time__c, Refused_Staff_URL__c , 
                   Refused_Staff_Name__c from Event where RecordType.Name = 'MARs' and Status__c <> 'Inactive' 
                   and Client_Chart__c=:clientChartId and Taper_Line_Item__r.Taper__r.Dosage_Type__c<> 'Open Ended' 
                   and PRN__c = false and StartDateTime = YESTERDAY order by  StartDateTime ];

        lstPRNMARs = [select id, Medicine__c, Strength__c, Route_of_Delivery__c, Frequency__c, ActivityDate,
                      Description, Staff__c, Medicine__r.Name, Signed_By__c , Doctor_Signed_User__c, Doctor_Signed_Date__c,
                      Doctor_Image_URL__c, Patient_Signed_User__c, Patient_Image_URL__c ,  Patient_Signed_Date_Time__c,
                      Refused_Staff_URL__c , Refused_Staff_Name__c, MARs_Refused__c , Hide_Button_Date_Time__c,
                      Status__c, Reason__c, StartDateTime, WhatId, Is_Administered__c  from Event where RecordType.Name = 'MARs' 
                      and Status__c <> 'Inactive' and Client_Chart__c=:clientChartId  and (
                      Taper_Line_Item__r.Taper__r.Dosage_Type__c = 'Open Ended' or PRN__c = true) and StartDateTime = YESTERDAY 
                      order by  StartDateTime ];
    }
    
    //this function is called on click of edit order button
    public PageReference EditOrder() {
        
        ViewOrderRec = new Order__c();

        ViewOrderRec = [select id, Status__c, Action__c , Order_Type__c, Signed_By__c, Order_By__c, Doctor_Image_URL__c, 
        Doctor_Signed_User__c,Medical_Reconciliation__c,Complete__c, PRN__c, Requested_Via__c,Justification__c,
                        Doctor_Signed_Date__c, Taper__c, Taper__r.Protocol__c, Taper__r.Name, Taper__r.Number_of_Days__c, 
                        Start_Date__c, CreatedById, Medicine__c, Medicine__r.Name,
                        Route__c, Frequency__c, Dose__c, Dosage_Form__c, Pharmacy_Status__c, Duration__c , Dispense_Amount__c  
                        ,Number_of_Refills__c, Send_To_Pharmacy__c, Warnings__c 
                        from Order__c where id = : system.CurrentPageReference().getParameters().get('orderId')];

        setAllBooleanToFalse();
        
        editOrderPopup = true;
        
        list<Order_Line_item__c> lstOLI = [select id, Day__c,No_of_Refills__c,Order__c,Status__c,Taper_Line_Item__c,
                                                   Dosage_Form__c, Dose__c, Frequency__c, Medicine__c, Route__c, 
                                                    Warning__c from Order_Line_Item__c where order__c =: viewOrderRec.id
                                                    order by Day__c asc];
        
        lstwrapperOLI = new list<wrapperOLI>();
        integer i =0;
        for(Order_Line_item__c o: lstOLI){
            lstwrapperOLI.add(new wrapperOLI(false,i, o ));
            i++;
        }
        
        return null;
    }
    
     public void EditOLI() {

        string objIndex = system.CurrentPageReference().getParameters().get('IndexNumber');
        wrapperOLI obj = lstwrapperOLI.get(integer.valueof(objIndex));
        obj.IsEdit = true;
    }

    public void SaveOLI() {

        string objIndex = system.CurrentPageReference().getParameters().get('IndexNumber');
        wrapperOLI obj = lstwrapperOLI.get(integer.valueof(objIndex));

        obj.IsEdit = false;
        upsert obj.OLI;        
    }

    public void RemoveOLI() {

        string objIndex = system.CurrentPageReference().getParameters().get('IndexNumber');
        string recId = system.CurrentPageReference().getParameters().get('recId');
        if(recId !=null && recId !='')
            delete[Select ID from Order_Line_Item__c where ID = : recId ];
            
        lstwrapperOLI.remove(integer.valueof(objIndex));

    }
    
    public void AddOLI(){
        
        id medicineId ;
        
        for(wrapperOLI o: lstwrapperOLI){
            medicineId = o.OLI.medicine__c;
            break;
        }
        Order_Line_Item__c oNew = new Order_Line_Item__c();
        oNew.Order__c = ViewOrderRec.id;
        oNew.Status__c = 'Open';
        oNew.Medicine__c = medicineId;
        oNew.Warning__c = ViewOrderRec.Warnings__c;
        lstwrapperOLI.add(new wrapperOLI(true, lstwrapperOLI.size(),oNew));
        
    }
    
    public  List<SelectOption> getFrequencies(){
    
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Order__c.Frequency__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            if(f.getValue()!='3 day (m,w,f)' && f.getValue()!='daily' && f.getValue()!='sessions' && f.getValue()!='weekdays only'){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        } 
        return options; 
    }
    
    public PageReference ViewOrder() {

        system.debug(system.CurrentPageReference().getParameters().get('orderId'));
        //OrderId = system.CurrentPageReference().getParameters().get('orderId');

        ViewOrderRec = new Order__c();

        ViewOrderRec = [select id, Status__c, Action__c , Order_Type__c, Signed_By__c, Order_By__c, Doctor_Image_URL__c, 
        Doctor_Signed_User__c,Medical_Reconciliation__c, PRN__c,
                        Doctor_Signed_Date__c, Taper__c, Taper__r.Protocol__c, Taper__r.Name, Taper__r.Number_of_Days__c, 
                        Start_Date__c, CreatedById, Medicine__c, Medicine__r.Name,
                        Route__c, Frequency__c, Dose__c, Dosage_Form__c, Pharmacy_Status__c, Duration__c , Dispense_Amount__c  
                        ,Number_of_Refills__c, Send_To_Pharmacy__c, Warnings__c 
                        from Order__c where id = : system.CurrentPageReference().getParameters().get('orderId')];

        if (ViewOrderRec.Order_Type__c != 'Manual' && ViewOrderRec.Order_Type__c != 'Action') {
            if(ViewOrderRec.Taper__c ==null)
                taper = new Taper__c();
            else
                taper = [select id, Name from Taper__c where id = : ViewOrderRec.Taper__c];
            
            list<Order_line_item__c> lstOLI = [select id, Frequency__c, Medicine__c, Day__c, Route__c, Dosage_Form__c, Dose__c, Medicine__r.Name
                                       from Order_line_item__c where order__c =: ViewOrderRec.id order by Day__c];

            list<OrderView.wrapperTLI > lst = new list<OrderView.wrapperTLI >();
            OrderView.wrapperTLI wrapObj ;
            for (Order_line_item__c TLI : lstOLI) {
                string freq = TLI.Frequency__c;
                list<string> lstf = freq.split(':');
                string timeStr = lstf[lstf.size() - 1]; //.replaceAll(' ','');
                list<string> lstTime = timeStr.split(',');
                wrapObj = new OrderView.wrapperTLI(TLI.Medicine__r.Name, TLI.Route__c, TLI.Dosage_Form__c, TLI.Dose__c, TLI.Frequency__c, lstTime ,TLI.Day__c);
                lst.add(wrapObj );
            }

            orderRec = new OrderView(ViewOrderRec, taper, lst);
        } else {
            taper = new Taper__c();
            list<OrderView.wrapperTLI > lst = new list<OrderView.wrapperTLI >();
            OrderView.wrapperTLI wrapObj ;
            string freq = ViewOrderRec.Frequency__c;
            
            list<string> lstTime = new list<string>();
            
            if(ViewOrderRec.Frequency__c!=null){
                list<string> lstf = freq.split(':');
                string timeStr = lstf[lstf.size() - 1]; //.replaceAll(' ','');
                lstTime = timeStr.split(',');
            }
            wrapObj = new OrderView.wrapperTLI(ViewOrderRec.Medicine__r.Name, ViewOrderRec.Route__c, ViewOrderRec.Dosage_Form__c, ViewOrderRec.Dose__c, ViewOrderRec.Frequency__c, lstTime ,0);
            lst.add(wrapObj );
            orderRec = new OrderView(ViewOrderRec, taper, lst);
        }
        setAllBooleanToFalse();
        
        viewPopupBoolean = true;
        
        return null;
    }
    
    public PageReference redirectToRefillCount(){
        
        PageReference meds = new PageReference('/apex/Meds_RefillCount?id=' + clientChartId + '&rt=' + rtparam );
        meds.setRedirect(true);
        return meds;
    }
    
    public PageReference redirectToMedicationRecord(){
        
        PageReference meds = new PageReference('/apex/MedicationRecordsPage?id=' + clientChartId + '&rt=' + rtparam );
        meds.setRedirect(true);
        return meds;
    }
    
    public void showMultipleMARs(){
        
        boolean anyselected=false;
        //
        lstWrapperMARs = new list<wrapperMARs>();
        lstWrapperPRNMARs = new list<wrapperMARs>();
        system.debug(setSelectedMARs);
        for(Event e: lstMedications){
            //system.debug(setSelectedMARs.contains(e.id));
            if(e.Status__c == 'Open' && e.Hide_Button_Date_Time__c <=DateTime.now()){            
                boolean sel = (e.Signed_By__c!=null && e.Signed_By__c!='' && e.Signed_By__c!='None' && e.Signed_By__c !='All')?true:false;
                if(sel)
                    anyselected = true;
                system.debug(sel);
                system.debug(e.id);
                system.debug(e.Doctor_Image_URL__c);
                if((e.Doctor_Image_URL__c==null || e.Doctor_Image_URL__c=='') && (sel?true:false))
                    staffSignReqd = true;
                //lstWrapperMARs.add(new wrapperMARs((setSelectedMARs!=null && setSelectedMARs.contains(e.id))?true:false,e));
                lstWrapperMARs.add(new wrapperMARs(sel,e));
            }
        }
        system.debug(staffSignReqd );
        for(Event e: lstPRNMedications ){
            //system.debug(setSelectedMARs.contains(e.id));
            if(e.Status__c == 'Open' && e.Hide_Button_Date_Time__c <=DateTime.now())  {            
                boolean sel = (e.Signed_By__c!=null && e.Signed_By__c!='' && e.Signed_By__c!='None' && e.Signed_By__c !='All')?true:false;
                if(sel)
                    anyselected = true;
                system.debug(e.id);
               system.debug(e.Doctor_Image_URL__c);
                if((e.Doctor_Image_URL__c==null  || e.Doctor_Image_URL__c=='') && (sel?true:false))
                    staffSignReqd = true;
                lstWrapperPRNMARs.add(new wrapperMARs(sel,e));
            }
        }
        setAllBooleanToFalse();
        if(anyselected)
            disableCheckboxes = true;
        multiplemars = true;
    }
    
    public class wrapperMARs{
        public boolean selected{get;set;}
        public Event MARs{get;set;}
        
        public wrapperMARs(boolean s,  Event e){
            selected = s;
           
            MARs = e;
        }
    }
    /*
    public class wrapperOrders{
        public boolean selected{get;set;}
        public Order__c order{get;set;}
        public string pharmacyEmail{get;set;}
        
        public wrapperOrders(boolean s, Order__c e){
            selected = s;
            order = e;
            pharmacyEmail='';
        }
    }*/
    public class wrapperOLI{
        
        public Order_Line_Item__c OLI{get;set;}
        public integer index {get; set;}
        public boolean isEdit {get; set;}

        public wrapperOLI(boolean e, integer i, Order_line_item__c o){
            isEdit = e;
            index = i;
            OLI  = o;
        }
    }    
}