//Test Class : HCPDashboardControllerTest
public with sharing class HCPDashboardController {

    public string signatureUrl {get; set;}
    public string accessKeyId {get; set;}
    public string secretAccessKey {get; set;}
    public string OrgName {get; set;}
    public string UserId {get; set;}
    public string UserName {get; set;}

    public List<OrderWrapper> activeOrders {get; set;}
    public List<OrderWrapper> pendingOrders {get; set;}
    public List<OrderWrapper> pendingPharmacyOrders {get; set;}
    public Boolean renderActiveOrders {get; set;}

    final string AWSURL;
    public string TestValue {get; set;}

    Public Id sunshineCenterRecordTypeId {get; set;}

    // OrderDetail dialog
    public id orderIdToView {get; set;}
    public Boolean displayDialog {get; set;}

    // OrderDetail Popup
    public Boolean viewPopupBoolean {get; set;}
    public OrderView orderRec {get; set;}
    public Order__c ViewOrderRec {get; set;}
    public Taper__c taper {get; set;}

    // Discontinue Popup
    public Boolean showDiscontinuePopup {get; set;}
    public Order__c orderDiscontinueDateTime {get; set;}
    public String selectedCancelledVia {get; set;}


    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public HCPDashboardController() {

        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;

        UserId = UserInfo.getUserId();
        UserName = UserInfo.getName();
        signatureUrl = 'Hello ' + UserName;

        sunshineCenterRecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get(ApexPages.CurrentPage().getParameters().get('rt')).getRecordTypeId();

        loadActiveOrders();
        loadPendingOrders();
        loadPendingPharmacyOrders();

        orderDiscontinueDateTime = new Order__c();
        orderDiscontinueDateTime.Discontinue_Date_Time__c = DateTime.now();
    }

    public List<SelectOption> getCancelledViaList () {
        List<SelectOption> cancelledViaList = new List<SelectOption>();
        //cancelledViaList.add(new SelectOption('', '-- None --'));
        Schema.DescribeFieldResult viaField = Order__c.Via_cancelled_by__c.getDescribe();
        List<Schema.PicklistEntry> viaValues = viaField.getPicklistValues();
        for (Schema.PicklistEntry entry : viaValues) {
            cancelledViaList.add(new SelectOption(entry.getLabel(), entry.getLabel()));
        }
        return cancelledViaList;
    }

    public void loadActiveOrders() {
        activeOrders = new List<OrderWrapper>();
        for (Order__c order : [Select ID, Name, Order_Type__c, Medicine__r.Name, Taper__r.Name, Status__c, Discontinue_Date_Time__c,
                               Via_cancelled_by__c, Order_By__c, Requested_via__c, Start_Date__c, Client_Chart__r.Name
                               from Order__c where Order_By__c = :UserId AND Status__c = : 'Active' AND Client_Chart__r.RecordTypeId = : sunshineCenterRecordTypeId]) {
            activeOrders.add(new OrderWrapper(order));
        }
        renderActiveOrders = true;
    }

    public void loadPendingOrders() {
        pendingOrders = new List<OrderWrapper>();
        for (Order__c order : [Select ID, Name, Order_Type__c, Signed_By__c, Doctor_Signed_Date__c, Doctor_Signed_User__c,
                               Medicine__r.Name, Taper__r.Name, Start_Date__c, Requested_via__c, Pharmacy_Status__c, Status__c,
                               Order_By__c, Doctor_Image_URL__c, Client_Chart__r.Name, Medical_Reconciliation__c  from Order__c
                               where Order_By__c = :UserId AND Status__c = : 'Under Review' AND Client_Chart__r.RecordTypeId = : sunshineCenterRecordTypeId]) {
            pendingOrders.add(new OrderWrapper(order));
        }
    }

    public void loadPendingPharmacyOrders() {
        pendingPharmacyOrders = new List<OrderWrapper>();
        for (Order__c order : [Select ID, Name, Order_Type__c, Signed_By__c, Doctor_Signed_Date__c, Doctor_Signed_User__c,
                               Medicine__r.Name, Taper__r.Name, Start_Date__c, Requested_via__c, Pharmacy_Status__c, Status__c,
                               Order_By__c, Doctor_Image_URL__c, Client_Chart__r.Name from Order__c
                               where Order_By__c = :UserId AND Status__c = : 'Pending Pharmacy' AND Client_Chart__r.RecordTypeId = : sunshineCenterRecordTypeId]) {
            pendingPharmacyOrders.add(new OrderWrapper(order));
        }
    }

    public void signWithSignature() {
        try {
            List<Order__c> checkedOrders = new List<Order__c>();
            for (OrderWrapper o : pendingOrders) {
                if (!o.check) continue;
                o.order.Doctor_Image_URL__c = AWSURL + signatureUrl;
                o.order.Signed_By__c = 'All';
                o.order.Doctor_Signed_Date__c = DateTime.now();
                o.order.Doctor_Signed_User__c = UserName;

                if (o.order.Order_Type__c != 'Action') {
                    if(o.order.Medical_Reconciliation__c != 'Brought In On Admit - Discontinue'){
                        if (o.order.Pharmacy_Status__c == 'Order Received')
                            o.order.Status__c = 'Active';
                        else
                            o.order.Status__c = 'Pending Pharmacy';
                    }
                    else{
                        o.order.Status__c = 'Inactive';
                        o.order.Discontinue_Date_Time__c = Datetime.now();
                    }
                } else {
                    o.order.Status__c = 'Active';
                }
                checkedOrders.add(o.order);
            }
            if (checkedOrders.size() > 0) {
                update checkedOrders;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Orders updated'));
                loadPendingOrders();
                loadActiveOrders();
                loadPendingPharmacyOrders();
            }
        } catch (DmlException e) {
            List<String> params = new String[] {e.getLineNumber() + '', e.getMessage()};
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,
                                 String.format('Error signing off orders {0}:{1}', params)));
        }
    }

    public void showDiscontinueDetailsPickerPopup() {
        showDiscontinuePopup = true;
        TestValue = showDiscontinuePopup + '';
    }

    public void discontinueOrders() {
        String signatureUrl = ApexPages.currentPage().getParameters().get('signatureUrl');
        showDiscontinuePopup = false;
        TestValue = showDiscontinuePopup + '';
        system.debug('selectedCancelledVia:' + selectedCancelledVia);
        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'SelectedVia:' + selectedCancelledVia));

        // TODO:
        // Step 1: change Status of orders to Inactive
        // Step 2: order continuation by deleting MARS, ask Huma
        List<Order__c> ordersToDiscontinue = new List<Order__c>();
        Map<id, DateTime> discontinuedOrdersMap = new Map<id, DateTime>();
        for (OrderWrapper wrapper : activeOrders) {
            if (!wrapper.check) continue;

            wrapper.order.Status__c = 'Inactive';
            wrapper.order.Order_Cancelled_By__c  = UserId;
            wrapper.order.Discontinue_Date_Time__c = orderDiscontinueDateTime.Discontinue_Date_Time__c;
            wrapper.order.Via_cancelled_by__c = 'email';
            wrapper.order.Doctor_Image_URL__c = AWSURL + signatureUrl;
            wrapper.order.Signed_By__c = 'All';
            wrapper.order.Doctor_Signed_Date__c = DateTime.now();
            wrapper.order.Doctor_Signed_User__c = UserName;

            ordersToDiscontinue.add(wrapper.order);
            discontinuedOrdersMap.put(wrapper.order.id, wrapper.order.Discontinue_Date_Time__c);
        }

        if (ordersToDiscontinue.size() == 0) return;

        update ordersToDiscontinue;

        List<Event> eventsToInactivate = new List<Event>();
        List<Event> events = [select id, Status__c, WhatId, StartDateTime from Event where WhatId in: discontinuedOrdersMap.keyset() and Status__c = 'Open'];
        for (Event event : events) {
            if (event.StartDateTime >= discontinuedOrdersMap.get(event.WhatId)) {
                event.Status__c = 'Inactive';
                eventsToInactivate.add(event);
            }
        }

        if (eventsToInactivate.size() > 0)
            update eventsToInactivate;

        loadActiveOrders();
    }

    public PageReference ShowOrderDetails() {
        //system.debug(system.CurrentPageReference().getParameters().get('orderId'));
        displayDialog = true;
        return null;
    }

    public PageReference ViewOrder() {

        system.debug(system.CurrentPageReference().getParameters().get('orderId'));
        //OrderId = system.CurrentPageReference().getParameters().get('orderId');

        ViewOrderRec = new Order__c();

        ViewOrderRec = [select id, Status__c, Action__c , Medical_Reconciliation__c, Order_Type__c, Signed_By__c, Order_By__c, Doctor_Image_URL__c, Doctor_Signed_User__c,
                        Doctor_Signed_Date__c, Taper__c, Taper__r.Protocol__c, Taper__r.Name, Taper__r.Number_of_Days__c, Start_Date__c, CreatedById, Medicine__c, Medicine__r.Name,
                        Route__c, Frequency__c, Dose__c, Dosage_Form__c, Pharmacy_Status__c, Duration__c , Dispense_Amount__c, Number_of_Refills__c
                        from Order__c where id = : system.CurrentPageReference().getParameters().get('orderId')];

        if (ViewOrderRec.Taper__c != null) {
            taper = [select id, Name, (select id, Frequency__c, Medicine__c, Duration_In_Days__c, Route__c, Dosage_Form__c, Strength__c, Medicine__r.Name
                                       from Taper_line_items__r) from Taper__c where id = : ViewOrderRec.Taper__c];
            system.debug(taper.Taper_line_items__r.size());

            list<OrderView.wrapperTLI > lst = new list<OrderView.wrapperTLI >();
            OrderView.wrapperTLI wrapObj ;
            for (Taper_Line_Item__c TLI : taper.Taper_line_Items__r) {
                string freq = TLI.Frequency__c;
                list<string> lstf = freq.split(':');
                string timeStr = lstf[lstf.size() - 1];//.replaceAll(' ', '');
                list<string> lstTime = timeStr.split(',');
                wrapObj = new OrderView.wrapperTLI(TLI.Medicine__r.Name, TLI.Route__c, TLI.Dosage_Form__c, TLI.Strength__c, TLI.Frequency__c, lstTime ,TLI.Duration_In_Days__c);
                lst.add(wrapObj );
            }

            orderRec = new OrderView(ViewOrderRec, taper, lst);
        } else {
            taper = new Taper__c();
            string freq = ViewOrderRec.Frequency__c;
            list<string> lstTime;
            if (freq != null) {
                list<string> lstf = freq.split(':');
                string timeStr = lstf[lstf.size() - 1];//.replaceAll(' ', '');
                lstTime = timeStr.split(',');
            } else {
                lstTime = new List<string>();
            }

            OrderView.wrapperTLI wrapObj = new OrderView.wrapperTLI(ViewOrderRec.Medicine__r.Name,
                    ViewOrderRec.Route__c, ViewOrderRec.Dosage_Form__c, ViewOrderRec.Dose__c, ViewOrderRec.Frequency__c,
                    lstTime ,0);
            list<OrderView.wrapperTLI > lst = new list<OrderView.wrapperTLI >();
            lst.add(wrapObj );
            orderRec = new OrderView(ViewOrderRec, taper, lst);
        }

        viewPopupBoolean = true;
        return null;
    }

    Public PageReference togglePopups() {
        PageReference pr = Page.HCPDashboard;
        pr.getParameters().put('rt', ApexPages.CurrentPage().getParameters().get('rt'));
        pr.setRedirect(true);
        return pr;
    }

    class OrderWrapper {
        public Boolean check {get; set;}
        public string orderTitle {get; set;}
        public Order__c order {get; set;}

        public OrderWrapper(Order__c order) {
            this.order = order;
            if (order.Order_Type__c == 'Manual') {
                orderTitle = order.Order_Type__c + ' ' + order.Medicine__r.Name;
            } else {
                orderTitle = order.Order_Type__c + ' ' + order.Taper__r.Name;
            }

        }
    }
}