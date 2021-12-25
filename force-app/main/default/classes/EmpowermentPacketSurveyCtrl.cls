public with sharing class EmpowermentPacketSurveyCtrl {
    public EmpowermentPacketSurveyCtrl() {

    }

    
    @AuraEnabled
    public static List<Opportunity> GetOpportunityRecord(){
    
      User bhtUser=[select id,Facility__c 
                    from User where id=: UserInfo.getUserId()];
     
       List<Opportunity> validOpportunity= new List<Opportunity>();
       List<Opportunity> dischargedOpportunity= new List<Opportunity>();
       List<Opportunity> allOpportunities= new List<Opportunity>();
     
       validOpportunity = [Select id,
                               Check_Out_Date__c, Name,CloseDate,
                               StageName,Sunshine_Center_Name__c,
                               Last_Survey_date__c,Is_Available_for_Survey__c 
                               from opportunity where 
                               ((StageName='Admitted') OR 
                               (StageName = 'Discharged' AND 
                               Check_Out_Date__c = LAST_N_DAYS:2)) AND
                               Empowerment_Packet_Survey_Created__c = FALSE AND
                               Sunshine_Center_Name__c IN: bhtUser.Facility__c.split(';') order by Name];
                               
       
       return validOpportunity;
         
    } 
    @AuraEnabled
    public static void saveEmpowerment(Empowerment_Packet_Survey__c EmpObj){

        try{
        
         List<Empowerment_Packet_Survey__c> lstEmpSurvey = [Select ID FROM Empowerment_Packet_Survey__c WHERE Related_Opportunity__c =: Id.valueOf(EmpObj.Related_Opportunity__c)
                                                             AND Status__c = 'Incomplete'];
         if(!lstEmpSurvey.isEmpty()){
             delete lstEmpSurvey;
             
         } 
         Opportunity op= [select id, Empowerment_Packet_Survey_Created__c from Opportunity where id=:Id.valueOf(EmpObj.Related_Opportunity__c)];
               op.Empowerment_Packet_Survey_Created__c=true;
               System.debug(op);
               update op;
            insert EmpObj;
        }
        catch(dmlException ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
}