public without Sharing class BuildMaps {
    
    public static map<string,integer> mapofMemIdByExceedCount = new map<string,integer>();
    public static map<string,Integer> mapofMemidByTodayLeadCount = new map<string,integer>();
    public static map<string,Integer> mapofMemIdByMaxLeadCountPerDay = new map<string,integer>();
    public static map<string,Integer> mapofMemIdByMaxLeadCountByGroupPerDay = new map<String,integer>();
    public static map<string,Integer> mapofMemidbyMaxLeadCountFromUser = new map<string,integer>();
    public static map<string,Integer> mapofMemidByPendingLeads = new map<string,integer>();
    public static map<string,Integer> mapofMemidByMinLeadsCount = new map<string,integer>();
    public static map<string,integer> mapofMemidByTodayNewLead = new map<string,integer>();
    public static map<string,integer> mapofMemidByAssignedLead = new map<string,integer>();
    
    public static Map<String, Integer> makeQNameToLastAssignedQmemberRRid(){
        Map<String, Integer> qNameToLastAssignedQmemberRRid = new Map<String, Integer>();
        List<Assignment_Group__c> allExistingQueue = new List<Assignment_Group__c>([SELECT id, name, Last_Allocated_RRid__c from Assignment_Group__c]);
        
        for(Assignment_Group__c q: allExistingQueue){
            if(q.Last_Allocated_RRid__c != null){
                qNameToLastAssignedQmemberRRid.put(q.name, Integer.valueOf(q.Last_Allocated_RRid__c));    
            }else{
                qNameToLastAssignedQmemberRRid.put(q.name, null);
            }
        }
        return qNameToLastAssignedQmemberRRid;
    }
    
    public static void validateUserCapacity(String groupName,set<String> LeadIdList){
        list<Assignment_Group_Member__c> listOfGroupMember = new list<Assignment_Group_Member__c>();
        list<Lead__c> listOfTodayLeads = new list<Lead__c>();
        list<Lead__c> listOfNewLeads = new list<Lead__c>();
        list<Lead__c> listOfAssignedTodayLeads = new list<Lead__c>();
        
        listOfGroupMember = [select id,Assignment_Group__r.Minimum_Lead_Volume__c,Assignment_Group__r.Name,Group_Member__r.Id,Assignment_Group__r.Lead_Stage__c,Assignment_Group__r.Lead_Stage_Exceed_Count__c,Max_Lead_Per_Day__c from Assignment_Group_Member__c where active__c = true and assignment_group__r.name =: groupName];
        listOfTodayLeads = [select id,ownerId,Lead_Stage__c from Lead__c where Lead_Assigned_Date_Time__c > today];
        listOfNewLeads = [select id,Lead_Assigned_Date__c,ownerId,Lead_Stage__c from Lead__c where Lead_Stage__c = 'New Enquiry'];
        listOfAssignedTodayLeads = [select id,Lead_Assigned_Date__c,ownerId,Lead_Stage__c from Lead__c where Lead_Assigned_Date__c = today];
        
        if(!listOfNewLeads.isEmpty()){
            for(Lead__c ld : listOfNewLeads){
                if(mapofMemidByPendingLeads.containsKey(ld.OwnerId)){
                    integer count = mapofMemidByPendingLeads.get(ld.OwnerId);
                    mapofMemidByPendingLeads.put(ld.OwnerId,count + 1);
                }else{
                    mapofMemidByPendingLeads.put(ld.OwnerId,1);
                } 
            }
        }
        for(Assignment_Group_Member__c agm : listOfGroupMember){
            mapofMemIdByExceedCount.put(agm.Group_Member__r.Id,Integer.valueOf(agm.Assignment_Group__r.Lead_Stage_Exceed_Count__c));
            mapofMemIdByMaxLeadCountPerDay.put(agm.Group_Member__r.Id,Integer.valueOf(agm.Max_Lead_Per_Day__c));
            mapofMemidByMinLeadsCount.put(agm.Group_Member__r.Id,Integer.valueOf(agm.Assignment_Group__r.Minimum_Lead_Volume__c));
        }
        
        if(!listOfAssignedTodayLeads.isEmpty()){
            for(Lead__c ld : listOfAssignedTodayLeads){
                if(mapofMemidByAssignedLead.containsKey(ld.ownerId)){
                    integer count = mapofMemidByAssignedLead.get(ld.ownerId);
                    mapofMemidByAssignedLead.put(ld.ownerId,count + 1);
                }else{
                    mapofMemidByAssignedLead.put(ld.ownerId,1);
                }
            }
        }
        
        for(Lead__c ld : listOfTodayLeads){
            if(mapofMemidByTodayLeadCount.containsKey(ld.ownerId)){
                integer count = mapofMemidByTodayLeadCount.get(ld.ownerId);
                mapofMemidByTodayLeadCount.put(ld.ownerId,count + 1);
            }else{
                mapofMemidByTodayLeadCount.put(ld.ownerId,1);
            }
            if(ld.Lead_Stage__c == 'New Enquiry'){
                if(mapofMemidByTodayNewLead.containsKey(ld.ownerId)){
                    integer count = mapofMemidByTodayNewLead.get(ld.ownerId);
                    mapofMemidByTodayNewLead.put(ld.ownerId,count+1);
                }else{
                    mapofMemidByTodayNewLead.put(ld.ownerId,1);
                }
            }
        }
    }
    
    public static void makeAllMemberOOF(){
        list<Assignment_Group_Member__c> agmList = new list<Assignment_Group_Member__c>();
        
        agmList = [select id,Out_Of_Office__c from Assignment_Group_Member__c where active__c = true and Out_Of_Office__c = false];
        if(!agmList.isEmpty()){
            for(Assignment_Group_Member__c agm : agmList){
                agm.Out_Of_Office__c = true; 
            }
            update agmList;
        }
    }
}