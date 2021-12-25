@isTest
public class allergiesTest {
    
    public static account a;
    public static Client_Chart__c cl;
    public static Allergies__c al;
    
    public static void createSampleData(){
         a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
         al = new Allergies__c();
         al.Client_Chart__c = cl.id;
         insert al;
         
    }
    
    static testMethod void testCase1(){
        
         test.startTest();
         
             createSampleData();
             
             ApexPages.CurrentPage().getParameters().put('id',cl.id);
             
             allergies alg = new allergies();
             
             alg.AddMoreAllergies();
             
             alg.s= '0';
             alg.UpdateAllergy();
             
             alg.SaveAllergy();
             
             alg.RemoveAllergy();
             
         test.stopTest();
        
    }
}