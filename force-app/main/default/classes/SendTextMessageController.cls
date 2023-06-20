public class SendTextMessageController {
    @AuraEnabled
    public static List<Messages__c> getPreviousTextMessages(String leadId) {
        List<Messages__c> previousTextMessages = [Select Id, Message_Body__c,Message_Type__c From Messages__c Where Lead__c =: leadId And Type__c = 'Text SMS' order by CreatedDate ASC limit 10000 ];
        return previousTextMessages;
    }
    @AuraEnabled
    public static void sendSMS(String leadId, String messageBody) {
        system.debug('messageBody--->'+messageBody);
        if(!String.isBlank(messageBody)){
            string phone = '';
            List<Lead__c> leadList = new List<Lead__c>();
            
            Messages__c msgRecToInsert = new Messages__c();
            msgRecToInsert.Message_Body__c = messageBody;
            msgRecToInsert.Message_Type__c = 'Sent';
            msgRecToInsert.Lead__c = leadId;
            msgRecToInsert.Type__c = 'Text SMS';
            insert msgRecToInsert;
            
            leadList = [Select Id,Phone__c from Lead__c where Id = :leadId and Phone__c != null order by LastModifiedDate Desc];
            if(!leadList.isEmpty()){
                phone  = leadList[0].Phone__c;
                if(!String.isBlank(phone)){
                    phone = '91'+phone.right(10);
                    API_SendTextMessage.sendMessage(phone, messageBody);
                }
            }
        }
    }
}