public inherited sharing class KipuChartAuditPPLIService{
    

    public static void updateRelatedPPLI(List<KIPU_Chart_Audit__c> lstKipuCharts){
                                                       
             List<Payment_Plan_Line_Items__c> updatePPLIList = new List<Payment_Plan_Line_Items__c>();
             Map<String,ID> kipuOppIdMap = new Map<String,ID>();
              for(KIPU_Chart_Audit__c kipu :  lstKipuCharts){
              
                  if(kipuOppIdMap.containsKey(kipu.Id) == False){
                    kipuOppIdMap.put(kipu.Opportunity__c,kipu.Id);
              
              
              
              }
              
              }        
              
              List<Payment_Plan_Line_Items__c> ppliList= new List<Payment_Plan_Line_Items__c>();
              ppliList= [select id,Type_of_Collection__c,Opportunity__c,Payment_Plan__r.Approval_Status__c from Payment_Plan_Line_Items__c
                           where Opportunity__c IN: kipuOppIdMap.keySet() and Payment_Plan__r.Approval_Status__c='Approved' and Type_of_Collection__c='Housing' ];                     
               for(Payment_Plan_Line_Items__c ppli : ppliList )    {
               
                   ppli.KIPU_Chart_Audit__c= kipuOppIdMap.get(ppli.Opportunity__c);
                   updatePPLIList.add(ppli);
                   
                   }     
                                                  
               update updatePPLIList;
               
               }
       
       
       
       
       }