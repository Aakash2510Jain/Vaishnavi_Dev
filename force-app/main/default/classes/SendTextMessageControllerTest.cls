@isTest
public class SendTextMessageControllerTest {
	@isTest
    static void testgetPreviousTextMessages(){
        Lead__c leadRec = new Lead__c(Phone__c='8208472038');
        insert leadRec;
        
        Messages__c msg = new Messages__c(Lead__c = leadRec.Id,Message_Body__c = 'Test Message', Message_Type__c = 'Sent');
        insert msg;
        
        SMS_Template__c smsTemplate = new SMS_Template__c(Type__c = 'SMS testing');
        insert smsTemplate;
        
        Test.startTest();
        SendTextMessageController.wrapper result = SendTextMessageController.getPreviousTextMessages(leadRec.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testSendSMS() {
        
        Lead__c lead = new Lead__c(Phone__c = '9860680699');
        insert lead;
        String messageBody = 'Test Message';
        String smsTempId = 'TestTemplateId';
        
        Test.startTest();  
        SendTextMessageController.sendSMS(lead.Id, messageBody, smsTempId);
        Test.stopTest();
        
        
    }
}