public Inherited Sharing class AlumniAppDetail_Selector {
    public AlumniAppDetail_Selector() {

    }
    /*
    @Description : get App detail by userName and Password
    */
    public static List<Alumni_App_Detail__c> getAppDetailByEmail(string userName,string password){

        List<Alumni_App_Detail__c> lstAppDetail = new List<Alumni_App_Detail__c>();

        lstAppDetail = [SELECT ID,Number_of_Days_Sober__c,First_Login__c ,Device_Token__c,(Select ID FROM Alumni_App_Sobriety_Checkins__r WHERE Sobriety_Checkin_Date__c = TODAY)
                                                    FROM Alumni_App_Detail__c WHERE Username__c =: userName
                                                    AND Password__c =: password];
        return lstAppDetail;
    }
    
    /*
    @Description : get App detail by Id
    */
    public static List<Alumni_App_Detail__c> getAppDetailById(string ID){

        List<Alumni_App_Detail__c> lstAppDetail = new List<Alumni_App_Detail__c>();

        lstAppDetail = [SELECT First_Login__c, ID,Number_of_Days_Sober__c,Is_Intake__c,(Select ID FROM Alumni_App_Sobriety_Checkins__r WHERE Sobriety_Checkin_Date__c = TODAY)
                                                    FROM Alumni_App_Detail__c WHERE ID =: ID];
        return lstAppDetail;
    }

    /*
    @Description : get App detail by Id
    */
    public static List<Alumni_App_Detail__c> getUserDetailByUserName(string userName){
        
        return [Select Username__c,User_Email__c,Id,Optp_Token_s__c FROM 
                Alumni_App_Detail__c WHERE Username__c =: userName];
    }

}