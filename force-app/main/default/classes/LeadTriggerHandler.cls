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
        try{
            set<Id> leadIds = new Set<Id>();
            Map<Id, Lead__c> existingLeadIdByNewLeadRec = new map<id, Lead__c>();
            Set<String> phonesSet = new Set<String>();
            Set<String> emailsSet = new Set<String>();  
            Set<String> altPhonesSet = new Set<String>();
            Set<String> altEmailsSet = new Set<String>();
            List<Lead__c> existingLeadsList = new List<Lead__c>();
            List<Lead__c> existingLeadWithPhones = new List<Lead__c>();
            List<Lead__c> existingLeadWithEmails = new List<Lead__c>();
            List<Campaign> campaignList = new List<Campaign>();
            List<Project__c> projectList = new List<Project__c>();
            Map<String,Lead__c> leadRecByPhoneMap = new Map<String, Lead__c>();
            Map<String,Lead__c> leadRecByEmailMap = new Map<String, Lead__c>();
            Map<string, Campaign> campaignSourceByCampaignRecMap = new map<String, Campaign>();
            Map<string, Project__c> projectNameByProjectRecMap = new map<String, Project__c>();
            
            Date todayDate = system.today();
            campaignList = [Select id,Lead_Source_Type__c,Lead_Sub_Source__c,Lead_Source__c,IsActive,StartDate,EndDate From Campaign where IsActive = true And StartDate <= : todayDate and EndDate >= : todayDate and Lead_Source_Type__c != null];
            system.debug('campaignList--->'+campaignList);
            if(!campaignList.isEmpty()){
                for(Campaign campaignRec : campaignList){
                    campaignSourceByCampaignRecMap.put(campaignRec.Lead_Source_Type__c, campaignRec);
                }
            }
            projectList = [Select Id,Name From Project__c];
            system.debug('projectList--->'+projectList);
            if(!projectList.isEmpty()){
                for(Project__c projectRec : projectList){
                    projectNameByProjectRecMap.put(projectRec.Name, projectRec);
                }
            }
            system.debug('projectNameByProjectRecMap--->'+projectNameByProjectRecMap);
            string queueId = [SELECT Id, Type FROM Group WHERE Type = 'Queue' AND Name = 'Lead Default Queue' limit 1].Id;
            
            
            
            
            for(Lead__c leadRec : newLeadList){
                leadRec.OwnerId = queueId;
                if(!String.isBlank(leadRec.Phone__c)){
                    leadRec.Phone__c = leadRec.Phone__c.replaceAll('[^0-9]', '');
                    leadRec.Phone__c = '+91' + leadRec.Phone__c.right(10);
                }
                if(!String.isBlank(leadRec.Alternate_Phone__c)){
                    leadRec.Alternate_Phone__c = leadRec.Alternate_Phone__c.replaceAll('[^0-9]', '');
                    leadRec.Alternate_Phone__c = '+91' +  leadRec.Alternate_Phone__c.right(10);
                }
                if(!string.isBlank(leadRec.Project_Name__c)){
                    system.debug('leadRec.Project_Name__c--->'+leadRec.Project_Name__c);
                    for(string projectName : projectNameByProjectRecMap.keyset()){
                        system.debug('leadRec.Project_Name__c--->'+leadRec.Project_Name__c);
                        system.debug('projectName--->'+projectName);
                        if(leadRec.Project_Name__c.containsIgnoreCase(projectName)){
                            system.debug('inside matching conditions');
                            leadRec.Project__c = projectNameByProjectRecMap.get(projectName).Id;
                            leadRec.Project_Pickval__c = projectNameByProjectRecMap.get(projectName).Name;
                        }
                    }
                }
                if(string.isEmpty(leadRec.Project__c) && string.isEmpty(leadRec.Project_Name__c)){
                    if(!test.isRunningTest()){
                        leadRec.Project__c = projectNameByProjectRecMap.get(system.label.Vaishnavi_Group_Project).Id;
                        leadRec.Project_Pickval__c = projectNameByProjectRecMap.get(system.label.Vaishnavi_Group_Project).Name;
                    }
                }
                if(leadRec.Phone__c != null){
                    phonesSet.add(leadRec.Phone__c);
                }
                if(leadRec.Alternate_Phone__c != null){
                    altPhonesSet.add(leadRec.Phone__c);
                }
                if(leadRec.Email__c != null)
                {
                    emailsSet.add(leadRec.Email__c);
                }
                if(leadRec.Alternate_Email__c != null)
                {
                    altEmailsSet.add(leadRec.Email__c);
                }
                if(leadRec.Lead_Source_Type__c != null){
                    if(campaignSourceByCampaignRecMap.containsKey(leadRec.Lead_Source_Type__c))
                        leadRec.Campaign__c = campaignSourceByCampaignRecMap.get(leadRec.Lead_Source_Type__c).Id;
                }
                leadRec.RecordTypeId = ConstantClass.newEnquiryLeadRT;
                
                //handle source and subsource and source type
                if(leadRec.Lead_Source_Type__c != null){
                    if(leadRec.Lead_Source_Type__c == 'Magazine' || leadRec.Lead_Source_Type__c == 'News Paper-Others' || leadRec.Lead_Source_Type__c == 'News Paper-TOI'){
                        leadRec.Lead_Sub_Source__c = 'Print';
                        leadRec.Lead_Source__c = 'ATL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Hoarding' || leadRec.Lead_Source_Type__c == 'Site Hoarding' || leadRec.Lead_Source_Type__c == 'Bus Wrap & Bus Shelter' || leadRec.Lead_Source_Type__c == 'Mobile Van'){
                        leadRec.Lead_Sub_Source__c = 'Outdoor';
                        leadRec.Lead_Source__c = 'ATL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Radio' ){
                        leadRec.Lead_Sub_Source__c = 'Electronic';
                        leadRec.Lead_Source__c = 'ATL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Exhibition/ Expo' ){
                        leadRec.Lead_Sub_Source__c = 'Exhibition/ Expo';
                        leadRec.Lead_Source__c = 'BTL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'News Paper Insert' ){
                        leadRec.Lead_Sub_Source__c = 'News Paper Insert';
                        leadRec.Lead_Source__c = 'BTL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Bangalore Club Event' || leadRec.Lead_Source_Type__c == 'Durga Pooja Event' || leadRec.Lead_Source_Type__c == 'Serene Run'){
                        leadRec.Lead_Sub_Source__c = 'Sponsorship';
                        leadRec.Lead_Source__c = 'BTL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Apartment Activity' ){
                        leadRec.Lead_Sub_Source__c = 'Apartment Activity';
                        leadRec.Lead_Source__c = 'BTL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Mall Activity' ){
                        leadRec.Lead_Sub_Source__c = 'Mall Activity';
                        leadRec.Lead_Source__c = 'BTL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Corporate Activity' ){
                        leadRec.Lead_Sub_Source__c = 'Corporate Activity';
                        leadRec.Lead_Source__c = 'BTL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Other Activations' ){
                        leadRec.Lead_Sub_Source__c = 'Other Activations';
                        leadRec.Lead_Source__c = 'BTL';
                    }
                    else if(leadRec.Lead_Source_Type__c == '99 Acres' || leadRec.Lead_Source_Type__c == 'Commonfloor' || leadRec.Lead_Source_Type__c == 'Housing' || leadRec.Lead_Source_Type__c == 'Magicbricks' || leadRec.Lead_Source_Type__c == 'Roofandfloor' ){
                        leadRec.Lead_Sub_Source__c = 'Portals';
                        leadRec.Lead_Source__c = 'DIGITAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Facebook/ Instagram' || leadRec.Lead_Source_Type__c == 'LinkedIn' || leadRec.Lead_Source_Type__c == 'Google Search' || leadRec.Lead_Source_Type__c == 'Google Display' || leadRec.Lead_Source_Type__c == 'Google Youtube'  || leadRec.Lead_Source_Type__c == 'Native Ads' ||  leadRec.Lead_Source_Type__c == 'Online PR' || leadRec.Lead_Source_Type__c == 'Propstory' ){
                        leadRec.Lead_Sub_Source__c = 'Paid Advertising';
                        leadRec.Lead_Source__c = 'DIGITAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Main Website-Inbound Call' || leadRec.Lead_Source_Type__c == 'Main Website-Enquiry Form' || leadRec.Lead_Source_Type__c == 'Main Website-Contact Us' || leadRec.Lead_Source_Type__c == 'Main Website-Chat' || leadRec.Lead_Source_Type__c == 'Microsite'){
                        leadRec.Lead_Sub_Source__c = 'Website';
                        leadRec.Lead_Source__c = 'DIGITAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Emailer' ){
                        leadRec.Lead_Sub_Source__c = 'Emailer';
                        leadRec.Lead_Source__c = 'DIGITAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'SMS' ){
                        leadRec.Lead_Sub_Source__c = 'SMS';
                        leadRec.Lead_Source__c = 'DIGITAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'HDFC Expo' || leadRec.Lead_Source_Type__c == 'ICICI Expo'){
                        leadRec.Lead_Sub_Source__c = 'Digital Expos';
                        leadRec.Lead_Source__c = 'DIGITAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Site Visit Referral'){
                        leadRec.Lead_Sub_Source__c = 'Site Visit Referral';
                        leadRec.Lead_Source__c = 'REFERRAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Management Booking' || leadRec.Lead_Source_Type__c == 'Management Referral' ||  leadRec.Lead_Source_Type__c == 'Employee Booking' || leadRec.Lead_Source_Type__c == 'Employee Referral'){
                        leadRec.Lead_Sub_Source__c = 'V-Team';
                        leadRec.Lead_Source__c = 'REFERRAL';
                    }
                    else  if(leadRec.Lead_Source_Type__c == 'Existing Customer' || leadRec.Lead_Source_Type__c == 'Existing Tenant' || leadRec.Lead_Source_Type__c == 'Existing Customer Referral' || leadRec.Lead_Source_Type__c == 'Existing Tenant Referral'){
                        leadRec.Lead_Sub_Source__c = 'V-Connect';
                        leadRec.Lead_Source__c = 'REFERRAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Associate Booking' || leadRec.Lead_Source_Type__c == 'Associate Referral'){
                        leadRec.Lead_Sub_Source__c = 'V-Associates';
                        leadRec.Lead_Source__c = 'REFERRAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Investors/ Shareholders'){
                        leadRec.Lead_Sub_Source__c = 'Investors/ Shareholders';
                        leadRec.Lead_Source__c = 'REFERRAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Others'){
                        leadRec.Lead_Sub_Source__c = 'Others';
                        leadRec.Lead_Source__c = 'Others';
                    }
                }
            }
            
            if(!phonesSet.isEmpty() || !emailsSet.isEmpty() || !altEmailsSet.isEmpty() || !altPhonesSet.isEmpty()){
                existingLeadsList = [Select Id,Phone__c,Email__c,createdDate From Lead__c where ( Phone__c In : phonesSet or Email__c In : emailsSet or Alternate_Phone__c IN: altPhonesSet or Alternate_Email__c IN: altEmailsSet) AND isConverted__c = false];
                system.debug('existingLeadsList--01>'+existingLeadsList);
                
                if(!existingLeadsList.isEmpty()){
                    for(Lead__c lead : existingLeadsList){
                        system.debug('lead.Email__c---02>'+lead.Email__c);
                        system.debug('lead.Phone__c---3>'+lead.Phone__c);
                        if(lead.Email__c != null){
                            leadRecByEmailMap.put(lead.Email__c, lead);
                            system.debug('lead.Email__c-::4>'+lead.Email__c);
                        }else if(lead.Phone__c != null){
                            leadRecByPhoneMap.put(lead.Phone__c, lead);
                            system.debug('lead.Phone__c-::5>'+lead.Phone__c);
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
                                        leadRec.RecordTypeId  = ConstantClass.ReEnquiryLeadRT;
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
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('LeadTriggerHandler', 'Before Lead Insert', e, null);
        }
    }
    
    public void afteInsert(Map<Id, Lead__c> newLeadMap, Map<Id, Lead__c> oldLeadMap){
        try{
            system.debug('After Lead Insert .....');
            set<Id> leadsEmailIds = new Set<Id>();
            
            for(Lead__C leadRec : newLeadMap.values()){
                if(leadRec.Email__c != null){
                    leadsEmailIds.add(leadRec.Id);
                }
            }
            if(!leadsEmailIds.isEmpty()){
                // send email for new lead created
                EmailIUtility.notifyCustomer(leadsEmailIds, 'New Enquiry');
            }
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('LeadTriggerHandler', 'After Lead Insert', e, null);
        }
    }
    
    public void beforeUpdate(Map<Id, Lead__c> newLeadMap, Map<Id, Lead__c> oldLeadMap){
        try{
            system.debug('Before Update');
            
            set<Id> leadIds = new Set<Id>();
            set<id> allocatedLeadsId = new set<Id>();
            set<Id> droppedLeadIds = new Set<Id>();
            set<Id> svProspectLeadIds = new Set<Id>();
            set<Id> svPlannedLeadIds = new Set<Id>();
            set<Id> leadIdsForFirstNotConnected = new Set<Id>();
            set<Id> leadIdsForSixDayNotConnected = new Set<Id>();
            set<Id> leadIdsForSevenDayNotConnected = new Set<Id>();
            set<Id> leadIdsForFirstInvalidNumber = new Set<Id>();
            List<Task> taskListToInsertforFollowup = new List<Task>();
            List<Lead__c> convertedLeadRecordsList = new List<Lead__c>();
            List<Project__c> projectList = new List<Project__c>();
            Map<string, Project__c> projectNameByProjectRecMap = new map<String, Project__c>();
            
            String profileName = [Select Name from Profile where Id =: UserInfo.getProfileId()].Name;
            projectList = [Select Id,Name From Project__c];
            
            system.debug('projectList--->'+projectList);
            if(!projectList.isEmpty()){
                for(Project__c projectRec : projectList){
                    projectNameByProjectRecMap.put(projectRec.Name, projectRec);
                }
            }
            system.debug('projectNameByProjectRecMap--->'+projectNameByProjectRecMap);
            for(Lead__c leadRec : newLeadMap.values()){
                system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                
                /*if(leadRec.Total_Calls__c != null && leadRec.Total_Calls__c > oldLeadMap.get(leadRec.Id).Total_Calls__c && leadRec.Total_Calls__c >= 5 && (leadRec.Total_Connected_Call__c <=0 || leadRec.Total_Connected_Call__c == null) && leadRec.Lead_Stage__c != ConstantClass.LeadStageDrop){
leadRec.Lead_Stage__c = ConstantClass.LeadStageDrop;
}*/
                if(leadRec.isConverted__c && leadRec.OwnerId == oldLeadMap.get(leadRec.Id).OwnerId && profileName != 'System Administrator'){
                    leadRec.addError('Converted Lead Can not be Edited');
                }
                system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                
                if(leadRec.Pre_Sales_Comments__c != oldLeadMap.get(leadRec.Id).Pre_Sales_Comments__c && (profileName != 'System Administrator' && profileName != 'Pre-Sales Team')){
                    (leadRec.Pre_Sales_Comments__c).addError('You do not have Privilege to edit Pre Sales Comment!!!');
                }
                system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                
                if(leadRec.Sales_Comment__c != oldLeadMap.get(leadRec.Id).Sales_Comment__c && (profileName != 'System Administrator' && profileName != 'Sales Team')){
                    (leadRec.Sales_Comment__c).addError('You do not have Privilege to edit Sales Comment!!!');
                }
                system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                
                system.debug('leadRec.Project_Name__c--->'+leadRec.Project_Name__c);
                
                if(!string.isBlank(leadRec.Project_Name__c)){
                    for(string projectName : projectNameByProjectRecMap.keyset()){
                        system.debug('projectName--->'+projectName);
                        system.debug('leadRec.Project_Name__c--->'+leadRec.Project_Name__c);
                        system.debug('projectName.containsIgnoreCase(leadRec.Project_Name__c)--->'+projectName.containsIgnoreCase(leadRec.Project_Name__c));
                        if(leadRec.Project_Name__c.containsIgnoreCase(projectName)){
                            leadRec.Project__c = projectNameByProjectRecMap.get(projectName).Id;
                            //leadRec.Project_Pickval__c = projectNameByProjectRecMap.get(projectName).Name;
                        }
                    }
                }
                if(string.isEmpty(leadRec.Project__c) && string.isEmpty(leadRec.Project_Name__c)){
                    if(!test.isRunningTest()){
                        leadRec.Project__c = projectNameByProjectRecMap.get(system.label.Vaishnavi_Group_Project).Id;
                        //leadRec.Project_Pickval__c = projectNameByProjectRecMap.get(system.label.Vaishnavi_Group_Project).Name;
                    }
                }
                System.debug('newLeadMap.values():::::'+newLeadMap.values());
                System.debug('oldLeadMap.values():::::'+oldLeadMap.values());
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
                system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                
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
                       leadRec.Lead_Substage__c == 'Vaastu Compliance' || leadRec.Lead_Substage__c == 'Unit Availability' || leadRec.Lead_Substage__c == 'Invalid Number'){ 
                           leadRec.Lead_Stage__c = ConstantClass.LeadStageDrop;
                       }
                    system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                    system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                    
                    if(leadRec.Lead_Substage__c == 'Interested' ){
                        if(string.isBlank(leadRec.Project_Pickval__c)){
                            leadRec.Project_Pickval__c.addError('Please fill Project');
                        }
                        if(string.isBlank(leadRec.Budget_Pick__c)){
                            leadRec.Budget_Pick__c.addError('Please fill Budget');
                        }
                        if(string.isBlank(leadRec.Unit_Pickval__c)){
                            leadRec.Unit_Pickval__c.addError('Please fill Unit');
                        }
                        if(string.isBlank(leadRec.Location__c)){
                            leadRec.Location__c.addError('Please fill Project Location');
                        }
                        if(string.isBlank(leadRec.Project_TimeLine__c)){
                            leadRec.Project_TimeLine__c.addError('Please fill Project Timeline');
                        }
                        
                        leadRec.Lead_Stage__c = ConstantClass.LeadStageSVProspect;
                    }
                    system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                    system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                    
                    if(leadRec.Lead_Substage__c == 'Site Visit Planned' || leadRec.Lead_Substage__c == 'Site Visit Proposed'){
                        leadRec.Lead_Stage__c = ConstantClass.LeadStageSVPlanned;
                    }
                    system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                    system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                    
                    if(leadRec.Lead_Substage__c == 'Not a relevant call' && (leadRec.Irrelevant_Call_Reason__c == null || string.isBlank(leadRec.Irrelevant_Call_Reason__c)) ){
                        leadRec.Irrelevant_Call_Reason__c.addError('Specify Not a relevant call reason');
                    }
                    system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                    system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                    
                    if(leadRec.Lead_Substage__c == 'Site Visit Planned' && (leadRec.Site_Visit_Date__c < system.now() ||leadRec.Site_Visit_Date__c == null) ){
                        leadRec.Site_Visit_Date__c.addError('Specify Site visit Date greater then today');
                    }
                    system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                    system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                    
                    if(leadRec.Lead_Substage__c == 'Follow up' && (leadRec.Next_Followup_Date_Time__c < system.now() ||leadRec.Next_Followup_Date_Time__c == null) ){
                        leadRec.Next_Followup_Date_Time__c.addError('Specify Follow up Date greater then today');
                    }
                    system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                    system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                    
                }
                
                if(leadRec.Lead_Stage__c != oldLeadMap.get(leadRec.Id).Lead_Stage__c){
                    
                    if(leadRec.Lead_Stage__c == ConstantClass.LeadStageSVPlanned){
                        if(leadRec.Site_Visit_Date__c < system.now() ||leadRec.Site_Visit_Date__c == null){
                            leadRec.Site_Visit_Date__c.addError('Specify Site visit Date greater then today');
                        }
                    }
                    system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                    system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                    
                    if(leadRec.Lead_Stage__c == ConstantClass.LeadStageDrop && (leadRec.Sales_Drop_Reason__c == null || string.isEmpty(leadRec.Sales_Drop_Reason__c)) && (profileName == 'Sales Team' || profileName == 'System Administrator')){
                        leadRec.Sales_Drop_Reason__c.addError('Specify Sales Drop Reason');
                    }
                    system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                    system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                    
                    if(leadRec.Lead_Stage__c == ConstantClass.LeadStageDrop && (leadRec.Pre_Sales_Drop_Reason__c == null || string.isEmpty(leadRec.Pre_Sales_Drop_Reason__c)) && (profileName == 'Pre-Sales Team'||profileName == 'System Administrator') ){
                        leadRec.Pre_Sales_Drop_Reason__c.addError('Specify Pre Sales Drop Reason');
                    }
                    system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                    system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                    
                    if(leadRec.Lead_Stage__c == ConstantClass.LeadStageDrop){
                        droppedLeadIds.add(leadRec.Id);
                        if(leadRec.Drop_Date_TIme__c == null){
                            leadRec.Drop_Date_TIme__c = system.now();
                        }
                        system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                        system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                        
                    }
                    system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                    system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                    
                    if(leadRec.Lead_Stage__c == ConstantClass.LeadStageSVProspect){
                        svProspectLeadIds.add(leadRec.Id);
                    }
                    system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                    system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                    
                }
                if(leadRec.Lead_Source_Type__c != null && leadRec.Lead_Source_Type__c != oldLeadMap.get(leadRec.Id).Lead_Source_Type__c){
                    if(leadRec.Lead_Source_Type__c == 'Magazine' || leadRec.Lead_Source_Type__c == 'News Paper-Others' || leadRec.Lead_Source_Type__c == 'News Paper-TOI'){
                        leadRec.Lead_Sub_Source__c = 'Print';
                        leadRec.Lead_Source__c = 'ATL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Hoarding' || leadRec.Lead_Source_Type__c == 'Site Hoarding' || leadRec.Lead_Source_Type__c == 'Bus Wrap & Bus Shelter' || leadRec.Lead_Source_Type__c == 'Mobile Van'){
                        leadRec.Lead_Sub_Source__c = 'Outdoor';
                        leadRec.Lead_Source__c = 'ATL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Radio' ){
                        leadRec.Lead_Sub_Source__c = 'Electronic';
                        leadRec.Lead_Source__c = 'ATL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Exhibition/ Expo' ){
                        leadRec.Lead_Sub_Source__c = 'Exhibition/ Expo';
                        leadRec.Lead_Source__c = 'BTL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'News Paper Insert' ){
                        leadRec.Lead_Sub_Source__c = 'News Paper Insert';
                        leadRec.Lead_Source__c = 'BTL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Bangalore Club Event' || leadRec.Lead_Source_Type__c == 'Durga Pooja Event' || leadRec.Lead_Source_Type__c == 'Serene Run'){
                        leadRec.Lead_Sub_Source__c = 'Sponsorship';
                        leadRec.Lead_Source__c = 'BTL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Apartment Activity' ){
                        leadRec.Lead_Sub_Source__c = 'Apartment Activity';
                        leadRec.Lead_Source__c = 'BTL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Mall Activity' ){
                        leadRec.Lead_Sub_Source__c = 'Mall Activity';
                        leadRec.Lead_Source__c = 'BTL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Corporate Activity' ){
                        leadRec.Lead_Sub_Source__c = 'Corporate Activity';
                        leadRec.Lead_Source__c = 'BTL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Other Activations' ){
                        leadRec.Lead_Sub_Source__c = 'Other Activations';
                        leadRec.Lead_Source__c = 'BTL';
                    }
                    else if(leadRec.Lead_Source_Type__c == '99 Acres' || leadRec.Lead_Source_Type__c == 'Commonfloor' || leadRec.Lead_Source_Type__c == 'Housing' || leadRec.Lead_Source_Type__c == 'Magicbricks' || leadRec.Lead_Source_Type__c == 'Roofandfloor' ){
                        leadRec.Lead_Sub_Source__c = 'Portals';
                        leadRec.Lead_Source__c = 'DIGITAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Facebook/ Instagram' || leadRec.Lead_Source_Type__c == 'LinkedIn' || leadRec.Lead_Source_Type__c == 'Google Search' || leadRec.Lead_Source_Type__c == 'Google Display' || leadRec.Lead_Source_Type__c == 'Google Youtube'  || leadRec.Lead_Source_Type__c == 'Native Ads' ||  leadRec.Lead_Source_Type__c == 'Online PR' || leadRec.Lead_Source_Type__c == 'Propstory' ){
                        leadRec.Lead_Sub_Source__c = 'Paid Advertising';
                        leadRec.Lead_Source__c = 'DIGITAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Main Website-Inbound Call' || leadRec.Lead_Source_Type__c == 'Main Website-Enquiry Form' || leadRec.Lead_Source_Type__c == 'Main Website-Contact Us' || leadRec.Lead_Source_Type__c == 'Main Website-Chat' || leadRec.Lead_Source_Type__c == 'Microsite'){
                        leadRec.Lead_Sub_Source__c = 'Website';
                        leadRec.Lead_Source__c = 'DIGITAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Emailer' ){
                        leadRec.Lead_Sub_Source__c = 'Emailer';
                        leadRec.Lead_Source__c = 'DIGITAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'SMS' ){
                        leadRec.Lead_Sub_Source__c = 'SMS';
                        leadRec.Lead_Source__c = 'DIGITAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'HDFC Expo' || leadRec.Lead_Source_Type__c == 'ICICI Expo'){
                        leadRec.Lead_Sub_Source__c = 'Digital Expos';
                        leadRec.Lead_Source__c = 'DIGITAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Site Visit Referral'){
                        leadRec.Lead_Sub_Source__c = 'Site Visit Referral';
                        leadRec.Lead_Source__c = 'REFERRAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Management Booking' || leadRec.Lead_Source_Type__c == 'Management Referral' ||  leadRec.Lead_Source_Type__c == 'Employee Booking' || leadRec.Lead_Source_Type__c == 'Employee Referral'){
                        leadRec.Lead_Sub_Source__c = 'V-Team';
                        leadRec.Lead_Source__c = 'REFERRAL';
                    }
                    else  if(leadRec.Lead_Source_Type__c == 'Existing Customer' || leadRec.Lead_Source_Type__c == 'Existing Tenant' || leadRec.Lead_Source_Type__c == 'Existing Customer Referral' || leadRec.Lead_Source_Type__c == 'Existing Tenant Referral'){
                        leadRec.Lead_Sub_Source__c = 'V-Connect';
                        leadRec.Lead_Source__c = 'REFERRAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Associate Booking' || leadRec.Lead_Source_Type__c == 'Associate Referral'){
                        leadRec.Lead_Sub_Source__c = 'V-Associates';
                        leadRec.Lead_Source__c = 'REFERRAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Investors/ Shareholders'){
                        leadRec.Lead_Sub_Source__c = 'Investors/ Shareholders';
                        leadRec.Lead_Source__c = 'REFERRAL';
                    }
                    else if(leadRec.Lead_Source_Type__c == 'Others'){
                        leadRec.Lead_Sub_Source__c = 'Others';
                        leadRec.Lead_Source__c = 'Others';
                    }
                    system.debug('leadRec-->'+leadRec);                        
                }
                
                if(oldLeadMap.get(leadRec.Id).Lead_Stage__c == ConstantClass.LeadStageDrop && leadRec.Lead_Stage__c != oldLeadMap.get(leadRec.Id).Lead_Stage__c){
                   // leadRec.Lead_Stage__c = ConstantClass.LeadStageDrop;
                }
                system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                
            }
            if(!convertedLeadRecordsList.isEmpty()){
                LeadConversionClass.convertLead(convertedLeadRecordsList);
            }
            if(!taskListToInsertforFollowup.isEmpty()){
                insert taskListToInsertforFollowup;
            }
            
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('LeadTriggerHandler', 'Before Lead Update', e, null);
        }
    }
    
    public void afterUpdate(Map<Id, Lead__c> newLeadMap, Map<Id, Lead__c> oldLeadMap){
        try{
            set<Id> notConnectedLeadIds =  new Set<Id>();
            set<Id> rnrLeadIds =  new Set<Id>();
            set<Id> invalidNumberLeadIds =  new Set<Id>();
            set<Id> droppedDueToComplaintLeadIds =  new Set<Id>();
            set<Id> salesAssignedLeadIds =  new Set<Id>();
            set<Id> siteVisitPlannedLeadIds = new Set<Id>();
            set<Id> preSalesAssignedLeadIds = new Set<Id>();
            set<Id> salesAssignedInternalNotificationLeadIds =  new Set<Id>();
            List<Task> taskListToInsertFOrFirstConnect = new List<Task>();
            Map<String,string> leadIdByLeadOwnerId = new Map<String, string>();

            for(Lead__c leadRec: newLeadMap.values()){
                leadIdByLeadOwnerId.put(leadRec.Id,leadRec.ownerId);
                if(leadRec.OwnerId != oldLeadMap.get(leadRec.Id).OwnerId && (string.valueOf(leadRec.OwnerId)).startsWith('005')  ){
                    if(string.valueOf(oldLeadMap.get(leadRec.Id).OwnerId).startsWith('00G')){
                        //If lead is assigned to pre sales team
                        preSalesAssignedLeadIds.add(leadRec.Id);
                    }
                    system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                    system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                    
                }  
                if(leadRec.Total_Calls__c != oldLeadMap.get(leadRec.Id).Total_Calls__c && leadRec.Total_Calls__c > oldLeadMap.get(leadRec.Id).Total_Calls__c && leadRec.Total_Connected_Call__c != oldLeadMap.get(leadRec.Id).Total_Connected_Call__c){
                    notConnectedLeadIds.add(leadRec.Id);
                }
                if(leadRec.Lead_Stage__c != oldLeadMap.get(leadRec.Id).Lead_Stage__c ){
                   
                    system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                    system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                    
                }
                if(leadRec.Lead_Substage__c != oldLeadMap.get(leadRec.Id).Lead_Substage__c ){
                    if(leadRec.Lead_Substage__c == ConstantClass.LeadSubStage_RINGNORESPONSE){
                        rnrLeadIds.add(leadRec.Id);
                    }
                    system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                    system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                    
                    if(leadRec.Lead_Substage__c == ConstantClass.LeadSubStage_INVALIDNUMBER){
                        invalidNumberLeadIds.add(leadRec.Id);
                    }
                    system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                    system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                    
                    if(leadRec.Lead_Substage__c == ConstantClass.LeadSubStage_VASTU || leadRec.Lead_Substage__c == ConstantClass.LeadSubStage_LOCATION || leadRec.Lead_Substage__c == ConstantClass.LeadSubStage_UNIT || leadRec.Lead_Substage__c == ConstantClass.LeadSubStage_BUDGET || leadRec.Lead_Substage__c == ConstantClass.LeadSubStage_FLOORPLAN || leadRec.Lead_Substage__c == ConstantClass.LeadSubStage_PROJECT){
                        droppedDueToComplaintLeadIds.add(leadRec.Id);
                    }
                    system.debug('leadRec.Lead_Stage__c-->'+leadRec.Lead_Stage__c);
                    system.debug('oldLeadMap.get(leadRec.Id).Lead_Stage__c-->'+oldLeadMap.get(leadRec.Id).Lead_Stage__c);
                    
                }
                if(leadRec.Sales_Team_Member__c != oldLeadMap.get(leadRec.Id).Sales_Team_Member__c && leadRec.Sales_Team_Member__c != null){
                    salesAssignedLeadIds.add(leadRec.Id);
                    salesAssignedInternalNotificationLeadIds.add(leadRec.Id);
                }
                if(leadRec.Site_Visit_Date__c != oldLeadMap.get(leadRec.Id).Site_Visit_Date__c && leadRec.Site_Visit_Date__c != null && leadRec.Site_Visit_Date__c >= system.today()){
                    siteVisitPlannedLeadIds.add(leadRec.Id);
                }
            }
            if(!notConnectedLeadIds.isEmpty()){
                EmailIUtility.notifyCustomer(notConnectedLeadIds,'RNR Notification to Customer');
            }
            if(!rnrLeadIds.isEmpty()){
                EmailIUtility.notifyCustomer(rnrLeadIds,'RNR Dropped Lead');
            }
            if(!invalidNumberLeadIds.isEmpty()){
                EmailIUtility.notifyCustomer(invalidNumberLeadIds,'Invalid Number');
                List<Task> taskList = [Select Id,Status From Task where Status != 'Completed' and WhatId in : invalidNumberLeadIds];
                if(!taskList.isEmpty()){
                    List<Task> taskListToUpdate = new List<Task>();
                    for(Task taskRec : taskList) {
                        Task taskRecToMarkClosed = new Task();
                        taskRecToMarkClosed.Id = taskRec.Id;
                        taskRecToMarkClosed.Status = 'Completed';
                        taskListToUpdate.add(taskRecToMarkClosed);
                    }
                    if(!taskListToUpdate.isEmpty()){
                        update taskListToUpdate;
                    }
                }
            }
            if(!droppedDueToComplaintLeadIds.isEmpty()){
                EmailIUtility.notifyCustomer(droppedDueToComplaintLeadIds,'Dropped due to Complaint');
            }
            if(!salesAssignedLeadIds.isEmpty()){
                EmailIUtility.notifyCustomer(salesAssignedLeadIds,'Notify Customer for Lead assigned to sales team');
            }
            if(!siteVisitPlannedLeadIds.isEmpty()){
                EmailIUtility.notifyCustomer(siteVisitPlannedLeadIds,'Notify Customer for Site Visit Planned');
            }
            if(!preSalesAssignedLeadIds.isEmpty()){
                EmailIUtility.notifyVaishnaviTeam(preSalesAssignedLeadIds,'New Lead Assigned to Pre-Sales Team');
                for(Id leadId : preSalesAssignedLeadIds){
                    Task taskRec = new Task();
                    taskRec.Subject = ConstantClass.FirstCallTAskAfterLeadAllocation;
                    taskRec.whatId = leadid;
                    taskrec.OwnerId = leadIdByLeadOwnerId.get(leadid);
                    taskRec.ActivityDate = system.today();
                    taskrec.IsReminderSet = true;
                    taskrec.ReminderDateTime = system.now().addMinutes(30);
                    taskListToInsertFOrFirstConnect.add(taskRec);
                }
                if(!taskListToInsertFOrFirstConnect.isEmpty()){
                    insert taskListToInsertFOrFirstConnect;
                }
            }
            
            if(!salesAssignedInternalNotificationLeadIds.isEmpty()){
                EmailIUtility.notifyVaishnaviTeam(salesAssignedInternalNotificationLeadIds,'New Lead Assigned to Sales Team');
                for(Id leadId : salesAssignedInternalNotificationLeadIds){
                    Task taskRec = new Task();
                    taskRec.Subject = ConstantClass.FirstCallTAskAfterLeadAllocation;
                    taskRec.whatId = leadid;
                    taskrec.OwnerId = leadIdByLeadOwnerId.get(leadid);
                    taskRec.ActivityDate = system.today();
                    taskrec.IsReminderSet = true;
                    taskrec.ReminderDateTime = system.now().addMinutes(30);
                    taskListToInsertFOrFirstConnect.add(taskRec);
                }
                if(!taskListToInsertFOrFirstConnect.isEmpty()){
                    insert taskListToInsertFOrFirstConnect;
                }
            }
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('LeadTriggerHandler', 'After Lead Update', e, null);
        }
    }
    
}