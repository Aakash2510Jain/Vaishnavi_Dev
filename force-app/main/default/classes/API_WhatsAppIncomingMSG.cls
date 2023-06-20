@RESTResource(urlMapping = '/whatsapp_incoming_msg/*')
global class API_WhatsAppIncomingMSG {
    @HttpPost
    global static void captureIncomingWhatsAppMSG(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String body = req.requestBody.toString();
        system.debug('body---->'+body);
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(body);
        
        String mobileNumber = (String) jsonMap.get('mobile');
        
        //List<List<SObject>> searchResults = [FIND '7042458620' IN ALL FIELDS RETURNING Lead__c(Id, Phone__c, Phone_Alternative__c),Opportunity__C(Id,Name,Phone__c)];
        
        List<Lead__c> leadsList = [Select Id,Name,Phone__c from Lead__c where Phone__C Like: mobileNumber];
        List<Opportunity__C> opportunityList = [Select Id,Name,Phone__c from Opportunity__C where Phone__C Like: mobileNumber];
        
        List<Messages__c> messageListToInsert = new List<Messages__c>();
        
        if(!leadsList.isEmpty()){
            for(Lead__c leadRec : leadsList){
                if( (leadRec.Phone__c).contains(mobileNumber)){
                    Messages__c messageRecToInsert = new Messages__c();
                    messageRecToInsert.Message_Body__c = (String) jsonMap.get('text');
                    messageRecToInsert.Lead__c = leadRec.Id;
                    messageRecToInsert.Type__c = 'Received';
                    messageListToInsert.add(messageRecToInsert);
                }
            }
            if(!messageListToInsert.isEmpty()){
                insert messageListToInsert;
            }
        }
        
        if(!opportunityList.isEmpty()){
            for(Opportunity__C oppRec : opportunityList){
                if( (oppRec.Phone__c).contains(mobileNumber)){
                    Messages__c messageRecToInsert = new Messages__c();
                    messageRecToInsert.Message_Body__c = (String) jsonMap.get('text');
                    messageRecToInsert.Opportunity__c = oppRec.Id;
                    messageRecToInsert.Type__c = 'Received';
                    messageListToInsert.add(messageRecToInsert);
                }
            }
            if(!messageListToInsert.isEmpty()){
                insert messageListToInsert;
            }
        }
        
    }
}