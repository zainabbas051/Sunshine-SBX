// Test class: utilizationreviewTest
/*
    controller class for utilizationreview vf component. Utilization Review is a record type of 
    utilization review object.
    @author: Huma Zafar
*/
public with sharing class utilizationreview {
    
    public Utilization_Review__c UR{get;set;}
    
    public boolean EditPage{get;set;}
    
    public id urID;
    
    public utilizationreview(){
        
        urID = ApexPages.CurrentPage().getParameters().get('rId');
        
        id clientChartId = ApexPages.CurrentPage().getParameters().get('id');
        
        if(urID != null){
            UR = [select id from Utilization_Review__c where id=: urID];
        }
        else{
            UR = new Utilization_Review__c();
            UR.RecordTypeId = Schema.SObjectType.Utilization_Review__c.getRecordTypeInfosByName().get('Utilization Review').getRecordTypeId();
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