public class SendWhatsAppNotificationHelper {
    @auraEnabled
    public static List<SMS_Template__c> getSMSTemplates() {
        return [SELECT Id, Message_for_FrontEnd__c,Message_Name__c,Message__c FROM SMS_Template__c where Type__c = 'WhatsApp' and id ='a0L1m0000044TWPEA2'];
    } 
    @auraEnabled
    public static void sendWhatsAppNotification(string smsTemplateId,string recordId) {
        system.debug('smsTemplateId--->'+smsTemplateId);
        system.debug('recordId--->'+recordId);
        string phoneNo = [select Phone__c From Lead__c where Id =: recordId].Phone__c;
        phoneNo = phoneNo.right(10);
        string message = [Select Message__c from SMS_Template__c where Id = 'a0L1m0000044TWPEA2'].Message__c;
        //message = 'It was a pleasure talking to you! I will be happy to connect with you further and take you through our delightfully designed residential projects that may suit your requirement and is within your expectations.\nFeel free to reach us on 8066966692 regarding any queries that you may have!\nHere is the link to the brochure - http://www.vaishnaviserenebooking.com/?gclid=CjwKCAjw4ZWkBhA4EiwAVJXwqXOKuZJ2GhJWtVm2F4nC3vzPAqvCeaVcPFyOErZ7nq63NOwcj30P4hoCx_wQAvD_BwE\n\nWarm Regards,\nTeam Vaishnavi\nhttps://www.vaishnavigroup.com/';
        API_WhatsApp.sendWhatsAppMessage(phoneNo, message);
    } 
    
    @future(callout=true)
    public static void sendWelcimeMessage(set<String> phoneNos){
        string textMessage = [Select Message__c from SMS_Template__c where Id = 'a0L1m0000044TW9EAM'].Message__c;
        list<string> messageList = string.valueOf(textMessage).split(' needlineBreak ');
        string stringToPass = '';
        system.debug('messageList---'+messageList.size());
        for(string msg:messageList){
            system.debug('msg--'+msg);
            stringToPass += msg+'\n';
        }
        system.debug('stringToPass--'+stringToPass);
        stringToPass = stringToPass.Substring(0,stringToPass.length()-1);
        system.debug('stringToPass--'+stringToPass);
        stringToPass = stringToPass.replace('{{1}}', '8066966692');
        stringToPass = stringToPass.replace('{{2}}', 'http://www.vaishnaviserenebooking.com/?gclid=CjwKCAjw4ZWkBhA4EiwAVJXwqXOKuZJ2GhJWtVm2F4nC3vzPAqvCeaVcPFyOErZ7nq63NOwcj30P4hoCx_wQAvD_BwE');
        for(string phone : phoneNos){
            API_WhatsApp.sendWhatsappTemplate(phone,stringToPass);
        }
    }
}