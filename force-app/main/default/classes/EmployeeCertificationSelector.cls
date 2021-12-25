public Inherited sharing class EmployeeCertificationSelector{

    public static List< Employee_Certifications__c > getCurrentEmployeesCertificaition(Set<string> setOfEmpIds, string certificationId){
        
        return [Select ID, Certification_Cost__c, Employee_Responsibility_Amount__c,
            Related_Employee__r.Certification_Budget_Allocation__c,
            Employee_Budget_Utilized__c FROM Employee_Certifications__c
            where ID !=: certificationId AND Related_Employee__c IN : setOfEmpIds AND Status__c!='Request Denied'];
        
    }
    
}