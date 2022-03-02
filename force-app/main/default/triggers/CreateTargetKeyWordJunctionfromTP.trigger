/*Test Class: CreateTargetKeyWordJunctionfromTP_Test
    written By: Zoobeez Fatima
    deployed on 8/11/2018*/

trigger CreateTargetKeyWordJunctionfromTP on Target_Page__c (after Insert,after update) {
    
    list<Keyword_Metric__c > LstKeywordMetric = new list<Keyword_Metric__c>(); 
    list<Back_link_Metrics__c > LstBackLinkMetric = new list<Back_link_Metrics__c >(); 
    List<Target_Keyword_Junction__c> LstExsistKJ = new list<Target_Keyword_Junction__c>();
    list<Target_Keyword_Junction__c> LstDeleteTKJ = new list<Target_Keyword_Junction__c>();
    list<Target_Keyword_Junction__c> LstTKJ = new list<Target_Keyword_Junction__c>();
    list<SEO_Back_Link_Junction__c> LstDeleteSEOBLJ = new list<SEO_Back_Link_Junction__c>();
    List<SEO_Back_Link_Junction__c> LstExsisSEOBLJ = new list<SEO_Back_Link_Junction__c>();
    list<SEO_Back_Link_Junction__c> LstSEOBLJ = new list<SEO_Back_Link_Junction__c>();


    Target_Keyword_Junction__c DelTKJIns = new Target_Keyword_Junction__c();
    Target_Keyword_Junction__c TKJIns = new Target_Keyword_Junction__c();

    SEO_Back_Link_Junction__c DelSEOBLJIns = new SEO_Back_Link_Junction__c ();
    SEO_Back_Link_Junction__c SEOBLJIns = new SEO_Back_Link_Junction__c ();


    map<string,boolean> MapIsKeywordJunctionExsist = new map<string,boolean>();
    map<string,boolean> MapIsBackLinkJunctionExsist = new map<string,boolean>();
    map<string,id> MapTargetToKeywordJunction = new map<string,id>();
    map<string,id> MapBackLinkToSEOBackLinkJunction = new map<string,id>();

    set<string> urlvalsSet = new set<string>();
    set<string> LinkUrlSet = new set<string>();
    set<id> tpidsSet = new set<id>();

    for(Target_Page__c TargetPageIns: trigger.new){
        tpidsSet.add(TargetPageIns.id);
        If( trigger.isUpdate &&(Trigger.Oldmap.get(TargetPageIns.id).Page__C != Trigger.NewMap.get(TargetPageIns.id).Page__C )){
            urlvalsSet .add(Trigger.Oldmap.get(TargetPageIns.id).Page__C);
            urlvalsSet .add(TargetPageIns.page__C);
        }
        else
            urlvalsSet .add(TargetPageIns.page__C);
    }
    
    LstExsistKJ = [select id, Keyword_Metrics__c ,Target_Page__c  from Target_Keyword_Junction__c where Target_Page__c  in:tpidsSet];
    LstExsisSEOBLJ = [select id, Back_link_Metrics__c,SEO_s_Page_Checklist__c from SEO_Back_Link_Junction__c where SEO_s_Page_Checklist__c  in:tpidsSet];

    
    LstKeywordMetric = [select id,url__C from Keyword_Metric__c  where url__c in : urlvalsSet];
    LstBackLinkMetric = [select id,Link_URL__c from Back_link_Metrics__c  where Link_URL__c in : urlvalsSet ];
    
    
    //for filling map
        for(Target_Page__c TargetPageIns: trigger.new){
            for(Target_Keyword_Junction__c KeywordJuncIns: LstExsistKJ ){
                if(TargetPageIns.id==KeywordJuncIns.Target_Page__c ){ 
                    MapIsKeywordJunctionExsist.put(TargetPageIns.id+':'+KeywordJuncIns.Keyword_Metrics__c ,true);
                    MapTargetToKeywordJunction.put(TargetPageIns.id+':'+KeywordJuncIns.Keyword_Metrics__c ,KeywordJuncIns.id);
                   system.debug('test');

                   
                   }
                else
                   MapIsKeywordJunctionExsist.put(TargetPageIns.id+'null',false); 
                   system.debug('test');
                 
            
            }
            
            for(SEO_Back_Link_Junction__c BackLinkJuncIns: LstExsisSEOBLJ ){
                if(TargetPageIns.id==BackLinkJuncIns.SEO_s_Page_Checklist__c){ 
                    MapIsBackLinkJunctionExsist.put(TargetPageIns.id+':'+BackLinkJuncIns.Back_link_Metrics__c,true);
                    MapBackLinkToSEOBackLinkJunction.put(TargetPageIns.id+':'+BackLinkJuncIns.Back_link_Metrics__c,BackLinkJuncIns.id);
                   system.debug('test');

                 }
                 else
                     MapIsBackLinkJunctionExsist.put(TargetPageIns.id+'null',false); 
             }
        }

    
        for(Target_Page__c TargetPageIns: trigger.new){
            if(trigger.isInsert ){
                for(Keyword_Metric__c KeywordIns:LstKeywordMetric ){
                     if(TargetPageIns.Page__C == KeywordIns.url__c ){
                         TKJIns = new Target_Keyword_Junction__c();
                         TKJIns.Keyword_Metrics__c = KeywordIns.id;
                         TKJIns.Target_Page__c = TargetPageIns.id;
                         LstTKJ.add(TKJIns);
                         system.debug('value to be tested::::'+LstTKJ);
                     }
                }
                insert LstTKJ;
                
                for(Back_link_Metrics__c  BackLinkIns:LstBackLinkMetric ){
                     if(TargetPageIns.Page__C==BackLinkIns.Link_URL__c){
                         SEOBLJIns = new SEO_Back_Link_Junction__c();
                         SEOBLJIns.Back_link_Metrics__c= BackLinkIns.id;
                         SEOBLJIns.SEO_s_Page_Checklist__c = TargetPageIns.id;
                         LstSEOBLJ.add(SEOBLJIns);
                         system.debug('value to be tested::::'+LstSEOBLJ);
                     }
             
                 }
                 insert LstSEOBLJ;
             }
             
             If( trigger.isUpdate &&(Trigger.Oldmap.get(TargetPageIns.id).Page__C != Trigger.NewMap.get(TargetPageIns.id).Page__C )){
                 for(Keyword_Metric__c KeywordIns :LstKeywordMetric ){
                     if(TargetPageIns.Page__C == KeywordIns.url__c){
                         TKJIns = new Target_Keyword_Junction__c();
                         TKJIns.Keyword_Metrics__c = KeywordIns.id;
                         TKJIns.Target_Page__c = TargetPageIns.id;
                         LstTKJ.add(TKJIns);
                         system.debug('value to be tested::::'+LstTKJ);
                     }
                     else{
                         if(MapIsKeywordJunctionExsist.get(TargetPageIns.id+':'+KeywordIns .id)==true){
                             DelTKJIns.id=MapTargetToKeywordJunction.get(TargetPageIns.id+':'+KeywordIns .id);
                             LstDeleteTKJ.add(DelTKJIns);
                             DelTKJIns = new Target_Keyword_Junction__c();
                        }
                    }
                
                 }
                 
                 for(Back_link_Metrics__c  BackLinkIns :LstBackLinkMetric  ){
                     if(TargetPageIns.Page__C==BackLinkIns.Link_URL__c){
                         SEOBLJIns = new SEO_Back_Link_Junction__c();
                         SEOBLJIns .Back_link_Metrics__c= BackLinkIns.id;
                         SEOBLJIns .SEO_s_Page_Checklist__c = TargetPageIns.id;
                         LstSEOBLJ .add(SEOBLJIns );
                         system.debug('value to be tested::::'+LstSEOBLJ );
                     }
                     else{
                         if(MapIsBackLinkJunctionExsist.get(TargetPageIns.id+':'+BackLinkIns.id)==true){
                             DelSEOBLJIns .id=MapBackLinkToSEOBackLinkJunction.get(TargetPageIns.id+':'+BackLinkIns.id);
                             LstDeleteSEOBLJ.add(DelSEOBLJIns );
                             DelSEOBLJIns = new SEO_Back_Link_Junction__c();
                     }
                 }
             }
             
             
         if(LstTKJ.size()>0){
             insert LstTKJ;
         }
          
          if(LstDeleteTKJ.size()>0){
              delete LstDeleteTKJ;
          }
          
         
         
          if(LstSEOBLJ .size()>0){
              insert LstSEOBLJ ;
          }
          
          if(LstDeleteSEOBLJ.size()>0){
              system.debug('Id debug  last work');
              delete LstDeleteSEOBLJ;
           }
         
         }
         
         
        
    
       
    
    
}
    

}