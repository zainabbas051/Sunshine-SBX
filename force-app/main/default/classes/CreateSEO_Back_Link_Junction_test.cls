@isTest(SeeAllData=true)
private class CreateSEO_Back_Link_Junction_test{ 
   
    public static testMethod void test(){
    
        
             test.startTest();
         Target_Page__c seoPage = new Target_Page__c(
                    Page__c = 'https://www.google.com'
                );
            insert seoPage;
            
                      
             Back_link_Metrics__c  BLM = new Back_link_Metrics__c (Link_URL__c ='https://www.google.com');
        
        insert BLM;
        
          Back_link_Metrics__c  BLM1 = new Back_link_Metrics__c (Link_URL__c ='https://www.google.com243435');
        
        insert BLM1;
            
           
        
        
            
           SEO_Back_Link_Junction__c SBJ = new SEO_Back_Link_Junction__c(
             Back_link_Metrics__c=BLM.id,
             SEO_s_Page_Checklist__c = seoPage.id
             );
             
             Insert SBJ;
             
        BLM.Link_URL__c = 'https://www.salesforce.com333';
             update  BLM;
        
        
        BLM1.Link_URL__c = 'https://www.google.com';
             update  BLM1;
        
         
            
            SEO_Back_Link_Junction__c SBJ1 = new SEO_Back_Link_Junction__c(
             Back_link_Metrics__c=BLM1.id,
             SEO_s_Page_Checklist__c = seoPage.id
             );
             
             Insert SBJ1;
        
     test.stopTest();
        

     
    } 
        
}