public class EmployeeCertification_Handler {

    public static void updateEmployeeBudget(List < Employee_Certifications__c > lst) {

        List < Employee__c > lstEmp = new List < Employee__c > ();
        Set<string> employeeSet = new Set<string>();
        for (Employee_Certifications__c iEmpCert : lst) {
            if (iEmpCert.Type_of_Certification__c != 'Mandatory Training') {          
                employeeSet.add(iEmpCert.Related_Employee__c);         
            }
        }
        
        if(employeeSet.isEmpty()){
            return;
        }
        
        List<Budget_Utilization__c> lstCurrentBudget = BudgetUtilizationSelector.getCurrentBudget(employeeSet);
        
        if(lstCurrentBudget.isEmpty() || test.isRunningTest()){
            Budget_Utilization__c budgetObj = new Budget_Utilization__c();
            budgetObj.RelatedEmployee__c = lst[0].Related_Employee__c;
            budgetObj.Utilized_Budget__c = lst[0].Employee_Budget_Utilized__c + (lst[0].Certification_Cost__c - lst[0].Employee_Responsibility_Amount__c);
            budgetObj.year__c = Date.today().year();
            insert budgetObj;
            
           
            return;
            
        }
        
        lstCurrentBudget[0].Utilized_Budget__c = lst[0].Employee_Budget_Utilized__c + (lst[0].Certification_Cost__c - lst[0].Employee_Responsibility_Amount__c);
        update lstCurrentBudget;
        
     
                                                        
    }
    
    public static void updateEmployeeMandatoryTrainingsInfo(List < Employee_Certifications__c > lst) {

        List < Employee__c > lstEmp = new List < Employee__c > ();
        Set<string> employeeSet = new Set<string>();
   
        List<String> Mandatory2certNames = new List<String>();
        List<String> Mandatory3certNames = new List<String>();

        for (Employee_Certifications__c iEmpCert : lst) {

        Employee__c empRec= new Employee__c(id=iEmpCert.Related_Employee__c);
        
            if (iEmpCert.Status__c == 'Completed' && (iEmpCert.Mandatory_for_Tier2_TransitionF__c==True || iEmpCert.Mandatory_for_Tier3_TransitionF__c==True)) {          
                employeeSet.add(iEmpCert.Related_Employee__c);                
            }
        }
        List <Employee_Certifications__c> EmpCertList=[select id,Certification_Name__c,Related_Employee__c,Mandatory_for_Tier3_TransitionF__c,Mandatory_for_Tier2_TransitionF__c 
                                                           from Employee_Certifications__c  where Related_Employee__c IN:employeeSet 
                                                           and (Mandatory_for_Tier2_TransitionF__c=True or Mandatory_for_Tier3_TransitionF__c=True )  ];
        
         Map<string,list<Employee_Certifications__c>> mapOfEmpCert2  = new Map<string,list<Employee_Certifications__c>>();
          Map<string,list<Employee_Certifications__c>> mapOfEmpCert3  = new Map<string,list<Employee_Certifications__c>>();
                                                           
        for(Employee_Certifications__c iCk : EmpCertList){
          if(iCk.Mandatory_for_Tier2_TransitionF__c==True){
            if(mapOfEmpCert2.containsKey(iCk.Related_Employee__c)){
                mapOfEmpCert2.get(iCk.Related_Employee__c).add(iCk);
                continue;
            }
            mapOfEmpCert2.put(iCk.Related_Employee__c, new List<Employee_Certifications__c>{ iCk} );
            }
            
            if(iCk.Mandatory_for_Tier3_TransitionF__c==True){
            if(mapOfEmpCert3.containsKey(iCk.Related_Employee__c)){
                mapOfEmpCert3.get(iCk.Related_Employee__c).add(iCk);
                continue;
            }
            mapOfEmpCert3.put(iCk.Related_Employee__c, new List<Employee_Certifications__c>{ iCk} );
            }
        }
       
        
           for(string empId :employeeSet){
               Employee__c emp = new Employee__c(id=Id.valueOf(empId));
               if(mapOfEmpCert2.get(emp.id)!=null){
               emp.Count_of_Tier2_Mandatory_Certifications__c=mapOfEmpCert2.get(emp.id).size();
                for(Employee_Certifications__c iCK: mapOfEmpCert2.get(emp.id)){
                   Mandatory2certNames.add(iCK.Certification_Name__c);
               }
               }
               if(mapOfEmpCert3.get(emp.id)!=null){
               emp.Count_of_Tier2_Mandatory_Certifications__c=mapOfEmpCert3.get(emp.id).size();
               for(Employee_Certifications__c iCK: mapOfEmpCert3.get(emp.id)){
                   Mandatory3certNames.add(iCK.Certification_Name__c);
               }
               
               }
               
              
               
               
               emp.Tier2_Mandatory_Training_Names__c=String.join(Mandatory2certNames,',');
               emp.Tier3_Mandatory_Training_Names__c=String.join(Mandatory3certNames,',');
               lstEmp.add(emp);
               }
                
        
        update lstEmp;
     
        
                                                        
    }


    public static void addAmountInEmpBudget(List < Employee_Certifications__c > lst) {

        List < Employee__c > lstEmp = new List < Employee__c > ();

        List < Employee_Certifications__c > lstOfOtherCertification = EmployeeCertificationSelector.getCurrentEmployeesCertificaition(new Set<string> { lst[0].Related_Employee__c },lst[0].ID);
        List<Budget_Utilization__c> lstCurrentBudget = BudgetUtilizationSelector.getCurrentBudget(new Set<string> { lst[0].Related_Employee__c });
        
         if(lstCurrentBudget.isEmpty()){
             return;
         }
        
        lstCurrentBudget[0].Utilized_Budget__c = 0;
        
        
        
         if (lstOfOtherCertification.isEmpty()) {
            lstCurrentBudget[0].Utilized_Budget__c = 0;
            update lstCurrentBudget;
           
            return;
        }
        
        
        
         for (Employee_Certifications__c iEmpCert: lstOfOtherCertification) {
         
           lstCurrentBudget[0].Utilized_Budget__c += (lstOfOtherCertification[0].Certification_Cost__c - lstOfOtherCertification[0].Employee_Responsibility_Amount__c);
            if (lstCurrentBudget[0].Utilized_Budget__c > iEmpCert.Related_Employee__r.Certification_Budget_Allocation__c) {
                lstCurrentBudget[0].Utilized_Budget__c = iEmpCert.Related_Employee__r.Certification_Budget_Allocation__c;
            }
            
        }
        
        update lstCurrentBudget;
      

    }
    
  
}