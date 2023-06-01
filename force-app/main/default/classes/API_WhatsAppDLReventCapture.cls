@RESTResource(urlMapping = '/whatsapp_dlr_event_capture/*')
global class API_WhatsAppDLReventCapture {
    @HttpPost
    global static void captureDLREventResponse(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String body = req.requestBody.toString();
        system.debug('body--->'+body);
        List<String> recipientEmailList = new List<String>();
        recipientEmailList.add('aakash.jain@utilitarianlab.com');
        recipientEmailList.add('vignesh.naik@utilitarianlab.com');
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses( recipientEmailList );
        email.setSubject('this is the response from whatsapp for DLR event!');
        email.setPlainTextBody(body);
        email.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
}