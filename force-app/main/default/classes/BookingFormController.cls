public with sharing class BookingFormController {
    public Applicant__c app {get;set;}
    public static String relationpickValue {get;set;} 
    public static String citizenshipstatuspickValue {get;set;}
    public static String gpapickValue {get;set;}  
    public static String sourceIncomepickValue {get;set;}
    public static String orgTypepickValue {get;set;}
    public static String industrypickValue {get;set;}
    public static String workRolepickValue {get;set;}
    public static String annualIncomepickValue {get;set;}
    public static String modeOfPaymentpickValue {get;set;}
    public static String purposeOfPurchasepickValue {get;set;}
    public static String comeToKnowAboutpickValue {get;set;}
    public static String sourceOfBookingpickValue {get;set;}
    public static String exitingCustomerpickValue {get;set;}
    public static String referredCustomerpickValue {get;set;}
    public static String exitingEmployeepickValue {get;set;}
    public static String referredEmployeepickValue {get;set;}
    public static String chkListBookingFormpickValue {get;set;}
    
    
    //Constructor 
    public BookingFormController(){  
        
        //Instances        
        app = new Applicant__c();
        
        relationpickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'First_Applicant_Relation_With__c'));
        system.debug('relationpickValue'+relationpickValue);
        
        citizenshipstatuspickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'FA_Citizenship_Status__c'));
        gpapickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'GPA_if_any__c'));
        chkListBookingFormpickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'Check_List_For_Booking_Form__c'));
        sourceIncomepickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'FA_Source_of_Income__c'));
        orgTypepickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'FA_Organization_Type__c'));
        industrypickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'FA_Industry_Sector__c'));
        workRolepickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'FA_Work_Role__c'));
        annualIncomepickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'FA_Annual_Income_INR__c'));
        modeOfPaymentpickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'Mode_of_Payment_Source__c'));
        purposeOfPurchasepickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'Purpose_of_Purchase__c'));
        comeToKnowAboutpickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'How_did_you_come_to_know_about_Vaishnavi__c'));
        sourceOfBookingpickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'Source_Of_Booking__c'));
        exitingCustomerpickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'Existing_Customer_of_Vaishnavi_Group__c'));
        referredCustomerpickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'Referred_by_Vaishnavi_Group_Customer__c'));
        exitingEmployeepickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'An_Existing_Employee_of_Vaisnavi_Group__c'));
        referredEmployeepickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'Referred_By_a_Vaishnavi_Group_Employee__c'));
    }
   
   @RemoteAction
   public static string SaveapplicantDetails(Applicant__c applicantObj){
      
       try{    
          //insert app;
          //system.debug('Record Inserted::>>>'+app);
       }
       catch(exception e){
           system.debug('error::>>>'+e.getLineNumber() + ' && Error Message :'+e.getMessage());
       }
       return 'SUCCESS'; 
    }
    
    
    
}