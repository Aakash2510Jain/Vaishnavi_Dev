@IsTest
private class BookingFormLifeControllerTest {
    @isTest
    static void testConstructor(){
        BookingFormLifeController Lifecontroller = new BookingFormLifeController();
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
        
        List<BookingFormLifeController.applicantDateWrapperClass> wrapListApp = new List<BookingFormLifeController.applicantDateWrapperClass>();
             
        BookingFormLifeController.applicantDateWrapperClass wrapApp = new BookingFormLifeController.applicantDateWrapperClass();
        wrapApp.day = 15;
        wrapApp.month = 08;
        wrapApp.year = 2023;
        wrapApp.firstApp = true;
        wrapListApp.add(wrapApp);
        
        BookingFormLifeController.oppDateWrapperClass wrap = new BookingFormLifeController.oppDateWrapperClass();
        BookingFormLifeController.oppDateWrapperClass wrap1 = new BookingFormLifeController.oppDateWrapperClass();
        BookingFormLifeController.oppDateWrapperClass wrap2 = new BookingFormLifeController.oppDateWrapperClass();
        BookingFormLifeController.oppDateWrapperClass wrap3 = new BookingFormLifeController.oppDateWrapperClass();
        
        List<BookingFormLifeController.oppDateWrapperClass> wrapList = new List<BookingFormLifeController.oppDateWrapperClass>();
        List<BookingFormLifeController.oppDateWrapperClass> wrapList1 = new List<BookingFormLifeController.oppDateWrapperClass>();
        List<BookingFormLifeController.oppDateWrapperClass> wrapList2 = new List<BookingFormLifeController.oppDateWrapperClass>();
        List<BookingFormLifeController.oppDateWrapperClass> wrapList3 = new List<BookingFormLifeController.oppDateWrapperClass>();
        
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
        BookingFormLifeController.getOpportunityDetails(oppRec.Id);
        BookingFormLifeController.getFirstApplicantDetails(oppRec.Id);
        BookingFormLifeController.getSecondApplicantDetails(oppRec.Id);
        BookingFormLifeController.getAllOpportunityDetails(oppRec.Id);
        BookingFormLifeController.saveAppDetails(applicantRec,oppRec,2023,06,22);
        BookingFormLifeController.saveAppDetails2(applicantRec);
        BookingFormLifeController.saveSecondAppDetails(applicantRec,2023,06,23);
        BookingFormLifeController.saveApartmentCostDetails(oppRec);
        BookingFormLifeController.saveSurveyDetails(oppRec);
        BookingFormLifeController.finalOpportunitySubmit(oppRec,2023,06,22);
        
        BookingFormLifeController.submitDet(listOfApplicantDetails,oppRec,wrapListApp,wrapList3);
        BookingFormLifeController.submitDet(listOfApplicantDetails,oppRec,wrapListApp,wrapList2);
        BookingFormLifeController.submitDet(listOfApplicantDetails,oppRec,wrapListApp,wrapList1);
        
        BookingFormLifeController.savePaymentDetails(oppRec,wrapList);
        BookingFormLifeController.savePaymentDetails(oppRec,wrapList1);
        BookingFormLifeController.savePaymentDetails(oppRec,wrapList2);
        
        test.stopTest();
    }

    
}