@isTest
public class SendWhatsAppNotificationHelperTest {
    @isTest
    static void testGetSMSTemplates(){
        SMS_Template__c temp = new SMS_Template__c(Type__c = 'WhatsApp', Id = 'a0L1m0000044TWPEA2');
        insert temp;
        
        Test.startTest();
        List<SMS_Template__c> templates = SendWhatsAppNotificationHelper.getSMSTemplates();
        Test.stopTest();     
    }
        
    @isTest
    static void testSendWhatsAppNotification(){
        String recordId = 'recordId';
        String smsTemplateId = 'smsTemplateId';
        
        Lead__c leadRec = new Lead__c(Id = recordId, Phone__c='8208472038');
        insert leadRec;
        
        SMS_Template__c template = new SMS_Template__c( Id = 'a0L1m0000044TWPEA2',Message__c = 'Test message');
        insert template;
        
        Test.startTest();
        SendWhatsAppNotificationHelper.sendWhatsAppNotification(smsTemplateId, recordId);
        Test.stopTest();
    }
    
     @isTest
    static void testsendWelcimeMessage() {
        
        Set<String> phoneNos = new Set<String>{ '1234567890' };
        SMS_Template__c template = new SMS_Template__c( Id = 'a0L1m0000044TW9EAM',Message__c = 'Welcome message');
        insert template;
        
        Test.startTest();
        SendWhatsAppNotificationHelper.sendWelcimeMessage(phoneNos);
        Test.stopTest();
    }
}