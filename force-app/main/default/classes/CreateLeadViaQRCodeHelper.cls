public class CreateLeadViaQRCodeHelper {
    public Campaign campaignRecord {get;set;}
    public String campaignRecordString{get;set;}
    public String LeadRecordString{get;set;}
    public string leadSource {get;set;}
    public String leadSubSource {get;set;}
    public String leadSourceType {get;set;}
    
    Public CreateLeadViaQRCodeHelper() {
        String recordId = Apexpages.currentPage().getParameters().get('id'); 
        Lead__c leadRecord = new Lead__c();
        campaignRecord = [SELECT Id,Name FROM Campaign WHERE ID =:recordId];
        System.debug('campaignRecord ::'+campaignRecord);
        campaignRecordString=JSON.serialize(campaignRecord);
        LeadRecordString = JSON.serialize(leadRecord);
        leadSource = JSON.serialize(UtilityPickListClass.getPicklistValues('Lead__c', 'Lead_Source__c'));
        leadSubSource = JSON.serialize(UtilityPickListClass.getPicklistValues('Lead__c', 'Lead_Sub_Source__c'));
        leadSourceType = JSON.serialize(UtilityPickListClass.getPicklistValues('Lead__c', 'Lead_Source_Type__c'));
    }
    
    @RemoteAction
    public Static string insertLeadDetails(String campaignId,String name,String email, String phone, String leadSource,String leadSubSource,String leadSourceType ){ 
        system.debug('campaign ID====> ' + campaignId);
        system.debug('leadSource--->'+leadSource);
        system.debug('leadSubSource--->'+leadSubSource);
        system.debug('leadSourceType--->'+leadSourceType);
        
        
        Lead__c leadRecordToInsert = new Lead__c();
        leadRecordToInsert.Name__c = name;
        leadRecordToInsert.Email__c =email;
        leadRecordToInsert.Phone__c = phone;
        if(!string.isBlank(leadSource) && leadSource != null)
            leadRecordToInsert.Lead_Source__c = leadSource;
        if(!string.isBlank(leadSubSource))
            leadRecordToInsert.Lead_Sub_Source__c = leadSubSource;    
        if(!string.isBlank(leadSourceType))
            leadRecordToInsert.Lead_Source_Type__c = leadSourceType;
        leadRecordToInsert.Campaign__c = campaignId;
        
        Insert leadRecordToInsert;
        System.debug('Lead Record ==>'+leadRecordToInsert);
        //CampaignMember member = new CampaignMember(LeadId=led.Id,CampaignId=leadId);
        //insert member; 
        //system.debug('member Record ==>>'+member);
        return 'SUCCESS';
    }
}