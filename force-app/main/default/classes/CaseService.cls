/*
TestClass = ClientTicket_CtrlTest
*/
public without sharing class CaseService {
    
    static IConfigRetriever config;
    final static string ASSIGNMENT_CONFIG = 'OwnerAssignmentConfig';

    static{
        config = (IConfigRetriever) Type.forName('CustomMetaDataConfig').newInstance();
    }

    public static void updateCaseEmployee(List<Case> lstCase){

        Case objCase = lstCase[0];
        objCase.AccountId = objCase.Sunshine_Center_Id__c;
        if(!validateCaseRecordType(objCase)){
            return;
        }
        string empName = getOwnerConfigsByDept(objCase);
        if(string.isBlank(empName)){
            return;
        }
        List<Employee__c> lstEmp = new EmployeeSelector().getEmpByName(empName);

        if(lstEmp.isEmpty()){
            return;
        }
        objCase.Ticket_Owner__c = lstEmp[0].Id;
        objCase.Client_Ticker_Owner_Email__c = lstEmp[0].Email__c;
    }

    private static boolean validateCaseRecordType(Case caseObj){

        String recordTypeDevName = Schema.SObjectType.Case.getRecordTypeInfosById().get(caseObj.RecordTypeId).getDeveloperName();
        if(!recordTypeDevName.equals('Client_Tickets')){
            return false;
        }
        return true;
    }

    private static string getOwnerConfigsByDept(Case caseObj){
        
        string jsonConfig =  getConfigs(ASSIGNMENT_CONFIG);
        if(string.isBlank(jsonConfig)){
            return '';
        } 
        Account acc = [Select Name from Account WHERE ID =: caseObj.AccountId];
        Map<string,Map<string,Map<string,string>>> ownerConfigs = convertOwnerConfigs(jsonConfig);
        string empStr = ownerConfigs?.get(acc.Name)?.get(caseObj.Department__c)?.get(caseObj.Specific_Query_Related_to__c);
        return empStr;    
    }

    private static string getConfigs(string configName){
        return (string)config.getConfiguration(configName);
    }

    private static Map<string,Map<string,Map<string,string>>> convertOwnerConfigs(string jsonStr){
        return (Map<string,Map<string,Map<string,string>>>) JSON.deserialize(jsonStr,Map<string,Map<string,Map<string,string>>>.class);
    }



}