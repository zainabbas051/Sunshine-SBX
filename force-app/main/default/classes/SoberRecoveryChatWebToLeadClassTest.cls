@isTest
public class SoberRecoveryChatWebToLeadClassTest
{
    static testMethod void testMe() {

    // create a new email and envelope object
    Messaging.InboundEmail email = new Messaging.InboundEmail() ;
    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
    
    // setup the data for the email
    email.HTMLBody = '<html><Table><tr><td>Name:</td><td>Test</td></Tr><tr><td>Phone:</td><td>586-342-4795</td></Tr><tr><td>Chat Summary</td><td>Test</td></Tr><tr><td>Chat Transcript</td><td>8527834688</td></Tr><Tr><td>Contact Email</td><td> </td></Tr><tr><td>category</td><td>We encourage you to contact this lead in a timely manner.</td></Tr></Table></HTML>';
        
    Test.startTest();
    
        // call the email service class and test it with the data in the testMethod
        SoberRecoveryChatWebToLeadClass instance = new SoberRecoveryChatWebToLeadClass();
        Messaging.InboundEmailResult result = instance.handleInboundEmail(email, env);
    
    Test.stopTest();
    
    }
}