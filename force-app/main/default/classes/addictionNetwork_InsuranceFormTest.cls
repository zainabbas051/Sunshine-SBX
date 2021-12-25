@istest
public class addictionNetwork_InsuranceFormTest{
    
    static testMethod void  addictionNetwork_InsuranceForm(){
        Test.startTest();
       
       //As Per Best Practice it is important to instantiate the Rest Context 
       
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
             
       req.requestURI = '/services/apexrest/an_insurance_form';  //Request URL
       req.httpMethod = 'POST';//HTTP Request Type
       RestContext.request = req;
       RestContext.response= res;
    
       addictionNetwork_InsuranceForm.ReturnClass results = addictionNetwork_InsuranceForm.createNewLead('Naveen', 'Chugh', 'chugh.naveen@gmail.com', '5963424795', 
                                                                                                         'Naveen', 'Chugh', '04/08/1988', 'Naveen', 'Chugh', '04/08/1988', 
                                                                                                         '1234', 'United Healthcare', '123456', '1234', '5863424795', 'test comments');

       system.assertEquals(results.statusCode,'Done');
       
       
       Test.stopTest();
   }

}