public class SendTextMessageController {
    @AuraEnabled
    public static wrapper getPreviousTextMessages(String leadId) {
        List<Messages__c> previousTextMessages = [Select Id, Message_Body__c,Message_Type__c From Messages__c Where Lead__c =: leadId And Type__c = 'Text SMS' order by CreatedDate ASC limit 10000 ];
        
        wrapper wrapperInstance = new wrapper([Select Id, Message_Body__c,Message_Type__c From Messages__c Where Lead__c =: leadId And Type__c = 'Text SMS' order by CreatedDate ASC limit 10000],
                                             [Select Id,Message_Name__c,Message_for_FrontEnd__c,Message__c from SMS_Template__c where Type__c = 'SMS']);
        return wrapperInstance; 
    }
    @AuraEnabled
    public static void sendSMS(String leadId, String messageBody, string smsTempId) {
        system.debug('messageBody--->'+messageBody);
        if(!String.isBlank(messageBody)){
            string phone = '';
            List<Lead__c> leadList = new List<Lead__c>();
            
            /*Messages__c msgRecToInsert = new Messages__c();
            msgRecToInsert.Message_Body__c = messageBody;
            msgRecToInsert.Message_Type__c = 'Sent';
            msgRecToInsert.Lead__c = leadId;
            msgRecToInsert.Type__c = 'Text SMS';
            insert msgRecToInsert;*/
            
            leadList = [Select Id,Phone__c from Lead__c where Id = :leadId and Phone__c != null order by LastModifiedDate Desc];
            if(!leadList.isEmpty()){
                phone  = leadList[0].Phone__c;
                if(!String.isBlank(phone)){
                    phone = '91'+phone.right(10);
                    API_SendTextMessage.sendMessage(phone, messageBody,leadId);
                }
            }
        }
    }
    
    public class wrapper{
        @auraenabled
        public List<Messages__c> messageList{get;set;}
        @auraenabled
        public List<SMS_Template__c> smsTemplateList{get;set;}
        
        public wrapper(List<Messages__c> messageList, List<SMS_Template__c> smsTemplateList){
            this.messageList = messageList;
            this.smsTemplateList = smsTemplateList;
        } 
        
        
    }
}