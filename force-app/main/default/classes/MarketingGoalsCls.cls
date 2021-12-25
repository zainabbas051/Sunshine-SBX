public class MarketingGoalsCls {
    
    
    
    public MarketingGoalsCls(){
        
    }
    /*
    public List<GaugeData> getData(){
        //AggregateResult agr = [SELECT Count(id) totalOpp, MAX(Today_Date_Number__c) tdn,Sunshine_Center__c FROM Opportunity WHERE 
        //     RecordType.DeveloperName='Monarch_Shores' group by Sunshine_Center__c limit 1];
        
        List<GaugeData>  MonthlyAdmitGoalData = new List<GaugeData>();
        MonthlyAdmitGoalData.add(new GaugeData('Admits',runReportAdmits(),0));
        
        
        
        return MonthlyAdmitGoalData;
        
    }*/
    
    public List<GaugeData> getDataMAG(){
        
        
        List<GaugeData>  MonthlyAdmitGoalData = new List<GaugeData>();
        MonthlyAdmitGoalData.add(new GaugeData('Admits',runReportMAG()[0],0));
        
        
        
        return MonthlyAdmitGoalData;
        
    }
    
    public List<GaugeData> getDataAPD(){
        
        
        List<GaugeData>  MonthlyAdmitGoalData = new List<GaugeData>();
        MonthlyAdmitGoalData.add(new GaugeData('Admits',runReportMAG()[1],0));
        
        
        
        return MonthlyAdmitGoalData;
        
    }
    
    public List<GaugeData> getDataMOG(){
        
        
        List<GaugeData>  MonthlyOppGoalData = new List<GaugeData>();
        MonthlyOppGoalData.add(new GaugeData('Opportunities',runReportMOG()[0],0));
        
        
        	
        return MonthlyOppGoalData;
        
    }
    
    public List<GaugeData> getDataOPD(){
        
        
        List<GaugeData>  MonthlyOppGoalData = new List<GaugeData>();
        MonthlyOppGoalData.add(new GaugeData('Opportunities',runReportMOG()[1],0));
        
        
        
        return MonthlyOppGoalData;
        
    }
    
    public List<GaugeData> getDataDDG(){
        
        
        List<GaugeData>  MonthlyDDGoalData = new List<GaugeData>();
        MonthlyDDGoalData.add(new GaugeData('Double Digit',runReportDDG(),0));
        
        
        
        return MonthlyDDGoalData;
        
    }
    
    
    /*
    private Decimal runReportAdmits(){
        
        //Query Report
        List<Report> reportList = [SELECT ID, DeveloperName FROM Report WHERE DeveloperName = 'MGD_Admits'];
        
        //Get Report ID
        String reportId = (String)reportList.get(0).get('Id');
        
        // Run the report
        Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);
        Map<String,Reports.ReportFact> reportFactMap = results.getFactMap();
        
        Decimal reportResultValue = Decimal.valueOf(reportFactMap.get('0!T').getAggregates()[0].getLabel());
        System.debug('Synchronous results: ' + reportResultValue);
        
        return reportResultValue;
    }*/
    
    private List<Decimal> runReportMAG(){
        
        //Query Report
        List<Report> reportList = [SELECT ID, DeveloperName FROM Report WHERE DeveloperName = 'Monthly_Admit_Goal'];
        
        //Get Report ID
        String reportId = (String)reportList.get(0).get('Id');
        
        // Run the report
        Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);
        Map<String,Reports.ReportFact> reportFactMap = results.getFactMap();
        
        Decimal reportResultValue = Decimal.valueOf(reportFactMap.get('0!T').getAggregates()[0].getLabel());
        System.debug('Synchronous results: ' + reportResultValue);
        
        List<Decimal> reportResults = new List<Decimal>();
        reportResults.add(Decimal.valueOf(reportFactMap.get('0!T').getAggregates()[0].getLabel()));
        reportResults.add(Decimal.valueOf(reportFactMap.get('0!T').getAggregates()[1].getLabel()));
        
        return reportResults;
    }
    
    private List<Decimal> runReportMOG(){
        
        //Query Report
        List<Report> reportList = [SELECT ID, DeveloperName FROM Report WHERE DeveloperName = 'Monthly_Opportunity_Goal'];
        
        //Get Report ID
        String reportId = (String)reportList.get(0).get('Id');
        
        // Run the report
        Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);
        Map<String,Reports.ReportFact> reportFactMap = results.getFactMap();
        
        Decimal reportResultValue = Decimal.valueOf(reportFactMap.get('0!T').getAggregates()[0].getLabel());
        System.debug('Synchronous results: ' + reportResultValue);
        
        List<Decimal> reportResults = new List<Decimal>();
        reportResults.add(Decimal.valueOf(reportFactMap.get('0!T').getAggregates()[0].getLabel()));
        reportResults.add(Decimal.valueOf(reportFactMap.get('0!T').getAggregates()[1].getLabel()));
        
        return reportResults;
    }
    
    public List<AggregateResult> getrunReportDDGClosed(){
        
        return [SELECT CloseDate cd,Count(ID)c FROM Opportunity WHERE CloseDate= THIS_MONTH AND Stagename IN ('Admitted','Rescued','Completed Treatment','Discharged')  AND RecordType.DeveloperName = 'Monarch_Shores' Group by CloseDate];
    }
    
    
    private Decimal runReportDDG(){
        
        //Query Report
        List<Report> reportList = [SELECT ID, DeveloperName FROM Report WHERE DeveloperName = 'Double_Digit_Goal'];
        
        //Get Report ID
        String reportId = (String)reportList.get(0).get('Id');
        
        // Run the report
        Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);
        Map<String,Reports.ReportFact> reportFactMap = results.getFactMap();
        
        Decimal reportResultValue = Decimal.valueOf(reportFactMap.get('0!T').getAggregates()[0].getLabel());
        System.debug('Synchronous results: ' + reportResultValue);
        
        return reportResultValue;
    }
    
    public class GaugeData{
        Public String name{get;set;}
        public Decimal tdn{get;set;}
        public integer tdnp{get;set;}
        
        public GaugeData(String name,Decimal tdn,integer tdnp){
            this.Name = name;
            this.tdn = tdn;
            this.tdnp = tdnp;
            
        }
    }
    
}