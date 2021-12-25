/*
Client ticket controller used in Client Ticket Module
*/
public without sharing class ClientTicket_Ctrl {
    public ClientTicket_Ctrl() {

    }
    @AuraEnabled
    public static Case getCaseDetail(string recordId){

        if(string.isBlank(recordId)){
            return new Case();
        }
        CaseSelector cs = new CaseSelector();
        return cs.getCaseAllFieldsById(recordId);

    }
    @AuraEnabled
    public static string addComments(string recordId,
                                    string comments,
                                    string employeeId){
        
        string caseCreatedBy = '';
        string notificationEmail = '';
        if(string.isBlank(recordId)){
            return '';
        }
        CaseSelector cs = new CaseSelector();
        Case caseObj = cs.getCaseById(recordId)[0];
        caseCreatedBy = caseObj.Ticket_Created_By__c;
        notificationEmail = caseObj.Ticket_Owner__r.Email__c;
        Case_Comment__c caseCommentObj = new Case_Comment__c();
        caseCommentObj.EmployeeId__c = caseObj.Ticket_Owner__c;
        if(employeeId != null){

            caseCreatedBy  = [Select Name FROM Employee__c
                              WHERE Id =: employeeId limit 1].Name;
            notificationEmail  = caseObj.SuppliedEmail;  
            caseCommentObj.IsEmployee__c = true;
        }
        
        
        caseCommentObj.Case__c = recordId;
        caseCommentObj.Comments__c = comments;
        caseCommentObj.Created_By__c = caseCreatedBy;
        caseCommentObj.Notify_Email__c = notificationEmail;
        insert caseCommentObj;
        return caseCommentObj.Id;
    }

    @AuraEnabled
    public static List<Case_Comment__c> getAllCaseComments(string recordId){

        if(string.isBlank(recordId)){
            return new List<Case_Comment__c>{};
        }
        return [Select Comments__c,CreatedDate,
                Created_By__c FROM Case_Comment__c 
                WHERE Case__c =: recordId order by CreatedDate desc];
    }

    @AuraEnabled
    public static List<Case> getAllCases(Integer pageSize,
                                        Integer pageNumber,
                                        string empId){
        try {   
            CaseSelector cs = new CaseSelector();
            List<Case> lstCases = cs.getCaseByEmpId(pageSize,
                                                    pageNumber,
                                                    empId);
            return lstCases;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
           
        }
    }

    @AuraEnabled
    public static List<Case> getAllCasesByFilter(Integer pageSize,
                                        Integer pageNumber,
                                        string empId,
                                        string filter){
        try {   
            CaseSelector cs = new CaseSelector(); 
            List<Case> lstCases = cs.getCasesByDynamicFilter(pageSize,
                                                    pageNumber,
                                                    empId,
                                                    filter);
            return lstCases;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
           
        }
    }
    
    @AuraEnabled
    public static string updateTicketInfo(Case caseObj){
        update caseObj;
        return '';
    }  
    
    @AuraEnabled
    public static Map<string,string> getEmployeeDetail(string employeeId){

        EmployeeSelector empSelector = new EmployeeSelector();
        Employee__c empObj = empSelector.getEmpById(employeeId)[0];
        
        Map<string,string> mapOptions = new Map<string,string>();
        mapOptions.put(empObj.Supervisor_Name__c,empObj.Supervisor_Name__r.Name);
        return mapOptions;
    } 

    @AuraEnabled
    public static boolean escalateCase(Case caseObj){
        try {
            EmployeeSelector empSelector = new EmployeeSelector();
            Employee__c empObj = empSelector.getEmpById(caseObj.Escalated_To__c)[0];
            caseObj.Escalated_To_Email__c = empObj.Email__c;
            upsert caseObj;
            return true;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<string,string> getSpecificQueryPickList(string sunShineCentre,
                                                string deptName){
        try {
            return ClientTicketServices.getValuesByDepartment(sunShineCentre,
                                                              deptName);
                                                              
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static Map<string,string> getDeptPickList(string sunShineCentre){
        try {
            return ClientTicketServices.getDepartmentPicklist(sunShineCentre);
                                                              
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}