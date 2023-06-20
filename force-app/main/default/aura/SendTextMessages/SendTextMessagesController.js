// sendTextMessageController.js
({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.getPreviousTextMessages");
        action.setParams({
            "leadId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.previousMessages", response.getReturnValue());
            }
            else {
                // Handle errors
                console.error("Error sending text message: " + response.getError());
            }
        });
        
        $A.enqueueAction(action);
    },
    sendTextMessage : function(component, event, helper) {
        debugger;
        var messageBody = component.get("v.messageBody");
        
        var action = component.get("c.sendSMS");
        action.setParams({
            "leadId": component.get("v.recordId"),
            "messageBody": messageBody
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
                
                // Do something on success
                console.log("Text message sent successfully!");
            }
            else {
                // Handle errors
                console.error("Error sending text message: " + response.getError());
            }
        });
        
        $A.enqueueAction(action);
    }
})