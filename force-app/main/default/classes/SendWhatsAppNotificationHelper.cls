public class SendWhatsAppNotificationHelper {
    @auraEnabled
    public static List<SMS_Template__c> getSMSTemplates() {
        return [SELECT Id, Message_for_FrontEnd__c,Message_Name__c,Message__c FROM SMS_Template__c where Type__c = 'WhatsApp'];
    } 
    @auraEnabled
    public static void sendWhatsAppNotification(string smsTemplateId,string recordId) {
        system.debug('smsTemplateId--->'+smsTemplateId);
        system.debug('recordId--->'+recordId);
        string phoneNo = [select Phone__c From Lead__c where Id =: recordId].Phone__c;
        phoneNo = phoneNo.right(10);
        string message = [Select Message__c from SMS_Template__c where Id =:smsTemplateId].Message__c;
        message = 'It was a pleasure talking to you! I will be happy to connect with you further and take you through our delightfully designed residential projects that may suit your requirement and is within your expectations.\nFeel free to reach us on MOBILNOOFVAISHNAVI regarding any queries that you may have!\nHere is the link to the brochure - BROCHERLINK\n\nWarm Regards,\nTeam Vaishnavi\nhttps://www.vaishnavigroup.com/';
        API_WhatsApp.sendWhatsAppMessage(phoneNo, message);
    } 
}