public with sharing class MeetupRegistrationController {
    @AuraEnabled(cacheable=true)
    public static List<Meetup__c> getMeetupRecordList(String registrationCodeStr){
        try {
            //build like string syntax for query 
            String searchKey = '%'+registrationCodeStr+'%';
            List<Meetup__c> meetUpLst = [SELECT Id, Name, RegistrationLimit__c, Status__c, RegistrationCode__c
                                            FROM Meetup__c 
                                            WHERE  RegistrationCode__c LIKE :searchKey
                                        ];

            if(meetupLst.size() > 0){
                return meetUpLst;
            }
            else{
                return null;
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getMeetupRegCount(Id meetupId){
        try {
            List<Meetup__c> meetups = [SELECT Id, RegistrationLimit__c, (SELECT Id from MeetupRegistrations__r) FROM Meetup__c where Id =:meetupId];
            String status = 'success';
            if(meetups.size() > 0){
                for(Meetup__c meetup : meetups){
                    if(meetup.MeetupRegistrations__r.size() == meetup.RegistrationLimit__c){
                        status = 'Error';
                    }
                }
                return status;
            }
            else{
                return 'Error';
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
