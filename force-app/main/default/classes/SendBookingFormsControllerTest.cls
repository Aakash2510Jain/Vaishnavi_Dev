@isTest
public class SendBookingFormsControllerTest {
	@isTest
    static void testSendPremiereBookingForm(){
        Opportunity__c opp = new Opportunity__c(Opportunity_Name__c = 'Test Opportunity');
        insert opp;
        
        EmailTemplate etemp = new EmailTemplate( Name = 'Premiere Booking Form', Subject = 'Test Premiere Booking Form Subject', HtmlValue = 'Premiere Booking Form HTML Value');
        insert etemp;
    }
}