@isTest

public class OrgValidtyTestCallOutMocker implements HttpCalloutMock {
  public String customResponse;
    public Integer customResponseCode;
      
    static String validResponse = 'true';
    static String inValidResponse = 'false';
      
    public HTTPResponse respond(HTTPRequest req) {      
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if (req.getEndpoint().toUpperCase().contains('APEXREST')) {
            res.setBody(validResponse);          
        } else {
            res.setBody(inValidResponse);          
        }

        If (customResponseCode==null) {
          res.setStatusCode(200);
        } else {
            res.setStatusCode(customResponseCode);
        }
        
        return res;
    }
}