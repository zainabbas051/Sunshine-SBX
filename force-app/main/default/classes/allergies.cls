/*
    main component for allergies
    @author: Huma Zafar
    Test Class : allergiesTest
*/
public with sharing class allergies {
    public string s{get;set;}
    Id ccid;
    public boolean EditPage{get;set;}
    
    public list<wrapperAllergies> lstAllergies{get;set;}
    
    public allergies(){
        ccid = ApexPages.CurrentPage().getParameters().get('id');
        
        loadAllergies();
        
    }
    
    private void loadAllergies(){
        
        lstAllergies = new list<wrapperAllergies>();
        
        list<Allergies__c> lstA = [select id, Allergen__c, Allergy_Type__c, Client_Chart__c, Onset__c, Reaction__c,
        Reaction_Type__c, Source__c, Status__c, Treatment__c from Allergies__c where Client_Chart__c =: ccid];
        
        wrapperAllergies wrap;
        
        for(integer i=0;i<lstA.size();i++){
            wrap = new wrapperAllergies(lstA[i],i);
            lstAllergies.add(wrap);
        }
    }
    
    public void AddMoreAllergies(){
        wrapperAllergies wrap = new wrapperAllergies(new Allergies__c(Client_Chart__c=ccid),lstAllergies.size());
        lstAllergies.add(wrap);
    }
    
    

    public void UpdateAllergy(){
        //indexVal = integer.valueof(system.CurrentPageReference().getParameters().get('param1'));
                system.debug('indexVal1'+s);

        integer indexval =integer.valueof(s);

        system.debug('indexVal'+indexVal);
        for(integer i=0;i<lstAllergies.size();i++){
            if(i == indexVal){
                Update lstAllergies[i].allergy;
                break;
            }
        }
        loadAllergies();
    }
    
    public void SaveAllergy(){
        //indexVal = integer.valueof(system.CurrentPageReference().getParameters().get('param1'));
                system.debug('indexVal1'+s);

        integer indexval =integer.valueof(s);

        system.debug('indexVal'+indexVal);
        for(integer i=0;i<lstAllergies.size();i++){
            if(i == indexVal && lstAllergies[i].allergy.Allergen__c!=null){
                Insert lstAllergies[i].allergy;
                break;
            }
        }
        loadAllergies();
    }
    
    
    public void RemoveAllergy(){
        //indexVal = integer.valueof(system.CurrentPageReference().getParameters().get('param1'));
                system.debug('indexVal1'+s);

        integer indexval =integer.valueof(s);

        system.debug('indexVal'+indexVal);
        for(integer i=0;i<lstAllergies.size();i++){
            if(i == indexVal){
                delete lstAllergies[i].allergy;
                break;
            }
        }
        loadAllergies();
    }
    
    public class wrapperAllergies{
        
        public integer index{get;set;}
        public Allergies__c allergy{get;set;}
        
        public wrapperAllergies(Allergies__c a, integer i){
            index = i;
            allergy = a;
        }
    }
}