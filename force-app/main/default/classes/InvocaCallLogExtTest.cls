@isTest()
public class InvocaCallLogExtTest {
    
      static testmethod void test1(){
        
        INVOCA_FOR_SF__Invoca_Call_Log__c i = new INVOCA_FOR_SF__Invoca_Call_Log__c();
        i.INVOCA_FOR_SF__transaction_id__c = '7735C7DB-F15CCE84';
        insert i;
        
        InvocaCallLogExt InvocaCallLog = new InvocaCallLogExt(new ApexPages.StandardController(i));
        
    }
}