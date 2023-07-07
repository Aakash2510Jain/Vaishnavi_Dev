public without sharing class  RoundRobinLeadAssignment{
    public static boolean reccuringTrigger = true;
    public static string groupName = '';
    public static map<string,string> mapofCouseByGroupName = new map<string,string>();
    @future
    public static void assignLeadsToBDS(String courseName,set<String> LeadIdList){
        system.debug('courseName ====> ' + courseName);
        system.debug('LeadIdList ====> ' + LeadIdList.size());
        boolean withinWorkingHour = false;
        string queueId = [SELECT Id, Type FROM Group WHERE Type = 'Queue' AND Name = 'Lead Default Queue' limit 1].Id;
        List<Lead__c> updateLeadList = new List<Lead__c>();
        List<Lead__c> DefaultQueueLeadList = new List<Lead__c>();
        List<Assignment_Group__c> QtoBeUpdated = new List<Assignment_Group__c>();
        Map<String, List<String>> QueueNameToQmemberIdList = new Map<String, List<String>>();
        Map<String, Boolean> userIdToUserAvailablityMap = new Map<String, Boolean>();
        Map<String, List<Lead__c>> qNameToListOfLeadsMap = new map<String,List<Lead__c>>();
        Map<String, Integer> qNameAndMemberIdTORoundRobinIDMaP = new Map<String, Integer>();
        Map<String, Integer> qNameToLastAssignedQmemberRRid = new Map<String, Integer>();
        Map<String, String> QnameAndRRidToMemberIDMap = new Map<String, String>();
        String Assignee = '';
        
        If(LeadIdList.size() > 0){
            List<Lead__c> LeadData =  [SELECT ID,OWNERID,Lead_Stage__c,Lead_Assigned_Date__c FROM Lead__c WHERE  id IN:LeadIdList  limit 50000]; //and Lead_Stage__c != null
            qNameToListOfLeadsMap.put(courseName,LeadData);
        }

        QueueNameToQmemberIdList = makeCustomQueueNameToListOfUserId(courseName); // group by group member
        userIdToUserAvailablityMap = makeuserIdToUserAvailablityMap(courseName); // group by group member availability
        qNameToLastAssignedQmemberRRid = BuildMaps.makeQNameToLastAssignedQmemberRRid(); // qname with last allocated ID
        QnameAndRRidToMemberIDMap = makeQnameAndRRidToMemberID(courseName); // qname with qname+rrid
        BuildMaps.validateUserCapacity(courseName,LeadIdList);
        
        for(String qName: qNameToListOfLeadsMap.keySet()){
            if(qName != null){
                for(Lead__c ld: qNameToListOfLeadsMap.get(qName)){
                    Boolean isAssigned = false;
                    Integer qMemberSize = 1;
                    While(QueueNameToQmemberIdList != null && qMemberSize != null && QueueNameToQmemberIdList.get(qName) != null && isAssigned == false && qMemberSize <= QueueNameToQmemberIdList.get(qName).size()){
                        Assignee = QueueNameToQmemberIdList.get(qName)[0];
                        Integer currentRRid, LastRRid; 
                        String QnameAndRRid, qMemberID;
                        if(qNameToLastAssignedQmemberRRid.get(qName) != null)
                            LastRRid = qNameToLastAssignedQmemberRRid.get(qName); 
                        if(LastRRid == null || LastRRid < 1){
                            qNameToLastAssignedQmemberRRid.remove(qName);
                            qNameToLastAssignedQmemberRRid.put(qName, 0);
                            currentRRid = 1;
                        }
                        if(LastRRid < QueueNameToQmemberIdList.get(qName).size()){
                            currentRRid = LastRRid + 1;
                        }else{
                            currentRRid = 1;
                            LastRRid = 0;
                        }
                        system.debug('currentRRid ====> ' + currentRRid);
                        
                        QnameAndRRid = qName + String.valueOf(currentRRid);
                        system.debug('QnameAndRRid ====> ' + QnameAndRRid);
                        
                        qMemberID = QnameAndRRidToMemberIDMap.get(QnameAndRRid);
                        system.debug('qMemberID ====> ' + qMemberID);
                        
                        boolean test = true;
                        if(assignmentConditionSatisfied(qName,qMemberID)){
                            system.debug('userIdToUserAvailablityMap.get(qMemberID) ====> ' + userIdToUserAvailablityMap.get(qMemberID));
                            if(userIdToUserAvailablityMap.get(qMemberID) == true){
                                system.debug('Owner is going to Change!!!');
                                ld.ownerId = Id.valueOf(qMemberID);
                                ld.Lead_Assigned_Date_Time__c = system.now();
                                ld.Lead_Assigned_Date__c = system.today();
                                updateLeadList.add(ld); 
                                isAssigned = true;
                                if(BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID) == null)
                                    BuildMaps.mapofMemidByTodayLeadCount.put(qMemberID,0);
                                BuildMaps.mapofMemidByTodayLeadCount.put(qMemberID,BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID)+1);
                                if(BuildMaps.mapofMemidByPendingLeads.get(qMemberID) == null)
                                    BuildMaps.mapofMemidByPendingLeads.put(qMemberID,0);
                                BuildMaps.mapofMemidByPendingLeads.put(qMemberID,BuildMaps.mapofMemidByPendingLeads.get(qMemberID) + 1);
                                if(BuildMaps.mapofMemidByTodayNewLead.get(qMemberID) == null)
                                    BuildMaps.mapofMemidByTodayNewLead.put(qMemberID,0);
                                BuildMaps.mapofMemidByTodayNewLead.put(qMemberID,BuildMaps.mapofMemidByTodayNewLead.get(qMemberID)+1);
                                if(BuildMaps.mapofMemidByAssignedLead.get(qMemberID) == null)
                                    BuildMaps.mapofMemidByAssignedLead.put(qMemberID,0);
                                BuildMaps.mapofMemidByAssignedLead.put(qMemberID,BuildMaps.mapofMemidByAssignedLead.get(qMemberID) + 1);
                            }else{
                                ld.OwnerId = queueId;
                                //DefaultQueueLeadList.add(ld);
                            }
                            LastRRid = LastRRid +1; 
                            qNameToLastAssignedQmemberRRid.remove(qName);
                            qNameToLastAssignedQmemberRRid.put(qName, LastRRid);
                            qMemberSize ++;
                        }else{
                            LastRRid = LastRRid +1; 
                            qNameToLastAssignedQmemberRRid.remove(qName);
                            qNameToLastAssignedQmemberRRid.put(qName, LastRRid);
                            qMemberSize ++;
                            ld.OwnerId = queueId;
                            //DefaultQueueLeadList.add(ld);
                        }
                    }
                }
            }
        }
        
        if(!qNameToLastAssignedQmemberRRid.keySet().isEmpty()){
            List<Assignment_Group__c> updateQrId = new List<Assignment_Group__c>();
            updateQrId = [Select id, name, Last_Allocated_RRid__c  from Assignment_Group__c where Name IN: qNameToLastAssignedQmemberRRid.keySet()];
            for(Assignment_Group__c Q: updateQrId){
                Q.Last_Allocated_RRid__c = qNameToLastAssignedQmemberRRid.get(Q.Name);
                QtoBeUpdated.add(q);
            }
        }
        system.debug('updateLeadList ====> ' + updateLeadList);
        if(!updateLeadList.isEmpty()){
            reccuringTrigger = false;
            try{
                update updateLeadList;  
            }catch(exception e){
                system.debug('Exception'+ e.getMessage() +'@@@@'+e.getLineNumber());
            }
        }
        
        if(!QtoBeUpdated.isEmpty()){
            Update QtoBeUpdated;           
        }
        
        if(!DefaultQueueLeadList.isEmpty()){
            system.debug('DefaultQueueLead__cList'+DefaultQueueLeadList.size());
            Set<Lead__c> myset = new Set<Lead__c>();
            List<Lead__c> result = new List<Lead__c>();
            myset.addAll(DefaultQueueLeadList);
            result.addAll(myset);
            update result;
        }
    }
    
    public static boolean assignmentConditionSatisfied(string qName,string qMemberID){
        system.debug('qMemberID--->'+qMemberID);
        boolean isconditionapproved = false;
        /*if(qMemberID != null){
            return false;
        }*/
        system.debug('BuildMaps.mapofMemidByAssignedLead.get(qMemberID) ====> ' + BuildMaps.mapofMemidByAssignedLead.get(qMemberID));
        system.debug('BuildMaps.mapofMemidbyMaxLeadCountFromUser.get(qMemberID) ====> ' + BuildMaps.mapofMemidbyMaxLeadCountFromUser.get(qMemberID));
        system.debug('BuildMaps.mapofMemidByPendingLeads.get(qMemberID) ====> ' + BuildMaps.mapofMemidByPendingLeads.get(qMemberID));
        system.debug('BuildMaps.mapofMemIdByExceedCount.get(qMemberID) ====> ' + BuildMaps.mapofMemIdByExceedCount.get(qMemberID));
        system.debug('BuildMaps.mapofMemidByTodayNewLead.get(qMemberID) ====> ' + BuildMaps.mapofMemidByTodayNewLead.get(qMemberID));
        system.debug('BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID) ====> ' + BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID));
        system.debug('BuildMaps.mapofMemIdByMaxLeadCountPerDay.get(qMemberID) ====> ' + BuildMaps.mapofMemIdByMaxLeadCountPerDay.get(qMemberID)); 
        system.debug('BuildMaps.mapofMemIdByMaxLeadCountByGroupPerDay.get(qMemberID) ====> ' + BuildMaps.mapofMemIdByMaxLeadCountByGroupPerDay.get(qMemberID));
        if(BuildMaps.mapofMemidByAssignedLead.get(qMemberID) == null){
            isconditionapproved = true;
        }else if(BuildMaps.mapofMemidByAssignedLead.get(qMemberID) != null && BuildMaps.mapofMemidbyMaxLeadCountFromUser.get(qMemberID) != null &&  BuildMaps.mapofMemidByAssignedLead.get(qMemberID) < BuildMaps.mapofMemidbyMaxLeadCountFromUser.get(qMemberID)){
            if(BuildMaps.mapofMemidByPendingLeads.get(qMemberID) == null || (BuildMaps.mapofMemidByPendingLeads.get(qMemberID) != null && BuildMaps.mapofMemIdByExceedCount.get(qMemberID) != null && BuildMaps.mapofMemidByPendingLeads.get(qMemberID) < BuildMaps.mapofMemIdByExceedCount.get(qMemberID))){
                if(BuildMaps.mapofMemidByTodayNewLead.get(qMemberID) == null ||(BuildMaps.mapofMemidByTodayNewLead.get(qMemberID) != null && BuildMaps.mapofMemidByMinLeadsCount.get(qMemberID) != null && BuildMaps.mapofMemidByTodayNewLead.get(qMemberID) < BuildMaps.mapofMemidByMinLeadsCount.get(qMemberID) && BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID) != null && BuildMaps.mapofMemIdByMaxLeadCountPerDay.get(qMemberID) != null && BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID) < BuildMaps.mapofMemIdByMaxLeadCountPerDay.get(qMemberID))){
                    isconditionapproved = true;
                }else if(BuildMaps.mapofMemIdByMaxLeadCountPerDay.get(qMemberID) == null && BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID) != null && BuildMaps.mapofMemIdByMaxLeadCountByGroupPerDay.get(qMemberID) != null && BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID) < BuildMaps.mapofMemIdByMaxLeadCountByGroupPerDay.get(qMemberID)){
                    isconditionapproved = true;
                }else if(BuildMaps.mapofMemIdByMaxLeadCountByGroupPerDay.get(qMemberID) == null && BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID) != null && BuildMaps.mapofMemidbyMaxLeadCountFromUser.get(qMemberID) != null &&  BuildMaps.mapofMemidByTodayLeadCount.get(qMemberID) < BuildMaps.mapofMemidbyMaxLeadCountFromUser.get(qMemberID)){
                    isconditionapproved = true;
                }  
            }else{
                isconditionapproved = false;
            }
        }
        return isconditionapproved;
    }
    
    public static map<String,List<Lead__c>> makeQueueNameToListOfAssignedLeadsMap(string courseName,set<String> LeadId){
        
        map<String,string> sourceIntentByGroupMap = new map<String,String>();
        Map<String, List<Lead__c>> groupNameByLeads = new Map<String, List<Lead__c>>();
        List<Lead__c> LeadsInQueue = [SELECT ID,Lead_Assigned_Date__c,OWNERID,Lead_Stage__c FROM Lead__c WHERE id in:LeadId limit 50000];
        
        if(!LeadsInQueue.isEmpty()){
            for(Lead__c ld: LeadsInQueue){
                if(ld.Lead_Stage__c != null){
                    if(groupNameByLeads.containsKey(courseName)){
                        groupNameByLeads.get(courseName).add(ld);    
                    }else{
                        groupNameByLeads.put(courseName,new List<Lead__c>{ld});      
                    }
                }
            }
        }
        
        return groupNameByLeads;
    }
    
    public static Map<String, List<String>> makeCustomQueueNameToListOfUserId(string assignmentGroupName){
        Map<String, List<String>> customQueueNameToListOfUserId = new Map<String, List<String>>();
        List<Assignment_Group__c> queueWithQueueMembers = new List<Assignment_Group__c>();
        Map<String, Id> queueNameToQueueIdMap = new Map<String, Id> ();
        
        List<Assignment_Group__c> listOfExistingQueue = new List<Assignment_Group__c>();
        listOfExistingQueue = [select id, name,Max_Lead_Per_Day__c from Assignment_Group__c];
        List<Assignment_Group_Member__c > listOfExistingQueueMembers = new List<Assignment_Group_Member__c >();
        listOfExistingQueueMembers = [select id, name,Out_Of_Office__c,Assignment_Group__c,Assignment_Group__r.name, Assignment_Id__c,Leave_End_Date__c,Leave_Start_Date__c,Group_Member__c,Group_Member__r.Id from Assignment_Group_Member__c where Assignment_Group__r.name =: assignmentGroupName and Assignment_Group__r.Do_Not_Consider_For_Lead_Assignment__c = false];
        
        Set<Id> existingQueueMembersQueueId = new Set<Id>();
        
        if(!listOfExistingQueueMembers.isEmpty()){
            for(Assignment_Group_Member__c agm : listOfExistingQueueMembers){
                if(customQueueNameToListOfUserId.containsKey(agm.Assignment_Group__r.name)){
                    customQueueNameToListOfUserId.get(agm.Assignment_Group__r.name).add(agm.Group_Member__r.Id);
                }else{
                    customQueueNameToListOfUserId.put(agm.Assignment_Group__r.name,new list<string>{agm.Group_Member__r.Id});
                }
            }
        }
        
        return customQueueNameToListOfUserId;
    }
    
    public static Map<String, Boolean> makeuserIdToUserAvailablityMap(string assignmentGroupName){
        Map<String, Boolean> userIdToUserAvailablityMap = new Map<String, Boolean>();   
        List<Assignment_Group_Member__c> agentAvailablity = new List<Assignment_Group_Member__c>();  
        agentAvailablity = [select id,Out_Of_Office__c,Group_Member__r.Id,Assignment_Group__r.name from Assignment_Group_Member__c where Assignment_Group__r.name =: assignmentGroupName and Out_Of_Office__c = false];
        
        for(Assignment_Group_Member__c Aa: agentAvailablity){
            userIdToUserAvailablityMap.put(aa.Group_Member__r.Id, true);    
        }
        
        return userIdToUserAvailablityMap;
    }
    
    public static Map<String, Integer> makeqNameAndMemberIdTORoundRobinIDMaP(String groupName){
        Map<String, Integer> qNameAndMemberIdTORoundRobinIDMaP = new Map<String, Integer>();
        list<Assignment_Group_Member__c> agmList = new list<Assignment_Group_Member__c>();
        agmList = [select id,Assignment_Group__r.name,Assignment_Id__c,Group_Member__r.Id from Assignment_Group_Member__c where Assignment_Group__r.name =: groupName];
        
        if(!agmList.isEmpty()){
            for(Assignment_Group_Member__c agm : agmList){
                String qName = agm.Assignment_Group__r.name; String qMember = agm.Group_Member__r.Id;
                if(!string.isBlank(qName) && !String.isBlank(qMember)){
                    String qNameAndQmamber = qName+qMember;
                    qNameAndMemberIdTORoundRobinIDMaP.put(qNameAndQmamber, Integer.valueOf(agm.Assignment_Id__c));
                } 
            }
        }
        return qNameAndMemberIdTORoundRobinIDMaP;        
    }
    
    public static Map<String, String> makeQnameAndRRidToMemberID(String groupName){
        system.debug('groupName ====> ' + groupName);
        //Map<String, Map<String, Integer>> qNameAndMemberIdTORoundRobinIDMaP = new Map<String, Map<String, Integer>>();  
        Map<String, String> QnameAndRRidToMemberIDMap = new Map<String, String>();
        list<Assignment_Group_Member__c> agmList = new list<Assignment_Group_Member__c>();
        
        agmList = [select id,Assignment_Group__r.name,Assignment_Id__c,Group_Member__r.Id,Out_Of_Office__c from Assignment_Group_Member__c where Assignment_Group__r.name =: groupName and Out_Of_Office__c = false];
        
        if(!agmList.isEmpty()){
            for(Assignment_Group_Member__c agm : agmList){
                String qName = agm.Assignment_Group__r.name; String qMember = string.valueOf(agm.Assignment_Id__c);
                
                if(!string.isBlank(qName) && !String.isBlank(qMember)){
                    String qNameAndQmamber = qName+qMember;
                    QnameAndRRidToMemberIDMap.put(qNameAndQmamber, String.valueOf(agm.Group_Member__r.Id));
                } 
            }
        }
        system.debug('QnameAndRRidToMemberIDMap ====> ' + QnameAndRRidToMemberIDMap);
        
        return QnameAndRRidToMemberIDMap;        
    }
    
}