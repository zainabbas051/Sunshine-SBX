public  inherited sharing class CaseSelector extends QuerySelector {
    
    Schema.SObjectType getSObjectType(){
        return Case.SObjectType;
    }

    List<Schema.SObjectField> getSObjectFieldList(){

        return new List<Schema.SObjectField> {
            Case.Id,
            Case.Ticket_Owner__c,
            Case.Ticket_Created_By__c,
            Case.CaseNumber,
            Case.Subject,
            Case.Description,
            Case.Status,
            Case.Escalated__c,
            Case.Case_Resolution__c,
            Case.ClosedDate };
    
    }

    public List<Case> getCaseById(string recordId){
        
        string extraFields = 'Ticket_Owner__r.Email__c,SuppliedEmail';
        return Database.query(newQueryFactory(extraFields).setConditions('Id =: recordId').toSoql());
    }

    public  List<Case> getCaseByEmpId(Integer pageSize,
                                            Integer pageNumber,
                                            string empId){
        
        string filter = 'Open';
        string empIdFilter = string.format('%{0}%',new List<string> { empId });
        Integer offset = (pageNumber - 1) * pageSize;
        return Database.query(newQueryFactory().setConditions('(Ticket_Owner__r.Ultimate_Parent__c like : empIdFilter OR Ticket_Owner__c =: empId) AND Status = :filter').setLimit(pageSize).offSet(offset).toSoql());        
    }

     public  List<Case> getCasesByDynamicFilter(Integer pageSize,
                                            Integer pageNumber,
                                            string empId,
                                            string filter ){

        Integer offset = (pageNumber - 1) * pageSize;
        string empIdFilter = string.format('%{0}%',new List<string> { empId });
        string queryFilter = '(Ticket_Owner__r.Ultimate_Parent__c like :empIdFilter OR Ticket_Owner__c =: empId) AND Status = :filter';
            
        if(filter.equals('Escalated'))
            queryFilter = '(Ticket_Owner__r.Ultimate_Parent__c like :empIdFilter OR Ticket_Owner__c =: empId) AND Escalated__c = true';
            
        if(filter.equals('All'))
            queryFilter = '(Ticket_Owner__r.Ultimate_Parent__c like :empIdFilter OR Ticket_Owner__c =: empId)';

        return Database.query(newQueryFactory().setConditions(queryFilter).setLimit(pageSize).offSet(offset).toSoql());        
                
    }
    
    public case getCaseAllFieldsById(string recordId){
        
        string extraFields = 'Ticket_Owner__r.Name,Department__c,Specific_Query_Related_to__c,Priority,';
        extraFields +='Escalated_Date_Time__c,Time_Since_Ticket_Opened__c,CreatedDate,';
        extraFields += 'Time_Taken_to_Resolve__c,Escalated_To__r.Name,Ticket_Owner__r.Sunshine_Center_Relation_To__r.Name';
       
       return (Case)Database.query(newQueryFactory(extraFields).setConditions('Id =: recordId').toSoql())[0];
                
    }

}