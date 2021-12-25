//Test Class : Utilities_AnalyticsTest
public without sharing class Utilities_AnalyticsPage {
    
    private final Account accRecord; 
    public Utilities_AnalyticsPage(ApexPages.StandardController stdController) {
        this.accRecord= (Account)stdController.getRecord();
        loadData();//This method will populate the Apex Properties defined above with the respective data
    
   }
    
    private Static transient double tier30Numerator=0.0;
    private Static transient double tier30Denominator=0.0;
    private Static transient double tier60Numerator=0.0;
    private Static transient double tier60Denominator=0.0;
    private Static transient double tier90Numerator=0.0;
    private Static transient double tier90Denominator=0.0;
    private Static transient double tier120Numerator=0.0;
    private Static transient double tier120Denominator=0.0;
    private Static transient double tier150Numerator=0.0;
    private Static transient double tier150Denominator=0.0;
    private Static transient double tier180Numerator=0.0;
    private Static transient double tier180Denominator=0.0;
    private Static transient double tier210Numerator=0.0;
    private Static transient double tier210Denominator=0.0;
    private Static transient double tier240Numerator=0.0;
    private Static transient double tier240Denominator=0.0;
    private Static transient double tier270Numerator=0.0;
    private Static transient double tier270Denominator=0.0;
    private Static transient double tier300Numerator=0.0;
    private Static transient double tier300Denominator=0.0;
    private Static transient double tier330Numerator=0.0;
    private Static transient double tier330Denominator=0.0;
    private Static transient double tier360Numerator=0.0;
    private Static transient double tier360Denominator=0.0;
    
    Public static Decimal Tier1TotalCollected{
        get{
            if(tier30Numerator == null)
                tier30Numerator = 0.0;
            return tier30Numerator;
        }set;    
    }
    
    Public static Decimal Tier1TotalBilled{
        get{
            if(tier30Denominator == null)
                tier30Denominator = 0.0;
            return tier30Denominator;
        }set;    
    }
    
    Public static Decimal Tier2TotalCollected{
        get{
            if(tier60Numerator == null)
                tier60Numerator = 0.0;
            return tier60Numerator;
        }set;    
    }
    
    Public static Decimal Tier2TotalBilled{
        get{
            if(tier60Denominator == null)
                tier60Denominator = 0.0;
            return tier60Denominator;
        }set;    
    }
    
    Public static Decimal Tier3TotalCollected{
        get{
            if(tier90Numerator == null)
                tier90Numerator = 0.0;
            return tier90Numerator;
        }set;    
    }
    
    
    Public static Decimal Tier3TotalBilled{
        get{
            if(tier90Denominator == null)
                tier90Denominator = 0.0;
            return tier90Denominator;
        }set;    
    }
    
    Public static Decimal Tier4TotalCollected{
        get{
            if(tier120Numerator == null)
                tier120Numerator = 0.0;
            return tier120Numerator;
        }set;    
    }
    
    Public static Decimal Tier4TotalBilled{
        get{
            if(tier120Denominator == null)
                tier120Denominator = 0.0;
            return tier120Denominator;
        }set;    
    }
    
    Public static Decimal Tier5TotalCollected{
        get{
            if(tier150Numerator == null)
                tier150Numerator = 0.0;
            return tier150Numerator;
        }set;    
    }
    
    Public static Decimal Tier5TotalBilled{
        get{
            if(tier150Denominator == null)
                tier150Denominator = 0.0;
            return tier150Denominator;
        }set;    
    }
    
    Public static Decimal Tier6TotalCollected{
        get{
            if(tier180Numerator == null)
                tier180Numerator = 0.0;
            return tier180Numerator;
        }set;    
    }
    
    Public static Decimal Tier6TotalBilled{
        get{
            if(tier180Denominator == null)
                tier180Denominator = 0.0;
            return tier180Denominator;
        }set;    
    }
    
    Public static Decimal Tier7TotalCollected{
        get{
            if(tier210Numerator == null)
                tier210Numerator = 0.0;
            return tier210Numerator;
        }set;    
    }
    
    Public static Decimal Tier7TotalBilled{
        get{
            if(tier210Denominator == null)
                tier210Denominator = 0.0;
            return tier210Denominator;
        }set;    
    }
    
    Public static Decimal Tier8TotalCollected{
        get{
            if(tier240Numerator == null)
                tier240Numerator = 0.0;
            return tier240Numerator;
        }set;    
    }
    
    Public static Decimal Tier8TotalBilled{
        get{
            if(tier240Denominator == null)
                tier240Denominator = 0.0;
            return tier240Denominator;
        }set;    
    }
    
    Public static Decimal Tier9TotalCollected{
        get{
            if(tier270Numerator == null)
                tier270Numerator = 0.0;
            return tier270Numerator;
        }set;    
    }
    
    Public static Decimal Tier9TotalBilled{
        get{
            if(tier270Denominator == null)
                tier270Denominator = 0.0;
            return tier270Denominator;
        }set;    
    }
    
    Public static Decimal Tier10TotalCollected{
        get{
            if(tier300Numerator == null)
                tier300Numerator = 0.0;
            return tier300Numerator;
        }set;    
    }
    
    Public static Decimal Tier10TotalBilled{
        get{
            if(tier300Denominator == null)
                tier300Denominator = 0.0;
            return tier300Denominator;
        }set;    
    }
    
    Public static Decimal Tier11TotalCollected{
        get{
            if(tier330Numerator == null)
                tier330Numerator = 0.0;
            return tier330Numerator;
        }set;    
    }
    
    Public static Decimal Tier11TotalBilled{
        get{
            if(tier330Denominator == null)
                tier330Denominator = 0.0;
            return tier330Denominator;
        }set;    
    }
    
    Public static Decimal Tier12TotalCollected{
        get{
            if(tier360Numerator == null)
                tier360Numerator = 0.0;
            return tier360Numerator;
        }set;    
    }
    
    Public static Decimal Tier12TotalBilled{
        get{
            if(tier360Denominator == null)
                tier360Denominator = 0.0;
            return tier360Denominator;
        }set;    
    }
    
    Public static List<analyticsWrapperData> Tier1List{
        get{
            if(Tier1List == null)
                Tier1List = new List<analyticsWrapperData>();
            return Tier1List;
        }set;    
    }
    
    Public static List<analyticsWrapperData> Tier2List{
        get{
            if(Tier2List == null)
                Tier2List = new List<analyticsWrapperData>();
            return Tier2List;
        }set;    
    }
    
    Public static List<analyticsWrapperData> Tier3List{
        get{
            if(Tier3List == null)
                Tier3List = new List<analyticsWrapperData>();
            return Tier3List;
        }set;    
    }
    
    Public static List<analyticsWrapperData> Tier4List{
        get{
            if(Tier4List == null)
                Tier4List = new List<analyticsWrapperData>();
            return Tier4List;
        }set;    
    }
    
    Public static List<analyticsWrapperData> Tier5List{
        get{
            if(Tier5List == null)
                Tier5List = new List<analyticsWrapperData>();
            return Tier5List;
        }set;    
    }
    
    Public static List<analyticsWrapperData> Tier6List{
        get{
            if(Tier6List == null)
                Tier6List = new List<analyticsWrapperData>();
            return Tier6List;
        }set;    
    }
    
    Public static List<analyticsWrapperData> Tier7List{
        get{
            if(Tier7List == null)
                Tier7List = new List<analyticsWrapperData>();
            return Tier7List;
        }set;    
    }
    
    Public static List<analyticsWrapperData> Tier8List{
        get{
            if(Tier8List == null)
                Tier8List = new List<analyticsWrapperData>();
            return Tier8List;
        }set;    
    }
    
    Public static List<analyticsWrapperData> Tier9List{
        get{
            if(Tier9List == null)
                Tier9List = new List<analyticsWrapperData>();
            return Tier9List;
        }set;    
    }
    
    Public static List<analyticsWrapperData> Tier10List{
        get{
            if(Tier10List == null)
                Tier10List = new List<analyticsWrapperData>();
            return Tier10List;
        }set;    
    }
    
    Public static List<analyticsWrapperData> Tier11List{
        get{
            if(Tier11List == null)
                Tier11List = new List<analyticsWrapperData>();
            return Tier11List;
        }set;    
    }
    
    Public static List<analyticsWrapperData> Tier12List{
        get{
            if(Tier12List == null)
                Tier12List = new List<analyticsWrapperData>();
            return Tier12List;
        }set;    
    }
    
    Public static List<analyticsWrapperData> Tier13List{
        get{
            if(Tier13List == null)
                Tier13List = new List<analyticsWrapperData>();
            return Tier13List;
        }set;    
    }
    
    public void loadData(){
        
        List<Id> accIdList = new List<Id>();
        Set<Id> accIdSet = new Set<Id>();
        List<Id> oppListId = new List<Id>();
        List<Id> caseIdList = new List<Id>();
        Map<Id,List<Collection_Line_Item__c>> caseCLIMap = new Map<Id,List<Collection_Line_Item__c>>();
        Map<Id,List<Case>> accountIdCaseListMap = new Map<Id,List<Case>>();
        List<Account> accUpdateList = new List<Account>();
        
        for(Account acc : [select id from Account where id=: accRecord.id]){
            accIdList.add(acc.id);
        }
        
        for(Opportunity opp : [Select id from Opportunity where Insurance_Provider__c IN: accIdList]){
            oppListId.add(opp.id);
        }
        
        if(oppListId.size()>0){
            for(Case c : [Select id, CaseNumber, ClosedDate, Collection_Date__c, Bill_Date__c, Billed_Amount__c, Opportunity__c, Opportunity__r.Insurance_Provider__c from Case where Opportunity__c IN: oppListId AND isClosed =: True]){
                if(accountIdCaseListMap.containsKey(c.Opportunity__r.Insurance_Provider__c)){
                    List<Case> tempList = new List<Case>();
                    tempList = accountIdCaseListMap.get(c.Opportunity__r.Insurance_Provider__c);
                    tempList.add(c);
                    accountIdCaseListMap.put(c.Opportunity__r.Insurance_Provider__c,tempList);
                }else{
                    List<Case> tempList = new List<Case>();
                    tempList.add(c);
                    accountIdCaseListMap.put(c.Opportunity__r.Insurance_Provider__c,tempList);
                }
                caseIdList.add(c.id);
            } 
            if(caseIdList.size()>0){
                for(Collection_Line_Item__c cli : [Select id, Case__c, Collection_Amount__c, Type_of_Collection__c, Collection_Date__c from Collection_Line_Item__c 
                                                   where Case__c IN: caseIdList AND (Type_of_Collection__c =: 'Original bill' OR Type_of_Collection__c =: 'Re-bill' OR Type_of_Collection__c =: 'Forwarded Recoupment' OR Type_of_Collection__c =: 'Appeal for adjustment')]){
                    if(caseCLIMap.containsKey(cli.Case__c)){
                        List<Collection_Line_Item__c> tempList = new List<Collection_Line_Item__c>();
                        tempList = caseCLIMap.get(cli.Case__c);
                        tempList.add(cli);
                        caseCLIMap.put(cli.Case__c,tempList);
                    }else{
                        List<Collection_Line_Item__c> tempList = new List<Collection_Line_Item__c>();
                        tempList.add(cli);
                        caseCLIMap.put(cli.Case__c,tempList);
                    }
                }
                for(id accId : accountIdCaseListMap.keySet()){
                    
                    
                    for(Case c : accountIdCaseListMap.get(accId)){
                        if(caseCLIMap.containsKey(c.id)){//Checking to see if CLI Exists for a Case, which means that Collection Actually took place for it.
                            for(Collection_Line_Item__c cli : caseCLIMap.get(c.id)){
                                 If((c.ClosedDate != null || cli.Collection_Date__c != null) && c.Billed_Amount__c != Null && c.Billed_Amount__c != 0 && cli.Collection_Amount__c != Null && cli.Collection_Amount__c != 0){
                                    //double percentageOfCollected = (cli.Collection_Amount__c / c.Billed_Amount__c)*100;
                                    
                                    integer collectionTier = 0;
                                    if(cli.Collection_Date__c != null)//Checking to see if the collection date is available
                                        collectionTier = c.Bill_Date__c.daysBetween(cli.Collection_Date__c);
                                    else//If no collection Date is present, then we will be using the case closed date
                                        collectionTier = c.Bill_Date__c.daysBetween(date.ValueOf(c.ClosedDate));
                                        
                                    if(collectionTier >=0 && collectionTier <= 30){
                                        tier30Numerator = tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator = tier30Denominator + c.Billed_Amount__c;
                                        
                                        Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        //tier30 = tier30+percentageOfCollected;
                                        //tier30Timer++;
                                        system.debug('Tier 30 Numerator :::'+tier30Numerator);
                                        system.debug('Tier 30 Denominator :::'+tier30Denominator);
                                    }
                                    else if(collectionTier >30 && collectionTier <= 60){
                                        tier30Numerator = tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator = tier30Denominator + c.Billed_Amount__c;
                                        Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                    }
                                    else if(collectionTier >60 && collectionTier <= 90){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                    }
                                    else if(collectionTier >90 && collectionTier <= 120){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                    }
                                    else if(collectionTier >120 && collectionTier <= 150){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier150Numerator = tier150Numerator + cli.Collection_Amount__c;
                                        tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                        Tier5List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                    }
                                    else if(collectionTier >150 && collectionTier <= 180){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier150Numerator = tier150Numerator + cli.Collection_Amount__c;
                                        tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                        Tier5List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier180Numerator = tier180Numerator + cli.Collection_Amount__c;
                                        tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                        Tier6List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                    }
                                     if(collectionTier >180 && collectionTier <= 210){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier150Numerator = tier150Numerator + cli.Collection_Amount__c;
                                        tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                        Tier5List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier180Numerator = tier180Numerator + cli.Collection_Amount__c;
                                        tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                        Tier6List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier210Numerator = tier210Numerator + cli.Collection_Amount__c;
                                        tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                        Tier7List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                    }
                                    else if(collectionTier >210 && collectionTier <= 240){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier150Numerator = tier150Numerator + cli.Collection_Amount__c;
                                        tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                        Tier5List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier180Numerator = tier180Numerator + cli.Collection_Amount__c;
                                        tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                        Tier6List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier210Numerator = tier210Numerator + cli.Collection_Amount__c;
                                        tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                        Tier7List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier240Numerator = tier240Numerator + cli.Collection_Amount__c;
                                        tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                        Tier8List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                    }
                                    else if(collectionTier >240 && collectionTier <= 270){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier150Numerator = tier150Numerator + cli.Collection_Amount__c;
                                        tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                        Tier5List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier180Numerator = tier180Numerator + cli.Collection_Amount__c;
                                        tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                        Tier6List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier210Numerator = tier210Numerator + cli.Collection_Amount__c;
                                        tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                        Tier7List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier240Numerator = tier240Numerator + cli.Collection_Amount__c;
                                        tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                        Tier8List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier270Numerator = tier270Numerator + cli.Collection_Amount__c;
                                        tier270Denominator = tier270Denominator + c.Billed_Amount__c;
                                        Tier9List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                    }
                                    else if(collectionTier >270 && collectionTier <= 300){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier150Numerator = tier150Numerator + cli.Collection_Amount__c;
                                        tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                        Tier5List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier180Numerator = tier180Numerator + cli.Collection_Amount__c;
                                        tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                        Tier6List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier210Numerator = tier210Numerator + cli.Collection_Amount__c;
                                        tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                        Tier7List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier240Numerator = tier240Numerator + cli.Collection_Amount__c;
                                        tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                        Tier8List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier270Numerator = tier270Numerator + cli.Collection_Amount__c;
                                        tier270Denominator = tier270Denominator + c.Billed_Amount__c;
                                        Tier9List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier300Numerator = tier300Numerator + cli.Collection_Amount__c;
                                        tier300Denominator = tier300Denominator + c.Billed_Amount__c;
                                        Tier10List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                    }
                                    else if(collectionTier >300 && collectionTier <= 330){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier150Numerator = tier150Numerator + cli.Collection_Amount__c;
                                        tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                        Tier5List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier180Numerator = tier180Numerator + cli.Collection_Amount__c;
                                        tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                        Tier6List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier210Numerator = tier210Numerator + cli.Collection_Amount__c;
                                        tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                        Tier7List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier240Numerator = tier240Numerator + cli.Collection_Amount__c;
                                        tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                        Tier8List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier270Numerator = tier270Numerator + cli.Collection_Amount__c;
                                        tier270Denominator = tier270Denominator + c.Billed_Amount__c;
                                        Tier9List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier300Numerator = tier300Numerator + cli.Collection_Amount__c;
                                        tier300Denominator = tier300Denominator + c.Billed_Amount__c;
                                        Tier10List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier330Numerator = tier330Numerator + cli.Collection_Amount__c;
                                        tier330Denominator = tier330Denominator + c.Billed_Amount__c;
                                        Tier11List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                    }
                                    else if(collectionTier >330){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier150Numerator = tier150Numerator + cli.Collection_Amount__c;
                                        tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                        Tier5List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier180Numerator = tier180Numerator + cli.Collection_Amount__c;
                                        tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                        Tier6List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier210Numerator = tier210Numerator + cli.Collection_Amount__c;
                                        tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                        Tier7List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier240Numerator = tier240Numerator + cli.Collection_Amount__c;
                                        tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                        Tier8List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier270Numerator = tier270Numerator + cli.Collection_Amount__c;
                                        tier270Denominator = tier270Denominator + c.Billed_Amount__c;
                                        Tier9List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier300Numerator = tier300Numerator + cli.Collection_Amount__c;
                                        tier300Denominator = tier300Denominator + c.Billed_Amount__c;
                                        Tier10List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier330Numerator = tier330Numerator + cli.Collection_Amount__c;
                                        tier330Denominator = tier330Denominator + c.Billed_Amount__c;
                                        Tier11List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                        tier360Numerator = tier360Numerator + cli.Collection_Amount__c;
                                        tier360Denominator = tier360Denominator + c.Billed_Amount__c;
                                        Tier12List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, cli.Collection_Amount__c, collectionTier, c.CaseNumber, c.id, cli.id));
                                        
                                    }    
                                }   
                            }    
                        }else{//If No CLI Exists for a Case, that means $0 Collection was collected on it. In these Cases, We still need to include the Denominator value for collection.
                            If((c.ClosedDate != null || c.Collection_Date__c != null) && c.Billed_Amount__c != Null ){
                                 
                                integer collectionTier = 0;
                                if(c.Collection_Date__c != null)//Checking to see if the Collection Date is available on the Case
                                    collectionTier = c.Bill_Date__c.daysBetween(c.Collection_Date__c);
                                else//If no Collection Date is available on the case, then we will simply use the Case Close Date
                                    collectionTier = c.Bill_Date__c.daysBetween(date.ValueOf(c.ClosedDate));
                                
                                if(collectionTier >=0 && collectionTier <= 30){
                                    tier30Denominator = tier30Denominator + c.Billed_Amount__c;
                                    Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                        
                                }
                                else if(collectionTier >30 && collectionTier <= 60){
                                    tier30Denominator = tier30Denominator + c.Billed_Amount__c;
                                    Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                        
                                }
                                else if(collectionTier >60 && collectionTier <= 90){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                }
                                else if(collectionTier >90 && collectionTier <= 120){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                }
                                else if(collectionTier >120 && collectionTier <= 150){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                    Tier5List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                }
                                else if(collectionTier >150 && collectionTier <= 180){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                    Tier5List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                    Tier6List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                }
                                 if(collectionTier >180 && collectionTier <= 210){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                    Tier5List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                    Tier6List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                    Tier7List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                }
                                else if(collectionTier >210 && collectionTier <= 240){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                    Tier5List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                    Tier6List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                    Tier7List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                    Tier8List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                }
                                else if(collectionTier >240 && collectionTier <= 270){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                    Tier5List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                    Tier6List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                    Tier7List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                    Tier8List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier270Denominator = tier270Denominator + c.Billed_Amount__c;
                                    Tier9List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                }
                                else if(collectionTier >270 && collectionTier <= 300){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                    Tier5List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                    Tier6List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                    Tier7List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                    Tier8List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier270Denominator = tier270Denominator + c.Billed_Amount__c;
                                    Tier9List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier300Denominator = tier300Denominator + c.Billed_Amount__c;
                                    Tier10List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                }
                                else if(collectionTier >300 && collectionTier <= 330){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                    Tier5List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                    Tier6List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                    Tier7List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                    Tier8List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier270Denominator = tier270Denominator + c.Billed_Amount__c;
                                    Tier9List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier300Denominator = tier300Denominator + c.Billed_Amount__c;
                                    Tier10List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier330Denominator = tier330Denominator + c.Billed_Amount__c;
                                    Tier11List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                }
                                else if(collectionTier >330){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    Tier1List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    Tier2List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    Tier3List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    Tier4List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                    Tier5List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                    Tier6List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                    Tier7List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                    Tier8List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier270Denominator = tier270Denominator + c.Billed_Amount__c;
                                    Tier9List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier300Denominator = tier300Denominator + c.Billed_Amount__c;
                                    Tier10List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier330Denominator = tier330Denominator + c.Billed_Amount__c;
                                    Tier11List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                    tier360Denominator = tier360Denominator + c.Billed_Amount__c;
                                    Tier12List.add(new analyticsWrapperData(c.Bill_Date__c, c.Bill_Date__c.addDays(collectionTier), c.Billed_Amount__c, 0, collectionTier, c.CaseNumber, c.id, null));
                                    
                                }  
                            }  
                        }
                    }
                    
                    Account acc = new Account(id=accId, Temp_Flag__c = True);
                    if(tier30Numerator != 0.0)
                        acc.X0_to_30_Days_Collection__c = (tier30Numerator/tier30Denominator)*100;
                    else
                        acc.X0_to_30_Days_Collection__c = 0.0;
                    if(tier60Numerator != 0.0)
                        acc.X30_to_60_Days_Collection__c = (tier60Numerator/tier60Denominator)*100;
                    else
                        acc.X30_to_60_Days_Collection__c = 0.0;
                    if(tier90Numerator != 0.0)
                        acc.X60_to_90_Days_Collection__c = (tier90Numerator/tier90Denominator)*100; 
                    else
                        acc.X60_to_90_Days_Collection__c = 0.0; 
                    if(tier120Numerator != 0.0)
                        acc.X90_to_120_Days_Collection__c = (tier120Numerator/tier120Denominator)*100;
                    else
                        acc.X90_to_120_Days_Collection__c = 0.0;
                    if(tier150Numerator != 0.0)
                        acc.X120_to_150_Days_Collection__c = (tier150Numerator/tier150Denominator)*100; 
                    else
                        acc.X120_to_150_Days_Collection__c = 0.0; 
                    if(tier180Numerator != 0.0)
                        acc.X150_to_180_Days_Collection__c = (tier180Numerator/tier180Denominator)*100;
                    else
                        acc.X150_to_180_Days_Collection__c = 0.0;
                    if(tier210Numerator != 0.0)
                        acc.X180_to_210_Days_Collection__c = (tier210Numerator/tier210Denominator)*100; 
                    else
                        acc.X180_to_210_Days_Collection__c = 0.0; 
                    if(tier240Numerator != 0.0)
                        acc.X210_to_240_Days_Collection__c = (tier240Numerator/tier240Denominator)*100;
                    else
                        acc.X210_to_240_Days_Collection__c = 0.0;
                    if(tier270Numerator != 0.0)
                        acc.X240_to_270_Days_Collection__c = (tier270Numerator/tier270Denominator)*100; 
                    else
                        acc.X240_to_270_Days_Collection__c = 0.0; 
                    if(tier300Numerator != 0.0)    
                        acc.X270_to_300_Days_Collection__c = (tier300Numerator/tier300Denominator)*100;
                    else
                        acc.X270_to_300_Days_Collection__c = 0.0;
                    if(tier330Numerator != 0.0)
                        acc.X300_to_330_Days_Collection__c = (tier330Numerator/tier330Denominator)*100; 
                    else
                        acc.X300_to_330_Days_Collection__c = 0.0; 
                    if(tier360Numerator != 0.0)
                        acc.X330_Days_and_Above_Collection__c = (tier360Numerator/tier360Denominator)*100;
                    else
                        acc.X330_Days_and_Above_Collection__c = 0.0;
                    
                    accUpdateList.add(acc); 
                    accIdSet.add(acc.id);
                    
                    
                }
            }       
           
        }
        
        
        
        
        for(Id accId : accIdList){
            if(!accIdSet.contains(accId)){
                Account acc = new Account(id=accId, Temp_Flag__c = True, X0_to_30_Days_Collection__c = 0.0, X30_to_60_Days_Collection__c = 0.0,
                                             X60_to_90_Days_Collection__c = 0.0, X90_to_120_Days_Collection__c = 0.0,
                                             X120_to_150_Days_Collection__c = 0.0, X150_to_180_Days_Collection__c = 0.0,
                                             X180_to_210_Days_Collection__c = 0.0, X210_to_240_Days_Collection__c = 0.0,
                                             X240_to_270_Days_Collection__c = 0.0, X270_to_300_Days_Collection__c = 0.0,
                                             X300_to_330_Days_Collection__c = 0.0, X330_Days_and_Above_Collection__c = 0.0);
                accUpdateList.add(acc); 
            }
        }
        //if(accUpdateList.size()>0)
            //update accUpdateList;
    }
    
    Public Class analyticsWrapperData{
        public date billDate { get; set; }
        public date collectionDate { get; set; }
        public Decimal billedAmount { get; set; }
        public Decimal collectedAmount { get; set; }
        public integer noOfDaysToCollect { get; set; }
        public String claimNumber { get; set; }
        public id claimId { get; set; }
        Public id collectionId { get; set; }
        
        public analyticsWrapperData(date billDate, date collectionDate, Decimal billedAmount, Decimal collectedAmount, integer noOfDaysToCollect, String claimNumber, id claimId, id collectionId){
            this.billDate = billDate;
            this.collectionDate = collectionDate;
            this.billedAmount = billedAmount;
            this.collectedAmount = collectedAmount;
            this.noOfDaysToCollect = noOfDaysToCollect;
            this.claimNumber = claimNumber;
            this.claimId = claimId;
            this.collectionId = collectionId;
        }
        
    }
    
}