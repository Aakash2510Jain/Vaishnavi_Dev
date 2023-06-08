/**
 * DeaGle:
 */
public without sharing class WhatsappMessangerController {
    
    @AuraEnabled(cacheable=true)
    public static List<MessageWrapper> getContactWhatsappHistory(String recordId){
        try {
            System.debug('recordId---'+recordId);
            if(!string.isBlank(recordId)){
                string sObjectName = getObjectAPIName(recordId);
                system.debug('--- '+recordId+'-----sObjectName----'+sObjectName);
                List<MessageWrapper> messages = new List<MessageWrapper>();
                list<Messages__c> MessageList = New List<Messages__c>();
                // if(sObjectName == 'Contact'){
                //     MessageList = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Txn_Id__c, Display_Phone_Number__c, Phone_Number_Id__c, Contact_Name__c, Wa_Id__c, From__c, Message_Id__c, Timestamp__c, Message_Body__c, Type__c,Message_Type__c FROM Messages__c WHERE Contact__c = :recordId ORDER By CreatedDate];
                // }else if(sObjectName == 'Opportunity__c'){
                //     MessageList = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Txn_Id__c, Display_Phone_Number__c, Phone_Number_Id__c, Contact_Name__c, Wa_Id__c, From__c, Message_Id__c, Timestamp__c, Message_Body__c, Type__c,Message_Type__c FROM Messages__c WHERE Opportunity__c = :recordId ORDER By CreatedDate];
                // }
                if(sObjectName == 'Campaign'){
                    sObjectName = 'Campaign__c';
                }
                string queryString = 'SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Txn_Id__c, Display_Phone_Number__c, Phone_Number_Id__c, Contact_Name__c, Wa_Id__c, From__c, Message_Id__c, Timestamp__c, Message_Body__c, Type__c,Message_Type__c FROM Messages__c WHERE '+sObjectName+' = :recordId ORDER By CreatedDate';
                MessageList = database.query(queryString);
                system.debug('MessageList--'+MessageList);
                if(!String.isBlank(recordId)) {
                    for(Messages__c message : MessageList) {
                         MessageWrapper mWrapper = New MessageWrapper(string.valueOf(message.id), message.From__c, message.Message_Body__c, message.Timestamp__c, '','');
                         if(message.Message_Type__c == 'Sent'){
                            System.debug('sentMessage');
                            mWrapper.classs = 'sent-message';
                            mWrapper.pclass = 'message-row-send';
                         }else{
                            mWrapper.classs = 'received-message';
                            mWrapper.pclass = 'message-row-recieve';
                         }
                         messages.add(mWrapper);
                    }
                }
                System.debug('messages--'+messages);
                return messages;
            }
            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> search(String searchTerm, string myObject, String filter) {
        String myQuery = null;
        myObject = 'SMS_Template__c';
        if(filter != null && filter != ''){
            myQuery = 'Select Id, Name,Message_Name__c, Template_Name__c from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' AND '+filter+' LIMIT  5';
        }
        else {
            if(searchTerm == null || searchTerm == ''){
                myQuery = 'Select Id,Message_Name__c, Name, Template_Name__c from '+myObject+' Where LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT  5';
            }
            else {
                myQuery = 'Select Id, Name,Message_Name__c, Template_Name__c from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' LIMIT  5';
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
    public static Boolean sendMessageText(String textMessage, String phoneNumber, string recordId){
        // try {
        //     Map<String,String> headerMap = new Map<String,String>{'Content-Type' => 'application/json', 'Authorization' => 'Bearer '+ WHATSAPP_TOKEN};
        //     HttpUtility utilityInstance = HttpUtility.getInstance();
        //     String responseBody = utilityInstance.httpReqHelper(headerMap, 'POST', JSON.serialize(constructTextMsgBody(textMessage, phoneNumber), true),WHATSAPP_ENDPOINT);
        //     System.debug('--- httpReqHelper '+ responseBody);
        //     return true;
        // } catch (Exception e) {
        //     System.debug('--- error message '+e.getMessage());
        //     return false;
        // }
        try{
            System.debug('textMessage----'+textMessage+'---phoneNumber-----'+phoneNumber+'----recordId----'+recordId);
            
            // replace 
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
            
            boolean isMessageSentSuccessfully = API_WhatsApp.sendWhatsappTemplate(phoneNumber,stringToPass);
            if(isMessageSentSuccessfully){
                string sObjectName = getObjectAPIName(recordId);
                Messages__c newMessage = New Messages__c();
                newMessage.Message_Body__c = stringToPass;
                newMessage.Message_Type__c = 'Sent';
                if(sObjectName == 'Opportunity__c'){
                    newMessage.Opportunity__c = recordId;
                } else if(sObjectName == 'Lead__c'){
                    newMessage.Lead__c = recordId;
                }else if(sObjectName == 'Campaign'){
                    newMessage.Campaign__c = recordId;
                }
                system.debug('newMessage---'+newMessage);
                insert newMessage;
            }
            return true;
        }catch(Exception e){
            System.debug('line--'+e.getLineNumber()+'-------'+e.getMessage());
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

    @AuraEnabled
    public static List<sobject> getPhoneNumber(string sojectName, string recordId){
        string querystring = 'select name,id,phone__c from '+sojectName+' where Id = \''+recordId +'\'';
        System.debug('querystring=='+querystring);
        List<sobject> retrivedData = Database.query(querystring);
        System.debug('retrivedData---'+retrivedData);
        system.debug('retrivedData.size()'+retrivedData.size());
        if(!retrivedData.isEmpty()){
            return retrivedData;
        }
        return null;
    }

    @AuraEnabled
    public static string getTemplateDetails(string tempId){
       List<SMS_Template__c> templateList = [select name,id,Message_for_FrontEnd__c,Message__c from SMS_Template__c where Id =:tempId];
        if(!templateList.isEmpty()){
            return JSON.serialize(templateList[0]);
        }
        return null;
    }

    public static string getObjectAPIName(string recordId){
        String keyCode  = recordId.subString(0,3);
        string objectAPIName;
    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    for(Schema.SObjectType objectInstance : gd.values()){
        if(objectInstance.getDescribe().getKeyPrefix() == keyCode){
        System.debug('Id is related to object: '+ objectInstance.getDescribe().getName());
        objectAPIName =  objectInstance.getDescribe().getName();
            }
        }
        return objectAPIName;
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
        @AuraEnabled
        public String pclass;

        public MessageWrapper(String id, String sender, String content, String timee, String classs, string pclass) {
            this.id = id;
            this.sender = sender;
            this.content = content;
            this.timee = timee;
            this.classs = classs;
            this.pclass = pclass;
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