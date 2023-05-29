/**
* @author Aakash Jain
* @email aakash.jain@utilitarianlab.com
* @create date 20-05-2023 18:13:59
* @modify date 20-05-2023 18:13:59
* @desc [description]
*/
public class LeadTriggerHandler {
    static LeadTriggerHandler handlerInstance;
    
    public static LeadTriggerHandler getInstance(){
        if (handlerInstance == null)
            handlerInstance = new LeadTriggerHandler();
        return handlerInstance;
    }
    
    public void beforeInsert(List<Lead__c> newLeadList){
        set<Id> leadIds = new Set<Id>();
        Map<Id, Lead__c> existingLeadIdByNewLeadRec = new map<id, Lead__c>();
        Set<String> phonesSet = new Set<String>();
        Set<String> emailsSet = new Set<String>();  
        List<Lead__c> existingLeadsList = new List<Lead__c>();
        List<Lead__c> existingLeadWithPhones = new List<Lead__c>();
        List<Lead__c> existingLeadWithEmails = new List<Lead__c>();
        List<Campaign> campaignList = new List<Campaign>();
        Map<String,Lead__c> leadRecByPhoneMap = new Map<String, Lead__c>();
        Map<String,Lead__c> leadRecByEmailMap = new Map<String, Lead__c>();
        Map<string, Campaign> campaignSourceByCampaignRecMap = new map<String, Campaign>();
        
        Date todayDate = system.today();
        campaignList = [Select id,Lead_Source_Type__c,Lead_Sub_Source__c,Lead_Source__c,IsActive,StartDate,EndDate From Campaign where IsActive = true And StartDate <= : todayDate and EndDate >= : todayDate and Lead_Source_Type__c != null];
        system.debug('campaignList--->'+campaignList);
        if(!campaignList.isEmpty()){
            for(Campaign campaignRec : campaignList){
                campaignSourceByCampaignRecMap.put(campaignRec.Lead_Source_Type__c, campaignRec);
            }
        }
        
        for(Lead__c leadRec : newLeadList){
            if(leadRec.Phone__c != null){
                leadRec.Phone__c = '+91'+leadRec.Phone__c;
                phonesSet.add(leadRec.Phone__c);
            }
            if(leadRec.Email__c != null)
            {
                emailsSet.add(leadRec.Email__c);
            }
            if(leadRec.Lead_Source_Type__c != null){
                if(campaignSourceByCampaignRecMap.containsKey(leadRec.Lead_Source_Type__c))
                    leadRec.Campaign__c = campaignSourceByCampaignRecMap.get(leadRec.Lead_Source_Type__c).Id;
            }
        }
        
        if(!phonesSet.isEmpty() || !emailsSet.isEmpty()){
            existingLeadsList = [Select Id,Phone__c,Email__c,createdDate From Lead__c where ( Phone__c In : phonesSet or Email__c In : emailsSet ) AND isConverted__c = false];
            system.debug('existingLeadsList-->'+existingLeadsList);
            
            if(!existingLeadsList.isEmpty()){
                for(Lead__c lead : existingLeadsList){
                    system.debug('lead.Email__c--->'+lead.Email__c);
                    system.debug('lead.Phone__c--->'+lead.Phone__c);
                    if(lead.Email__c != null){
                        leadRecByEmailMap.put(lead.Email__c, lead);
                    }else if(lead.Phone__c != null){
                        leadRecByPhoneMap.put(lead.Phone__c, lead);
                    }
                }
                system.debug('leadRecByPhoneMap-->'+leadRecByPhoneMap);
                system.debug('leadRecByEmailMap-->'+leadRecByEmailMap);
                if(!leadRecByPhoneMap.isEmpty() || !leadRecByEmailMap.isEmpty()){
                    for(Lead__c leadRec : newLeadList){
                        system.debug('lead.Email__c--->'+leadRec.Email__c);
                        system.debug('lead.Phone__c--->'+leadRec.Phone__c);
                        if(leadRec.Phone__c != null){
                            system.debug('leadRecByPhoneMap.containsKey(leadRec.Phone__c)--->'+leadRecByPhoneMap.containsKey(leadRec.Phone__c));
                            if(leadRecByPhoneMap.containsKey(leadRec.Phone__c)){
                                if(((system.now().getTime() - (leadRecByPhoneMap.get(leadRec.Phone__c).createdDate).getTime())/(24*3600*1000)) >90){
                                    leadRec.Lead_Stage__c = ConstantClass.LeadStageReEnquiry;
                                }else{
                                    leadRec.To_Be_Deleted__c = true;
                                    existingLeadIdByNewLeadRec.put(leadRecByPhoneMap.get(leadRec.Phone__c).Id, leadRec);  
                                }
                            }else if(leadRec.Email__c != null){
                                system.debug('leadRecByEmailMap.containsKey(leadRec.Email__c)--->'+leadRecByEmailMap.containsKey(leadRec.Email__c));
                                if(leadRecByEmailMap.containsKey(leadRec.Email__c)){
                                    if(((system.now().getTime() - (leadRecByEmailMap.get(leadRec.Email__c).createdDate).getTime())/(24*3600*1000)) >90){
                                        leadRec.Lead_Stage__c = ConstantClass.LeadStageReEnquiry;
                                    }else{
                                        leadRec.To_Be_Deleted__c = true;
                                        existingLeadIdByNewLeadRec.put(leadRecByEmailMap.get(leadRec.Email__c).Id, leadRec);
                                    }
                                }
                            }
                        }
                        else if(leadRec.Email__c != null){
                            system.debug('leadRecByPhoneMap.containsKey(leadRec.Phone__c)--->'+leadRecByPhoneMap.containsKey(leadRec.Phone__c));
                            if(leadRecByPhoneMap.containsKey(leadRec.Phone__c)){
                                if(((system.now().getTime() - (leadRecByPhoneMap.get(leadRec.Phone__c).createdDate).getTime())/(24*3600*1000)) >90){
                                    leadRec.Lead_Stage__c = ConstantClass.LeadStageReEnquiry;
                                }else{
                                    leadRec.To_Be_Deleted__c = true;
                                    existingLeadIdByNewLeadRec.put(leadRecByPhoneMap.get(leadRec.Phone__c).Id,leadRec);
                                }
                            }else if(leadRec.Email__c != null){
                                system.debug('leadRecByEmailMap.containsKey(leadRec.Email__c)--->'+leadRecByEmailMap.containsKey(leadRec.Email__c));
                                if(leadRecByEmailMap.containsKey(leadRec.Email__c)){
                                    if(((system.now().getTime() - (leadRecByEmailMap.get(leadRec.Email__c).createdDate).getTime())/(24*3600*1000)) >90){
                                        leadRec.Lead_Stage__c = ConstantClass.LeadStageReEnquiry;
                                    }else{
                                        leadRec.To_Be_Deleted__c = true;
                                        existingLeadIdByNewLeadRec.put(leadRecByEmailMap.get(leadRec.Email__c).Id,leadRec);
                                    }
                                }
                            }
                        }
                    }
                    system.debug('existingLeadIdByNewLeadRec-->'+existingLeadIdByNewLeadRec);
                    if(!existingLeadIdByNewLeadRec.isEmpty()){
                        system.debug('Calling method to Create Task');
                        createTaskForRenquiry.insertTask(existingLeadIdByNewLeadRec);
                    }
                    
                }
                
            }
        }
    }
    
