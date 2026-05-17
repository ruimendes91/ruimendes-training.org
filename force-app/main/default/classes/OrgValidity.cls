global with sharing class OrgValidity{

     private static final String ENDPOINT_URL = 'https://security.secure.force.com/services/apexrest/THRest?since=';
     private static final String RELEASE_NOTES = 'https://security.secure.force.com/DevelopSecureWebAppsReleaseNotes';
     public String ReleaseNotes {get; set;}
     public String ValidFail {get; set;}
     public String ValidSuccess {get; set;}

     public OrgValidity() {
        String ValidateVal = ValidateOrg();
        if(ValidateVal.contains('true')) {
           ValidSuccess = 'Your Org is Up to date. No action required!';
        } else {
           ValidFail = 'Your Org is not up to date. Please signup for a new org';
        }
        ReleaseNotes = RELEASE_NOTES;
     }

     private String ValidateOrg() {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setTimeout(90000);
        DateTime dt = [SELECT CreatedDate FROM Organization].CreatedDate;
        String endPoint = ENDPOINT_URL+dt.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'','GMT');
        req.setEndpoint(endPoint);

        HttpResponse res =  new Http().send(req);
        system.debug('Response : '+req.getBody());
        if(res.getStatusCode() != 200) {
            //throw new Exception('Non valid response FROM server. Response: ' + res.getStatusCode());
            ApexPages.Message errorMsg = new ApexPages.Message(
                                        ApexPages.Severity.FATAL, 'Unable to Validate the Request, Pleae Contact...');
            ApexPages.addMessage(errorMsg);
        }
        return res.getBody();
    }
}