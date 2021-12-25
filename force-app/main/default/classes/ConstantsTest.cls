@isTest(SeeAllData = True)
private class ConstantsTest{
    public Static testmethod void Constants_Class(){
        test.startTest();
            id var1 = Constants.TaskTxDcPlansRecordTypeId;
            string accessKeyId = Constants.accessKeyId;   
            string secretAccessKey = Constants.secretAccessKey;
            string OrgName = Constants.OrgName; 
            Map<Integer, String> tempMap = Constants.LoadDigitsWords();
            Map<String,Integer> tempMap2 = Constants.LoadWordsDigit();
            id var2 = Constants.insuranceClaimRecordTypeId;  
            id var3 = Constants.sfSupportCaseRecordTypeId; 
            id var5 = Constants.ConcurrentReviewRecordTypeId; 
            id var6 = Constants.InsuranceCaseManagerRecordTypeId; 
            
        test.StopTest();
    }
}