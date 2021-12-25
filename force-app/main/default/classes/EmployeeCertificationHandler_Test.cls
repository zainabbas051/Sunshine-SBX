@isTest
private class EmployeeCertificationHandler_Test{

     @TestSetup
    static void createTestData() {
            
           Employee__c supvisor = new Employee__c();
           supvisor.Name__c = 'supervisor';
           supvisor.Designation__c = 'bht';
           supvisor.email__c = 'safia.osman@hotmail.com';
           insert supvisor;
           
           Employee__c emp = new Employee__c();
           emp.Name__c = 'test emp';
           emp.Designation__c = 'bht';
           emp.email__c = 'safia.osman@hotmail.com';
           emp.supervisor_name__c = supvisor.Id;
           emp.Username__c='safia.osman@hotmail.com';
           emp.Password__c='w123';
           insert emp;
           
           Employee__c emp2 = new Employee__c();
           emp2.Name__c = 'test emp 1';
           emp2.Designation__c = 'bht';
           emp2.email__c = 'safia.osman@hotmail.com';
           emp2.supervisor_name__c = supvisor.Id;
           emp2.Tier_2_Transition_Eligible_Date__c = Date.Today();
           emp2.Tier_2_Transition_Date__c=null;
           emp2.Tier_Allocation__c='Tier 1';
           emp2.Count_of_Tier2_Mandatory_Certifications__c=1;
           insert emp2;
           
           Certifications__c cert = new Certifications__c();
           cert.Certification_Name__c = 'CERT2';
           cert.Allocated_Tiers__c = 'Tier 2';
           cert.Certification_Cost__c = 55;
           insert cert;
           
           Certifications__c cert2 = new Certifications__c();
           cert2.Certification_Name__c = 'Mandatory for T2';
           cert2.Allocated_Tiers__c = 'Tier 2';
           cert2.Certification_Cost__c = 55;
           cert2.Mandatory_for_Tier_2_Transition__c=true;
          // cert2.status__c = 'Completed';
           insert cert2;
           
          
    }
    
     @isTest static void myTest() {
            
          Employee__c emp = [Select id from Employee__c where Supervisor_Name__c != '' limit 1];
          Certifications__c cert = [Select id from Certifications__c where Mandatory_for_Tier_2_Transition__c = true limit 1];
          
           Employee_Certifications__c empCert = new Employee_Certifications__c();
           empCert.Related_Employee__c = emp.Id;
           empCert.Related_Certification__c = cert.Id;
           empCert.Type_of_Certification__c='Staff Requested';
           
           insert empCert;
           
           empCert.status__c = 'Completed';
           
           update empCert;
          
    }
    
     @isTest static void myTest1() {
            
          Employee__c emp = [Select id from Employee__c where Supervisor_Name__c != '' limit 1];
          Certifications__c cert = [Select id from Certifications__c where Mandatory_for_Tier_2_Transition__c = true limit 1];
          
           Employee_Certifications__c empCert = new Employee_Certifications__c();
           empCert.Related_Employee__c = emp.Id;
           empCert.Related_Certification__c = cert.Id;
           empCert.Type_of_Certification__c='Staff Requested';
           
           insert empCert;
           
           empCert.status__c = 'Request Denied';
           
           update empCert;
          
    }
    
    
     @isTest static void myTest2() {
            
          Employee__c emp = [Select id from Employee__c where Supervisor_Name__c != '' limit 1];
          Certifications__c cert = [Select id from Certifications__c where Mandatory_for_Tier_2_Transition__c = true limit 1];
          
           Employee_Certifications__c empCert = new Employee_Certifications__c();
           empCert.Related_Employee__c = emp.Id;
           empCert.Related_Certification__c = cert.Id;
           empCert.Type_of_Certification__c='Staff Requested';
           
           insert empCert;
           
            Employee_Certifications__c empCert1 = new Employee_Certifications__c();
           empCert1.Related_Employee__c = emp.Id;
           empCert1.Related_Certification__c = cert.Id;
           empCert1.Type_of_Certification__c='Staff Requested';
           
           insert empCert1;
           
           empCert1.status__c = 'Request Denied';
           
           update empCert1;         
    }
    
     @isTest static void myTest3() {
            
          Employee__c emp = [Select id from Employee__c where Name__c = 'test emp 1' limit 1];
          
           Employee__c supvisor = new Employee__c();
           supvisor.Name__c = 'supervisor2';
           supvisor.Designation__c = 'bht';
           supvisor.email__c = 'safia.osman@hotmail.com';
           insert supvisor;
           
           emp.supervisor_name__c = supvisor.Id;
           update emp;  
           
           test.startTest();
           Map<string,string> mapOfNewHerarchy = new Map<string,string>();
           mapOfNewHerarchy.put(supvisor.Id,supvisor.Id);
           System.enqueueJob(new updateEmployeeHeirarchy_Queable(mapOfNewHerarchy)); // call the recursion again to update next level child
           
           test.stopTest();  
                      
    }
}