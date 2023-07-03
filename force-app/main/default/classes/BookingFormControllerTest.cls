@isTest
public class BookingFormControllerTest {
    @isTest
    static void testConstructor(){
        BookingFormController controller = new BookingFormController();
    }
    
    @isTest
    static void testGetOpportunityDetails() {
        
        Opportunity__c opportunityRec = new Opportunity__c(Opportunity_Name__c ='Test Opportunity');
        insert opportunityRec;
        
        List<Applicant__c> listOfApplicantDetails = new List<Applicant__c>();
        
        
        Applicant__c applicantRec = new Applicant__c(Name__c ='Test Applicant', Opportunity__c=opportunityRec.Id,First_Applicant__c =true );
        insert applicantRec;
        listOfApplicantDetails.add(applicantRec);
        
        Applicant__c applicantRec1 = new Applicant__c(Name__c ='Test Applicant', Opportunity__c=opportunityRec.Id,First_Applicant__c =false );
        insert applicantRec1;
        
        List<BookingFormController.applicantDateWrapperClass> wrapListApp = new List<BookingFormController.applicantDateWrapperClass>();
        
        
        BookingFormController.applicantDateWrapperClass wrapApp = new BookingFormController.applicantDateWrapperClass();
        wrapApp.day = 15;
        wrapApp.month = 08;
        wrapApp.year = 2023;
        wrapApp.firstApp = true;
        wrapListApp.add(wrapApp);
        
        BookingFormController.oppDateWrapperClass wrap = new BookingFormController.oppDateWrapperClass();
        BookingFormController.oppDateWrapperClass wrap1 = new BookingFormController.oppDateWrapperClass();
        BookingFormController.oppDateWrapperClass wrap2 = new BookingFormController.oppDateWrapperClass();
        BookingFormController.oppDateWrapperClass wrap3 = new BookingFormController.oppDateWrapperClass();
        
        List<BookingFormController.oppDateWrapperClass> wrapList = new List<BookingFormController.oppDateWrapperClass>();
        List<BookingFormController.oppDateWrapperClass> wrapList1 = new List<BookingFormController.oppDateWrapperClass>();
        List<BookingFormController.oppDateWrapperClass> wrapList2 = new List<BookingFormController.oppDateWrapperClass>();
        List<BookingFormController.oppDateWrapperClass> wrapList3 = new List<BookingFormController.oppDateWrapperClass>();
        
        wrap.dateyear = 2023;
        wrap.datemonth = 06;
        wrap.dateday = 03;
        wrap.dateName = 'cheque';
        wrapList.add(wrap);
        
        wrap1.dateyear = 2023;
        wrap1.datemonth = 06;
        wrap1.dateday = 03;
        wrap1.dateName = 'cardSwipe';
        wrapList1.add(wrap1);
        
        wrap2.dateyear = 2023;
        wrap2.datemonth = 06;
        wrap2.dateday = 03;
        wrap2.dateName = 'onlinePayment';
        wrapList2.add(wrap2);
        
        wrap3.dateyear = 2023;
        wrap3.datemonth = 06;
        wrap3.dateday = 03;
        wrap3.dateName = 'today';
        wrapList3.add(wrap3);
        
        
        
        
        test.startTest();
        BookingFormController.getOpportunityDetails(opportunityRec.Id);
        BookingFormController.getFirstApplicantDetails(opportunityRec.Id);
        BookingFormController.getSecondApplicantDetails(opportunityRec.Id);
        BookingFormController.getAllOpportunityDetails(opportunityRec.Id);
        BookingFormController.saveAppDetails(applicantRec1,opportunityRec,2023,06,22);
        BookingFormController.saveAppDetails2(applicantRec1);
        BookingFormController.saveSecondAppDetails(applicantRec1,2023,06,23);
        BookingFormController.saveApartmentCostDetails(opportunityRec);
        
        BookingFormController.savePaymentDetails(opportunityRec,wrapList);
        BookingFormController.savePaymentDetails(opportunityRec,wrapList1);
        BookingFormController.savePaymentDetails(opportunityRec,wrapList2);
        
        BookingFormController.saveAllOppDetails(opportunityRec,wrapList2);
        BookingFormController.saveSecondApplicantData(applicantRec1,opportunityRec.Id,opportunityRec,wrapList2,25,08,2011);
        BookingFormController.saveSecondApplicantData(applicantRec1,opportunityRec.Id,opportunityRec,wrapList3,25,08,2011);
        BookingFormController.saveFirstApplicantData(applicantRec1,opportunityRec.Id,opportunityRec,wrapList3,25,08,2011);
        
        BookingFormController.saveSurveyDetails(opportunityRec);
        BookingFormController.finalOpportunitySubmit(opportunityRec,2023,06,22);
        
        BookingFormController.submitDet(listOfApplicantDetails,opportunityRec,wrapListApp,wrapList3);
        BookingFormController.submitDet(listOfApplicantDetails,opportunityRec,wrapListApp,wrapList2);
        BookingFormController.submitDet(listOfApplicantDetails,opportunityRec,wrapListApp,wrapList1);
        
        
        
        test.stopTest();
    } 
}