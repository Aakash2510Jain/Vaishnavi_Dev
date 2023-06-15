({
	doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.sendSereneBookingForm");
        action.setParams({
            oppId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
			var toastEvent = $A.get("e.force:showToast");
            var state = response.getState();
            if(state === "SUCCESS"){    
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Premiere Booking Form Sent Successfully',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
            }
            else{
				toastEvent.setParams({
                    title : 'Sent Error',
                    message: 'Error.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'sticky'
                });
            }
            toastEvent.fire();
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        }); 
        $A.enqueueAction(action);

    }
})