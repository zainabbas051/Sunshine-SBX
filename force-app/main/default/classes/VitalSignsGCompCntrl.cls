public class VitalSignsGCompCntrl {
    Public String pageName {get;set;}
	
    Public Recurring_Assessment__c vs {get;set;}
    public VitalSignsGCompCntrl(){
        
        String clientChartId = ApexPages.currentPage().getParameters().get('cId');
        
        List<Recurring_Assessment__c> listRA = [SELECT Id,BP_Diastolic__c, BP_Systolic__c, Temperature__c, Pulse__c, 
                                                Respirations__c, X02_Saturation__c FROM Recurring_Assessment__c 
                                               WHERE BP_Diastolic__c = null and Recordtype.developerName='Vital_Signs' and CLient_Chart__c=:clientChartId order by Time_Due__c asc];
        if(listRA.size() > 0)
            vs = listRA[0];
        else
        	vs = new Recurring_Assessment__c(Name='VS-'+Crypto.getRandomInteger(),
                                         RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                                                                        get('Vital Signs').getRecordTypeId(),
                                            Related_To__c=ApexPages.currentPage().getParameters().get('recId'),
                                            Client_Chart__c = clientChartId);
    }
    
    public PageReference Save(){
        upsert vs;
        
        System.debug('pagename:: ' + pageName);
        PageReference pr = new PageReference('/apex/'+pageName + '?vsId='+vs.Id);
        pr.setRedirect(true);
        return pr;
    }
    
    
}