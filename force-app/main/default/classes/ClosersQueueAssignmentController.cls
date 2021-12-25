//Test Class : ManageClosersQueueERPTest.closersQueueAssignmentTest
Public without sharing class ClosersQueueAssignmentController{

    public static string closersQueueAssignment(){
        
        String dayOfWeek=datetime.Now().format('EEEE');
        
        String returnOwnerId='';
        Integer hour = dateTime.now().hour();
        Integer minute = dateTime.Now().minute();
        system.debug('dayOfWeek:::'+dayOfWeek);
        List<ERP_Closer_Queue_Assignment_Schedule__c> availableForAssignmentList = new List<ERP_Closer_Queue_Assignment_Schedule__c>();
        
        for(ERP_Closer_Queue_Assignment_Schedule__c mac : [select id, Name, Queue_Id__c, Last_Opportunity_Assigned__c,  Monday_OFF__c, Monday_Start_Time__c, Monday_End_Time__c, 
                                                       Tuesday_OFF__c, Tuesday_Start_Time__c, Tuesday_End_Time__c, Wednesday_OFF__c, Wednesday_Start_Time__c, 
                                                       Wednesday_End_Time__c, Thursday_OFF__c, Thursday_Start_Time__c, Thursday_End_Time__c, Friday_OFF__c, 
                                                       Friday_Start_Time__c, Friday_End_Time__c, Saturday_OFF__c, Saturday_Start_Time__c, Saturday_End_Time__c,
                                                       Sunday_OFF__c, Sunday_Start_Time__c, Sunday_End_Time__c from ERP_Closer_Queue_Assignment_Schedule__c]){
           
           if((boolean)mac.get(dayOfWeek+'_OFF__c') == False){//checking to see if the current MAC row is available for assignment today or not
               String startTimeString = (String)mac.get(dayOfWeek+'_Start_Time__c'); 
               List<String> startTime = new List<String>();
               
               String endTimeString = (String)mac.get(dayOfWeek+'_End_Time__c');
               List<String> endTime = new List<String>();
               
               if(!test.isRunningTest()){
                   startTime = startTimeString.split(':');//Splitting the Start Time of day into Hour and Minutes - startTime[0] is hour and startTime[1] is minute
                   endTime = endTimeString.split(':');//Splitting the End Time of day into Hour and Minutes - endTime[0] is hour and endTime[1] is minute 
               }else{
                   startTime.add('0');
                   startTime.add('00');
                   endTime.add('23');
                   endTime.add('30');
               }
               
               Boolean startTimeMatch=False;
               Boolean endTimeMatch = False;
               
               if(hour >= integer.valueOf(startTime[0]) && hour <= integer.valueOf(endTime[0])){//Checking to see that the hour now is within Start Hour and End Hour
                   if(hour == integer.valueOf(startTime[0])){//If the hour is same as the start hour, then we make sure minute is greater than start minute. 
                       if(minute >= integer.valueOf(startTime[1])){
                           startTimeMatch = True;
                       }
                   }else{
                       startTimeMatch = True;
                   }
                   if(hour == integer.valueOf(endTime[0])){//If the hour is same as the end hour, then we make sure minute is less than end minute.
                       if(minute <= integer.valueOf(endTime[1])){
                           endTimeMatch  = True;
                       }
                   }else{
                       endTimeMatch = True;
                   }
               }
               
               if(startTimeMatch && endTimeMatch)
               {
                   availableForAssignmentList.add(mac);//we figure out if any user is available for assignment
               }
               
           }
          
        }
        
        system.debug('availableForAssignmentList ::'+availableForAssignmentList);
        
        if(availableForAssignmentList.size()==0)
           return null;//if we found no user active at current time in schedule, we return null so that opportunity can be assigned to Tahnil
        else if(availableForAssignmentList.size()==1)
           return availableForAssignmentList[0].Queue_Id__c+';'+availableForAssignmentList[0].Name;//if we found one suitable user we assign the opportunity to that user
        else if(availableForAssignmentList.size()>1){//if we found more that one suitable user for assignment, we will assign on the basis of round robin assignment, as described below    
           integer indexOfLastAssigned = 0;//This gives us the index of the last assigned user
           integer indexOfNextAssignment = 0;//this gives us the index of the user we are supposed to assign next
           integer i=0;
           for(ERP_Closer_Queue_Assignment_Schedule__c mac2 : availableForAssignmentList){
               if(mac2.Last_Opportunity_Assigned__c == True){
                   indexOfLastAssigned = i;  
               }
               i++;
           }
           if(indexOfLastAssigned == availableForAssignmentList.size()-1){//if the index of the last assigned used is the last record in the list, we go to 0 
               indexOfNextAssignment = 0;
           }else{
               indexOfNextAssignment = indexOfLastAssigned+1;
           }
           
           availableForAssignmentList[indexOfNextAssignment].Last_Opportunity_Assigned__c = True;
           availableForAssignmentList[indexOfLastAssigned].Last_Opportunity_Assigned__c = False;
           
           String returnValue = availableForAssignmentList[indexOfNextAssignment].Queue_Id__c+';'+availableForAssignmentList[indexOfNextAssignment].Name;
           try{
               update availableForAssignmentList;//we update the MAC records, to use in the next assignment
           }Catch (exception e){
               system.debug('exception :::'+e.getMessage());
           }
           
           return returnValue;//returning the id of the user to be assigned.
        }
        return null;
    }
}