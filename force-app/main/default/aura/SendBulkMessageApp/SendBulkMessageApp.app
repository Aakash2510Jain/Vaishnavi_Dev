<aura:application extends="force:slds" implements="lightning:isUrlAddressable" access="Global" >
	 <aura:attribute name="listofLeads" type="String" default=""/>
    	 <aura:attribute name="myParam" type="String" default=""/>

    <aura:handler name="init" value="{!this}" action="{!c.onPageReferenceChange}"/>
    <aura:attribute name="leadList" type="Lead__c[]"/>
    <c:sendBulkMessage aura-id="myLwc"/>
    <!--c:sendBulkMessage my-param="{!v.listofLeads}" ></c:sendBulkMessage-->  

</aura:application>