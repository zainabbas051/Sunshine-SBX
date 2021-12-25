@isTest(SeeAllData=true)
private class CreateTargetKeyWordJunction_Test{ 
   
    public static testMethod void test(){
    
        
             test.startTest();
         Target_Page__c seoPage = new Target_Page__c(
                    Page__c = 'https://www.google.com'
                );
            insert seoPage;
            
                      
            Keyword_Metric__c km = new Keyword_Metric__c(
                    Name = 'Test Keyword',
                    CPC__c = 123,
                    Difficulty__c = 213,
                    Position__c = 514,
                    Traffic_desc__c = 456,
                    URL__c = 'https://www.google.com',
                    Volume__c = 123
            );
            
            insert km;
            
            Keyword_Metric__c km1 = new Keyword_Metric__c(
                    Name = 'Test Keyword',
                    CPC__c = 123,
                    Difficulty__c = 213,
                    Position__c = 514,
                    Traffic_desc__c = 456,
                    URL__c = 'https://www.google.com243435',
                    Volume__c = 123
            );
            
            insert km1;
        
        
            
            Target_Keyword_Junction__c tkj = new Target_Keyword_Junction__c(
                    Keyword_Metrics__c = km.id,
                    Target_Page__c = seoPage.id
                );
            insert tkj; 
            
        km.url__C= 'https://www.salesforce.com333';
             update  km;
        
        
        KM1.Url__C= 'https://www.google.com';
             update  KM1;
        
        Target_Keyword_Junction__c tkj1 = new Target_Keyword_Junction__c(
                    Keyword_Metrics__c = km1.id,
                    Target_Page__c = seoPage.id
                );
            insert tkj1; 
        
     test.stopTest();
        

     
    } 
        
}