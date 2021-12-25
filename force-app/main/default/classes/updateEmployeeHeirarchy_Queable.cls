public class updateEmployeeHeirarchy_Queable implements Queueable{
    
    Map<string,string> mapOfHerarchy;
    public updateEmployeeHeirarchy_Queable(Map<string,string> aMapOfHerarchy){  
        mapOfHerarchy = aMapOfHerarchy;
    }

     public void execute(QueueableContext context) {

        
        List<Employee__c> lstEmployee = [Select ID,Ultimate_Parent__c,Supervisor_Name__c FROM
                                         Employee__c WHERE Supervisor_Name__c =:  mapOfHerarchy.keySet()];

        if(lstEmployee.isEmpty()){
            return; // if no child left
        }

        Map<string,string> mapOfNewHerarchy = new Map<string,string>();

        for(Employee__c iEmp : lstEmployee){

            iEmp.Ultimate_Parent__c = mapOfHerarchy.get(iEmp.Supervisor_Name__c);
            mapOfNewHerarchy.put(iEmp.Id,iEmp.Ultimate_Parent__c+'|'+iEmp.Id);

        }
        mapOfHerarchy = null; // dispose the current map

        update lstEmployee;
        if(!test.isRunningTest()){
            System.enqueueJob(new updateEmployeeHeirarchy_Queable(mapOfNewHerarchy)); // call the recursion again to update next level child
        }
    }
}