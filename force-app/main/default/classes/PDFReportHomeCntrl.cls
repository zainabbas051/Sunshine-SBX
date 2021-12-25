public class PDFReportHomeCntrl {
    
    Public ID ClientChartId {get;set;}
    public PDFReportHomeCntrl(){
        ClientChartId = ApexPages.currentPage().getParameters().get('Id');
    }
    
    public List<PDF_Merge__c> getPDFMerge(){
        System.debug(':: ' + ClientChartId);
        return [SELECT ID, Name, Status__c, Requested_Date__c, Final_PDF_Url__c FROM PDF_Merge__c WHERE Client_Chart__c=:ClientChartId ORDER BY CREATEDDATE];
    }
    
    public PageReference NewPDFMerge(){
        PageReference pr = new PageReference('/apex/pdfreportsvfp?id='+ApexPages.currentPage().getParameters().get('Id'));
        
        return pr;
    }
}