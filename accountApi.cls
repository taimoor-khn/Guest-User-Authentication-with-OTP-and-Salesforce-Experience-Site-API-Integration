@RestResource(urlMapping='/Accountapi/*')
global with sharing class accountApi {
    @HttpPost
    global static string updateAccountRecord() {
        try {
            String body = RestContext.request.requestBody.toString();
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(body);
            
            // Get accountId and newFieldValue from the request body
            String accId = (String) data.get('accId');
            String otp = (String) data.get('otp');
            String email = (String) data.get('email');
            system.debug(accId);
            
            account acc=new account();
            acc.id=accId;
            acc.otp__c=otp;
            
            OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'taimoor.ali8606@gmail.com'];
            
            // Initialize the email message
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { email });
            mail.setSubject('Your OTP Code');
            mail.setPlainTextBody('Your OTP is: ' + otp);
            
            // Set Org-Wide Email Address if available
            if (owea.size() > 0) {
                mail.setOrgWideEmailAddressId(owea[0].Id);
            } else {
                System.debug('Org-Wide Email Address not found.');
                // Exit if no valid org-wide email address is found
            }
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
            update acc;
            
            return 'true';
        } catch (Exception e) {
            return string.valueof(e);
        }
    }
}