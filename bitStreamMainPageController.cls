public with sharing class bitStreamMainPageController {
    private static Map<string, String> otpMap = new Map<string, String>();
    
    @AuraEnabled
    public static boolean checkAccountExists(String userId) {
        List<Account> accounts = [SELECT Id,Name,Email__c,User_Id__c,otp__c FROM Account WHERE User_Id__c=:userId limit 1];
        system.debug('Acount--->'+accounts);
        if (accounts.isEmpty()) {
            return false;
        }
        String otp =  String.valueOf(Math.mod(Math.abs(Crypto.getRandomInteger()), 1000000));
        
        //accounts[0].otp__c= otp;
        boolean result=apiUtility.updateAccount(accounts[0].Id,otp,accounts[0].Email__c);
        if(!result)
        {
            return false;
        }
        //update accounts;
        //  otpMap.put(accounts[0].Name, otp);
        // bitStreamMainPageController.sendOtpEmail(accounts[0].Email__c, otp);
        
        return result;
    }
    
    @AuraEnabled
    public static Boolean verifyOtp(string userId, String enteredOtp) {
        system.debug('Otp by the user Input---->>>>'+enteredOtp);
        List<Account> accounts = [SELECT Id, Name,Email__c,User_Id__c,otp__c  FROM Account WHERE User_Id__c=:userId AND otp__c=:enteredOtp limit 1];
        if(accounts.size()>0)
        {
            return true;
        }else
        {
            return false;
        }
        //return otpMap.containsKey(Name) && otpMap.get(Name) == enteredOtp;
    }
    
    
    
    private static void sendOtpEmail(String email, String otp) {
        // Simplified email send (requires an email service in Salesforce org)
        
    }
    
    
 
}