/*
TestClass = ClientTicket_CtrlTest
*/
public inherited sharing class EmployeeSelector extends QuerySelector {
    
    Schema.SObjectType getSObjectType(){
        return Employee__c.SObjectType;
    }

    List<Schema.SObjectField> getSObjectFieldList(){

        return new List<Schema.SObjectField> {
            Employee__c.Id,
            Employee__c.Supervisor_Name__c,
            Employee__c.Email__c

        };
    
    }
    public List<Employee__c> getEmpById(string recordId){
        
        string extraFields = 'Supervisor_Name__r.Name';
        return (List<Employee__c>)Database.query(newQueryFactory(extraFields).setConditions('Id =: recordId').toSoql());
    }

    public List<Employee__c> getEmpByName(string empName){
        
        return (List<Employee__c>)Database.query(newQueryFactory().setConditions('Name =: empName').toSoql());
    }
}