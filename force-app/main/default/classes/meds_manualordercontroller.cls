/*
    controller class for Meds_ManualOrder vf component.
    @author: Huma Zafar
*/
public class meds_manualordercontroller{


    public Order__c order {get; set;}
    public boolean EditPage {get; set;}
    id clientChartId;
    
    public id OrderByUserId{get;set;}
    string rtParam;
    
    Sunshine_Center_Id__c SC;
    
    Boolean SendtoPharmacy ;
    
    public meds_manualordercontroller(){
        clientChartId = ApexPages.CurrentPage().getParameters().get('id');
        rtParam = ApexPages.CurrentPage().getParameters().get('rt');
        /*
         SC = Sunshine_Center_Id__c.getValues(rtparam);
        
        if(SC.Required_Pharmacy_Email__c)
            SendtoPharmacy = true;
        else
            SendtoPharmacy = false;
          */  
        EditPage = false;
        order = new Order__c();
    }

    public void EditFullPage(){
      EditPage = true;
    }
    
    public  List<SelectOption> getFrequencies(){
    
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Order__c.Frequency__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            if(f.getValue()!='3 day (m,w,f)' && f.getValue()!='daily' && f.getValue()!='sessions' && f.getValue()!='weekdays only'){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        } 
        return options; 
    }
    
    public  List<SelectOption> getUsers(){
         
         set<id> userRoleId = new set<id>();
                 
        list<string> rts = rtParam.split(';');
        for(string sr: rts){
            Sunshine_Center_Id__c SC = Sunshine_Center_Id__c.getValues(sr);
            if(sc!=null)
            userRoleId.add(SC.Health_Care_Practitioner_Role_ID__c);
        }
                
        List<SelectOption> options = new List<SelectOption>();
        
        list<User> lstUsers = [select id,Name from  User where UserRoleId=:userRoleId];
        
        for(User u: lstUsers){
            options.add(new SelectOption(u.id,u.Name));
        }
        return options;
    }
     public PageReference submitFunc(){

      try{
      
        System.debug('submit button method');        
        
        order = OrderUtil.returnManualOrder(order,clientChartId);
        
        system.debug(OrderByUserId);
        
        if(order.Send_To_Pharmacy__c == 'No' )
            order.Pharmacy_Status__c = 'Order Received';
        order.Order_By__c =OrderByUserId;
        insert (order);        
        
        list<order_Line_Item__c> lstCreateOLI = new list<Order_Line_Item__c>();
        for(integer i =0;i<order.Duration__c; i++){
            Order_Line_Item__c OLI = new Order_Line_Item__c();
            OLI.Day__c = i+1;
            OLI.Dosage_Form__c = order.Dosage_Form__c;
            OLI.Dose__c = order.Dose__c;
            OLI.Frequency__c = order.Frequency__c ;
            OLI.Medicine__c = order.Medicine__c;
            OLI.No_of_Refills__c = order.Number_of_Refills__c;
            OLI.Order__c = order.id;
            OLI.Route__c = order.Route__c;
            if(i ==0 && order.Send_To_Pharmacy__c == 'No' && !order.Medical_Reconciliation__c.contains('Discontinue'))
                OLI.Status__c = 'In Progress';
            else
                OLI.Status__c = 'Open';            
            OLI.Warning__c = order.Warnings__c;
            lstCreateOLI.add(OLI);

        }
        if(lstCreateOLI.size()>0)
            insert lstCreateOLI;
        if(order.Send_To_Pharmacy__c == 'No' && !order.Medical_Reconciliation__c.contains('Discontinue')){
            list<Event> lstCreateMARs = new list<Event>();
            for(Order_Line_Item__c oli : lstCreateOLI){
                if(oli.Day__c == 1)
                    lstCreateMARs.add(OrderUtil.returnStandardMARs(oli,order, order.Warnings__c,clientChartId));
            }
            //Event createMARs = OrderUtil.returnManualMARs(order,clientChartId);                            
            //insert createMARs ;
            if(lstCreateMARs.size()>0)
                insert lstCreateMARs;
        }
        
        order = new Order__c();
        PageReference meds = new PageReference('/apex/MedsHomePage?id=' + clientChartId+'&rt='+rtparam );
        meds.setRedirect(true);
        return meds;
      }
      catch(exception e){
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        return null;
      }
    }
}