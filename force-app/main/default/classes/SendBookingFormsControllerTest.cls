@isTest
public class SendBookingFormsControllerTest {
    @isTest
    static void testSendPremiereBookingForm(){
        Opportunity__c opp = new Opportunity__c(Opportunity_Name__c = 'Test Opportunity',Email__c = 'Test@gmail.com');
        insert opp;
        
        
        
        test.startTest();
        SendBookingFormsController.sendPremiereBookingForm(opp.id);
        test.stopTest();
        
        
    }
    
    @isTest
    static void testSendLifeBookingForm(){
        Opportunity__c opp = new Opportunity__c(Opportunity_Name__c = 'Test Opportunity',Email__c = 'Test@gmail.com');
        insert opp;
        
        test.startTest();
        SendBookingFormsController.sendLifeBookingForm(opp.id);
        test.stopTest();
        
        
    }
    
    
    @isTest
    static void testSendSereneBookingForm(){
        Opportunity__c opp = new Opportunity__c(Opportunity_Name__c = 'Test Opportunity',Email__c = 'Test@gmail.com');
        insert opp;
        
        test.startTest();
        SendBookingFormsController.sendSereneBookingForm(opp.id);
        test.stopTest();
        
        
    }    
    
}