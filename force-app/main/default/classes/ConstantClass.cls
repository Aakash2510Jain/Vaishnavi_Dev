public without sharing class ConstantClass {
    public Static Final String TaskSubjectForDuplicateLead = 'ReEnquiry Details';
    public Static Final String TaskSubjectForFollowUpLead = 'Make First Call Attempt!!!';
    public Static Final String TaskSubjectForNextFollowUpLead = 'Followup Call with Customer!!!';
    public Static Final String TaskSubjectForNewLead = 'New Lead Created, Please Reach Out!!!';
    public Static Final String errorForDuplicateLeadByPhone = 'Duplicate Lead by Phone Number!!!';
    public Static Final String errorForDuplicateLeadByEmail = 'Duplicate Lead by Email!!!';
    public Static Final String errorForPastFollowUpDate = 'Please fill Futuristic Date/Time !!!';
    
    
    public Static Final String TaskSubjectForConnectedCall = 'connect';
    public Static Final String TaskSubjectForCalledCall = 'call';
    
    public Static Final String LeadStageNewEnquiry = 'New Enquiry';
    public Static Final String LeadStageReEnquiry = 'ReEnquiry';
    public Static Final String LeadStageNotConnected = 'Not Connected';
    public Static Final String LeadStageConnected = 'Connected';
    public Static Final String LeadStageSVProspect = 'SV Prospect';
    public Static Final String LeadStageSVPlanned = 'SV Planned';
    public Static Final String LeadStageDrop = 'Drop';
    public Static Final String LeadStageConverted = 'Converted';
    public Static Final String newEnquiryLeadRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('New Enquiry').getRecordTypeId();
    public Static Final String ReEnquiryLeadRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('ReEnquiry').getRecordTypeId();
    public Static Final String convertedLeadQueue = [select Id from Group where  Type = 'Queue' AND NAME = 'Converted Leads Queue'].id;
    public Static Final integer TATForReEnquiryLead = 45;
    
    public Static Final String CallTaskAgentStatusANSWERED = 'answered';
    public Static Final String CallTaskCustomerStatusANSWERED = 'answered';
    public Static Final String CallTaskCallStatusSUCCESS = 'Success';
    public Static Final String CallTaskCustomerStatusNOT_ANSWERED = 'not_answered';
    public Static Final String CallTaskCustomerStatusNO_Answer = 'NoAnswer';
    public Static Final String CallTaskCallStatusFAIL = 'Fail';


    
}