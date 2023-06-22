({
    pullAccount : function(component) {
        var action=component.get("c.getLeads");
        action.setParams({            
            sleadIds:component.get("v.leadIds") 
        });
        action.setCallback(this,function(e){
            if(e.getState()=='SUCCESS'){
                var result=e.getReturnValue();
                if(result!=null && result.length>0){
                    component.set("v.leadList",result);
                }
                else{
                    this.showToast("ERROR","error",'No record return'); 
                }
            }
            else{
                this.showToast("ERROR","error",JSON.stringify(e.getError())); 
            }
        });
        $A.enqueueAction(action);
    },
    
    showToast:function(title,type,message){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({"title": title,"type": type,"message": message}).fire();
        }
        else{
            alert(message);
        }
    },
    
 })