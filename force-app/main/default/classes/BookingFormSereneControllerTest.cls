@IsTest
private class BookingFormSereneControllerTest {
    @isTest
    static void testConstructor(){
        BookingFormSereneController Serenecontroller = new BookingFormSereneController();
    }
    
    @isTest
    static void testGetOpportunityDetails() {
        Opportunity__c oppRec = new Opportunity__c(Opportunity_Name__c = 'Test Opportunity');
        insert oppRec;
        
        List<Applicant__c> listOfApplicantDetails = new List<Applicant__c>();
        
        Applicant__c applicantRec = new Applicant__c(Name__c ='Test Applicant', Opportunity__c=oppRec.Id,First_Applicant__c =true );
        insert applicantRec;
        listOfApplicantDetails.add(applicantRec);
        
        Applicant__c applicantRec1 = new Applicant__c(Name__c ='Test Applicant', Opportunity__c=oppRec.Id,First_Applicant__c =false );
        insert applicantRec1;
        
        List<BookingFormSereneController.applicantDateWrapperClass> wrapListApp = new List<BookingFormSereneController.applicantDateWrapperClass>();
             
        BookingFormSereneController.applicantDateWrapperClass wrapApp = new BookingFormSereneController.applicantDateWrapperClass();
        wrapApp.day = 15;
        wrapApp.month = 08;
        wrapApp.year = 2023;
        wrapApp.firstApp = true;
        wrapListApp.add(wrapApp);
        
        BookingFormSereneController.oppDateWrapperClass wrap = new BookingFormSereneController.oppDateWrapperClass();
        BookingFormSereneController.oppDateWrapperClass wrap1 = new BookingFormSereneController.oppDateWrapperClass();
        BookingFormSereneController.oppDateWrapperClass wrap2 = new BookingFormSereneController.oppDateWrapperClass();
        BookingFormSereneController.oppDateWrapperClass wrap3 = new BookingFormSereneController.oppDateWrapperClass();
        
        List<BookingFormSereneController.oppDateWrapperClass> wrapList = new List<BookingFormSereneController.oppDateWrapperClass>();
        List<BookingFormSereneController.oppDateWrapperClass> wrapList1 = new List<BookingFormSereneController.oppDateWrapperClass>();
        List<BookingFormSereneController.oppDateWrapperClass> wrapList2 = new List<BookingFormSereneController.oppDateWrapperClass>();
        List<BookingFormSereneController.oppDateWrapperClass> wrapList3 = new List<BookingFormSereneController.oppDateWrapperClass>();
        
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
        BookingFormSereneController.getOpportunityDetails(oppRec.Id);
        BookingFormSereneController.getFirstApplicantDetails(oppRec.Id);
        BookingFormSereneController.getSecondApplicantDetails(oppRec.Id);
        BookingFormSereneController.getAllOpportunityDetails(oppRec.Id);
        BookingFormSereneController.saveAppDetails(applicantRec,oppRec,2023,06,22);
        BookingFormSereneController.saveAppDetails2(applicantRec);
        BookingFormSereneController.saveSecondAppDetails(applicantRec,2023,06,23);
        BookingFormSereneController.saveApartmentCostDetails(oppRec);
        BookingFormSereneController.saveSurveyDetails(oppRec);
        BookingFormSereneController.finalOpportunitySubmit(oppRec,2023,06,22);
        
        BookingFormSereneController.submitDet(listOfApplicantDetails,oppRec,wrapListApp,wrapList3);
        BookingFormSereneController.submitDet(listOfApplicantDetails,oppRec,wrapListApp,wrapList2);
        BookingFormSereneController.submitDet(listOfApplicantDetails,oppRec,wrapListApp,wrapList1);
        
        BookingFormSereneController.savePaymentDetails(oppRec,wrapList);
        BookingFormSereneController.savePaymentDetails(oppRec,wrapList1);
        BookingFormSereneController.savePaymentDetails(oppRec,wrapList2);
        
        test.stopTest();
    }

    
}