@isTest
private class Ctrl_Clinical_Certification_Test{
    
    
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
           emp2.Name__c = 'test emp';
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
           insert cert2;
           
            
     
           
           Budget_Utilization__c  BUObj2= new Budget_Utilization__c  ();
           BUObj2.RelatedEmployee__c=emp2.id;
           BUObj2.Year__c=2020;
           BUObj2.Utilized_Budget__c=5;
           BUObj2.Available_Budget__c=450;
           insert BUObj2;
           
           Employee_Certifications__c empCert = new Employee_Certifications__c();
           empCert.Related_Employee__c = emp.Id;
           empCert.Related_Certification__c = cert.Id;
           empCert.Type_of_Certification__c='Staff Requested';
           
           insert empCert;
           
           Budget_Utilization__c  BUObj= new Budget_Utilization__c  ();
           BUObj.RelatedEmployee__c=emp.id;
           BUObj.Year__c=2020;
           BUObj.Utilized_Budget__c=5;
           BUObj.Available_Budget__c=450;
           insert BUObj;
           
           Employee_Certifications__c empCert2 = new Employee_Certifications__c();
           empCert2.Related_Employee__c = emp2.Id;
           empCert2.Related_Certification__c = cert2.Id;
           
           insert empCert2;
           
           Employee_Certifications__c empCert3 = new Employee_Certifications__c();
           empCert3.Related_Employee__c = emp.Id;
           empCert3.Related_Certification__c = cert2.Id;
           
           insert empCert3;
          
    }
       
     @isTest static void myTest() {
            
            Employee__c emp = [Select id from Employee__c where Supervisor_Name__c != '' limit 1];
            Employee_Certifications__c empCert = [Select id from Employee_Certifications__c limit 1];
          
            Ctrl_Clinical_Certification.GetAvailableCertification(emp.Id,'Tier 2','Monarch Shores');
            Ctrl_Clinical_Certification.GetNumberofCertifications(emp.Id);
            Ctrl_Clinical_Certification.GetAllCertification();
            Ctrl_Clinical_Certification.getEmployeeDetail(emp.Id);
            Ctrl_Clinical_Certification.GetApplaiedCertification(emp.Id);
            Ctrl_Clinical_Certification.GetOngoingCertification(emp.Id);
            Ctrl_Clinical_Certification.GetCompletedCertification(emp.Id);
            Ctrl_Clinical_Certification.GetRejectedCertification(emp.Id);
            Ctrl_Clinical_Certification.GetReinbursementCertification(emp.Id);
            Ctrl_Clinical_Certification.CompleteCertification(empCert.Id);
            Ctrl_Clinical_Certification.cancelCertificationRequest(empCert.Id);
            Ctrl_Clinical_Certification.isStaff(emp.Id);
            Ctrl_Clinical_Certification.getBudgetDetail(emp.Id);
            Ctrl_Clinical_Certification.getEmployeeProfileInfo(emp.Id);
            Ctrl_Clinical_Certification.getEnableRequestBtn(emp.Id);
            Ctrl_Clinical_Certification.updateEmployee(emp);
            
            Employee__c ec= Ctrl_Clinical_Certification.Login('safia.osman@hotmail.com','w123','{ "ip": "182.189.4.116", "city": "Karachi", "region": "Sindh", "country": "PK", "loc": "24.8608,67.0104", "org": "AS132165 Connect Communications", "postal": "59201", "timezone": "Asia/Karachi", "readme": "https://ipinfo.io/missingauth" }');
            Ctrl_Clinical_Certification.SendResetPasswordEmail('safia.osman@hotmail.com');
            Ctrl_Clinical_Certification.ResetPassword(emp.Id,'123');
    
           
           
            
    }
    
      @isTest static void myTestSup() {
            
            Employee__c supEmp = [Select id from Employee__c where Supervisor_Name__c = '' limit 1];
          
            Ctrl_Clinical_Certification.GetSupervisorSummary(supEmp.Id);
            Ctrl_Clinical_Certification.GetReportingEmployees(supEmp.Id);
            Ctrl_Clinical_Certification.getTeir2Employees(supEmp.Id);
            Ctrl_Clinical_Certification.getTeir3Employees(supEmp.Id);
            Ctrl_Clinical_Certification.getManualTierTransitEmployees(supEmp.Id);
            Ctrl_Clinical_Certification.getEmployees(supEmp.Id);
            Ctrl_Clinical_Certification.isStaff(supEmp.Id);
            Ctrl_Clinical_Certification.getEmployeeList(supEmp.Id);
            Ctrl_Clinical_Certification.getCertificationRequests(supEmp.Id);
            Ctrl_Clinical_Certification.getCompletedCertificationRequests(supEmp.Id);   
                 
    }
    
     @isTest static void myCreateTest() {
            
            Employee__c Emp = [Select id from Employee__c where Supervisor_Name__c != '' limit 1];
            Certifications__c cert = [Select id from Certifications__c limit 1];
            Ctrl_Clinical_Certification.createCertificationRequest(Emp.Id, cert.Id, 'Employee', 5, true, true);
         
    }
    
    
     @isTest static void myApproveCert() {
     
         
          Employee_Certifications__c empCert = [Select id,status__c ,Reimbursement_Request_Status__c from Employee_Certifications__c limit 1];
           Employee__c supEmp = [Select id from Employee__c where Supervisor_Name__c = '' limit 1];
           empCert.status__c = 'Completed';
           empCert.Reimbursement_Request_Status__c = 'Submitted';
           
          Ctrl_Clinical_Certification.approveCertification(new List<Employee_Certifications__c>  {empCert},supEmp.Id);
          empCert.status__c = 'Requested';
           Ctrl_Clinical_Certification.approveCertification(new List<Employee_Certifications__c>  {empCert},supEmp.Id);
           empCert.status__c = 'Submitted For Completion';
          
            Ctrl_Clinical_Certification.approveCertification(new List<Employee_Certifications__c>  {empCert},supEmp.Id);
            Ctrl_Clinical_Certification.updateOngoingCertifications(empCert.id, 'Completed', 'test.com', Date.Today());
            //Ctrl_Clinical_Certification.updateOngoingCertifications(empCert.id, 'Request Reinbursement', 'test.com', Date.Today());
         
    }
    
     @isTest static void myRejectCert() {
     
         
          Employee_Certifications__c empCert = [Select id,status__c ,Reimbursement_Request_Status__c from Employee_Certifications__c limit 1];
           Employee__c supEmp = [Select id from Employee__c where Supervisor_Name__c = '' limit 1];
           empCert.status__c = 'Completed';
           empCert.Reimbursement_Request_Status__c = 'Submitted';
           
          Ctrl_Clinical_Certification.rejectCertification(new List<Employee_Certifications__c>  {empCert},supEmp.Id);
          empCert.status__c = 'Requested';
           Ctrl_Clinical_Certification.rejectCertification(new List<Employee_Certifications__c>  {empCert},supEmp.Id);
           empCert.status__c = 'Submitted For Completion';
          
            Ctrl_Clinical_Certification.rejectCertification(new List<Employee_Certifications__c>  {empCert},supEmp.Id);
         
    }

}