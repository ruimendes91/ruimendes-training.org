public class XSS_Basics_Demo {
  public String basicText { get; set; }
  public String outputText { get; set; }
     
    public XSS_Basics_Demo(){
        basicText='';
        if(apexpages.currentpage().getparameters().get('text')!=null && apexpages.currentpage().getparameters().get('text')!='')
            basicText=apexpages.currentpage().getparameters().get('text');
        outputText = basicText.replace('\r\n','<br/>');
    }

    
    public PageReference makePretty() {
        PageReference PageWithParam=Page.XSS_Basics_Demo;
        PageWithParam.getParameters().put('text', basicText);
        PageWithParam.setRedirect(true);
        return PageWithParam;
    }
}