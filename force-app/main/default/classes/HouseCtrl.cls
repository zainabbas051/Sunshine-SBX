public with sharing class HouseCtrl {
    public HouseCtrl() {

    }
    @AuraEnabled
    public static List<House__c> getHouseList(){
        
        return [Select Id,Name,Sunshine_Center__r.Name from House__c];
    }
   
}