    public void afteInsert(Map<Id, Lead__c> newLeadMap, Map<Id, Lead__c> oldLeadMap){
        List<Task> taskListToInsert = new List<Task>();
        
        for(Id leadId : newLeadMap.keyset()){
            Task taskRecToInsert = new Task();
            taskRecToInsert.whatId = leadId;
            taskRecToInsert.Subject = ConstantClass.TaskSubjectForNewLead;
            taskListToInsert.add(taskRecToInsert);
        }
        system.debug('taskListToInsert-->'+taskListToInsert);
        if(!taskListToInsert.isEmpty()){
            insert taskListToInsert;
        }
    }
    public void beforeUpdate(Map<Id, Lead__c> newLeadMap, Map<Id, Lead__c> oldLeadMap){
        List<Task> taskListToInsertforFollowup = new List<Task>();
        
        for(Lead__c leadRec : newLeadMap.values()){
            if(leadRec.Next_Followup_Date_Time__c != oldLeadMap.get(leadRec.Id).Next_Followup_Date_Time__c && leadRec.Next_Followup_Date_Time__c != null){
                if(leadRec.Next_Followup_Date_Time__c < system.now()){
                    leadRec.addError(ConstantClass.errorForPastFollowUpDate);
                }
                else{
                    Task taskRecToInsert = new Task();
                    taskRecToInsert.whatId = leadRec.Id;
                    taskRecToInsert.Subject = ConstantClass.TaskSubjectForFollowUpLead;
                    taskRecToInsert.Follow_Up_Date_Time__c = leadRec.Next_Followup_Date_Time__c;
                    taskListToInsertforFollowup.add(taskRecToInsert);
                }
            }
            if(leadRec.Lead_Substage__c != oldLeadMap.get(leadRec.Id).Lead_Substage__c && leadRec.Lead_Substage__c != null){
                if(leadRec.Lead_Substage__c == 'Not Interested' || leadRec.Lead_Substage__c == 'Not a relevant call' || 
                   leadRec.Lead_Substage__c == 'Junk lead'|| leadRec.Lead_Substage__c == 'Just Enquiry'|| 
                   leadRec.Lead_Substage__c == 'Did not Show up for site visit'|| leadRec.Lead_Substage__c == 'Not Interested in Property'
                  ){ 
                      leadRec.Lead_Stage__c = 'Drop';
                  }
                if(leadRec.Lead_Substage__c == 'Interested' ){
                    leadRec.Lead_Stage__c = ConstantClass.LeadStageSVProspect;
                }
                if(leadRec.Lead_Substage__c == 'Site Visit Planned' || leadRec.Lead_Substage__c == 'Site Visit Proposed'){
                    leadRec.Lead_Stage__c = ConstantClass.LeadStageSVPlanned;
                }
                if(leadRec.Lead_Substage__c == 'Not a relevant call' && (leadRec.Irrelevant_Call_Reason__c == null || string.isBlank(leadRec.Irrelevant_Call_Reason__c)) ){
                    leadRec.Irrelevant_Call_Reason__c.addError('Specify Not a relevant call reason');
                }
                if(leadRec.Lead_Substage__c == 'Site Visit Planned' && (leadRec.Site_Visit_Date__c < system.now() ||leadRec.Site_Visit_Date__c == null) ){
                    leadRec.Site_Visit_Date__c.addError('Specify Site visit Date greater then today');
                }
                if(leadRec.Lead_Substage__c == 'Follow up' && (leadRec.Next_Followup_Date_Time__c < system.now() ||leadRec.Next_Followup_Date_Time__c == null) ){
                    leadRec.Next_Followup_Date_Time__c.addError('Specify Follow up Date greater then today');
                }
            }
			            
        }
        if(!taskListToInsertforFollowup.isEmpty()){
            insert taskListToInsertforFollowup;
        }
    }
    
}