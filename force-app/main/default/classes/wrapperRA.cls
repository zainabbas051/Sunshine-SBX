/*
    wrapper class for RA related recordtypes
    author huma
*/
public class wrapperRA{
    public boolean selected{get;set;}
    public Recurring_Assessment__c RA{get;set;}
    
    public wrapperRA(Recurring_Assessment__c r, Boolean selected_checkbox){
        this.selected = selected_checkbox;
        this.RA = r;
    }
}