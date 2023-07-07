public without sharing class channelPartnerFormController {

    public String cpId {get;set;}

    public channelPartnerFormController() {
        cpId = Apexpages.currentPage().getParameters().get('id'); 
        system.debug('cpId---'+cpId);
    }

    @RemoteAction
    public static Channel_Partner__c getChannelPartnerDetails(string cpId){
        try{
            Channel_Partner__c channelPartnerRec = [Select Id,Channel_Partner_Name__c,Email__c,Phone__c,Aadhar_Card_No__c,RERA_Application_No__c FROM Channel_Partner__c WHERE Id =: cpId];
            return channelPartnerRec;
        }catch(Exception e){
            return null;
        }
    }

    @RemoteAction
    public static string saveChannelPartnerRecord(Channel_Partner__c channelPartnerRectoUpdate){
        try{
            if(channelPartnerRectoUpdate != null){
                update channelPartnerRectoUpdate;
            }
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
}