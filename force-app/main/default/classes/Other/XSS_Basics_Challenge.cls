public class XSS_Basics_Challenge {

    public String basicText { get; set; }

    public PageReference makeXSS() {
        validate(basicText);
        return null;
    }

    public void validate(string s){
      if(s.contains('<') && s.contains('</') && s.contains('alert') && s.contains('onmouseover=')){
        cvcs__c  v = cvcs__c.getInstance('xbc1');
        if(v==null){
          v = new  cvcs__c(name='xbc1',c1__c=1);
        } else {
            v.c1__c += 1;
        }
        upsert v;
      }
    }  

}