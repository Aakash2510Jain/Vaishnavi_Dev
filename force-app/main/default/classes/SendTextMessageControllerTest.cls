@isTest
public class SendTextMessageControllerTest {
    
    public class ExampleCalloutMock implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('Salesforcescool');
            return res;
        }
    }
    
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
        
        Lead__c leadRecord = new Lead__c(Phone__c = '9860680699');
        insert leadRecord;
        String messageBody = 'Test Message';
        String smsTempId = 'TestTemplateId';
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
        SendTextMessageController.sendSMS(leadRecord.Id, messageBody, smsTempId);
        Test.stopTest();
        
        
    }
}