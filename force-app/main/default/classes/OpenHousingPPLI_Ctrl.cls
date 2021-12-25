public without sharing class OpenHousingPPLI_Ctrl {
    
    public OpenHousingPPLI_Ctrl() {}

    public static map<string, string> mapOfOpp;
    @AuraEnabled
    public static string SunshineCenter {get; set;} 

    @AuraEnabled
    public static string getAllPPLIs(Integer pageSize, Integer pageNumber, string empId)
    {
        string JSONResult = '';
        Integer offset = (pageNumber - 1) * pageSize;
        Employee__c emp = [select id, Sunshine_Center_Relation_To__c, 
                                Sunshine_Center_Relation_To__r.Name
                                 from Employee__c where id =: empId];
        String AccountID = emp.Sunshine_Center_Relation_To__c;
        SunshineCenter = emp.Sunshine_Center_Relation_To__r.Name;

        if(SunshineCenter != null && !String.isBlank(SunshineCenter))
        {
            map<string, list<Payment_Plan_Line_items__c>> mapOfPPLI = returnAllPPs(SunshineCenter);
            list<paymentPlanWrapper> listPPs = new list<paymentPlanWrapper>();
            for(string OppId : mapOfPPLI.keyset())
            {
                paymentPlanWrapper ppwrap = new paymentPlanWrapper();
                ppwrap.ClientId = OppId;
                ppwrap.ClientName = mapOfOpp.containsKey(OppId) ? mapOfOpp.get(OppId) : '';
                list<PPLIWrapper> listPPli = new list<PPLIWrapper>();
                decimal totalAm = 0.0;
                for(Payment_Plan_Line_Items__c ppli : mapOfPPLI.get(OppId))
                {
                    PPLIWrapper ppliWrap = new PPLIWrapper();
                    ppliWrap.Amount = ppli.Amount_For_Collection__c;
                    ppliWrap.DueDate = ppli.Due_Date__c;
                    ppliWrap.id = ppli.id;
                    ppliWrap.Name = ppli.Name;
                    totalAm += ppli.Amount_For_Collection__c;
                    listPPli.add(ppliWrap);
                }
                ppwrap.Pay = 'Pay';
                ppwrap.TotalDue = totalAm;
                ppwrap.ListOfPPLis = listPPli;
                listPPs.add(ppwrap);

            }
                
            JSONResult = JSON.serializePretty(listPPs) ;
        }
        system.debug('##AllJSONResult=='+JSONResult);
        return JSONResult;
    }

    @AuraEnabled
    public static string getPPLIsByFilter(Integer pageSize, Integer pageNumber, string empId)
    {
        string JSONResult = '';
        Integer offset = (pageNumber - 1) * pageSize;
        Employee__c emp = [select id, Sunshine_Center_Relation_To__c, 
                                Sunshine_Center_Relation_To__r.Name
                                 from Employee__c where id =: empId];
        String AccountID = emp.Sunshine_Center_Relation_To__c;
        SunshineCenter = emp.Sunshine_Center_Relation_To__r.Name;

        if(SunshineCenter != null && !String.isBlank(SunshineCenter))
        {
            map<string, list<Payment_Plan_Line_items__c>> mapOfPPLI = returnFilteredPPs(pageSize,pageNumber,SunshineCenter);
            list<paymentPlanWrapper> listPPs = new list<paymentPlanWrapper>();
            for(string OppId : mapOfPPLI.keyset())
            {
                paymentPlanWrapper ppwrap = new paymentPlanWrapper();
                ppwrap.ClientId = OppId;
                ppwrap.ClientName = mapOfOpp.containsKey(OppId) ? mapOfOpp.get(OppId) : '';
                list<PPLIWrapper> listPPli = new list<PPLIWrapper>();
                for(Payment_Plan_Line_Items__c ppli : mapOfPPLI.get(OppId))
                {
                    PPLIWrapper ppliWrap = new PPLIWrapper();
                    ppliWrap.Amount = ppli.Amount_For_Collection__c;
                    ppliWrap.DueDate = ppli.Due_Date__c;
                    ppliWrap.id = ppli.id;
                    ppliWrap.Name = ppli.Name;
                    listPPli.add(ppliWrap);
                }

                ppwrap.ListOfPPLis = listPPli;
                listPPs.add(ppwrap);

            }
                
            JSONResult = JSON.serializePretty(listPPs) ;
        }
        system.debug('##FilJSONResult=='+JSONResult);
        return JSONResult;
    }

    public static map<string, list<Payment_Plan_Line_items__c>> returnAllPPs(string SCName)
    {
        map<string, list<Payment_Plan_Line_items__c>> MapOfClientsPPLIs = new map<string, list<Payment_Plan_Line_items__c>>();
        mapOfOpp = new map<string, string>();
        for(Payment_Plan_Line_items__c ppli : [Select id, Name, Payment_Plan__r.Opportunity__r.Name,
                                                    Payment_Plan__r.Opportunity__c, 
                                                    Due_Date__c, Amount_For_Collection__c from 
                                                    Payment_Plan_Line_items__c where 
                                                    Type_of_Collection__c =: 'Housing' 
                                                    AND Due_Date__c <= TODAY AND 
                                                    (Status__c = 'Open' OR Status__c = 'Card Declined') 
                                                    AND Sunshine_Center__c =: SCName])
        {
            
            list<Payment_Plan_Line_items__c> listPPLI = new list<Payment_Plan_Line_items__c>();
            if(MapOfClientsPPLIs.containsKey(ppli.Payment_Plan__r.Opportunity__c))
            {
                listPPLI = MapOfClientsPPLIs.get(ppli.Payment_Plan__r.Opportunity__c);
            }
            listPPLI.add(ppli);
            MapOfClientsPPLIs.put(ppli.Payment_Plan__r.Opportunity__c, listPPLI);
            
            if(!mapOfOpp.containsKey(ppli.Payment_Plan__r.Opportunity__c))
            {
                mapOfOpp.put(ppli.Payment_Plan__r.Opportunity__c, ppli.Payment_Plan__r.Opportunity__r.name);
            }
        }
        
        return MapOfClientsPPLIs;

    }

    public static map<string, list<Payment_Plan_Line_items__c>> returnFilteredPPs(Integer pageSize, Integer pageNumber, string SCName)
    {
        Integer offset = (pageNumber - 1) * pageSize;
        map<string, list<Payment_Plan_Line_items__c>> MapOfClientsPPLIs = new map<string, list<Payment_Plan_Line_items__c>>();
        for(Payment_Plan_Line_items__c ppli : [Select id,Name ,Payment_Plan__r.Opportunity__r.Name, 
                                                    Due_Date__c, Amount_For_Collection__c from 
                                                    Payment_Plan_Line_items__c where 
                                                    Type_of_Collection__c =: 'Housing' 
                                                    AND Due_Date__c <= TODAY AND 
                                                    (Status__c = 'Open' OR Status__c = 'Card Declined') 
                                                    AND Sunshine_Center__c =: SCName 
                                                    limit : pageSize Offset : offset])
        {
            
            list<Payment_Plan_Line_items__c> listPPLI = new list<Payment_Plan_Line_items__c>();
            if(MapOfClientsPPLIs.containsKey(ppli.Payment_Plan__r.Opportunity__r.Name))
            {
                listPPLI = MapOfClientsPPLIs.get(ppli.Payment_Plan__r.Opportunity__r.Name);
            }
            listPPLI.add(ppli);
            MapOfClientsPPLIs.put(ppli.Payment_Plan__r.Opportunity__r.Name, listPPLI);

        }
        
        return MapOfClientsPPLIs;

    }

    public class paymentPlanWrapper
    {
        @AuraEnabled
        public String ClientName {get; set;}
        @AuraEnabled
        public String ClientId {get; set;}
        @AuraEnabled
        public String PPName {get; set;}
        @AuraEnabled
        public String PPType {get; set;}
        @AuraEnabled
        public decimal TotalDue {get; set;}
        @AuraEnabled
        public string Pay {get; set;}
        @AuraEnabled
        public List<PPLIWrapper> ListOfPPLis {get; set;}

        public paymentPlanWrapper()
        {}

        public paymentPlanWrapper(String ClientName, String PPName, String PPType, List<PPLIWrapper> ListOfPPLis)
        {
            this.ClientName = ClientName;
            this.PPName = PPName;
            this.PPType = PPType;
            this.ListOfPPLis = ListOfPPLis;
        }
    }


    public class PPLIWrapper
    {
        @AuraEnabled
        public Decimal Amount {get; set;}
        @AuraEnabled
        public String id {get; set;}
        @AuraEnabled
        public Date DueDate {get; set;}
        @AuraEnabled
        public String Name {get; set;}

    }

}