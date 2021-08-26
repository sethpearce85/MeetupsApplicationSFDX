import { LightningElement, api , wire, track} from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

import getMeetupRecordList from '@salesforce/apex/MeetupRegistrationController.getMeetupRecordList';
import getMeetupRegCount from '@salesforce/apex/MeetupRegistrationController.getMeetupRegCount';
import USER_FIRST_NAME from "@salesforce/schema/User.FirstName";
import USER_LAST_NAME from "@salesforce/schema/User.LastName";
import USER_EMAIL from "@salesforce/schema/User.Email";
import USER_ID from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
//import createMessageRegistration from '@salesforce/apex/MeetupRegistrationController.createMessageRegistration';

const actions = [
    { label: 'Show details', name: 'show_details' },
    { label: 'Delete', name: 'delete' },
];

const columns = [{
    label: 'Meetup Name',
    fieldName: 'Name',
    type: 'text',
    sortable: true
},
{
    label: 'Status',
    fieldName: 'Status__c',
    type: 'picklist',
    sortable: true
},
{
    label: 'Registration Limit',
    fieldName: 'RegistrationLimit__c',
    type: 'number',
    sortable: true
},
{
    label: 'Registration Code',
    fieldName: 'RegistrationCode__c',
    type: 'text',
    sortable: false
},
{
    type: "button",
    fixedWidth: 150,
    typeAttributes: {
    label: 'Register',
    title: 'Register',
    name: 'register',
    value: 'register',
    variant: 'brand',
    class: 'scaled-down'

}

}
];

//firstName = USER_FIRST_NAME;

export default class MeetupRegistration extends NavigationMixin(LightningElement) {

    @track firstName;
    @track lastName;
    @track email;

    @track columns = columns;
    @track error;
    @track meetupList;    
    @track modalOpen = false;
    @track code;
    @track meetupId;
  
    selectedRegistrationCode;
   
  
    //auto populate current user firstname, lastname and email into register modal form.
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [USER_FIRST_NAME, USER_LAST_NAME, USER_EMAIL]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
           this.error = error ; 
        } else if (data) {
            this.firstName = data.fields.FirstName.value;
            this.lastName = data.fields.LastName.value;
            this.email = data.fields.Email.value;
        }
    }

    //NOTE -- TBD - Using Page REF to pass Meetup Reg# to URL for reference
    // currentPageReference;
    // pageId;
    // @wire(CurrentPageReference)
    // setCurrentPageReference(currentPageReference){
    //     if(currentPageReference){
    //         this.currentPageReference = currentPageReference;
    //         this.setCurrentPageIdBasedOnUrl;
    //     }
    // }

    // get newPageURLParams(){
    //     return{
    //         c__code: this.queryTerm
    //     }
    // }

    // get newPageReference() {
    //     return Object.assign({}, this.currentPageReference, {
    //         state: Object.assign({}, this.currentPageReference.state, this.newPageURLParams)
    //     });
    // }

    // setCurrentPageIdBasedOnUrl() {
    //     this.pageId = this.currentPageReference.state.c__code;
    // }

    // navigateToNewPage() {
    //     this[NavigationMixin.Navigate](
    //         this.newPageReference,
    //         false // if true js history is replaced without pushing a new history entry onto the browser history stack
    //     );        // if false new js history entry is created. User will be able to click browser back/forward buttons
    // }

    //function for for capturing user input on search input, on enter key press. 
    handleKeyUp(evt) {
        console.log(USER_FIRST_NAME);
        const isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            const queryTerm = evt.target.value;
            console.log('before callout to SFDC');
            console.log(queryTerm);
            getMeetupRecordList({registrationCodeStr : queryTerm})
            .then(
                result => {
                    console.log(result);
                    this.meetupList = result; 
                }).catch(
                error=> {
                    this.error = error;
                    console.log(this.error);
                }
            );
        }
        else{
            this.meetupList = undefined; 
        }
    }


    //handle button logic - open registration LWC 
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        this.meetupId = event.detail.row.Id;

        getMeetupRegCount({meetupId : this.meetupId})
            .then(
                result => {
                    console.log(result);
                    if(result == 'success'){
                        this.modalOpen = true;
                    }
                    else{
                        this.dispatchEvent(new ShowToastEvent({
                            title: 'Too Many Registrations ',
                            message: 'There are the max number of registrations for this meetup!',
                            variant: 'warn'
                        }));
                    }
                })
            .catch(
                error=> {
                    this.error = error;
                    console.log(this.error);
                }
            );
    }
    
    handleSuccess(){
        this.dispatchEvent(new ShowToastEvent({
            title: 'Registered Successfully',
            message: 'You have been registered for the event!',
            variant: 'success'
        }));
        this.modalOpen = false
   }

    closeModal(){
        this.modalOpen = false;
    }

    submitRegistration(event){   
        const fields = event.detail.fields;
        fields.Meetup__c = this.meetupId;
        this.modalOpen = false;
        
        this.dispatchEvent(new ShowToastEvent({
            title: 'Registered Successfully',
            message: 'You have been registered for the event!',
            variant: 'success'
        }));
    }
  

}