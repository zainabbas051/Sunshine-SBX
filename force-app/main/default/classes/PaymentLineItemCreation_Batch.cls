global class PaymentLineItemCreation_Batch implements Database.Batchable < sObject > , Database.Stateful {
    public decimal DueAmount;
    Set < String > smsSunshineCentre = new Set < String > ();
    Set < String > emailSunshineCentre = new Set < String > ();
    string owea;

    global PaymentLineItemCreation_Batch(string owea) {
        this.owea = owea;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {

        string ADMMITTED_STAGE = 'Admitted';
        string HOUSING_COLLECTION = 'Housing';
        List < string > statusLst = new List < String > {
            'Open',
            'Closed'
        };

        fetchSunshineFromCustomSetting(smsSunshineCentre, emailSunshineCentre);

        return Database.getQueryLocator([SELECT Id,Opportunity__r.Name, Opportunity__r.Phone__c,Client_Name__c,
            Opportunity__r.Sunshine_Center_Name__c,
            Total_Rental_Amount_Due__c, Opportunity__c, Opportunity__r.Email__c,
            (SELECT Id, Amount_For_Collection__c, Payment_Plan__c, Type_of_Collection__c, Status__c FROM Payment_Plan_Line_Items__r WHERE Type_of_Collection__c =: HOUSING_COLLECTION AND Status__c IN: statusLst)
            FROM KIPU_Chart_Audit__c
            WHERE Opportunity__r.StageName =: ADMMITTED_STAGE AND Total_Rental_Amount_Due__c > 0
        ]);
    }

    global void execute(Database.BatchableContext bc, List < KIPU_Chart_Audit__c > records) {

        List < Payment_Plan_Line_Items__c > lstPaymentPlan = new List < Payment_Plan_Line_Items__c > ();
        List < String > emailReceipients = new List < String > ();
        List < smagicinteract__smsMagic__c > smsReceipents = new List < smagicinteract__smsMagic__c > ();
        Map<Id,Id> mapOfOppty = getPaymentPlan(records);

        for (KIPU_Chart_Audit__c record: records) {
            Payment_Plan_Line_Items__c ppli = createPPLIRecord(record,mapOfOppty);
            if(ppli == null){
                continue;
            }
            lstPaymentPlan.add(ppli);
        }  
        update records;
        insert lstPaymentPlan;
            
        for(KIPU_Chart_Audit__c  record: records){
            if (emailSunshineCentre.contains(record.Opportunity__r.Sunshine_Center_Name__c)) {
                //emailReceipients.add(record.Opportunity__r.Email__c);
                HousingPaymentNotificationsUtil.sendEmail(record, owea);
            }
            
            if (smsSunshineCentre.contains(record.Opportunity__r.Sunshine_Center_Name__c)) {
                smsReceipents.add(HousingPaymentNotificationsUtil.sendSMS(record));
            }
        }
        
         if (!Test.isRunningTest()) {
            insert smsReceipents;
        }           
    }

    private Payment_Plan_Line_Items__c createPPLIRecord(KIPU_Chart_Audit__c kipuAudit,
                                                Map<Id,Id> mapOfOppty){

        decimal totalAmountCollected = 0;
        decimal totalAmountPending = 0;
        decimal totalRemainingDues = 0;
        Id paymentPlan;

        if(mapOfOppty != null &&
            kipuAudit.Payment_Plan_Line_Items__r.size() == 0 &&
            kipuAudit.Total_Rental_Amount_Due__c >= 50){

                totalRemainingDues = kipuAudit.Total_Rental_Amount_Due__c;
                kipuAudit.Total_Rental_Amount_Pending__c = totalRemainingDues;
                paymentPlan = mapOfOppty?.get(kipuAudit.Opportunity__c);
                if(paymentPlan == null){
                    //dont need to create any PPLI record
                    return null;
                }    
                return new Payment_Plan_Line_Items__c(KIPU_Chart_Audit__c = kipuAudit.Id,
                    Payment_Plan__c = paymentPlan,
                    Amount_For_Collection__c = totalRemainingDues,
                    Status__c = 'Open',
                    Type_of_Collection__c = 'Housing', Due_Date__c = Date.today(), 
                    Collector_Notes__c = 'Created Automatically by Housing Rental Calculation' , Assigned_To__c = label.Nick_User_Id);   
        }

        for (Payment_Plan_Line_Items__c iPpl: kipuAudit.Payment_Plan_Line_Items__r) {

            decimal amountForCollection = (iPpl.Amount_For_Collection__c == null) ? 0  : iPpl.Amount_For_Collection__c;
            paymentPlan = iPpl.Payment_Plan__c;
            if (iPpl.Status__c.equals('Closed')) {
                totalAmountCollected += amountForCollection;
                continue;
            }
            //for Open status
            totalAmountPending += amountForCollection;
        }
        //totalAmountPending ==> All Open PPLI
        //totalAmountCollected ==> All Closed PPLI
        //totalRemainingDues subtracts closed pplis' amount from the kipu due amount and assign it to kipu pending amount
       
        totalRemainingDues =  kipuAudit.Total_Rental_Amount_Due__c - totalAmountCollected;
        
        Integer reminder = math.mod(Integer.valueOf(totalRemainingDues), 50);
        totalRemainingDues = totalRemainingDues - reminder;
        
        kipuAudit.Total_Rental_Amount_Pending__c = (totalRemainingDues < 0) ? 0 : totalRemainingDues;
        kipuAudit.Total_Rental_Amount_Collected__c = totalAmountCollected;
        
        //below code checks if pending amount calculated in above code alreading has a part in Open PPLI's
        //above calculated pending amount variable is totalRemainingDues and Open PPLIs amount variable is totalAmountPending
       
        totalRemainingDues = totalRemainingDues - totalAmountPending;
        
        if (totalRemainingDues < 50) {
             //dont need to create any PPLI record
            return null;
        }
        
       
        
        return new Payment_Plan_Line_Items__c(KIPU_Chart_Audit__c = kipuAudit.Id,
            Payment_Plan__c = paymentPlan,
            Amount_For_Collection__c = totalRemainingDues,
            Status__c = 'Open',
            Type_of_Collection__c = 'Housing', Due_Date__c = Date.today(), 
                    Collector_Notes__c = 'Created Automatically by Housing Rental Calculation' , Assigned_To__c = label.Nick_User_Id);   
    }

    /*
    @param KIPU_Chart_Audit__c collection
    @descripton get all payment plan for each opportunity through Kipu Chart Audit
    */
    Map<Id,Id> getPaymentPlan(List<KIPU_Chart_Audit__c> kipuChartAudits){
        
        Set<Id> opptyId = new Set<Id>();
        Map<Id,Id> mapOfOppty;

        for(KIPU_Chart_Audit__c kipuAudit : kipuChartAudits){
            if(kipuAudit.Payment_Plan_Line_Items__r.size() == 0){
                opptyId.add(kipuAudit.Opportunity__c);
            }    
        }
        if(opptyId.isEmpty()){
            return mapOfOppty;
        }
        mapOfOppty = new Map<Id,Id>();
        for(Opportunity oppty : OpportunitySelector.getOpportunitiesWithPaymentPlan(opptyId)){
            Id paymentPlanId = (oppty.Payment_Plan__r.size() > 0) ? oppty.Payment_Plan__r[0].Id : null;
            if(paymentPlanId == null){
                continue;
            }
            mapOfOppty.put(oppty.Id,paymentPlanId);
        }
        return mapOfOppty;
    }

    void fetchSunshineFromCustomSetting(Set < string > smsSunshineCentre, Set < string > emailSunshineCentre) {

        List < Sunshine_Center_Id__c > sunshineCentres = Sunshine_Center_Id__c.getall().values();
        for (Sunshine_Center_Id__c sunShineCentre: sunshineCentres) {
            if (sunShineCentre.SendPaymentNotificationEmail__c) {
                emailSunshineCentre.add(sunShineCentre.Name);
            }
            if (sunShineCentre.SendPaymentNotificationSMS__c) {
                smsSunshineCentre.add(sunShineCentre.Name);
            }
        }
    }

    global void finish(Database.BatchableContext bc) {
    }
}