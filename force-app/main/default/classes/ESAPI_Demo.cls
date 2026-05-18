public class ESAPI_Demo {

    public String basicText { get; set; }
    public String prettyText;
    
   /*
    Task #1 
    The code below mixes unsanitized user input and HTML markup for injection onto the visualforce page through an outputtext tag with escape="false." 
    As you learned in the XSS section, this design pattern can lead to an XSS vulnerability.
    
    We cannot output encode the whole string (prettyText) because it contains code, but we can output encode the user controlled portion (basicText). This is the best practice for
    any situation where you need to use escape="false". The only problem is that Apex does not contain a method to perform HTML encoding (only Visualforce does)!
    
    To solve this, the ESAPI package from OWASP contains methods for performing output encoding in apex. The following methods are available for HTML encoding:
    
    Managed Package - OWASP.ESAPI.encoder().SFDC_HTMLENCODE(...)
    
    Unmanaged Package - ESAPI.encoder().SFDC_HTMLENCODE(...)
    
    Note: The primary differences between the managed and unmanaged packages is that the managed package has governor limit benefits and 
    the unmanaged package allows you to see and edit the contained code. 
    
    
    Use either of the above methods to wrap the user controlled variable in HTML encoding so it is safe to place inside an escape="false" Visualforce tag.
    
    */

    public String getPrettyText() {
        if(!string.isBlank(basicText)){
            prettyText = '<b><font size="6" face="Comic Sans MS" color="blue"><i>'+basicText+'<i></font></p>';
            return prettyText;
        } else {
            return null;
        }
    }
    
    
    
    
    public PageReference makePretty() {
        return null;
    }

    
}