// Test Class: utilizationconcurrentreviewTest 
/*
    controller class for utilizationconcurrentreview vf component. Utilization Concurrent Review is a record type of 
    utilization review object.
    @author: Huma Zafar
*/
public with sharing class utilizationconcurrentreview {
    public Utilization_Review__c UR{get;set;}
    
    public boolean EditPage{get;set;}
    
    public id urID;
    
    public utilizationconcurrentreview(){
        
        urID = ApexPages.CurrentPage().getParameters().get('rId');
        
        id clientChartId = ApexPages.CurrentPage().getParameters().get('id');
        
        if(urID != null){
            UR = [select id, Authorization_date__c, Number_of_days__c, Frequency__c, Level_of_care__c, Start_date__c,
            End_date__c, Last_coverage_date__c, Authorization_number__c, Next_review_date__c,  
            Insurance_Company_Picklist__c, Comments__c from Utilization_Review__c where id=: urID];
        }
        else{
            UR = new Utilization_Review__c();
            UR.RecordTypeId = Schema.SObjectType.Utilization_Review__c.getRecordTypeInfosByName().get('Concurrent Review').getRecordTypeId();
        }
        EditPage = false; 
    }
    
    public void EditFullPage(){
        EditPage = true;
    }
    
    public PageReference submitFunc(){
        
        try{
            System.debug('submit button method');
            upsert UR ;
            return null;
        }
        catch(exception e){
            return null;
        }
    }
}