//Test class : Utilities_TempTest
public without sharing class Utilities_Temp {
    
    public static void createPAA (List<Id> idList){
        List<Pre_Admission_Assessment__c > paaRecordList = new List<Pre_Admission_Assessment__c>();
        List<Opportunity> oppUpdateList = new List<Opportunity>();
        for(Pre_Admission_Assessment__c iPre : [Select id, On_Probation_Parole__c, Opportunity__r.Probation_Parole__c, Temp_Flag__c from Pre_Admission_Assessment__c where ID IN: idList]){
            
            iPre.On_Probation_Parole__c=iPre.Opportunity__r.Probation_Parole__c;
            iPre.Temp_Flag__c = True;
            paaRecordList.add(iPre);
        
        }
        if(paaRecordList.size()>0)
            update paaRecordList;
    }     

}