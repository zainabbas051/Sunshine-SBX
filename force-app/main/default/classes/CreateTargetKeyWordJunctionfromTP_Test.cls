@isTest(SeeAllData=true)
private class CreateTargetKeyWordJunctionfromTP_Test { 
   
    public static testMethod void test(){
    
        
             test.startTest();
        
                      
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
            
            
        Back_link_Metrics__c  BLM = new Back_link_Metrics__c (Link_URL__c ='https://www.google.com');
        
        insert BLM;
        
        
          Target_Page__c seoPage = new Target_Page__c(
                    Page__c = 'https://www.google.com'
                );
            insert seoPage;
                  
        Target_Page__c seoPage1 = new Target_Page__c(
                    Page__c = 'https://www.google.com1890'
                );
            insert seoPage1;
        
        
            
            
            Target_Keyword_Junction__c tkj = new Target_Keyword_Junction__c(
                    Keyword_Metrics__c = km.id,
                    Target_Page__c = seoPage.id
                );
            insert tkj; 
            
            SEO_Back_Link_Junction__c SBJ = new SEO_Back_Link_Junction__c(
             Back_link_Metrics__c=BLM.id,
             SEO_s_Page_Checklist__c = seoPage.id
             );
             
             Insert SBJ;
            
        seoPage.Page__c = 'https://www.salesforce.com333';
             update  seoPage;
        
        
        
      
        
        seoPage1.Page__c = 'https://www.google.com';
             update  seoPage1;
        
        Target_Keyword_Junction__c tkj1 = new Target_Keyword_Junction__c(
                    Keyword_Metrics__c = km.id,
                    Target_Page__c = seoPage1.id
                );
            insert tkj1; 
        
     test.stopTest();
        

     
    } 
        
}