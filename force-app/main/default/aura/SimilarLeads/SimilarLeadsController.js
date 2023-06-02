({
    doInit : function(component, event, helper) {
        debugger;
        var callPicklistMethod = component.get("c.getSourceTypePicklistValues");
        $A.enqueueAction(callPicklistMethod);
        var action = component.get("c.getLeads");
        action.setParams({
            "recordId" : component.get('v.recordId')
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
               
                var result= response.getReturnValue();
                var DataToSplit  = [];
                if(result != null && result != undefined){

                    for(var i=0;i<result.length;i++){
                        if(result[i].Lead_Source_Type__c !=null){
                          var str = result[i].Lead_Source_Type__c.replace(/-/g, ' ');
                             const arr1 = str.split(' ');
                            var pickvalues = '';
                            if(arr1.length  === 1){
                                 pickvalues = arr1[0].substring(0, 2);
                                
                            }else if(arr1.length === 2){
                               pickvalues = arr1[0].substring(0, 1) +arr1[1].substring(0, 1);
                            }else if(arr1.length === 3){
                                 pickvalues = arr1[0].substring(0, 1) +arr1[1].substring(0, 1)+arr1[2].substring(0, 1);
                            }
                            result[i].ShortName = pickvalues;
                        }
                    }
                    component.set("v.leadListWithsimDomain", result);
                }
                else{
                    component.set("v.showImage", true);
                }
            }
        });      
        $A.enqueueAction(action);
    },
    getSourceTypePicklistValues : function(component, event, helper) {
        debugger;
        var action = component.get("c.getLeadSourceTypePickList");
        action.setParams({
            ObjectApi_name : 'Lead__c',
            Field_name : 'Lead_Source_Type__c'
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var dataPickList= response.getReturnValue();
                if(dataPickList !=null && dataPickList !=undefined){
                    component.set("v.LeadSourcePickList",dataPickList);
                }
            } else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }else if (state=== "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
        });
        $A.enqueueAction(action);
    }
})