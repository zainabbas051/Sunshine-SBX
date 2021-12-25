@istest
public class addictionNetwork_ContactUsTest{
    
    static testMethod void  addictionNetwork_ContactUs(){
        Test.startTest();
       
       //As Per Best Practice it is important to instantiate the Rest Context 
       
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
             
       req.requestURI = '/services/apexrest/an_insurance_form';  //Request URL
       req.httpMethod = 'POST';//HTTP Request Type
       RestContext.request = req;
       RestContext.response= res;
    
       addictionNetwork_ContactUs.ReturnClass results = addictionNetwork_ContactUs.createNewLead('Naveen', 'Chugh', 'chugh.naveen@gmail.com', '5963424795', 'test comments');

       system.assertEquals(results.statusCode,'Done');
       
       
       Test.stopTest();
   }

}