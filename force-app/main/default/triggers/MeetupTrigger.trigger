trigger MeetupTrigger on Meetup__c (before insert) {
    //before inset, trigger delegate class will verify and create Meetup__c.RegistrationCode__c field value. 
    if(Trigger.isBefore && Trigger.isInsert){
        MeetupTriggerHelper.populateRegistrationCode(Trigger.new);
    }
}