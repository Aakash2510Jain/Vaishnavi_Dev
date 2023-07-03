public without sharing class BookingFormController {
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
    public static String leadSourceType {get;set;}
    public static String sourceOfBooking {get;set;}
    public static String bookingFormCheckList {get;set;}
    public String BookingFormSiteURL {get;set;}
    public String oppId {get;set;}
    
    
    //Constructor 
    public BookingFormController(){  
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
        leadSourceType = JSON.serialize(UtilityPickListClass.getPicklistValues('Opportunity__c', 'About_VAISHNAVI_PREMIERE__c'));
        sourceOfBooking = JSON.serialize(UtilityPickListClass.getPicklistValues('Opportunity__c', 'Source_Of_Booking__c'));
        bookingFormCheckList = JSON.serialize(UtilityPickListClass.getPicklistValues('Opportunity__c', 'Booking_Form_Checklist__c'));

        oppId = Apexpages.currentPage().getParameters().get('id'); 
        system.debug('oppId---'+oppId);
    }

    @RemoteAction
    public static Opportunity__c getOpportunityDetails(string oppId){
        system.debug('oppId --> '+oppId);
        Opportunity__c opportunityRecord = New Opportunity__c();
        try{
            opportunityRecord = [SELECT Id,Opportunity_Name__c,Drawn_On__c,Booking_Form_Premiere_Submission_Date__c,Cheque_DD_Date__c,Card_Swipe_Transaction_Date__c,Online_Payment_Transaction_Date__c,
            About_VAISHNAVI_PREMIERE__c,Source_Of_Booking__c,Booking_Form_Checklist__c,Booking_Form_Checklist_Option__c,Existing_Customer_Referral__c,Vaishnavi_Referral__c,Customer_Name__c,Project_Name__c,Unit_Plot_No__c,
            Customer_Mobile_No__c,Customer_Email_Id__c,Existing_Employee_Referral__c,Employee_Vaishnavi_Referral__c,Employee_Name__c,Employee_Id__c,Employee_Email_Id__c,Employee_Mobile_No__c,
            (SELECT Id,Name__c,Date_Of_Birth__c,Relation_With__c,Occupation__c,Designation__c,Citizenship_Status__c,GPA_if_any__c,Permanent_Address__c,Correspondence_Address__c,Customer_Mobile_No__c,
            Phone__c,Employee_Email_ID__c,PAN_Number__c,Aadhaar_Number__c,Name_of_the_Organization_Business__c,Office_Phone_No__c,Source_of_Income__c,Organization_Type__c,Industry_Sector__c,
            Work_Role__c,Annual_Income_INR__c,Mode_of_Payment_Source__c,Purpose_of_Purchase__c FROM Applicants__r),Lead_Source_Type__c,Apartment_No__c,Floor_No__c,Super_Built_Up_Area__c,Base_Rate__c,Floor_Rise_Rate__c,
            PLC_Charges__c,Total_Rate__c,Clubhouse_Charges__c,Car_Park_Cost__c,No_of_Car_Parks__c,Sale_Value__c,Booking_Amount__c,Cheque_DD_No__c,Branch__c,Card_Swipe_Transaction_Number__c,
            Online_Payment_Transaction_Number__c From Opportunity__c WHERE Id =: oppId];
            system.debug('opportunityRecord ---> '+opportunityRecord);
        }catch(Exception e){
            system.debug('Exception::'+e.getStackTraceString());
        }        
        return opportunityRecord;
    }

    @RemoteAction
    public static string submitDet(List<Applicant__c> listOfApplicantDetails, Opportunity__c oppDetails, List<BookingFormController.applicantDateWrapperClass> dateList, List<BookingFormController.oppDateWrapperClass> oppDateList){
        List<Applicant__c> appListToBeUpdated = New List<Applicant__c>();
        List<Opportunity__c> oppListToBeUpdated = New List<Opportunity__c>();
        for(Applicant__c applicant : listOfApplicantDetails){
            for(applicantDateWrapperClass wrap : dateList){
                system.debug('First_Applicant__c :: '+applicant.First_Applicant__c);
                system.debug('wrap Boolean :: '+wrap.firstApp);
                if(applicant.First_Applicant__c == wrap.firstApp){
                    if(wrap.year != 0){
                        applicant.Date_Of_Birth__c = Date.newInstance(wrap.year, wrap.month, wrap.day);
                        system.debug('applicant.Date_Of_Birth__c :: '+applicant.Date_Of_Birth__c);
                    }
                }
            }
            appListToBeUpdated.add(applicant);
        }

        for(oppDateWrapperClass oppWrapp : oppDateList){
            if(oppWrapp.dateName == 'today'){
                oppDetails.Booking_Form_Premiere_Submission_Date__c = Date.newInstance(oppWrapp.dateyear, oppWrapp.datemonth, oppWrapp.dateday);
            }else if(oppWrapp.dateName == 'cheque'){
                oppDetails.Cheque_DD_Date__c = Date.newInstance(oppWrapp.dateyear, oppWrapp.datemonth, oppWrapp.dateday);
            }else if(oppWrapp.dateName == 'cardSwipe'){
                oppDetails.Card_Swipe_Transaction_Date__c = Date.newInstance(oppWrapp.dateyear, oppWrapp.datemonth, oppWrapp.dateday);
            }else if(oppWrapp.dateName == 'onlinePayment'){
                oppDetails.Online_Payment_Transaction_Date__c = Date.newInstance(oppWrapp.dateyear, oppWrapp.datemonth, oppWrapp.dateday);
            }
        }
        system.debug('appListToBeUpdated :: '+appListToBeUpdated);
        // upsert oppListToBeUpdated;
        upsert appListToBeUpdated;
        system.debug('oppDetails :: '+oppDetails);
        upsert oppDetails;
        upsert listOfApplicantDetails;
        return 'Success';
    }

    public class applicantDateWrapperClass{
        public Integer year {get;set;}
        public Integer month {get;set;}
        public Integer day {get;set;}
        public Boolean firstApp {get;set;}
    }

    public class oppDateWrapperClass{
        public Integer dateyear {get;set;}
        public Integer datemonth {get;set;}
        public Integer dateday {get;set;}
        public string dateName {get;set;}
    }

    @RemoteAction
    public static string saveFirstApplicantData(Applicant__c applicantDetails, string oppId, Opportunity__c oppDetails, List<BookingFormController.oppDateWrapperClass> oppDateList, integer birthday, integer birthmonth, integer birthyear){
        try{
            if(birthday == 0 && birthmonth==0 && birthyear==0){
                
            }else{
                applicantDetails.Date_Of_Birth__c = Date.newInstance(birthyear, birthmonth, birthday); 
            }
            List<Applicant__c> appList = [SELECT Id FROM Applicant__c WHERE First_Applicant__c = true AND Opportunity__c =: oppId];
            if(appList.size() > 0){
                update applicantDetails;
            }else{
                insert applicantDetails;
            }
            for(oppDateWrapperClass oppWrapp : oppDateList){
                if(oppWrapp.dateName == 'today'){
                    oppDetails.Booking_Form_Premiere_Submission_Date__c = Date.newInstance(oppWrapp.dateyear, oppWrapp.datemonth, oppWrapp.dateday);
                } 
            }
            update oppDetails;
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static string saveSecondApplicantData(Applicant__c applicantDetails, string oppId, Opportunity__c oppDetails, List<BookingFormController.oppDateWrapperClass> oppDateList, integer birthday, integer birthmonth, integer birthyear){
        try{
            system.debug('applicantDetails ----> '+applicantDetails);
            if(birthday == 0 && birthmonth==0 && birthyear==0){
                
            }else{
                applicantDetails.Date_Of_Birth__c = Date.newInstance(birthyear, birthmonth, birthday); 
            }
            List<Applicant__c> appList = [SELECT Id FROM Applicant__c WHERE First_Applicant__c = false AND Opportunity__c =: oppId];
            system.debug('appList ---> '+appList);
            if(appList.size() > 0){
                update applicantDetails;
            }else{
                insert applicantDetails;
            }
            for(oppDateWrapperClass oppWrapp : oppDateList){
                if(oppWrapp.dateName == 'today'){
                    oppDetails.Booking_Form_Premiere_Submission_Date__c = Date.newInstance(oppWrapp.dateyear, oppWrapp.datemonth, oppWrapp.dateday);
                } 
            }
            update oppDetails;

            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static string saveAllOppDetails(Opportunity__c oppDetails, List<BookingFormController.oppDateWrapperClass> oppDateList){
        try{

            system.debug('oppDetails ----> '+oppDetails);
            for(oppDateWrapperClass oppWrapp : oppDateList){
                if(oppWrapp.dateName == 'today'){
                    oppDetails.Booking_Form_Premiere_Submission_Date__c = Date.newInstance(oppWrapp.dateyear, oppWrapp.datemonth, oppWrapp.dateday);
                }else if(oppWrapp.dateName == 'cheque'){
                    oppDetails.Cheque_DD_Date__c = Date.newInstance(oppWrapp.dateyear, oppWrapp.datemonth, oppWrapp.dateday);
                }else if(oppWrapp.dateName == 'cardSwipe'){
                    oppDetails.Card_Swipe_Transaction_Date__c = Date.newInstance(oppWrapp.dateyear, oppWrapp.datemonth, oppWrapp.dateday);
                }else if(oppWrapp.dateName == 'onlinePayment'){
                    oppDetails.Online_Payment_Transaction_Date__c = Date.newInstance(oppWrapp.dateyear, oppWrapp.datemonth, oppWrapp.dateday);
                }
            }
            update oppDetails;
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static Applicant__c getFirstApplicantDetails(string oppId){
        try{
            Applicant__c appDetails = [SELECT Id,Name__c,Mobile__c,Email_Id__c,First_Applicant__c,Extension__c,Opportunity__c,Date_Of_Birth__c,Relation_With__c,Occupation__c,Designation__c,Citizenship_Status__c,GPA_if_any__c,Permanent_Address__c,Correspondence_Address__c,Customer_Mobile_No__c,
            Phone__c,Employee_Email_ID__c,PAN_Number__c,Aadhaar_Number__c,Name_of_the_Organization_Business__c,Office_Phone_No__c,Source_of_Income__c,Organization_Type__c,Industry_Sector__c,
            Work_Role__c,Annual_Income_INR__c,Mode_of_Payment_Source__c,Purpose_of_Purchase__c FROM Applicant__c WHERE Opportunity__c =: oppId AND First_Applicant__c = true];
            return appDetails;
        }catch(Exception e){
            return null;
        }
    }

    @RemoteAction
    public static Applicant__c getSecondApplicantDetails(string oppId){
        try{
            Applicant__c appDetails = [SELECT Id,Name__c,Extension__c,Mobile__c,Email_Id__c,First_Applicant__c,Opportunity__c,Date_Of_Birth__c,Relation_With__c,Occupation__c,Designation__c,Citizenship_Status__c,GPA_if_any__c,Permanent_Address__c,Correspondence_Address__c,Customer_Mobile_No__c,
            Phone__c,Employee_Email_ID__c,PAN_Number__c,Aadhaar_Number__c,Name_of_the_Organization_Business__c,Office_Phone_No__c,Source_of_Income__c,Organization_Type__c,Industry_Sector__c,
            Work_Role__c,Annual_Income_INR__c,Mode_of_Payment_Source__c,Purpose_of_Purchase__c FROM Applicant__c WHERE Opportunity__c =: oppId AND First_Applicant__c = false];
            return appDetails;
        }catch(Exception e){
            return null;
        }
    }

    @RemoteAction
    public static Opportunity__c getAllOpportunityDetails(string oppId){
        try{
            Opportunity__c oppDetails = [SELECT Id,Opportunity_Name__c,Drawn_On__c,Booking_Form_Premiere_Submission_Date__c,Cheque_DD_Date__c,Card_Swipe_Transaction_Date__c,
            Online_Payment_Transaction_Date__c,About_VAISHNAVI_PREMIERE__c,Source_Of_Booking__c,Booking_Form_Checklist__c,Booking_Form_Checklist_Option__c,
            Existing_Customer_Referral__c,Vaishnavi_Referral__c,Customer_Name__c,Project_Name__c,Unit_Plot_No__c,Customer_Mobile_No__c,Customer_Email_Id__c,
            Existing_Employee_Referral__c,Employee_Vaishnavi_Referral__c,Employee_Name__c,Employee_Id__c,Employee_Email_Id__c,Employee_Mobile_No__c,
            Lead_Source_Type__c,Apartment_No__c,Floor_No__c,Super_Built_Up_Area__c,Base_Rate__c,Floor_Rise_Rate__c,PLC_Charges__c,Total_Rate__c,
            Clubhouse_Charges__c,Car_Park_Cost__c,No_of_Car_Parks__c,Sale_Value__c,Booking_Amount__c,Cheque_DD_No__c,Branch__c,Card_Swipe_Transaction_Number__c,
            Online_Payment_Transaction_Number__c,CP_Name_Company__c,Channel_Partner_Mobile_No__c,RERA_Regn_No__c From Opportunity__c WHERE Id =: oppId];
            return oppDetails;
        }catch(Exception e){
            return null;
        }
    }






    /* UPDATED CODE */

    @RemoteAction
    public static string saveAppDetails(Applicant__c appDetails, Opportunity__c oppDetails, Integer year, Integer month, Integer day){
        try{
            if(day == 0 && month==0 && year==0){
                
            }else{
                appDetails.Date_Of_Birth__c = Date.newInstance(year, month, day); 
            }
            if(appDetails.Id != null){
                update appDetails;
            }else{
                insert appDetails;
            }
            update oppDetails;
            return appDetails.Id;

        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static string saveAppDetails2(Applicant__c appDetails){
        try{
            update appDetails;
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static string saveSecondAppDetails(Applicant__c appDetails, Integer year, Integer month, Integer day){
        try{
            if(day == 0 && month==0 && year==0){
                
            }else{
                appDetails.Date_Of_Birth__c = Date.newInstance(year, month, day); 
            }
            if(appDetails.Id != null){
                update appDetails;
            }else{
                insert appDetails;
            }
            return appDetails.Id;

        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static string saveApartmentCostDetails(Opportunity__c oppDetails){
        try{
            update oppDetails;
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static string savePaymentDetails(Opportunity__c oppDetails, List<BookingFormController.oppDateWrapperClass> oppDateList){
        try{
            for(oppDateWrapperClass oppWrapp : oppDateList){
                if(oppWrapp.dateName == 'cheque'){
                    if(oppWrapp.dateyear == 0 && oppWrapp.datemonth==0 && oppWrapp.dateday==0){

                    }else{
                        oppDetails.Cheque_DD_Date__c = Date.newInstance(oppWrapp.dateyear, oppWrapp.datemonth, oppWrapp.dateday);
                    }
                }else if(oppWrapp.dateName == 'cardSwipe'){
                    if(oppWrapp.dateyear == 0 && oppWrapp.datemonth==0 && oppWrapp.dateday==0){

                    }else{
                        oppDetails.Card_Swipe_Transaction_Date__c = Date.newInstance(oppWrapp.dateyear, oppWrapp.datemonth, oppWrapp.dateday);
                    }
                }else if(oppWrapp.dateName == 'onlinePayment'){
                    if(oppWrapp.dateyear == 0 && oppWrapp.datemonth==0 && oppWrapp.dateday==0){

                    }else{
                        oppDetails.Online_Payment_Transaction_Date__c = Date.newInstance(oppWrapp.dateyear, oppWrapp.datemonth, oppWrapp.dateday);
                    }
                }
            }
            update oppDetails;
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static string saveSurveyDetails(Opportunity__c oppDetails){
        try{
            update oppDetails;
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static string finalOpportunitySubmit(Opportunity__c oppDetails, Integer year, Integer month, Integer day){
        try{
            if(day == 0 && month==0 && year==0){
                
            }else{
                oppDetails.Booking_Form_Premiere_Submission_Date__c = Date.newInstance(year, month, day); 
            }
            update oppDetails;
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
}