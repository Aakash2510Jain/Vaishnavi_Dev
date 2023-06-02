import { LightningElement, track, wire, api } from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import getMessagesList from '@salesforce/apex/WhatsappMessangerController.getContactWhatsappHistory';
import { refreshApex } from '@salesforce/apex';
import sendMessageTemplate from '@salesforce/apex/WhatsappMessangerController.sendMessageTemplate';
import MOBILE_PHONE from '@salesforce/schema/Contact.MobilePhone';
import WTemplateModal from 'c/wtemplateModal';

const fields = [MOBILE_PHONE];
export default class WhatsappMessanger extends LightningElement {

    @track messages = [
        /* {
            id: 1,
            sender: 'other',
            content: 'Hi there! How can I help you today?',
            time: '10:00 AM',
            class: 'sent-message'
        },
        {
            id: 2,
            sender: 'me',
            content: 'Hi! I have a question about my account.',
            time: '10:01 AM',
            class: 'received-message'
        },
        {
            id: 3,
            sender: 'other',
            content: 'Sure, what would you like to know?',
            time: '10:02 AM',
            class: 'received-message'
        } */
    ];
    @track error;

    disableSend = true;

    @api recordId = '';
    templateName;
    phoneNo;
    wiredMessagesResult;


    @wire(getMessagesList, { contactId: '$recordId' })
    wiredMessages(result) {
        debugger;
        this.wiredMessagesResult = result;
        if (result && result.data) {
            console.log('---', result.data);
            this.messages = result.data;
            this.error = undefined;
        } else if (result && result.error) {
            this.error = result.error;
            this.messages = undefined;
        }
    }

    //3. Wire the output of the out of the box method getRecord to the property account
    @wire(getRecord, {
        recordId: "$recordId",
        fields
    })
    contact;

    get getMobilePhone() {
        return getFieldValue(this.contact.data, MOBILE_PHONE);
    }

    connectedCallback() {
        // Subscribe to the channel
        const channel = '/data/Messages__ChangeEvent';
        const messageCallback = (response) => {
            // Handle the update message
            this.handleUpdateMessage(response);
        };
        subscribe(channel, -1, messageCallback).then((subscription) => {
            debugger;
            console.log('Subscribed to EMP API successfully: ', subscription.channel);
            this.subscription = subscription;
        });
    }

    handleUpdateMessage(response) {
        debugger;
        // Handle the received message here.
        if (response.data.payload.ChangeEventHeader.entityName === 'Messages__c' && response.data.payload.ChangeEventHeader.changeType === 'CREATE' && response.data.payload.Contact__c && this.recordId === response.data.payload.Contact__c) {
            //const updatedRecordId = response.data.payload.Id;
            refreshApex(this.wiredMessagesResult);
        }
    }
    

    disconnectedCallback() {
        // Unsubscribe from the channel
        if (this.subscription) {
            unsubscribe(this.subscription, (response) => {
                console.log('unsubscribe() response: ', JSON.stringify(response));
            });
        }
    }

    

    //TODO: get the messages from backend, WHATSAPP server
    handleSendMessage(event) {
        debugger;
        //TODO: show message preview on template selection.
        /*const inputField = this.template.querySelector('.message-input');
        const message = inputField.value.trim();

        if(message) {
            const now = new Date();
            const time = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit'});

            this.messages.push({
                id: this.messages.length,
                content: message,
                sender: 'me',
                time: time,
                class: 'sent-message'
            });

            inputField.value = '';
            inputField.focus();
        }*/
        if(this.templateName && getFieldValue(this.contact.data, MOBILE_PHONE)) {
            sendMessageTemplate({ templateName: this.templateName, phoneNumber : getFieldValue(this.contact.data, MOBILE_PHONE) })
            .then(result => {
                debugger;
                console.log(result);
            })
            .catch(error => {
                this.error = error;
                console.log(error);
            });
        }

    }

    

    handleTemplateSelection(event){
        debugger;
        if(event.detail) {
            this.templateName = event.detail;
            console.log("the selected record template name is"+event.detail);
            this.disableSend = false;
        }else {
            this.disableSend = true;
        }
    }

    async handleOpenModal() {
        debugger;
        const result = await WTemplateModal.open({
            // `label` is not included here in this example.
            // it is set on lightning-modal-header instead
            size: 'large',
            description: 'Choose Whatsapp Template',
        });
        // if modal closed with X button, promise returns result = 'undefined'
        // if modal closed with OK button, promise returns result = 'okay'
        console.log(result);
    }

    handleCloseModal() {
      
    }
    
}