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
            leadRec.RecordTypeId = ConstantClass.newEnquiryLeadRT;
            //handle source and subsource and source type
            if(leadRec.Lead_Source_Type__c != null ){
                if(leadRec.Lead_Source_Type__c == 'Magazine' || leadRec.Lead_Source_Type__c == 'News Paper-Others' || leadRec.Lead_Source_Type__c == 'News Paper-TOI'){
                    leadRec.Lead_Sub_Source__c = 'Print';
                    leadRec.Lead_Source__c = 'ATL';
                }
                if(leadRec.Lead_Source_Type__c == 'Hoarding' || leadRec.Lead_Source_Type__c == 'Site Hoarding' || leadRec.Lead_Source_Type__c == 'Bus Wrap & Bus Shelter' || leadRec.Lead_Source_Type__c == 'Mobile Van'){
                    leadRec.Lead_Sub_Source__c = 'Outdoor';
                    leadRec.Lead_Source__c = 'ATL';
                }
                if(leadRec.Lead_Source_Type__c == 'Radio' ){
                    leadRec.Lead_Sub_Source__c = 'Electronic';
                    leadRec.Lead_Source__c = 'ATL';
                }
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
                                if(((system.now().getTime() - (leadRecByPhoneMap.get(leadRec.Phone__c).createdDate).getTime())/(24*3600*1000)) >ConstantClass.TATForReEnquiryLead){
                                    leadRec.Lead_Stage__c = ConstantClass.LeadStageReEnquiry;
                                    leadRec.RecordTypeId =  ConstantClass.ReEnquiryLeadRT;
                                }else{
                                    leadRec.To_Be_Deleted__c = true;
                                    existingLeadIdByNewLeadRec.put(leadRecByPhoneMap.get(leadRec.Phone__c).Id, leadRec);  
                                }
                            }else if(leadRec.Email__c != null){
                                system.debug('leadRecByEmailMap.containsKey(leadRec.Email__c)--->'+leadRecByEmailMap.containsKey(leadRec.Email__c));
                                if(leadRecByEmailMap.containsKey(leadRec.Email__c)){
                                    if(((system.now().getTime() - (leadRecByEmailMap.get(leadRec.Email__c).createdDate).getTime())/(24*3600*1000)) > ConstantClass.TATForReEnquiryLead){
                                        leadRec.Lead_Stage__c = ConstantClass.LeadStageReEnquiry;
                                        leadRec.RecordTypeId =  ConstantClass.ReEnquiryLeadRT;
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
                                if(((system.now().getTime() - (leadRecByPhoneMap.get(leadRec.Phone__c).createdDate).getTime())/(24*3600*1000)) >ConstantClass.TATForReEnquiryLead){
                                    leadRec.Lead_Stage__c = ConstantClass.LeadStageReEnquiry;
                                    leadRec.RecordTypeId =  ConstantClass.ReEnquiryLeadRT;
                                }else{
                                    leadRec.To_Be_Deleted__c = true;
                                    existingLeadIdByNewLeadRec.put(leadRecByPhoneMap.get(leadRec.Phone__c).Id,leadRec);
                                }
                            }else if(leadRec.Email__c != null){
                                system.debug('leadRecByEmailMap.containsKey(leadRec.Email__c)--->'+leadRecByEmailMap.containsKey(leadRec.Email__c));
                                if(leadRecByEmailMap.containsKey(leadRec.Email__c)){
                                    if(((system.now().getTime() - (leadRecByEmailMap.get(leadRec.Email__c).createdDate).getTime())/(24*3600*1000)) >ConstantClass.TATForReEnquiryLead){
                                        leadRec.Lead_Stage__c = ConstantClass.LeadStageReEnquiry;
                                        leadRec.RecordTypeId =  ConstantClass.ReEnquiryLeadRT;
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
            transferToSalesTeamHelper.shareAndTagSalesTeamMember(leadId);
            Task taskRecToInsert = new Task();
            taskRecToInsert.whatId = leadId;
            taskRecToInsert.Subject = ConstantClass.TaskSubjectForFollowUpLead;
            taskListToInsert.add(taskRecToInsert);
        }
        system.debug('taskListToInsert-->'+taskListToInsert);
        if(!taskListToInsert.isEmpty()){
            insert taskListToInsert;
        }
    }
    public void beforeUpdate(Map<Id, Lead__c> newLeadMap, Map<Id, Lead__c> oldLeadMap){
        List<Task> taskListToInsertforFollowup = new List<Task>();
        List<Lead__c> convertedLeadRecordsList = new List<Lead__c>();
        String profileName = [Select Name from Profile where Id =: UserInfo.getProfileId()].Name;
        set<Id> leadIds = new Set<Id>();
                
        for(Lead__c leadRec : newLeadMap.values()){
            if(leadRec.isConverted__c && leadRec.OwnerId == oldLeadMap.get(leadRec.Id).OwnerId && profileName != 'System Administrator'){
                leadRec.addError('Converted Lead Can not be Edited');
            }
            if(leadRec.isQualified__c == false && leadRec.isQualified__c != oldLeadMap.get(leadRec.Id).isQualified__c){
                leadRec.isQualified__c = true;
            }
            if(leadRec.isQualified__c && leadRec.Qualified_Date_Time__c == null){
                leadRec.Qualified_Date_Time__c = system.now();
            }
            if(leadRec.Lead_Stage__c != oldLeadMap.get(leadRec.Id).Lead_Stage__c){
                if(leadRec.Lead_Stage__c == ConstantClass.LeadStageConverted){
                    leadRec.isConverted__c = true;
                    leadRec.OwnerId = ConstantClass.convertedLeadQueue;
                    convertedLeadRecordsList.add(leadRec);
                }    
            }
            if(leadRec.Next_Followup_Date_Time__c != oldLeadMap.get(leadRec.Id).Next_Followup_Date_Time__c && leadRec.Next_Followup_Date_Time__c != null){
                if(leadRec.Next_Followup_Date_Time__c < system.now()){
                    leadRec.addError(ConstantClass.errorForPastFollowUpDate);
                }
                else{
                    Task taskRecToInsert = new Task();
                    taskRecToInsert.whatId = leadRec.Id;
                    taskRecToInsert.Subject = ConstantClass.TaskSubjectForNextFollowUpLead;
                    taskRecToInsert.Follow_Up_Date_Time__c = leadRec.Next_Followup_Date_Time__c;
                    taskRecToInsert.Description = 'Provide the Conversation Comments for the Call(Answered/UnAswered)';
                    taskListToInsertforFollowup.add(taskRecToInsert);
                }
            }
            
            if(leadRec.Lead_Substage__c != oldLeadMap.get(leadRec.Id).Lead_Substage__c && leadRec.Lead_Substage__c != null){
                if(leadRec.Lead_Substage__c == 'Not Interested' || leadRec.Lead_Substage__c == 'Not a relevant call' || 
                   leadRec.Lead_Substage__c == 'Junk lead'|| leadRec.Lead_Substage__c == 'Just Enquiry'|| 
                   leadRec.Lead_Substage__c == 'Did not Show up for site visit'|| leadRec.Lead_Substage__c == 'Not Interested in Property' ||
                   leadRec.Lead_Substage__c == 'Budget' || leadRec.Lead_Substage__c == 'Location' || leadRec.Lead_Substage__c == 'Project Timeline' ||
                   leadRec.Lead_Substage__c == 'Vaastu Compliance' || leadRec.Lead_Substage__c == 'Unit Availability'){ 
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
            system.debug('leadRec.Lead_Stage__c--->'+leadRec.Lead_Stage__c);
            system.debug('leadRec.Lead_Stage__c--->'+leadRec.Lead_Stage__c);
            if(leadRec.Lead_Stage__c != oldLeadMap.get(leadRec.Id).Lead_Stage__c){
                if(leadRec.Lead_Stage__c == ConstantClass.LeadStageSVPlanned){
                    if(leadRec.Site_Visit_Date__c < system.now() ||leadRec.Site_Visit_Date__c == null){
                        leadRec.Site_Visit_Date__c.addError('Specify Site visit Date greater then today');
                    }
                }
                if(leadRec.Lead_Stage__c == ConstantClass.LeadStageDrop && (leadRec.Sales_Drop_Reason__c == null || string.isEmpty(leadRec.Sales_Drop_Reason__c))){
                    leadRec.Sales_Drop_Reason__c.addError('Specify Drop Reason');
                }
                /*if(oldLeadMap.get(leadRec.Id).Lead_Stage__c == ConstantClass.LeadStageNewEnquiry || oldLeadMap.get(leadRec.Id).Lead_Stage__c == ConstantClass.LeadStageReEnquiry || oldLeadMap.get(leadRec.Id).Lead_Stage__c == ConstantClass.LeadStageNotConnected || oldLeadMap.get(leadRec.Id).Lead_Stage__c == ConstantClass.LeadStageConnected){
                    if(leadRec.Lead_Stage__c == ConstantClass.LeadStageSVProspect || leadRec.Lead_Stage__c == ConstantClass.LeadStageSVPlanned || leadRec.Lead_Stage__c == ConstantClass.LeadStageConverted){
                        if(leadRec.Budget__c == null ||leadRec.Budget__c < 1){
                            leadRec.Budget__c.addError('Specify Budget Value!!!');
                        }
                        if(leadRec.Project__c == null ){
                            leadRec.Project__c.addError('Specify Project!!!');
                        }
                        if(leadRec.Unit_Details__c == null){
                            leadRec.Unit_Details__c.addError('Specify Unit Details!!!');
                        }
                        if(leadRec.Location__c == null ){
                            leadRec.Location__c.addError('Specify Location Value!!!');
                        }
                        if(leadRec.Project_TimeLine__c == null ){
                            leadRec.Project_TimeLine__c.addError('Specify Project Timeline!!!');
                        }
                    }
                }*/
            }
            if(leadRec.Lead_Source_Type__c != null && leadRec.Lead_Source_Type__c != oldLeadMap.get(leadRec.Id).Lead_Source_Type__c){
                if(leadRec.Lead_Source_Type__c == 'Magazine' || leadRec.Lead_Source_Type__c == 'News Paper-Others' || leadRec.Lead_Source_Type__c == 'News Paper-TOI'){
                    leadRec.Lead_Sub_Source__c = 'Print';
                    leadRec.Lead_Source__c = 'ATL';
                }
                if(leadRec.Lead_Source_Type__c == 'Hoarding' || leadRec.Lead_Source_Type__c == 'Site Hoarding' || leadRec.Lead_Source_Type__c == 'Bus Wrap & Bus Shelter' || leadRec.Lead_Source_Type__c == 'Mobile Van'){
                    leadRec.Lead_Sub_Source__c = 'Outdoor';
                    leadRec.Lead_Source__c = 'ATL';
                }
                if(leadRec.Lead_Source_Type__c == 'Radio' ){
                    leadRec.Lead_Sub_Source__c = 'Electronic';
                    leadRec.Lead_Source__c = 'ATL';
                }
            }
            
            // send notification emails for pre-sales
          /*  if(leadRec.OwnerId != oldLeadMap.get(leadRec.Id).OwnerId && (string.valueOf(leadRec.OwnerId)).startsWith('005')){
                leadIds.add(leadRec.Id);
            }*/
            
        }
        /*if(!leadIds.isEMpty()){
            EmailIUtility.notifyPreSalesTeamOnLeadAssignment(leadIDs, 'Pre-sales Team welcome email');
        }
		*/
        if(!convertedLeadRecordsList.isEmpty()){
            LeadConversionClass.convertLead(convertedLeadRecordsList);
        }
        if(!taskListToInsertforFollowup.isEmpty()){
            insert taskListToInsertforFollowup;
        }
    }
    public void afterUpdate(Map<Id, Lead__c> newLeadMap, Map<Id, Lead__c> oldLeadMap){
        set<Id> leadIds =  new Set<Id>();
        set<Id> salesTeamLeadIds =  new Set<Id>();
        set<String> phoneNos = new Set<String>();
        
        for(Lead__c leadRec: newLeadMap.values()){
            // for pre sales team
            if(leadRec.OwnerId != oldLeadMap.get(leadRec.Id).OwnerId && (string.valueOf(leadRec.OwnerId)).startsWith('005')){
                leadIds.add(leadRec.Id);
            }
            // for sales team
            if(leadRec.Sales_Team_Member__c	 != oldLeadMap.get(leadRec.Id).Sales_Team_Member__c	 && leadRec.Sales_Team_Member__c != null){
                salesTeamLeadIds.add(leadRec.Id);
            }
            if(leadRec.Lead_Stage__c != oldLeadMap.get(leadRec.Id).Lead_Stage__c && leadRec.Lead_Stage__c == ConstantClass.LeadStageConnected){
                if(leadRec.phone__c != null)
                    phoneNos.add(leadRec.phone__c);
            }
            
        }
        if(!leadIds.isEMpty()){
            EmailIUtility.notifyPreSalesTeamOnLeadAssignment(leadIDs, 'Pre-sales Team welcome email');
        }
        if(!salesTeamLeadIds.isEMpty()){
            EmailIUtility.notifySalesTeamOnLeadAssignment(salesTeamLeadIds, 'Sales Lead Verified Notification');
        }
        if(!phoneNos.isEmpty()){
            SendWhatsAppNotificationHelper.sendWelcimeMessage(phoneNos);
        }
        
        /* Map<Id, Lead__c> leadIdByLeadRecMap = new Map<Id, Lead__c>();
List<Visit__c> visitListToInsert = new List<Visit__c>();

for(Lead__c leadRec : newLeadMap.values()){
if(leadRec.Lead_Stage__c != oldLeadMap.get(leadRec.Id).Lead_Stage__c && leadRec.Lead_Stage__c == ConstantClass.LeadStageSVPlanned){
leadIdByLeadRecMap.put(leadRec.Id, leadRec);
}
}
if(!leadIdByLeadRecMap.isEmpty()){
for(Lead__c leadRec: leadIdByLeadRecMap.values()){
Visit__c visitRecToInsert = new Visit__c();
visitRecToInsert.Lead__c = leadRec.id;
visitRecToInsert.Planned_visit_date__c = leadRec.Site_Visit_Date__c;
visitListToInsert.add(visitRecToInsert);
}
if(!visitListToInsert.isEmpty()){
insert visitListToInsert;
}
}*/
    }
}