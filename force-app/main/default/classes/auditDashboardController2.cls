//Test Class : auditDashboardController_Test
global without sharing class auditDashboardController2{
    
    public auditDashboardController2(){
        chaptersYesIntake = 0;
        monarchYesIntake = 0;
        mountainYesIntake = 0;
        willowYesIntake = 0;
        chaptersNoIntake = 0;
        monarchNoIntake = 0;
        mountainNoIntake = 0;
        willowNoIntake = 0;
        
        chaptersYesColumbia = 0;
        monarchYesColumbia = 0;
        mountainYesColumbia = 0;
        willowYesColumbia = 0;
        chaptersNoColumbia = 0;
        monarchNoColumbia = 0;
        mountainNoColumbia = 0;
        willowNoColumbia = 0;
        
        chaptersYesBPS = 0;
        monarchYesBPS = 0;
        mountainYesBPS = 0;
        willowYesBPS = 0;
        chaptersNoBPS = 0;
        monarchNoBPS = 0;
        mountainNoBPS = 0;
        willowNoBPS = 0;
        
        chaptersYesITP = 0;
        monarchYesITP = 0;
        mountainYesITP = 0;
        willowYesITP = 0;
        chaptersNoITP = 0;
        monarchNoITP = 0;
        mountainNoITP = 0;
        willowNoITP = 0;
        
        chaptersYesMTP = 0;
        monarchYesMTP = 0;
        mountainYesMTP = 0;
        willowYesMTP = 0;
        chaptersNoMTP = 0;
        monarchNoMTP = 0;
        mountainNoMTP = 0;
        willowNoMTP = 0;
        
        chaptersYesHP = 0;
        monarchYesHP = 0;
        mountainYesHP = 0;
        willowYesHP = 0;
        chaptersNoHP = 0;
        monarchNoHP = 0;
        mountainNoHP = 0;
        willowNoHP = 0;
        
        chaptersYesPsychEval = 0;
        monarchYesPsychEval = 0;
        mountainYesPsychEval = 0;
        willowYesPsychEval = 0;
        chaptersNoPsychEval = 0;
        monarchNoPsychEval = 0;
        mountainNoPsychEval = 0;
        willowNoPsychEval = 0;
        
        chaptersYesPain = 0;
        monarchYesPain = 0;
        mountainYesPain = 0;
        willowYesPain = 0;
        chaptersNoPain = 0;
        monarchNoPain = 0;
        mountainNoPain = 0;
        willowNoPain = 0;
        
        chaptersYesNutritional = 0;
        monarchYesNutritional = 0;
        mountainYesNutritional = 0;
        willowYesNutritional = 0;
        chaptersNoNutritional = 0;
        monarchNoNutritional = 0;
        mountainNoNutritional = 0;
        willowNoNutritional = 0;
        
        chaptersYesF2F = 0;
        monarchYesF2F = 0;
        mountainYesF2F = 0;
        willowYesF2F = 0;
        chaptersNoF2F = 0;
        monarchNoF2F = 0;
        mountainNoF2F = 0;
        willowNoF2F = 0;
        
        chaptersNumberMPN = 0.0;
        monarchNumberMPN = 0.0;
        mountainNumberMPN = 0.0;
        willowNumberMPN = 0.0;
        chaptersRequiredMPN = 0.0;
        monarchRequiredMPN = 0.0;
        mountainRequiredMPN = 0.0;
        willowRequiredMPN = 0.0;
        
        chaptersNumberCPN = 0.0;
        monarchNumberCPN = 0.0;
        mountainNumberCPN = 0.0;
        willowNumberCPN = 0.0;
        chaptersRequiredCPN = 0.0;
        monarchRequiredCPN = 0.0;
        mountainRequiredCPN = 0.0;
        willowRequiredCPN = 0.0;
        
        chaptersNumberOC = 0.0;
        monarchNumberOC = 0.0;
        mountainNumberOC = 0.0;
        willowNumberOC = 0.0;
        chaptersRequiredOC = 0.0;
        monarchRequiredOC = 0.0;
        mountainRequiredOC = 0.0;
        willowRequiredOC = 0.0;
        
        chaptersNumberOfGoodDetox=0.0;
        monarchNumberOfGoodDetox=0.0;
        mountainNumberOfGoodDetox=0.0;
        willowNumberOfGoodDetox=0.0;
        chaptersNumberOfTotalDetox=0.0;
        monarchNumberOfTotalDetox=0.0;
        mountainNumberOfTotalDetox=0.0;
        willowNumberOfTotalDetox=0.0;
        
        chaptersNumberOfGoodNursingScreens = 0.0;
        monarchNumberOfGoodNursingScreens = 0.0;
        mountainNumberOfGoodNursingScreens = 0.0;
        willowNumberOfGoodNursingScreens = 0.0;
        chaptersNumberOfTotalNursingScreens = 0.0;
        monarchNumberOfTotalNursingScreens = 0.0;
        mountainNumberOfTotalNursingScreens = 0.0;
        willowNumberOfTotalNursingScreens = 0.0;
    }
    
    String monthValue = '';
    String yearValue = '';

    
    public Integer chaptersYesIntake{get;set;}
    public Integer monarchYesIntake{get;set;}
    public Integer mountainYesIntake{get;set;}
    public Integer willowYesIntake{get;set;}
    public Integer chaptersNoIntake{get;set;}
    public Integer monarchNoIntake{get;set;}
    public Integer mountainNoIntake{get;set;}
    public Integer willowNoIntake{get;set;}
    
    public Integer chaptersYesColumbia{get;set;}
    public Integer monarchYesColumbia{get;set;}
    public Integer mountainYesColumbia{get;set;}
    public Integer willowYesColumbia{get;set;}
    public Integer chaptersNoColumbia{get;set;}
    public Integer monarchNoColumbia{get;set;}
    public Integer mountainNoColumbia{get;set;}
    public Integer willowNoColumbia{get;set;}
    
    
    public Integer chaptersYesBPS{get;set;}
    public Integer monarchYesBPS{get;set;}
    public Integer mountainYesBPS{get;set;}
    public Integer willowYesBPS{get;set;}
    public Integer chaptersNoBPS{get;set;}
    public Integer monarchNoBPS{get;set;}
    public Integer mountainNoBPS{get;set;}
    public Integer willowNoBPS{get;set;}
    
    
    public Integer chaptersYesITP{get;set;}
    public Integer monarchYesITP{get;set;}
    public Integer mountainYesITP{get;set;}
    public Integer willowYesITP{get;set;}
    public Integer chaptersNoITP{get;set;}
    public Integer monarchNoITP{get;set;}
    public Integer mountainNoITP{get;set;}
    public Integer willowNoITP{get;set;}
    
    public Integer chaptersYesMTP{get;set;}
    public Integer monarchYesMTP{get;set;}
    public Integer mountainYesMTP{get;set;}
    public Integer willowYesMTP{get;set;}
    public Integer chaptersNoMTP{get;set;}
    public Integer monarchNoMTP{get;set;}
    public Integer mountainNoMTP{get;set;}
    public Integer willowNoMTP{get;set;}
    
    
    public Integer chaptersYesHP{get;set;}
    public Integer monarchYesHP{get;set;}
    public Integer mountainYesHP{get;set;}
    public Integer willowYesHP{get;set;}
    public Integer chaptersNoHP{get;set;}
    public Integer monarchNoHP{get;set;}
    public Integer mountainNoHP{get;set;}
    public Integer willowNoHP{get;set;}
    
    public Integer chaptersYesPsychEval{get;set;}
    public Integer monarchYesPsychEval{get;set;}
    public Integer mountainYesPsychEval{get;set;}
    public Integer willowYesPsychEval{get;set;}
    public Integer chaptersNoPsychEval{get;set;}
    public Integer monarchNoPsychEval{get;set;}
    public Integer mountainNoPsychEval{get;set;}
    public Integer willowNoPsychEval{get;set;}
    
    public Integer chaptersYesPain{get;set;}
    public Integer monarchYesPain{get;set;}
    public Integer mountainYesPain{get;set;}
    public Integer willowYesPain{get;set;}
    public Integer chaptersNoPain{get;set;}
    public Integer monarchNoPain{get;set;}
    public Integer mountainNoPain{get;set;}
    public Integer willowNoPain{get;set;}
    
    
    public Integer chaptersYesNutritional{get;set;}
    public Integer monarchYesNutritional{get;set;}
    public Integer mountainYesNutritional{get;set;}
    public Integer willowYesNutritional{get;set;}
    public Integer chaptersNoNutritional{get;set;}
    public Integer monarchNoNutritional{get;set;}
    public Integer mountainNoNutritional{get;set;}
    public Integer willowNoNutritional{get;set;}
    
    public Integer chaptersYesF2F{get;set;}
    public Integer monarchYesF2F{get;set;}
    public Integer mountainYesF2F{get;set;}
    public Integer willowYesF2F{get;set;}
    public Integer chaptersNoF2F{get;set;}
    public Integer monarchNoF2F{get;set;}
    public Integer mountainNoF2F{get;set;}
    public Integer willowNoF2F{get;set;}
    
    public Double chaptersNumberMPN{get;set;}
    public Double monarchNumberMPN{get;set;}
    public Double mountainNumberMPN{get;set;}
    public Double willowNumberMPN{get;set;}
    public Double chaptersRequiredMPN{get;set;}
    public Double monarchRequiredMPN{get;set;}
    public Double mountainRequiredMPN{get;set;}
    public Double willowRequiredMPN{get;set;}
    
    public Double chaptersNumberCPN{get;set;}
    public Double monarchNumberCPN{get;set;}
    public Double mountainNumberCPN{get;set;}
    public Double willowNumberCPN{get;set;}
    public Double chaptersRequiredCPN{get;set;}
    public Double monarchRequiredCPN{get;set;}
    public Double mountainRequiredCPN{get;set;}
    public Double willowRequiredCPN{get;set;}
    
    
    
    public Double chaptersNumberOC{get;set;}
    public Double monarchNumberOC{get;set;}
    public Double mountainNumberOC{get;set;}
    public Double willowNumberOC{get;set;}
    public Double chaptersRequiredOC{get;set;}
    public Double monarchRequiredOC{get;set;}
    public Double mountainRequiredOC{get;set;}
    public Double willowRequiredOC{get;set;}
    
    public double chaptersNumberOfGoodDetox{get;set;}
    public double monarchNumberOfGoodDetox{get;set;}
    public double mountainNumberOfGoodDetox{get;set;}
    public double willowNumberOfGoodDetox{get;set;}
    public double chaptersNumberOfTotalDetox{get;set;}
    public double monarchNumberOfTotalDetox{get;set;}
    public double mountainNumberOfTotalDetox{get;set;}
    public double willowNumberOfTotalDetox{get;set;}
    
    public double chaptersNumberOfGoodNursingScreens{get;set;}
    public double monarchNumberOfGoodNursingScreens{get;set;}
    public double mountainNumberOfGoodNursingScreens{get;set;}
    public double willowNumberOfGoodNursingScreens{get;set;}
    public double chaptersNumberOfTotalNursingScreens{get;set;}
    public double monarchNumberOfTotalNursingScreens{get;set;}
    public double mountainNumberOfTotalNursingScreens{get;set;}
    public double willowNumberOfTotalNursingScreens{get;set;}
    
    public void loadData(){
        if(monthValue != '' && yearValue!=''){
            String tempString = monthValue+'_'+yearValue;
            
            List<Id> kipuChartAuditIdList = new List<Id>();
            
            List<List<SObject>> searchList = [FIND :monthValue IN ALL FIELDS
                                              RETURNING
                                              KIPU_Chart_Audit__c (Id, Months_In_Treatment__c)];
            if(searchList.isEmpty()==False){
                system.debug('tempString ::::'+tempString);
                
                for(KIPU_Chart_Audit__c aud : (List<KIPU_Chart_Audit__c>)searchList[0]){
                    system.debug('Audit Months in Treatment :::'+aud.Months_In_Treatment__c);
                    system.debug('Months in Treatment Contains Temp String :::'+aud.Months_In_Treatment__c.contains(tempString));
                    if(aud.Months_In_Treatment__c.contains(tempString)){
                        kipuChartAuditIdList.add(aud.id);
                    }
                }
            }
            
            if(kipuChartAuditIdList.isEmpty()==False){
                for(KIPU_Chart_Audit__c aud : [Select id, Sunshine_Center__c, Intake_Consents_completed_within_24_hour__c, Columbia_Triage_completed_within_24_hour__c, BPS_is_completed_within_72_hours__c, 
                                           ITP_completed_within_24_hours__c, MTP_completed_within_1_week__c, F2F_completed_within_24_hours__c, H_P_is_completed_within_24_hours__c, Psych_Eval_is_completed_within_24_hours__c, 
                                           Pain_Screen_completed_within_24_hours__c, Nutritional_Screen_complete_within_24_Hr__c, Number_of_Good_Q15_Detox_Checks__c, Number_of_Good_Q30_Detox_Checks__c, 
                                           Total_Number_of_Q15_Detox_Checks__c, Total_Number_of_Q30_Detox_Checks__c, Number_of_Good_Nursing_Screens__c, Total_Number_of_Nursing_Screens__c,
                                           (Select id, No_of_Clinical_Progress_Note_Required__c, No_of_Medical_Progress_Note_Required__c, No_of_Outside_Contact_Required__c,
                                           Number_of_Clinical_Progress_Note__c, Number_of_Medical_Progress_Note__c, Number_of_Outside_Contact__c from KIPU_Audit_Week_Line_Items__r)
                                            from KIPU_Chart_Audit__c where ID IN: kipuChartAuditIdList]){
                 
                 
                 }
            }
            
            for(KIPU_Chart_Audit__c aud : [Select id, Sunshine_Center__c, Intake_Consents_completed_within_24_hour__c, Columbia_Triage_completed_within_24_hour__c, BPS_is_completed_within_72_hours__c, 
                                           ITP_completed_within_24_hours__c, MTP_completed_within_1_week__c, F2F_completed_within_24_hours__c, H_P_is_completed_within_24_hours__c, Psych_Eval_is_completed_within_24_hours__c, 
                                           Pain_Screen_completed_within_24_hours__c, Nutritional_Screen_complete_within_24_Hr__c, Number_of_Good_Q15_Detox_Checks__c, Number_of_Good_Q30_Detox_Checks__c, 
                                           Total_Number_of_Q15_Detox_Checks__c, Total_Number_of_Q30_Detox_Checks__c, Number_of_Good_Nursing_Screens__c, Total_Number_of_Nursing_Screens__c,
                                           (Select id, No_of_Clinical_Progress_Note_Required__c, No_of_Medical_Progress_Note_Required__c, No_of_Outside_Contact_Required__c,
                                           Number_of_Clinical_Progress_Note__c, Number_of_Medical_Progress_Note__c, Number_of_Outside_Contact__c from KIPU_Audit_Week_Line_Items__r)
                                            from KIPU_Chart_Audit__c where Months_In_Treatment__c LIKE: tempString]){
                
                if(aud.Sunshine_Center__c == 'Chapters Capistrano'){
                    if(aud.Intake_Consents_completed_within_24_hour__c == 'Yes')
                        chaptersYesIntake++;
                    if(aud.Intake_Consents_completed_within_24_hour__c == 'No')
                        chaptersNoIntake++;
                    if(aud.Columbia_Triage_completed_within_24_hour__c == 'Yes')
                        chaptersYesColumbia++;
                    if(aud.Columbia_Triage_completed_within_24_hour__c == 'No')
                        chaptersNoColumbia++;
                    if(aud.BPS_is_completed_within_72_hours__c == 'Yes')
                        chaptersYesBPS++;
                    if(aud.BPS_is_completed_within_72_hours__c == 'No')
                        chaptersNoBPS++;
                    if(aud.ITP_completed_within_24_hours__c == 'Yes')
                        chaptersYesITP++;
                    if(aud.ITP_completed_within_24_hours__c == 'No')
                        chaptersNoITP++;
                    if(aud.MTP_completed_within_1_week__c == 'Yes')
                        chaptersYesMTP++;
                    if(aud.MTP_completed_within_1_week__c == 'No')
                        chaptersNoMTP++;
                    if(aud.H_P_is_completed_within_24_hours__c == 'Yes')
                        chaptersYesHP++;
                    if(aud.H_P_is_completed_within_24_hours__c == 'No')
                        chaptersNoHP++;
                    if(aud.Psych_Eval_is_completed_within_24_hours__c == 'Yes')
                        chaptersYesPsychEval++;
                    if(aud.Psych_Eval_is_completed_within_24_hours__c == 'No')
                        chaptersNoPsychEval++;
                    if(aud.Pain_Screen_completed_within_24_hours__c == 'Yes')
                        chaptersYesPain++;
                    if(aud.Pain_Screen_completed_within_24_hours__c == 'No')
                        chaptersNoPain++;
                    if(aud.Nutritional_Screen_complete_within_24_Hr__c == 'Yes')
                        chaptersYesNutritional++;
                    if(aud.Nutritional_Screen_complete_within_24_Hr__c == 'No')
                        chaptersNoNutritional++;
                    if(aud.F2F_completed_within_24_hours__c == 'Yes')
                        chaptersYesF2F++;
                    if(aud.F2F_completed_within_24_hours__c == 'No')
                        chaptersNoF2F++;
                    if(aud.Number_of_Good_Q15_Detox_Checks__c != null)
                        chaptersNumberOfGoodDetox = chaptersNumberOfGoodDetox+aud.Number_of_Good_Q15_Detox_Checks__c;
                    if(aud.Number_of_Good_Q30_Detox_Checks__c != null)
                        chaptersNumberOfGoodDetox = chaptersNumberOfGoodDetox+aud.Number_of_Good_Q30_Detox_Checks__c;
                    if(aud.Total_Number_of_Q15_Detox_Checks__c != null)
                        chaptersNumberOfTotalDetox = chaptersNumberOfTotalDetox+aud.Total_Number_of_Q15_Detox_Checks__c;
                    if(aud.Total_Number_of_Q30_Detox_Checks__c != null)
                        chaptersNumberOfTotalDetox = chaptersNumberOfTotalDetox+aud.Total_Number_of_Q30_Detox_Checks__c;
                    if(aud.Number_of_Good_Nursing_Screens__c != null)
                        chaptersNumberOfGoodNursingScreens = chaptersNumberOfGoodNursingScreens+aud.Number_of_Good_Nursing_Screens__c;
                    if(aud.Total_Number_of_Nursing_Screens__c != null)
                        chaptersNumberOfTotalNursingScreens = chaptersNumberOfTotalNursingScreens+aud.Total_Number_of_Nursing_Screens__c;
                        
                }  
                if(aud.Sunshine_Center__c == 'Monarch Shores' || aud.Sunshine_Center__c == 'Monarch IOP'){
                    if(aud.Intake_Consents_completed_within_24_hour__c == 'Yes')
                        monarchYesIntake++;
                    if(aud.Intake_Consents_completed_within_24_hour__c == 'No')
                        monarchNoIntake++;
                    if(aud.Columbia_Triage_completed_within_24_hour__c == 'Yes')
                        monarchYesColumbia++;
                    if(aud.Columbia_Triage_completed_within_24_hour__c == 'No')
                        monarchNoColumbia++; 
                    if(aud.BPS_is_completed_within_72_hours__c == 'Yes')
                        monarchYesBPS++;
                    if(aud.BPS_is_completed_within_72_hours__c == 'No')
                        monarchNoBPS++;
                    if(aud.ITP_completed_within_24_hours__c == 'Yes')
                        monarchYesITP++;
                    if(aud.ITP_completed_within_24_hours__c == 'No')
                        monarchNoITP++;   
                    if(aud.MTP_completed_within_1_week__c == 'Yes')
                        monarchYesMTP++;
                    if(aud.MTP_completed_within_1_week__c == 'No')
                        monarchNoMTP++;
                    if(aud.H_P_is_completed_within_24_hours__c == 'Yes')
                        monarchYesHP++;
                    if(aud.H_P_is_completed_within_24_hours__c == 'No')
                        monarchNoHP++;
                    if(aud.Psych_Eval_is_completed_within_24_hours__c == 'Yes')
                        monarchYesPsychEval++;
                    if(aud.Psych_Eval_is_completed_within_24_hours__c == 'No')
                        monarchNoPsychEval++;
                    if(aud.Pain_Screen_completed_within_24_hours__c == 'Yes')
                        monarchYesPain++;
                    if(aud.Pain_Screen_completed_within_24_hours__c == 'No')
                        monarchNoPain++;
                    if(aud.Nutritional_Screen_complete_within_24_Hr__c == 'Yes')
                        monarchYesNutritional++;
                    if(aud.Nutritional_Screen_complete_within_24_Hr__c == 'No')
                        monarchNoNutritional++;
                    if(aud.F2F_completed_within_24_hours__c == 'Yes')
                        monarchYesF2F++;
                    if(aud.F2F_completed_within_24_hours__c == 'No')
                        monarchNoF2F++;
                    if(aud.Number_of_Good_Q15_Detox_Checks__c != null)
                        monarchNumberOfGoodDetox = monarchNumberOfGoodDetox+aud.Number_of_Good_Q15_Detox_Checks__c;
                    if(aud.Number_of_Good_Q30_Detox_Checks__c != null)
                        monarchNumberOfGoodDetox = monarchNumberOfGoodDetox+aud.Number_of_Good_Q30_Detox_Checks__c;
                    if(aud.Total_Number_of_Q15_Detox_Checks__c != null)
                        monarchNumberOfTotalDetox = monarchNumberOfTotalDetox+aud.Total_Number_of_Q15_Detox_Checks__c;
                    if(aud.Total_Number_of_Q30_Detox_Checks__c != null)
                        monarchNumberOfTotalDetox = monarchNumberOfTotalDetox+aud.Total_Number_of_Q30_Detox_Checks__c;
                    if(aud.Number_of_Good_Nursing_Screens__c != null)
                        monarchNumberOfGoodNursingScreens = monarchNumberOfGoodNursingScreens+aud.Number_of_Good_Nursing_Screens__c;
                    if(aud.Total_Number_of_Nursing_Screens__c != null)
                        monarchNumberOfTotalNursingScreens = monarchNumberOfTotalNursingScreens+aud.Total_Number_of_Nursing_Screens__c;
                }  
                if(aud.Sunshine_Center__c == 'Mountain Springs Recovery' || aud.Sunshine_Center__c == 'Mountain Springs IOP'){
                    if(aud.Intake_Consents_completed_within_24_hour__c == 'Yes')
                        mountainYesIntake++;
                    if(aud.Intake_Consents_completed_within_24_hour__c == 'No')
                        mountainNoIntake++;
                    if(aud.Columbia_Triage_completed_within_24_hour__c == 'Yes')
                        mountainYesColumbia++;
                    if(aud.Columbia_Triage_completed_within_24_hour__c == 'No')
                        mountainNoColumbia++;
                    if(aud.BPS_is_completed_within_72_hours__c == 'Yes')
                        mountainYesBPS++;
                    if(aud.BPS_is_completed_within_72_hours__c == 'No')
                        mountainNoBPS++;
                    if(aud.ITP_completed_within_24_hours__c == 'Yes')
                        mountainYesITP++;
                    if(aud.ITP_completed_within_24_hours__c == 'No')
                        mountainNoITP++;
                    if(aud.MTP_completed_within_1_week__c == 'Yes')
                        mountainYesMTP++;
                    if(aud.MTP_completed_within_1_week__c == 'No')
                        mountainNoMTP++;
                    if(aud.H_P_is_completed_within_24_hours__c == 'Yes')
                        mountainYesHP++;
                    if(aud.H_P_is_completed_within_24_hours__c == 'No')
                        mountainNoHP++;
                    if(aud.Psych_Eval_is_completed_within_24_hours__c == 'Yes')
                        mountainYesPsychEval++;
                    if(aud.Psych_Eval_is_completed_within_24_hours__c == 'No')
                        mountainNoPsychEval++;
                    if(aud.Pain_Screen_completed_within_24_hours__c == 'Yes')
                        mountainYesPain++;
                    if(aud.Pain_Screen_completed_within_24_hours__c == 'No')
                        mountainNoPain++;
                    if(aud.Nutritional_Screen_complete_within_24_Hr__c == 'Yes')
                        mountainYesNutritional++;
                    if(aud.Nutritional_Screen_complete_within_24_Hr__c == 'No')
                        mountainNoNutritional++;
                    if(aud.F2F_completed_within_24_hours__c == 'Yes')
                        mountainYesF2F++;
                    if(aud.F2F_completed_within_24_hours__c == 'No')
                        mountainNoF2F++;
                    if(aud.Number_of_Good_Q15_Detox_Checks__c != null)
                        mountainNumberOfGoodDetox = mountainNumberOfGoodDetox+aud.Number_of_Good_Q15_Detox_Checks__c;
                    if(aud.Number_of_Good_Q30_Detox_Checks__c != null)
                        mountainNumberOfGoodDetox = mountainNumberOfGoodDetox+aud.Number_of_Good_Q30_Detox_Checks__c;
                    if(aud.Total_Number_of_Q15_Detox_Checks__c != null)
                        mountainNumberOfTotalDetox = mountainNumberOfTotalDetox+aud.Total_Number_of_Q15_Detox_Checks__c;
                    if(aud.Total_Number_of_Q30_Detox_Checks__c != null)
                        mountainNumberOfTotalDetox = mountainNumberOfTotalDetox+aud.Total_Number_of_Q30_Detox_Checks__c;
                    if(aud.Number_of_Good_Nursing_Screens__c != null)
                        mountainNumberOfGoodNursingScreens = mountainNumberOfGoodNursingScreens+aud.Number_of_Good_Nursing_Screens__c;
                    if(aud.Total_Number_of_Nursing_Screens__c != null)
                        mountainNumberOfTotalNursingScreens = mountainNumberOfTotalNursingScreens+aud.Total_Number_of_Nursing_Screens__c;
                }  
                if(aud.Sunshine_Center__c == 'Willowsprings Recovery' || aud.Sunshine_Center__c == 'Willow IOP'){
                    if(aud.Intake_Consents_completed_within_24_hour__c == 'Yes')
                        willowYesIntake++;
                    if(aud.Intake_Consents_completed_within_24_hour__c == 'No')
                        willowNoIntake++;
                    if(aud.Columbia_Triage_completed_within_24_hour__c == 'Yes')
                        willowYesColumbia++;
                    if(aud.Columbia_Triage_completed_within_24_hour__c == 'No')
                        willowNoColumbia++;
                    if(aud.BPS_is_completed_within_72_hours__c == 'Yes')
                        willowYesBPS++;
                    if(aud.BPS_is_completed_within_72_hours__c == 'No')
                        willowNoBPS++;
                    if(aud.ITP_completed_within_24_hours__c == 'Yes')
                        willowYesITP++;
                    if(aud.ITP_completed_within_24_hours__c == 'No')
                        willowNoITP++;
                    if(aud.MTP_completed_within_1_week__c == 'Yes')
                        willowYesMTP++;
                    if(aud.MTP_completed_within_1_week__c == 'No')
                        willowNoMTP++;
                    if(aud.H_P_is_completed_within_24_hours__c == 'Yes')
                        willowYesHP++;
                    if(aud.H_P_is_completed_within_24_hours__c == 'No')
                        willowNoHP++;
                    if(aud.Psych_Eval_is_completed_within_24_hours__c == 'Yes')
                        willowYesPsychEval++;
                    if(aud.Psych_Eval_is_completed_within_24_hours__c == 'No')
                        willowNoPsychEval++;
                    if(aud.Pain_Screen_completed_within_24_hours__c == 'Yes')
                        willowYesPain++;
                    if(aud.Pain_Screen_completed_within_24_hours__c == 'No')
                        willowNoPain++;
                    if(aud.Nutritional_Screen_complete_within_24_Hr__c == 'Yes')
                        willowYesNutritional++;
                    if(aud.Nutritional_Screen_complete_within_24_Hr__c == 'No')
                        willowNoNutritional++;
                    if(aud.F2F_completed_within_24_hours__c == 'Yes')
                        willowYesF2F++;
                    if(aud.F2F_completed_within_24_hours__c == 'No')
                        willowNoF2F++;
                    if(aud.Number_of_Good_Q15_Detox_Checks__c != null)
                        willowNumberOfGoodDetox = willowNumberOfGoodDetox+aud.Number_of_Good_Q15_Detox_Checks__c;
                    if(aud.Number_of_Good_Q30_Detox_Checks__c != null)
                        willowNumberOfGoodDetox = willowNumberOfGoodDetox+aud.Number_of_Good_Q30_Detox_Checks__c;
                    if(aud.Total_Number_of_Q15_Detox_Checks__c != null)
                        willowNumberOfTotalDetox = willowNumberOfTotalDetox+aud.Total_Number_of_Q15_Detox_Checks__c;
                    if(aud.Total_Number_of_Q30_Detox_Checks__c != null)
                        willowNumberOfTotalDetox = willowNumberOfTotalDetox+aud.Total_Number_of_Q30_Detox_Checks__c;
                    if(aud.Number_of_Good_Nursing_Screens__c != null)
                        willowNumberOfGoodNursingScreens = willowNumberOfGoodNursingScreens+aud.Number_of_Good_Nursing_Screens__c;
                    if(aud.Total_Number_of_Nursing_Screens__c != null)
                        willowNumberOfTotalNursingScreens = willowNumberOfTotalNursingScreens+aud.Total_Number_of_Nursing_Screens__c;
                }  
                for(KIPU_Audit_Week_Line_Item__c wli : aud.KIPU_Audit_Week_Line_Items__r){
                    if(aud.Sunshine_Center__c == 'Chapters Capistrano'){
                        if(wli.Number_of_Medical_Progress_Note__c != null)
                           chaptersNumberMPN = chaptersNumberMPN+wli.Number_of_Medical_Progress_Note__c;
                        if(wli.No_of_Medical_Progress_Note_Required__c !=null)
                            chaptersRequiredMPN = chaptersRequiredMPN+wli.No_of_Medical_Progress_Note_Required__c;
                        if(wli.Number_of_Clinical_Progress_Note__c != null)
                           chaptersNumberCPN = chaptersNumberCPN+wli.Number_of_Clinical_Progress_Note__c;
                        if(wli.No_of_Clinical_Progress_Note_Required__c !=null)
                            chaptersRequiredCPN = chaptersRequiredCPN+wli.No_of_Clinical_Progress_Note_Required__c;
                        if(wli.Number_of_Outside_Contact__c != null)
                           chaptersNumberOC = chaptersNumberOC+wli.Number_of_Outside_Contact__c;
                        if(wli.No_of_Outside_Contact_Required__c !=null)
                            chaptersRequiredOC = chaptersRequiredOC+wli.No_of_Outside_Contact_Required__c;
                    }
                    if(aud.Sunshine_Center__c == 'Monarch Shores' || aud.Sunshine_Center__c == 'Monarch IOP'){
                        if(wli.Number_of_Medical_Progress_Note__c != null)
                            monarchNumberMPN = monarchNumberMPN+wli.Number_of_Medical_Progress_Note__c;
                        if(wli.No_of_Medical_Progress_Note_Required__c !=null)
                            monarchRequiredMPN = monarchRequiredMPN+wli.No_of_Medical_Progress_Note_Required__c;
                        if(wli.Number_of_Clinical_Progress_Note__c != null)
                            monarchNumberCPN = monarchNumberCPN+wli.Number_of_Clinical_Progress_Note__c;
                        if(wli.No_of_Clinical_Progress_Note_Required__c !=null)
                            monarchRequiredCPN = monarchRequiredCPN+wli.No_of_Clinical_Progress_Note_Required__c;
                        if(wli.Number_of_Outside_Contact__c != null)
                            monarchNumberOC = monarchNumberOC+wli.Number_of_Outside_Contact__c;
                        if(wli.No_of_Outside_Contact_Required__c !=null)
                            monarchRequiredOC = monarchRequiredOC+wli.No_of_Outside_Contact_Required__c;
                    }
                    if(aud.Sunshine_Center__c == 'Mountain Springs Recovery' || aud.Sunshine_Center__c == 'Mountain Springs IOP'){
                        if(wli.Number_of_Medical_Progress_Note__c != null)
                            mountainNumberMPN = mountainNumberMPN+wli.Number_of_Medical_Progress_Note__c;
                        if(wli.No_of_Medical_Progress_Note_Required__c !=null)
                            mountainRequiredMPN = mountainRequiredMPN+wli.No_of_Medical_Progress_Note_Required__c;
                        if(wli.Number_of_Clinical_Progress_Note__c != null)
                            mountainNumberCPN = mountainNumberCPN+wli.Number_of_Clinical_Progress_Note__c;
                        if(wli.No_of_Clinical_Progress_Note_Required__c !=null)
                            mountainRequiredCPN = mountainRequiredCPN+wli.No_of_Clinical_Progress_Note_Required__c;
                        if(wli.Number_of_Outside_Contact__c != null)
                            mountainNumberOC = mountainNumberOC+wli.Number_of_Outside_Contact__c;
                        if(wli.No_of_Outside_Contact_Required__c !=null)
                            mountainRequiredOC = mountainRequiredOC+wli.No_of_Outside_Contact_Required__c;
                    } 
                    if(aud.Sunshine_Center__c == 'Willowsprings Recovery' || aud.Sunshine_Center__c == 'Willow IOP'){
                        if(wli.Number_of_Medical_Progress_Note__c != null)
                            willowNumberMPN = willowNumberMPN+wli.Number_of_Medical_Progress_Note__c;
                        if(wli.No_of_Medical_Progress_Note_Required__c !=null)
                            willowRequiredMPN = willowRequiredMPN+wli.No_of_Medical_Progress_Note_Required__c;
                        if(wli.Number_of_Clinical_Progress_Note__c != null)
                            willowNumberCPN = willowNumberCPN+wli.Number_of_Clinical_Progress_Note__c;
                        if(wli.No_of_Clinical_Progress_Note_Required__c !=null)
                            willowRequiredCPN = willowRequiredCPN+wli.No_of_Clinical_Progress_Note_Required__c;
                        if(wli.Number_of_Outside_Contact__c != null)
                            willowNumberOC = willowNumberOC+wli.Number_of_Outside_Contact__c;
                        if(wli.No_of_Outside_Contact_Required__c !=null)
                            willowRequiredOC = willowRequiredOC+wli.No_of_Outside_Contact_Required__c;
                    }   
                }
                    
                     
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please Select a Valid Month and Year before Clicking on Load Data!!!'));
        }
    }
    
    public List<SelectOption> getMonthItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--NONE--','--NONE--'));
        options.add(new SelectOption('JAN','JAN'));
        options.add(new SelectOption('FEB','FEB'));
        options.add(new SelectOption('MAR','MAR'));
        options.add(new SelectOption('APR','APR'));
        options.add(new SelectOption('MAY','MAY'));
        options.add(new SelectOption('JUN','JUN'));
        options.add(new SelectOption('JUL','JUL'));
        options.add(new SelectOption('AUG','AUG'));
        options.add(new SelectOption('SEP','SEP'));
        options.add(new SelectOption('OCT','OCT'));
        options.add(new SelectOption('NOV','NOV'));
        options.add(new SelectOption('DEC','DEC'));
        return options;
    }
    
    public String getMonthValue() {
        return monthValue;
    }
    
    public void setMonthValue(String monthValue) {
        this.monthValue = monthValue;
    }
    
    public List<SelectOption> getYearItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--NONE--','--NONE--'));
        options.add(new SelectOption('2019','2019'));
        options.add(new SelectOption('2020','2020'));
        options.add(new SelectOption('2021','2021'));
        return options;
    }
    
    public String getYearValue() {
        return yearValue;
    }
    
    public void setYearValue(String yearValue) {
        this.yearValue = yearValue;
    }

}