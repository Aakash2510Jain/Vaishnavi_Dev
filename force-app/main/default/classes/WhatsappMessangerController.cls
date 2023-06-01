/**
 * DeaGle:
 */
public without sharing class WhatsappMessangerController {
    
    @AuraEnabled(cacheable=true)
    public static List<MessageWrapper> getContactWhatsappHistory(String contactId){
        system.debug('--- '+contactId);
        try {
            List<MessageWrapper> messages = new List<MessageWrapper>();
            if(!String.isBlank(contactId)) {
                for(Messages__c message : [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Txn_Id__c, Display_Phone_Number__c, Phone_Number_Id__c, Contact_Name__c, Wa_Id__c, From__c, Message_Id__c, Timestamp__c, Message_Body__c, Type__c FROM Messages__c WHERE Contact__c = :contactId ORDER By CreatedDate]) {
                    if(true) {
                        messages.add(new MessageWrapper(message.id, message.From__c, message.Message_Body__c, message.Timestamp__c, 'received-message'));
                    }
                }
            }
            return messages;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> search(String searchTerm, string myObject, String filter) {
        String myQuery = null;
        if(filter != null && filter != ''){
            myQuery = 'Select Id, Name, Template_Name__c from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' AND '+filter+' LIMIT  5';
        }
        else {
            if(searchTerm == null || searchTerm == ''){
                myQuery = 'Select Id, Name, Template_Name__c from '+myObject+' Where LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT  5';
            }
            else {
                myQuery = 'Select Id, Name, Template_Name__c from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' LIMIT  5';
            }
        }
        List<sObject> lookUpList = database.query(myQuery);
        return lookUpList;
    }

    private static final String WHATSAPP_TOKEN = 'EAAKJz6xiZC6gBAOCerZB6JKxKb5RuDsXAKLZCH7Xxngt7fZAlP8zyQvix9fT19kaNXU8zVX41nRnGx1AkGk77fWdprQ0r7moGU3n1ULSi7SPJOPyP0RVCxLSB4NiqILpNGSaJctCZBhRYmtbJX0XRrCQ7M8gPZCIfOrtXWnGPKfFN6mosheFdEoh670keAJ6MccZBs3fqPnFQZDZD'; //TODO: make it dynamic.
    private static final String WHATSAPP_ENDPOINT = 'callout:Whatsapp_Cloud';

    
    @AuraEnabled
    public static Boolean sendMessageTemplate(String templateName, String phoneNumber) {
        try {
            Map<String,String> headerMap = new Map<String,String>{'Content-Type' => 'application/json', 'Authorization' => 'Bearer '+ WHATSAPP_TOKEN};
            HttpUtility utilityInstance = HttpUtility.getInstance();
            String responseBody = utilityInstance.httpReqHelper(headerMap, 'POST', JSON.serialize(constructTemplateBody(templateName, phoneNumber), true), WHATSAPP_ENDPOINT);
            System.debug('--- httpReqHelper '+ responseBody);
            return true;

        }catch(Exception e) {
            System.debug('--- error message '+e.getMessage());
            return false;
        }
    }

    //static String testText = '{"phone_number": "whatsapp:+919738951291","message": {"content": {"type": "text","text": "Hello, this is a test message!"}}}';
    @AuraEnabled
    public static Boolean sendMessageText(String textMessage, String phoneNumber){
        try {
            Map<String,String> headerMap = new Map<String,String>{'Content-Type' => 'application/json', 'Authorization' => 'Bearer '+ WHATSAPP_TOKEN};
            HttpUtility utilityInstance = HttpUtility.getInstance();
            String responseBody = utilityInstance.httpReqHelper(headerMap, 'POST', JSON.serialize(constructTextMsgBody(textMessage, phoneNumber), true),WHATSAPP_ENDPOINT);
            System.debug('--- httpReqHelper '+ responseBody);
            return true;
        } catch (Exception e) {
            System.debug('--- error message '+e.getMessage());
            return false;
        }
    }

    //static String testText = '{"messaging_product": "whatsapp","recipient_type": "individual","to": "+919738951291","type": "text","text": {"preview_url": false,"body": "testing"}}';
    private static WTextMsgWrapper constructTextMsgBody(String textMessage, String phoneNumber) {
        WTextMsgWrapper msgWrapper = new WTextMsgWrapper();
        msgWrapper.messaging_product = 'whatsapp';
        msgWrapper.recipient_type = 'individual';
        msgWrapper.to = phoneNumber;
        msgWrapper.type = 'text';

        WTextWrapper textWrapper = new WTextWrapper();
        textWrapper.body = textMessage;

        msgWrapper.text = textWrapper;

        return msgWrapper;

    }

    
    private static WhatsappMessageWrapper constructTemplateBody(String templateName, String phoneNumber) {
        
        /*{"messaging_product": "whatsapp","to": "919738951291","type": "template","template": {"name": "hello_world","language": {"code": "en_US"}}}*/

        WhatsappMessageWrapper msgWrapper = new WhatsappMessageWrapper();
        msgWrapper.messaging_product = 'whatsapp';
        msgWrapper.type = 'template';
        msgWrapper.to = phoneNumber;
        WhatsappMessageWrapper.cls_template templateObj = new WhatsappMessageWrapper.cls_template();
        templateObj.name = templateName;

        WhatsappMessageWrapper.cls_language languageObj = new WhatsappMessageWrapper.cls_language();
        languageObj.code = 'en_US';

        templateObj.language = languageObj;

        msgWrapper.template = templateObj;

        return msgWrapper;
    }

    public class MessageWrapper {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String sender;
        @AuraEnabled
        public String content;
        @AuraEnabled
        public String timee;
        @AuraEnabled
        public String classs;

        public MessageWrapper(String id, String sender, String content, String timee, String classs) {
            this.id = id;
            this.sender = sender;
            this.content = content;
            this.timee = timee;
            this.classs = classs;
        }
    }


    /**
     * {
            "messaging_product": "whatsapp",
            "recipient_type": "individual",
            "to": "+919738951291",
            "type": "text",
            "text": { // the text object
                "preview_url": false,
                "body": "testing"
                }
        }
     */
    public class WTextMsgWrapper {
        public String messaging_product;
        public String recipient_type;
        public String to;
        public String type;
        public WTextWrapper text;
    }

    public class WTextWrapper {
        public Boolean preview_url;
        public String body;
    }
}