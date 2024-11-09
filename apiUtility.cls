public with sharing class apiUtility {
    
    @AuraEnabled
    public static boolean updateAccount(String accId, String otp,string email) {
        // Prepare the endpoint URL
        String endpointUrl = 'https://bitstream-dev-ed.develop.my.salesforce.com/services/apexrest/Accountapi/';
        Integration_User_Access_Token__c  Access_Token_Custom_Setting = Integration_User_Access_Token__c.getValues('Integration_User');
        system.debug(Access_Token_Custom_Setting);
        // Create the HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointUrl);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        // req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId()); // Auth header for session-based authentication
        req.setHeader('Authorization', 'Bearer ' + Access_Token_Custom_Setting.Access_Token__c);
        // Prepare the request body
        String requestBody = '{"accId": "' + accId + '", "otp": "' + otp + '", "email": "' + email + '"}';
        req.setBody(requestBody);
        
        // Make the HTTP callout
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        // Handle the response
        if (res.getStatusCode() == 200) {
            return true;
        } else {
            return false;
        }
    }
    @future(callout=true) 
    public static void callOutUpdateAccessToken()
    {
        Integration_User_Access_Token__c mc = [SELECT Id, Name,Grant_Type__c,Access_Token__c, Client_Id__c, Client_Secret_Key__c FROM Integration_User_Access_Token__c WHERE Name = 'Integration_User'];
        system.debug(mc);
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();        
        request.setEndpoint( URL.getOrgDomainUrl().toExternalForm()+'/services/oauth2/token');
        String bodyString = 'grant_type='+mc.Grant_Type__c+'&client_id='+mc.Client_Id__c+'&client_secret='+mc.Client_Secret_Key__c;
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody(bodyString);
        HttpResponse response = http.send(request);
        
        system.debug(response.getBody());
        map<string,string> temp=new  map<string,string> ();
        temp=(map<string,string>)System.JSON.deserialize(response.getBody(), map<string,string>.class);
        system.debug(temp.get('access_token'));
        mc.Access_Token__c=temp.get('access_token');
        update mc;
    }
}