public with sharing class BookingFormSereneController {
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
    public String BookingFormSiteURL {get;set;}
    public String oppId {get;set;}
    
    
    //Constructor 
    public BookingFormSereneController(){  
        BookingFormSiteURL = Constants.APPLICANT_SITE ;
        
        //Instances                
        relationpickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'Relation_With__c'));
        system.debug('relationpickValue'+relationpickValue);
        
        citizenshipstatuspickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'Citizenship_Status__c'));
        gpapickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'GPA_if_any__c'));
        sourceIncomepickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'Source_of_Income__c'));
        orgTypepickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'Organization_Type__c'));
        industrypickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'Industry_Sector__c'));
        workRolepickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'Work_Role__c'));
        annualIncomepickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'Annual_Income_INR__c'));
        modeOfPaymentpickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'Mode_of_Payment_Source__c'));
        purposeOfPurchasepickValue = JSON.serialize(UtilityPickListClass.getPicklistValues('Applicant__c', 'Purpose_of_Purchase__c'));

        oppId = Apexpages.currentPage().getParameters().get('id'); 
        system.debug('oppId---'+oppId);
    }

    @RemoteAction
    public static Opportunity__c getOpportunitySereneDetails(string oppId){
        system.debug('oppId --> '+oppId);
        Opportunity__c opportunityRecord = New Opportunity__c();
        try{
            opportunityRecord = [SELECT Id,Opportunity_Name__c,(SELECT Id,Name__c,Date_Of_Birth__c,Relation_With__c,Occupation__c,Designation__c,
            Citizenship_Status__c,GPA_if_any__c,Permanent_Address__c,Correspondence_Address__c,Customer_Mobile_No__c,Phone__c,Employee_Email_ID__c,
            PAN_Number__c,Aadhaar_Number__c,Name_of_the_Organization_Business__c,Office_Phone_No__c,Source_of_Income__c,Organization_Type__c,Industry_Sector__c,
            Work_Role__c,Annual_Income_INR__c,Mode_of_Payment_Source__c,Purpose_of_Purchase__c FROM Applicants__r),Apartment_No__c,Floor_No__c,
            Super_Built_Up_Area__c,Base_Rate__c,Floor_Rise_Rate__c,PLC_Charges__c,Total_Rate__c,Clubhouse_Charges__c,Car_Park_Cost__c,No_of_Car_Parks__c,
            Sale_Value__c,Booking_Amount__c,Cheque_DD_No__c,Branch__c,Card_Swipe_Transaction_Number__c,Online_Payment_Transaction_Number__c From Opportunity__c WHERE Id =: oppId];
            system.debug('opportunityRecord ---> '+opportunityRecord);
        }catch(Exception e){
            system.debug('Exception::'+e.getStackTraceString());
        }        
        return opportunityRecord;
    }

    @RemoteAction
    public static string saveSereneOppDetails(List<Applicant__c> listOfApplicantDetails, Opportunity__c oppDetails){
        upsert oppDetails;
        upsert listOfApplicantDetails;
        return 'Success';
    }
}