//Test Class : BizibleTouchpointUtilityTest
public without sharing class BizibleTouchpointUtility {
    public static Opportunity updateOpp (Id oppId, bizible2__Bizible_Touchpoint__c bt){
         if(oppId != null && bt.id != null){
            Opportunity tempOpp = new Opportunity(id=oppId);
            tempOpp.Bizible_Ad_Campaign_Name__c = bt.bizible2__Ad_Campaign_Name__c;
            tempOpp.Bizible_Ad_Content__c = bt.bizible2__Ad_Content__c;
            tempOpp.Bizible_Ad_Destination_URL__c = bt.bizible2__Ad_Destination_URL__c;
            tempOpp.Bizible_Ad_Group_Name__c = bt.bizible2__Ad_Group_Name__c;
            tempOpp.Bizible_Browser__c = bt.bizible2__Browser__c;
            tempOpp.Bizible_Form_URL__c = bt.bizible2__Form_URL__c;
            tempOpp.Bizible_Geo_City__c = bt.bizible2__Geo_City__c;
            tempOpp.Bizible_Geo_Country__c = bt.bizible2__Geo_Country__c;
            tempOpp.Bizible_Geo_Region__c = bt.bizible2__Geo_Region__c;
            tempOpp.Bizible_Keyword_Text__c = bt.bizible2__Keyword_Text__c;
            tempOpp.Bizible_Landing_Page__c = bt.bizible2__Landing_Page__c;
            tempOpp.Bizible_Marketing_Channel_Path__c = bt.bizible2__Marketing_Channel_Path__c;
            tempOpp.Bizible_Marketing_Channel__c = bt.bizible2__Marketing_Channel__c;
            tempOpp.Bizible_Medium__c = bt.bizible2__Medium__c;
            tempOpp.Bizible_Platform__c = bt.bizible2__Platform__c;
            tempOpp.Bizible_Referrer_Page__c = bt.bizible2__Referrer_Page__c;
            tempOpp.Bizible_Segment__c = bt.bizible2__Segment__c;
            tempOpp.Bizible_Touchpoint_Position__c = bt.bizible2__Touchpoint_Position__c;
            tempOpp.Bizible_Touchpoint_Source__c = bt.bizible2__Touchpoint_Source__c;
            tempOpp.Bizible_Touchpoint_Type__c = bt.bizible2__Touchpoint_Type__c;
            tempOpp.Bizible_UniqueId__c = bt.bizible2__UniqueId__c;
            return tempOpp;   
         } 
         return null;   
    }
}