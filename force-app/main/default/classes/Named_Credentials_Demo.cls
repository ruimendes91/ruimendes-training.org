public with sharing class Named_Credentials_Demo {
    public String portalStatus {get;set;}
    
    public Named_Credentials_Demo()
    {
        portalStatus = '';
    }
       
    public void openPortal(){
        HttpRequest req = new HttpRequest();
            req.setEndpoint('https://secret-storage.herokuapp.com/');           
            req.setMethod('GET');
            Http http = new Http();
            HTTPResponse res = http.send(req);                   
            portalStatus = res.getBody();
    }
}