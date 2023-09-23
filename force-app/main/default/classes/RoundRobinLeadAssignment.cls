public without sharing class  RoundRobinLeadAssignment{
    
    public static boolean reccuringTrigger = true;
    public static string groupName = '';
    public static map<string,string> mapofCouseByGroupName = new map<string,string>();
    @future
    public static void assignLeadsToBDS(String assignmentGroupName,set<String> leadIdList,boolean preSalesToSalesTransfer){
        system.debug('assignmentGroupName::'+ assignmentGroupName);
        boolean withinWorkingHour = false;
        List<lead__c> updateLeadList = new List<lead__c>();
        List<Assignment_Group__c> QtoBeUpdated = new List<Assignment_Group__c>();
        Map<String, List<String>> QueueNameToQmemberIdList = new Map<String, List<String>>();
        Map<String, Boolean> userIdToUserAvailablityMap = new Map<String, Boolean>();
        Map<String, List<lead__c>> qNameToListOfLeadsMap = new map<String,List<lead__c>>();
        Map<String, Integer> qNameAndMemberIdTORoundRobinIDMaP = new Map<String, Integer>();
        Map<String, Integer> qNameToLastAssignedQmemberRRid = new Map<String, Integer>();
        Map<String, String> QnameAndRRidToMemberIDMap = new Map<String, String>();
        List<Lead__Share> leadShareRecords = new List<Lead__Share>();
        
        //withinWorkingHour = BuildMaps.CheckBusinessHours();
        qNameToListOfLeadsMap  = makeQueueNameToListOfAssignedLeadsMap(assignmentGroupName, leadIdList,preSalesToSalesTransfer);//Group wise leads based on source intent
        system.debug('mapofCouseByGroupName::'+mapofCouseByGroupName);
        QueueNameToQmemberIdList = makeCustomQueueNameToListOfUserId(mapofCouseByGroupName.get(assignmentGroupName)); // group by group member
        userIdToUserAvailablityMap = makeuserIdToUserAvailablityMap(mapofCouseByGroupName.get(assignmentGroupName)); // group by group member availability
        
        //qNameAndMemberIdTORoundRobinIDMaP = makeqNameAndMemberIdTORoundRobinIDMaP(assignmentGroupName);
        qNameToLastAssignedQmemberRRid = BuildMaps.makeQNameToLastAssignedQmemberRRid(); // qname with last allocated ID
        QnameAndRRidToMemberIDMap = makeQnameAndRRidToMemberID(mapofCouseByGroupName.get(assignmentGroupName)); // qname with qname+rrid
        BuildMaps.validateUserCapacity(assignmentGroupName);
        
        system.debug('BuildMaps.mapofMemIdByExceedCount::'+BuildMaps.mapofMemIdByExceedCount);//member id with exceed count
        system.debug('BuildMaps.mapofMemidByTodayLeadCount::'+BuildMaps.mapofMemidByTodayLeadCount);//member id with today's lead count
        system.debug('BuildMaps.mapofMemIdByMaxLeadCountPerDay::'+BuildMaps.mapofMemIdByMaxLeadCountPerDay);// member id with max lead count per day(AGM)
        system.debug('BuildMaps.mapofMemIdByMaxLeadCountByGroupPerDay::'+BuildMaps.mapofMemIdByMaxLeadCountByGroupPerDay);// member id with max lead count per day(GM)
        system.debug('BuildMaps.mapofMemidbyMaxleadCountFromUser::'+BuildMaps.mapofMemidbyMaxleadCountFromUser);//member id with max lead count from user
        system.debug('BuildMaps.mapofMemidByPendingLeads::'+BuildMaps.mapofMemidByPendingLeads);//member id with new leads count.
        
        for(String qName: qNameToListOfLeadsMap.keySet()){
            system.debug('qName---'+qName);
            if(qName != null){
                for(lead__c ld: qNameToListOfLeadsMap.get(qName)){
                    Boolean isAssigned = false;
                    Integer qMemberSize = 1;
                    system.debug('QueueNameToQmemberIdList::'+QueueNameToQmemberIdList);
                    system.debug('QueueNameToQmemberIdList.get(qName)::'+QueueNameToQmemberIdList.get(qName));
                    While(QueueNameToQmemberIdList != null && qMemberSize != null && QueueNameToQmemberIdList.get(qName) != null && isAssigned == false && qMemberSize <= QueueNameToQmemberIdList.get(qName).size()){
                        Integer currentRRid, LastRRid; 
                        String QnameAndRRid, qMemberID;
                        System.debug('qNameToLastAssignedQmemberRRid ====> ' + qNameToLastAssignedQmemberRRid);
                        System.debug('qNameToLastAssignedQmemberRRid.get(qName) ====> ' + qNameToLastAssignedQmemberRRid.get(qName));
                        if(qNameToLastAssignedQmemberRRid.get(qName) != null)
                            LastRRid = qNameToLastAssignedQmemberRRid.get(qName); 
                        System.debug('LastRRid-------+++++'+LastRRid);
                        if(LastRRid == null || LastRRid < 1){
                            qNameToLastAssignedQmemberRRid.remove(qName);
                            qNameToLastAssignedQmemberRRid.put(qName, 0);
                            currentRRid = 1;
                            System.debug('Inside 1  currentRRid'+currentRRid);
                        }
                        system.debug('LastRRid::'+LastRRid);
                        system.debug('QueueNameToQmemberIdList.get(qName).size()::'+QueueNameToQmemberIdList.get(qName).size());
                        if(LastRRid < QueueNameToQmemberIdList.get(qName).size()){
                            currentRRid = LastRRid + 1;
                            System.debug('Inside 2  currentRRid'+currentRRid);
                        }
                        else if(QueueNameToQmemberIdList.get(qName).size() == 1){
                            
                            
                        }
                        else{
                            currentRRid = 1;
                            LastRRid = 0;
                            System.debug('Inside 3  currentRRid'+currentRRid);
                        }
                        QnameAndRRid = qName + String.valueOf(currentRRid);
                        system.debug('QnameAndRRid::'+QnameAndRRid);
                        system.debug('QnameAndRRidToMemberIDMap::'+QnameAndRRidToMemberIDMap);
                        qMemberID = QnameAndRRidToMemberIDMap.get(QnameAndRRid);
                        System.debug('QnameAndRRid::'+QnameAndRRid);
                        System.debug('qMemberID::'+qMemberID);
                        
                        if(assignmentConditionSatisfied(qName,qMemberID)){//qName,qMemberID,userIdbyLeadcount,ld.Learner_Uid__c,assignmentConditionSatisfied(true)
                            system.debug('userIdToUserAvailablityMap.get(qMemberID):'+userIdToUserAvailablityMap.get(qMemberID));
                            if(userIdToUserAvailablityMap.get(qMemberID) == true){
                                system.debug('Owner is going to Change!!!');
                                if (preSalesToSalesTransfer == false) {
                                    ld.ownerId = Id.valueOf(qMemberID);
                                    ld.Lead_Assigned_Date_Time__c = system.now();
                                    ld.Lead_Assigned_Time__c = Time.newInstance(Datetime.now().hour(), Datetime.now().minute(), Datetime.now().second(), 0);
                                    ld.Lead_Assigned_Date__c = system.today();
                                    ld.Assignment_Group__c = qName;
                                    if (BuildMaps.mapofAssignGroupNameById.get(qName) != null) {
                                        ld.AG_related_to__c = BuildMaps.mapofAssignGroupNameById.get(qName);                                        
                                    }
                                    updateLeadList.add(ld); 
                                }
                                else if (preSalesToSalesTransfer == true) {
                                    system.debug('ld.OwnerId-->'+ld.OwnerId);
                                    ld.Pre_Sales_Team_Member__c = ld.OwnerId;
                                    system.debug('ld.Pre_Sales_Team_Member__c-->'+ld.Pre_Sales_Team_Member__c);
                                    ld.OwnerId = Id.valueOf(qMemberID);
                                    system.debug('ld.OwnerId-->'+ld.OwnerId);
                                    ld.Sales_Team_Member__c = Id.valueOf(qMemberID);
                                    Lead__Share leadShareRec = new Lead__Share();
                                    leadShareRec.ParentId = ld.Id;
                                    leadShareRec.UserOrGroupId = Id.valueOf(ld.Pre_Sales_Team_Member__c);
                                    leadShareRec.AccessLevel = 'Edit';
                                    system.debug('leadShareRec--->'+leadShareRec);
                                    leadShareRecords.add(leadShareRec);
                                    
                                    if (ld.Sales_Team_Member__c != null) {
                                        ld.isQualified__c = true;
                                        ld.Qualified_Date_Time__c = system.now();
                                        updateLeadList.add(ld); 
                                    }
                                }
                                isAssigned = true;
                                //BuildMaps.memberIdbypendingLeadCount.put(qMemberID,BuildMaps.memberIdbypendingLeadCount.get(qMemberID) + 1);
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
                                
                            }
                            LastRRid = LastRRid +1; 
                            qNameToLastAssignedQmemberRRid.remove(qName);
                            qNameToLastAssignedQmemberRRid.put(qName, LastRRid);
                            System.debug('qNameToLastAssignedQmemberRRid::'+qNameToLastAssignedQmemberRRid);
                            qMemberSize ++;
                            system.debug('qMemberSize::'+qMemberSize);
                        }else{
                            LastRRid = LastRRid +1; 
                            qNameToLastAssignedQmemberRRid.remove(qName);
                            qNameToLastAssignedQmemberRRid.put(qName, LastRRid);
                            qMemberSize ++;
                        }
                    }
                }
            }
            
        }
        
        if(!qNameToLastAssignedQmemberRRid.keySet().isEmpty())
        {
            List<Assignment_Group__c> updateQrId = new List<Assignment_Group__c>();
            updateQrId = [Select id, name, Last_Allocated_RRid__c  from Assignment_Group__c where Name IN: qNameToLastAssignedQmemberRRid.keySet()];
            for(Assignment_Group__c Q: updateQrId)
            {
                Q.Last_Allocated_RRid__c = qNameToLastAssignedQmemberRRid.get(Q.Name);
                QtoBeUpdated.add(q);
            }
        }
        System.debug('updateLeadList---'+updateLeadList);
        if(!updateLeadList.isEmpty()){
            reccuringTrigger = false;
            update updateLeadList;  
        }
        if (!leadShareRecords.isEmpty()) {
            try{
                insert leadShareRecords;  
            }catch(exception e){
                system.debug('Exception'+ e.getMessage() +'@@@@'+e.getLineNumber());
            }
            
        }
        if(!QtoBeUpdated.isEmpty())
            Update QtoBeUpdated;
        
    }
    
    
    
    public static boolean assignmentConditionSatisfied(string qName,string qMemberID){
        system.debug('qName--- '+qName);
        system.debug('qMemberID--- '+qMemberID);
        boolean isconditionapproved = false;
        
        if(BuildMaps.mapofMemidByAssignedLead.get(qMemberID) == null){
            // very first lead
            isconditionapproved = true;
        }else{
             if(BuildMaps.mapofMemidByAssignedLead.get(qMemberID) != null && BuildMaps.mapofMemidByAssignedLead.get(qMemberID) <  BuildMaps.mapofMemidByMaxLeadPerDayFromAG.get(qMemberID)){
                if(BuildMaps.mapofMemidByAssignedLead.get(qMemberID) < BuildMaps.mapofMemIdByMaxLeadCountPerDay.get(qMemberID)){
                    isconditionapproved = true;
                }else{
                    isconditionapproved = false;
                }
            }else{
                isconditionapproved = false;
            }
        }
        system.debug('isconditionapproved::'+isconditionapproved);
        return isconditionapproved;
    }
    
    public static map<String,List<lead__c>> makeQueueNameToListOfAssignedLeadsMap(string courseName, Set<String> leadIdList,boolean preSalesToSalesTransfer){
        system.debug('courseName::'+courseName);
        system.debug('courseName::'+courseName);
        map<String,string> sourceIntentByGroupMap = new map<String,String>();
        string groupName = [Select Name
                            From Assignment_Group__c where Name =: courseName
                            limit 1].name;
        Map<String, List<lead__c>> groupNameByLeads = new Map<String, List<lead__c>>();
        string queueId = [SELECT Id, Type FROM Group WHERE Type = 'Queue' AND Name = 'Lead Default Queue' limit 1].Id;
        List<lead__c> leadsInQueue = [SELECT ID,OWNERID,Lead_Assigned_Date__c,Lead_Assigned_Time__c,ProjectName_formula__c,Lead_Assigned_Date_Time__c FROM lead__c WHERE id in : leadIdList];
        mapofCouseByGroupName.put(courseName,groupName);
        
        // Inserting QueueId and list of case assigned to the queue id into the map:-QueueNameToListOfAssignedCasesMap
        if(!leadsInQueue.isEmpty()){
            for(lead__c ld: leadsInQueue){
                    if(groupNameByLeads.containsKey(courseName)){
                        groupNameByLeads.get(courseName).add(ld);    
                    }else{
                        groupNameByLeads.put(courseName,new List<lead__c>{ld});      
                    }
                }
            /*else{
                    if(ld.ProjectName_formula__c != null){
                        if(groupNameByLeads.containsKey(ld.ProjectName_formula__c)){
                            groupNameByLeads.get(ld.ProjectName_formula__c).add(ld);    
                        }else{
                            groupNameByLeads.put(ld.ProjectName_formula__c,new List<lead__c>{ld});      
                        }
                    }                    
                }*/
                
                System.debug('QueueNameToListOfAssignedCasesMap::'+groupNameByLeads);
            }
        return groupNameByLeads;
    }
    
    public static Map<String, List<String>> makeCustomQueueNameToListOfUserId(string assignmentGroupName){
        system.debug('assignmentGroupName--->'+assignmentGroupName);
            
        Map<String, List<String>> customQueueNameToListOfUserId = new Map<String, List<String>>();
        List<Assignment_Group__c> queueWithQueueMembers = new List<Assignment_Group__c>();
        Map<String, Id> queueNameToQueueIdMap = new Map<String, Id> ();
        
        List<Assignment_Group__c> listOfExistingQueue = new List<Assignment_Group__c>();
        listOfExistingQueue = [select id, name,Max_Lead_Per_Day__c from Assignment_Group__c];
        List<Assignment_Group_Member__c > listOfExistingQueueMembers = new List<Assignment_Group_Member__c >();
        listOfExistingQueueMembers = [select id, name,Out_Of_Office__c,Assignment_Group__c,Assignment_Group__r.name, Assignment_Id__c,Leave_End_Date__c,Leave_Start_Date__c,Group_Member__c,Group_Member__r.Id from Assignment_Group_Member__c where Assignment_Group__r.name =: assignmentGroupName And Out_Of_Office__c = false];
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
        system.debug('customQueueNameToListOfUserId::'+customQueueNameToListOfUserId);
        return customQueueNameToListOfUserId;
    }
    
    public static Map<String, Boolean> makeuserIdToUserAvailablityMap(string assignmentGroupName){
        /**Need to  handle leave*/ 
        Map<String, Boolean> userIdToUserAvailablityMap = new Map<String, Boolean>();   
        List<Assignment_Group_Member__c> agentAvailablity = new List<Assignment_Group_Member__c>();  
        agentAvailablity = [select id,Out_Of_Office__c,Group_Member__r.Id,Assignment_Group__r.name from Assignment_Group_Member__c where Assignment_Group__r.name =: assignmentGroupName and Out_Of_Office__c = false];
        system.debug('agentAvailablity::'+agentAvailablity);
        for(Assignment_Group_Member__c Aa: agentAvailablity)
        {
            userIdToUserAvailablityMap.put(aa.Group_Member__r.Id, true);    
        }
        System.debug('userIdToUserAvailablityMap-----'+userIdToUserAvailablityMap);
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
        //Map<String, Map<String, Integer>> qNameAndMemberIdTORoundRobinIDMaP = new Map<String, Map<String, Integer>>();  
        Map<String, String> QnameAndRRidToMemberIDMap = new Map<String, String>();
        
        list<Assignment_Group_Member__c> agmList = new list<Assignment_Group_Member__c>();
        agmList = [select id,Assignment_Group__r.name,Assignment_Id__c,Group_Member__r.Id,Out_Of_Office__c from Assignment_Group_Member__c where Assignment_Group__r.name =: groupName and Out_Of_Office__c = false];
        system.debug('agmList::'+agmList);
        if(!agmList.isEmpty()){
            for(Assignment_Group_Member__c agm : agmList){
                String qName = agm.Assignment_Group__r.name; String qMember = string.valueOf(agm.Assignment_Id__c);
                system.debug('qName::'+qName);
                system.debug('qMember::'+qMember);
                if(!string.isBlank(qName) && !String.isBlank(qMember)){
                    String qNameAndQmamber = qName+qMember;
                    system.debug('qNameAndQmamber::'+qNameAndQmamber);
                    QnameAndRRidToMemberIDMap.put(qNameAndQmamber, String.valueOf(agm.Group_Member__r.Id));
                } 
            }
        }
        
        //System.debug('QnameAndRRidToMemberIDMap---'+QnameAndRRidToMemberIDMap);
        return QnameAndRRidToMemberIDMap;        
    }
}