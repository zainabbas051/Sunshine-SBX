//Test Class : PickListCheckBoxCtrlTest
public class PickListCheckBoxCtrl {
   
    public string  objectName{ get;set;} 
    public sObject s_object { get;set;}
    public string Assessment_FieldName{ get;set;}
    public string Assessment_FieldValue{ get;set;}
    public Boolean IsEdit{ get;set;}
    
  
    public PickListCheckBoxCtrl(){
        
        
    
    }
    
     public List<SelectOption> MPOptions {
     get {
       List<SelectOption> options = new List<SelectOption>();
       Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
       Map<String, Schema.SObjectField> field_map = targetType.newSObject().getSObjectType().getDescribe().fields.getMap();
       for( Schema.PicklistEntry f : field_map .get(Assessment_FieldName).getDescribe().getPicklistValues()) {
             options.add(new SelectOption(f.getValue(), f.getLabel()));
        } 
       return options;
     }  
     set;
    }
    
    
      public String[] MPItems { 
        get {
              String[] selected = new List<String>();
            Set<string> assessmentValue = new Set<String>();
            
            if(Assessment_FieldValue == null) return selected ;
            for(string assValue : Assessment_FieldValue.split(';'))
                 assessmentValue.add(assValue);
          
            List<SelectOption> sos = this.MPOptions;
            for(SelectOption s : sos) {
            if (assessmentValue.contains(s.getValue()))
               selected.add(s.getValue());
            }
            return selected;
       }
       
       set {
            String selectedCheckBox = '';
            for(String s : value) {
                 if (selectedCheckBox == '') 
                   selectedCheckBox += s;
                 else selectedCheckBox += ';' + s;
            }
            if(!Test.isRunningTest())
                s_object.put(Assessment_FieldName,selectedCheckBox);
           
         }
     
     }

}