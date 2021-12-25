public without sharing class cntplacementCenter {
    
    
    //Warpper class for create/edit email mulitple email 
    public list<wrapperPC> lstPlacementCenters{get;set;}
    public integer numberOfRowToRemove{get; set;}    
    public integer numberOfRow{get; set;}        
    public list<string> lstemailadd{get; set;}
    public Placement_Center__c placementCenter{get; set;}
    //Warpper class to see existing records 
    public list<Placement_Center__c> lstPC{get; set;}
    public id placementId{get; set;}
    
    //display popup condition
    public boolean displayInfo {get; set;}     

    //display popup close
    public void closeInfo() {
        numberOfRowToRemove=0;
        lstPlacementCenters=new list<wrapperPC>();
        placementCenter=new Placement_Center__c();
        loadExisitingData();
        displayInfo = false;  

    }     

    //display popup open
    public void showdisplayInfo() {   
        displayInfo = true;    
    }

    public cntplacementCenter(){
        lstPlacementCenters=new list<wrapperPC>();
        numberOfRowToRemove=0;
        numberOfRow=0;
        system.debug('::::'+numberOfRowToRemove);
        loadExisitingData();
    }

    void loadExisitingData(){
        lstPC = [select Name, Email__c, Active__c from Placement_Center__c];
    }
    
    public void addPlacement(){
        placementCenter=new Placement_Center__c();
        lstPlacementCenters=new list<wrapperPC>();
        lstPlacementCenters.add(new wrapperPC(''));
        showdisplayInfo();
    } 
    
    public void savePlacement(){
        string addEmail='';
        boolean invalidEmail=false;
        if(placementCenter.Name!='' && placementCenter.Name!=null){
            
            for(wrapperPC item:lstPlacementCenters){

                if(item.email!='' && validateEmail(item.email)){
                    addEmail+=item.email+';';
                }else{
                    invalidEmail=true;
                    break;                
                }
            }
            
            Account acc = new Account();
            acc.Name = placementCenter.Name;
            acc.Type = 'Treatment Center';
            
            if(!invalidEmail){
                addEmail = addEmail.removeEnd(';');
                placementCenter.Email__c=addEmail;
                upsert placementCenter;
                insert acc;//Inserting account with type treatment center, so that it can be linked on Opportunity
                loadExisitingData();
                closeInfo();
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Record save successfully.'));
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please update invalid email address and save record again.'));                
            }
        }
    }
    
    public void addRow(){
        lstPlacementCenters.add(new wrapperPC(''));
    } 

    public void delemailRow(){
        system.debug('::::'+numberOfRowToRemove);
        if(numberOfRowToRemove!=null){
            lstPlacementCenters.remove(numberOfRowToRemove);
            numberOfRowToRemove=0;
        }
    }
    
    public void delPlacementRecordRow(){

        if(numberOfRow!=null){
            placementCenter=new Placement_Center__c();
            placementCenter=lstPC[numberOfRow];
            lstPC.remove(numberOfRow);
            delete placementCenter;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Record deleted successfully.'));
            numberOfRowToRemove=0;
        }

    }
    
    public void editAddplacement(){
        
        lstPlacementCenters=new list<wrapperPC>();
        
        if(placementId!=null){
            
            placementCenter=[select id, name, Active__c,Email__c from Placement_Center__c where id=:placementId];
            string[] str=placementCenter.Email__c.split(';');
            if(str.size()>0){
                for(string item:str){
                    lstPlacementCenters.add(new wrapperPC(item));
                }
            }
            showdisplayInfo();
        }        
    }

    public static Boolean validateEmail(String email) {
        Boolean res = true;
                    
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
    
        if (!MyMatcher.matches()) 
            res = false;
        return res; 
    }
        
    public class wrapperPC{
        public string email{get; set;}

        public wrapperPC(string aEmail){
            this.email=aEmail;
        }
    }
}