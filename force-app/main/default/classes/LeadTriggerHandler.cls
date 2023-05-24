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
        Map<String,Lead__c> leadRecByPhoneMap = new Map<String, Lead__c>();
        Map<String,Lead__c> leadRecByEmailMap = new Map<String, Lead__c>();
        
        for(Lead__c leadRec : newLeadList){
            if(leadRec.Phone__c != null){
                leadRec.Phone__c = '+91'+leadRec.Phone__c;
                phonesSet.add(leadRec.Phone__c);
            }
            if(leadRec.Email__c != null)
            {
                emailsSet.add(leadRec.Email__c);
            }
        }
        
        if(!phonesSet.isEmpty() || !emailsSet.isEmpty()){
            existingLeadsList = [Select Id,Phone__c,Email__c From Lead__c where Phone__c In : phonesSet or Email__c In : emailsSet];
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
                                leadRec.To_Be_Deleted__c = true;
                                existingLeadIdByNewLeadRec.put(leadRecByPhoneMap.get(leadRec.Phone__c).Id, leadRec);
                            }else if(leadRec.Email__c != null){
                                system.debug('leadRecByEmailMap.containsKey(leadRec.Email__c)--->'+leadRecByEmailMap.containsKey(leadRec.Email__c));
                                if(leadRecByEmailMap.containsKey(leadRec.Email__c)){
                                    leadRec.To_Be_Deleted__c = true;
                                    existingLeadIdByNewLeadRec.put(leadRecByEmailMap.get(leadRec.Email__c).Id, leadRec);
                                }
                            }
                        }
                        else if(leadRec.Email__c != null){
                            system.debug('leadRecByPhoneMap.containsKey(leadRec.Phone__c)--->'+leadRecByPhoneMap.containsKey(leadRec.Phone__c));
                            if(leadRecByPhoneMap.containsKey(leadRec.Phone__c)){
                                leadRec.To_Be_Deleted__c = true;
                                existingLeadIdByNewLeadRec.put(leadRecByPhoneMap.get(leadRec.Phone__c).Id,leadRec);
                            }else if(leadRec.Email__c != null){
                                system.debug('leadRecByEmailMap.containsKey(leadRec.Email__c)--->'+leadRecByEmailMap.containsKey(leadRec.Email__c));
                                if(leadRecByEmailMap.containsKey(leadRec.Email__c)){
                                    leadRec.To_Be_Deleted__c = true;
                                    existingLeadIdByNewLeadRec.put(leadRecByEmailMap.get(leadRec.Email__c).Id,leadRec);
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
    }
}