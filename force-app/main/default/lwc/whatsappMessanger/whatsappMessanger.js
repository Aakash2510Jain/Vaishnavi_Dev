import { LightningElement, track, wire, api } from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import getMessagesList from '@salesforce/apex/WhatsappMessangerController.getContactWhatsappHistory';
import getPhoneNumber from '@salesforce/apex/WhatsappMessangerController.getPhoneNumber';
import { refreshApex } from '@salesforce/apex';
import sendMessageTemplate from '@salesforce/apex/WhatsappMessangerController.sendMessageTemplate';
import MOBILE_PHONE from '@salesforce/schema/Contact.MobilePhone';
import WTemplateModal from 'c/wtemplateModal';
import sendtextMessage from '@salesforce/apex/WhatsappMessangerController.sendMessageText';
import templateDetails from '@salesforce/apex/WhatsappMessangerController.getTemplateDetails';





const fields = ['Phone__c'];

export default class WhatsappMessanger extends LightningElement {
     textMessage = '';
     @api objectApiName;
     @api recordId = '';

     isModalOpen = false;
     templateDetails = {};
     templateMessage;
     templateMessageBackend;
    @track messages = [
        //  {
        //     id: 1,
        //     sender: 'other',
        //     content: 'Hi there! How can I help you today?',
        //     time: '10:00 AM',
        //     classs: 'sent-message',
        //     pclass: 'message-row-send'
        // },
        // {
        //     id: 2,
        //     sender: 'me',
        //     content: 'Hi! I have a question about my account.',
        //     time: '10:01 AM',
        //     classs: 'received-message',
        //     pclass: 'message-row-recieve'
        // },
        // {
        //     id: 3,
        //     sender: 'other',
        //     content: 'Sure, what would you like to know?',
        //     time: '10:02 AM',
        //     class: 'received-message',
        //     pclass: 'message-row-recieve'
        // } 
    ];
    @track error;

    disableSend = true;

    templateId;
    phoneNo;
    wiredMessagesResult;
    selectedRecPhoneNumber;

    get backgroundStyle() {
        return `height:50rem;background-image:url("https://img.freepik.com/premium-photo/3d-rendering-bunch-square-badges-with-whatsapp-logo-green-background_284880-352.jpg")`;
    }

    @wire(getMessagesList, { recordId: '$recordId' })
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
    debugger;
    selectedRecordDetails;

    get getMobilePhone() {
        debugger;
        return getFieldValue(this.Opportunity__C.data, 'Phone__c');
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
      
        // if(this.templateName && getFieldValue(this.contact.data, MOBILE_PHONE)) {
        //     sendMessageTemplate({ templateName: this.templateName, phoneNumber : getFieldValue(this.contact.data, MOBILE_PHONE) })
        //     .then(result => {
        //         debugger;
        //         console.log(result);
        //     })
        //     .catch(error => {
        //         this.error = error;
        //         console.log(error);
        //     });
        // }

        if(this.textMessage) {
            sendtextMessage({ textMessage: this.textMessage, phoneNumber : this.selectedRecPhoneNumber, recordId : this.recordId })
            .then(result => {
                debugger;
                refreshApex(this.wiredMessagesResult);
                this.textMessage = '';
            })
            .catch(error => {
                this.error = error;
            });
        }

      
    }

    getTemplateDetails(){
      
           
    }
    

    handleTemplateSelection(event){
        debugger;
        if(event.detail) {
            this.templateId = event.detail;
            console.log("the selected record template name is"+event.detail);
            templateDetails({tempId: this.templateId})
            .then(result => {
                if(result){
                    debugger;
                    this.templateDetails = JSON.parse(result);
                    console.log('this.parsedValue ' + this.templateDetails.data);
                    this.templateMessage = this.templateDetails.Message_for_FrontEnd__c;
                    this.templateMessageBackend = this.templateDetails.Message__c;
                    this.textMessage = this.templateDetails.Message__c;

                }
                    })
            .catch(error => {
                this.error = error;
            });
                this.disableSend = false;
        }else {
            this.disableSend = true;
        }
    }
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }

    async handleOpenModal() {
        debugger;
        this.isModalOpen = true;
        // const result = await WTemplateModal.open({
        //     // `label` is not included here in this example.
        //     // it is set on lightning-modal-header instead
        //     size: 'large',
        //     description: 'Choose Whatsapp Template',
        // });
        // // if modal closed with X button, promise returns result = 'undefined'
        // // if modal closed with OK button, promise returns result = 'okay'
    }

    handleCloseModal() {
      
    }
    // Changes by Vigi

    // @wire(getPhoneNumber, { sojectName: '$objectApiName', recordId: '$recordId'})
    // wiredPhonenumber(result) {
    //     debugger;
    //     if (result && result.data) {
    //         this.selectedRecPhoneNumber = result;
    //     } else if (result && result.error) {
          
    //     }
    // }



    getPhoneNum(){
        getPhoneNumber({ sojectName: this.objectApiName, recordId: this.recordId})
        .then(result => {
            if(result){
                debugger;
                 this.selectedRecPhoneNumber = result[0].Phone__c;
            }
                })
        .catch(error => {
            this.error = error;
        });
           
    }
   
    
    enableSendButton(event){
        debugger;
        this.getPhoneNum();
        console.log(event.target.value);
        this.textMessage = event.target.value;
        this.disableSend = false;
    }


    handleOkay() {
        this.getPhoneNum();
        this.isModalOpen = false;
    }

}