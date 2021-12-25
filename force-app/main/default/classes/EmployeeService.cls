public class EmployeeService implements Queueable{

    
    Employee__c tempSuperVisor;
    string tempParentId;
    public static void updateEmpTierFields(List<Employee__c> lstEmp){
          
          for(Employee__c iEmp : lstEmp){
              
              iEmp.Tier_2_Transition_Eligible_Date__c = (iEmp.Employment_Start_Date__c != null) ? iEmp.Employment_Start_Date__c.addMonths(6) : null;
              iEmp.Tier_3_Transition_Eligible_Date__c = (iEmp.Employment_Start_Date__c!= null) ? iEmp.Employment_Start_Date__c.addYears(1) : null;
             
          
          }
    
    
    }
    
    public static void createBudgetRecord(List<Employee__c> lstEmp){
    
        List<Budget_Utilization__c> budgetList = new List<Budget_Utilization__c>();
    
        for(Employee__c a : lstEmp)
        {
           Budget_Utilization__c budget = new Budget_Utilization__c ();
           budget.RelatedEmployee__c = a.id;
           budget.Year__c= System.Today().year();
           
           budget.Name = 'Budget-'+System.Today().year(); 
           integer budgetAllocation;
           switch on a.Tier_Allocation__c {
            when 'Tier 1' {       // when block 1
                budgetAllocation=Integer.ValueOf(Label.Tier_1_Budget);
            }   
            when 'Tier 2' {       // when block 2
                budgetAllocation=Integer.ValueOf(Label.Tier_2_Budget);
            }
            when 'Tier 3' {       // when block 3
                budgetAllocation=Integer.ValueOf(Label.Tier_3_Budget);
            }
            when else {       // default block, optional
                budgetAllocation=0;
            }
               
        }
        budget.Available_Budget__c=budgetAllocation;
        budgetList.add(budget); 
        
    
        insert budgetList;
        }
    }
    
    public static void resetUltimateParent(Employee__c empObj,Employee__c oldEmp){
      
      if(empObj.Supervisor_Name__c != oldEmp.Supervisor_Name__c && empObj.Supervisor_Name__c == null ){
          
           empObj.Ultimate_Parent__c = '';
 
      }
        
    }
    
    public static void updateCompleteEmployeeHeirarchy(Employee__c empObj,Employee__c oldEmp){

      if(oldEmp != null && empObj.Supervisor_Name__c == oldEmp.Supervisor_Name__c ){
            return;
      }

     /* List<Employee__c> childRecords = [Select ID,Ultimate_Parent__c,Supervisor_Name__c FROM
                                         Employee__c WHERE Supervisor_Name__c  =: empObj.Id];

      if(childRecords.isEmpty()){
        return; // if there is no child record dont do any thing
      }*/
      

      if(empObj.Supervisor_Name__c == null){
         System.enqueueJob(new EmployeeService(empObj));
         return;

      }
      //traverse to the top gradually
      Employee__c empSuperVisor = [Select ID,Ultimate_Parent__c,Supervisor_Name__c FROM
                                         Employee__c WHERE Id  =: empObj.Supervisor_Name__c LIMIT 1];


      System.enqueueJob(new EmployeeService(empSuperVisor));

     }
    
    public  EmployeeService(Employee__c empSuperVisor){

        tempSuperVisor = empSuperVisor;
   
    }

    public void execute(QueueableContext context) {

        
        if(tempSuperVisor.Supervisor_Name__c == null){
           
            updateEmployeeHeirarchyChild(tempSuperVisor.Id); // this mean that this is the top Parent Id
            return;
        }
        Employee__c empSuperVisor = [Select ID,Ultimate_Parent__c,Supervisor_Name__c FROM
                                         Employee__c WHERE Id  =: tempSuperVisor.Supervisor_Name__c LIMIT 1];

        if(Limits.getQueueableJobs() < Limits.getLimitQueueableJobs()){
          System.enqueueJob(new EmployeeService(empSuperVisor)); // call the recursion again
        }

    }

    void updateEmployeeHeirarchyChild(string topParentId){
        
        if(!test.isRunningTest()){
           
             System.enqueueJob(new updateEmployeeHeirarchy_Queable(new Map<string,string> {topParentId => topParentId})); // call the recursion again
       
        }
        
    }

}