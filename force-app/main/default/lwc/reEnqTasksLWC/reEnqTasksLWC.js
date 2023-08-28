import { LightningElement,wire, api, track } from 'lwc';
import getRecordList from '@salesforce/apex/SimilarTasksHelper.getTasks';

export default class SimilarLeadLWC extends LightningElement {

    @track recList = [];
    @api url = '';
    @api recordId;
    @wire(getRecordList,{recordId:'$recordId'})
    wiredResponse(result){
        if(result.data){
            debugger;
            console.log('Contacts-------',result.data);
            //this.recList = [];
            for(let i =0; i<result.data.length; i++){
                let rec = {...result.data[i]};
                rec.Sub = 'Re-Enq';
                var str1 = rec.Modified_Created_Date__c.toString().slice(0,10);
                var str2 = str1 + ' ';
                var str3 = str2 + rec.Modified_Created_Date__c.toString().slice(11,16);
                rec.CreatedDateFmt = str3;
                rec.url = 'https://vaishnavigroup--dev.sandbox.lightning.force.com/lightning/r/Task/'+rec.Id+'/view';
                this.recList.push(rec);
                console.log('this.recList[i].url -- ' , rec );
            }
             
        }else{
            console.log("Error Fetching Tasks",result);
        }
    }
}