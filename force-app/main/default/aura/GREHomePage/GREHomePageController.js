// RedirectButtonController.js
({
    redirectToURL : function(component, event, helper) {
        var url = component.get("v.url");
        window.location.href = url;
    }
})