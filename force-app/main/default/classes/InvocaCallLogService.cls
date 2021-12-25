public inherited sharing class InvocaCallLogService {
    

    public static void updateCustomerBusinessObjectValue(List<INVOCA_FOR_SF__Invoca_Call_Log__c> lstInvoca,
                                                        Map<Id,INVOCA_FOR_SF__Invoca_Call_Log__c> oldMap){

           /* update */
       Map<Id,String> leadIdMap2 = new Map<id,String>();
       Map<Id,String> OppIdMap = new Map<id,String>();
       for(INVOCA_FOR_SF__Invoca_Call_Log__c iInvoca : lstInvoca){
           
         
           boolean isValid = !String.isBlank(iInvoca.INVOCA_FOR_SF__Customer_Business_Object_Name_4__c) && 
                              iInvoca.INVOCA_FOR_SF__Customer_Business_Object_Name_4__c.equals('shortcode_type') && 
                              (oldMap == null || (oldMap != null && String.isBlank(oldMap.get(iInvoca.Id).INVOCA_FOR_SF__Lead__c))) && 
                              !String.isBlank(iInvoca.INVOCA_FOR_SF__Lead__c);
                            
            if(isValid){       
                leadIdMap2.put(iInvoca.INVOCA_FOR_SF__Lead__c,iInvoca.INVOCA_FOR_SF__Customer_Business_Object_Value_4__c );               
            }
           
           isValid = (oldMap == null ||(oldMap != null && String.isBlank(oldMap.get(iInvoca.Id).INVOCA_FOR_SF__Opportunity__c))) &&
                     !String.isBlank(iInvoca.INVOCA_FOR_SF__Opportunity__c) &&
                     iInvoca.INVOCA_FOR_SF__Customer_Business_Object_Name_4__c.equals('shortcode_type');
           
            if(isValid){         
                OppIdMap.put(iInvoca.INVOCA_FOR_SF__Opportunity__c,iInvoca.INVOCA_FOR_SF__Customer_Business_Object_Value_4__c );     
           }
       }
       updateLeads(leadIdMap2);   
       updateOpportunities(OppIdMap);                                         
    }

    private static void updateLeads(Map<Id,String> leadIdMap){

        List<Lead> lstLead = new List<Lead>();

        for(string key : leadIdMap.keySet()){
            Lead l = new Lead();
            l.Id = key;
            l.Shortcode_Button_Clicked__c = leadIdMap.get(key);
            lstLead.add(l);
        }

        update lstLead;

    }

    private static void updateOpportunities(Map<Id,String> OppIdMap){

        List<Opportunity> lstOppty = new List<Opportunity>();

        for(string key : OppIdMap.keySet()){
            Opportunity o = new Opportunity();
            o.Id = key;
            o.Shortcode_Button_Clicked__c = OppIdMap.get(key);
            lstOppty.add(o);
        }

        update lstOppty;

    }
}