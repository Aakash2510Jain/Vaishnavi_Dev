public without sharing class API_Whatsapp_GETALLTEMPLATES {
    private static String whatsapp_baseURL          = 'https://wamedia.smsgupshup.com/GatewayAPI/rest';
    private static String whatsapp_userid           = '2000212725';
    private static String whatsapp_password         = 'BTmHHaeBc';
    final static string success_response            = 'success';
    final static string error_response              = 'failure';
	
    @auraEnabled
    public static void fetchAllWhatsAppTemplates(){
        List<SMS_Template__c> smsListToUpsert = new List<SMS_Template__c>();
        List<SMS_Template__c> existingSmsList = new List<SMS_Template__c>();
        Map<String, String> smsIdBySalesforceId = new Map<String, String>();
        Map<String, String> requestParams = prepareRequestParams();
        HttpRequest httpRequest = new HttpRequest();
        Http http = new Http();
        
        existingSmsList = [Select Id,ID__c from SMS_Template__c];
        if(!existingSmsList.isEmpty()){
            for(SMS_Template__c smsTemplateRec : existingSmsList){
                smsIdBySalesforceId.put(smsTemplateRec.Id__c, smsTemplateRec.Id);
            }
        }
        
        httpRequest.setMethod('GET');
        String queryString = '';       
        
        for (String param : requestParams.keySet()) {
            System.debug('requestParams.keySet()==='+requestParams.get(param));
            String value = EncodingUtil.urlEncode(requestParams.get(param), 'UTF-8');
            System.debug('value--'+value);
            queryString += '&' + param + '=' + value;
        }

        httpRequest.setEndpoint(whatsapp_baseURL + '?' + queryString);
        
        HttpResponse httpResponse = http.send(httpRequest);
        
        if (httpResponse.getStatusCode() == 200) {
            String responseBody = httpResponse.getBody();
            ParseWhatsappTemplates parsedResponse = ParseWhatsappTemplates.parse(responseBody);
            
            for(ParseWhatsappTemplates.cls_data messageRecord : parsedResponse.data){
                SMS_Template__c smsRec = new SMS_Template__c();
                if(smsIdBySalesforceId.containsKey(messageRecord.id)){
                    //existing record <> update
                    smsRec.Id = smsIdBySalesforceId.get(messageRecord.id);
                }
                smsRec.Id__c = messageRecord.id;
                smsRec.Button_Type__c = messageRecord.button_type;
                smsRec.Category__c = messageRecord.category;
                Long createdDateTime = Long.valueOf(messageRecord.creation_time);
                Long updatedDateTime = Long.valueOf(messageRecord.updation_time);
                smsRec.Created_Date_Time__c = DateTime.newInstance(createdDateTime);
                smsRec.Updated_Date_Time__c = DateTime.newInstance(updatedDateTime);
                smsRec.Message__c = messageRecord.body;
                smsRec.Message_for_FrontEnd__c = messageRecord.body;
                smsRec.Message_Name__c = messageRecord.name;
                smsRec.Status__c = messageRecord.button_type;
                smsRec.Template_Name__c = messageRecord.button_type;
                smsRec.Type__c = messageRecord.button_type;
                smsListToUpsert.add(smsRec);
            }
            if(!smsListToUpsert.isEmpty()){
                upsert smsListToUpsert;
            }
        } else {
             System.debug('Error Occured: ');
        }
    }
    Public static Map<String, String> prepareRequestParams(){
        Map<String, String> requestParams = new Map<String, String>();
        requestParams.put('method', 'get_whatsapp_hsm');
        requestParams.put('userid', whatsapp_userid);
        requestParams.put('password', whatsapp_password);
        
        return requestParams;
    } 
}