//Test Class : corporateFinanceUtilityTest
Public without sharing class corporateFinanceIntegrationHelper{
    
    public static string createRevenueHelper(Integer companyId, Date collectionDate, Decimal amount, String amountType){
    
        revenueWrapper rw = new revenueWrapper();
        rw.company_id = companyId;
        rw.collection_date = collectionDate.Year()+'/'+collectionDate.Month()+'/'+collectionDate.Day(); 
        rw.amount = amount;
        rw.amount_type = amountType;
        
        createRevenueWrapper crw = new createRevenueWrapper(rw);
        
        string jsonString = JSON.serialize(crw);
        system.debug('jsonString :::'+jsonString);
        
        return jsonString;    
    }
    
    public static string createNoOfDealsHelper(Integer companyId, Date collectionDate, Integer noOfDeals, String typeOfDeal){
        
        dealsWrapper dw = new dealsWrapper();
        dw.company_id = companyId;
        dw.collection_date = collectionDate.Year()+'/'+collectionDate.Month()+'/'+collectionDate.Day(); 
        dw.number_of_deals = noOfDeals;
        dw.type_of_deals = typeOfDeal;
         
        createDealsWrapper cdw = new createDealsWrapper(dw);
        
        string jsonString = JSON.serialize(cdw);
        system.debug('jsonString :::'+jsonString);
        
        return jsonString;    
    
    }
    
    public class createDealsWrapper{
        public dealsWrapper deal;
        public createDealsWrapper(dealsWrapper deal){
            this.deal = deal;
        }
    }
    
    public class dealsWrapper{
        public integer company_id;
        public string collection_date; 
        public integer number_of_deals;
        public string type_of_deals;
        
        public dealsWrapper(){
        }
        
    }
    
    public class createRevenueWrapper{
        public revenueWrapper revenue;
        
        public createRevenueWrapper(revenueWrapper revenue){
            this.revenue = revenue;
        }
    }
    
    public class revenueWrapper{
        public integer company_id; 
        public string collection_date;
        public decimal amount;
        public string amount_type;
        
        public revenueWrapper(){
        }
    }
    
}