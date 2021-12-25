@isTest
public  class UnclaimContentRequestTest{
    
    static testmethod void TestMethod_Case1(){
        
        test.startTest();
        
        Content_Request__c CR = new Content_Request__c();
        CR.Writer_Status__c = 'Open';
        insert CR;
        
        UnclaimContentRequest.UnclaimContentRequest(CR.id);
        
        test.stoptest();
    }
    static testmethod void TestMethod_Case2(){
        
        test.startTest();
        
        Content_Request__c CR = new Content_Request__c();
        CR.Writer_Status__c = 'Approved for Submission';
        CR.Assigned_Writer__c = UserInfo.getUserId();
        insert CR;
        
        UnclaimContentRequest.UnclaimContentRequest(CR.id);
        
        test.stoptest();
    }
    static testmethod void TestMethod_Case3(){
        
        test.startTest();
        
        Content_Request__c CR = new Content_Request__c();
        CR.Writer_Status__c = 'In Progress';
        CR.Assigned_Writer__c = UserInfo.getUserId();
        insert CR;
        
        UnclaimContentRequest.UnclaimContentRequest(CR.id);
        
        test.stoptest();
    }
}