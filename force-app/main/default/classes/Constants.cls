//Test Class : ConstantsTest
public class Constants
{
    
    public static ID insuranceClaimRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();//Getting the id of Insurance Claim Case Record Type
    public static ID sfSupportCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SF Support Case').getRecordTypeId();//Getting the id of Insurance Claim Case Record Type
    
    
    // Task Record Type for TxDc Plans Target Dates
    public static final Id TaskTxDcPlansRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('TxDC Plans Target Dates').getRecordTypeId();
    
    // Incident_Report__c Record Type for TxDc Plans Target Dates
    public static final Id IR_MedicationIncidentAttachmentRecordTypeId = Schema.SObjectType.Incident_Report__c.getRecordTypeInfosByName().get('Medication Incident Attachment').getRecordTypeId();
    public static final Id IR_MedicationIncidentReportRecordTypeId = Schema.SObjectType.Incident_Report__c.getRecordTypeInfosByName().get('Medication Incident Report').getRecordTypeId();
    
    // PHI Log Record Type ID's
    public static final Id PhiLogAuthRecordTypeId = Schema.SObjectType.PHI_Log__c.getRecordTypeInfosByName().get('Authorization for Release of Confidential Information').getRecordTypeId();
    
    // Utilization Review Record Type ID's
    public static final Id ConcurrentReviewRecordTypeId = Schema.SObjectType.Utilization_Review__c.getRecordTypeInfosByName().get('Concurrent Review').getRecordTypeId();
    public static final Id UtilizationReviewRecordTypeId = Schema.SObjectType.Utilization_Review__c.getRecordTypeInfosByName().get('Utilization Review').getRecordTypeId();
    
    // Contact Record Type ID's
    public static final Id InsuranceCaseManagerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Insurance Case Manager').getRecordTypeId();
    
    // freepu Amazon File server credentials
    final static string BUCKETNAME = 'FREEPU';
    static awsBucket__c AmazonBucketValue = awsBucket__c.getValues(BUCKETNAME);

    // To keep words for digits
    public static Map<Integer, String> mapDigitsWords;
    
    public static Map<Integer, String> LoadDigitsWords(){
    
        mapDigitsWords = new Map<Integer, String>();
        
        mapDigitsWords.put(1,'One');
        mapDigitsWords.put(2,'Two');
        mapDigitsWords.put(3,'Three');
        mapDigitsWords.put(4,'Four');
        mapDigitsWords.put(5,'Five');
        mapDigitsWords.put(6,'Six');
        mapDigitsWords.put(7,'Seven');
        mapDigitsWords.put(8,'Eight');
        mapDigitsWords.put(9,'Nine');
        mapDigitsWords.put(10,'Ten');
        mapDigitsWords.put(11,'Eleven');
        mapDigitsWords.put(12,'Tweleve');
        mapDigitsWords.put(13,'Thirteen');
        mapDigitsWords.put(14,'Fourteen');
        mapDigitsWords.put(15,'Fifteen');
        
        return mapDigitsWords;
    }
    // To keep digits for words
    public static Map<String,Integer> mapWordsDigit;
    
    public static Map<String,Integer> LoadWordsDigit(){
    
        mapWordsDigit = new Map<String,Integer>();
        
        mapWordsDigit.put('One',1);
        mapWordsDigit.put('Two',1);
        mapWordsDigit.put('Three',3);
        mapWordsDigit.put('Four',4);
        mapWordsDigit.put('Five',5);
        mapWordsDigit.put('Six',6);
        mapWordsDigit.put('Seven',7);
        mapWordsDigit.put('Eight',8);
        mapWordsDigit.put('Nine',9);
        mapWordsDigit.put('Ten',10);
        mapWordsDigit.put('Eleven',11);
        mapWordsDigit.put('Tweleve',12);
        mapWordsDigit.put('Thirteen',13);
        mapWordsDigit.put('Fourteen',14);
        mapWordsDigit.put('Fifteen',15);
        
        return mapWordsDigit;
    }
    public static string accessKeyId  = AmazonBucketValue.accessKeyId__c;
    public static string secretAccessKey = AmazonBucketValue.secretAccessKey__c;
    public static string OrgName = 'sandbox3';
}