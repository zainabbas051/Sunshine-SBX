//test class : SendEmailConfirmation_CtrlTest
public inherited sharing class HousingPPLIService{
    

    public static void updateRelatedKIPUAuditChart(List<Payment_Plan_Line_Items__c> lstPPLI){
    Map<String,ID> mapofOppotunity= new Map<String,ID>();
    List<Payment_Plan_Line_Items__c> updatePPLIList = new List<Payment_Plan_Line_Items__c>();
    for(Payment_Plan_Line_Items__c ppli : lstPPLI){
        if(mapofOppotunity.containsKey(ppli.Id) == False){
                    mapofOppotunity.put(ppli.Opportunity__c,ppli.Id);
                    }
                    
                    
    }
    
    List<KIPU_Chart_Audit__c> kipuList= new List<KIPU_Chart_Audit__c>();
    
    kipuList=[select id, Opportunity__c from KIPU_Chart_Audit__c where Opportunity__c IN: mapofOppotunity.KeySet()];
    Map<String,ID> kipuOppIdMap = new Map<String,ID>();
              for(KIPU_Chart_Audit__c kipu :  kipuList){
              
                  if(kipuOppIdMap.containsKey(kipu.Id) == False){
                    kipuOppIdMap.put(kipu.Opportunity__c,kipu.Id);
              
              
              
              }
              }
              
              for(Payment_Plan_Line_Items__c ppli : lstPPLI )    {
               
                   Payment_Plan_Line_Items__c ppliNew = new Payment_Plan_Line_Items__c();
                   ppliNew.id=ppli.id;
                   ppliNew.KIPU_Chart_Audit__c= kipuOppIdMap.get(ppli.Opportunity__c);
                   updatePPLIList.add(ppliNew);
                   
                   }     
                                                  
               update updatePPLIList;
               
    
    }
    }