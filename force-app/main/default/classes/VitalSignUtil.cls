public  with sharing  class VitalSignUtil{
    private static boolean Isexsist= true;
    
    public VitalSignUtil(){}

    public static boolean IsVitalSignExsist(string CCID){
        string VSID= [ SELECT Id FROM Recurring_Assessment__c 
                   WHERE RecordType.DeveloperName='Vital_Signs' and Client_Chart__c=:CCId and Status__c!='Closed'].id;
        
        if (VSID!=null)
            return Isexsist;
        else 
            return Isexsist;
               
    
    }
    


}