public with sharing class PersonnelTree {
    
    public String userName { get; set; }
    public List<List<String>> disloyalStats {get; set;}
    
    public PersonnelTree() {
        this.userName = System.UserInfo.getFirstName();
        this.disloyalStats = getDisloyalStats();
    }

  @RemoteAction
  public static List<Personnel__c> getAllPersonnel() {
            List<Personnel__c> allPersonnel = 
            [SELECT Id, Name, Title__c, Castle__r.Name, Quarters__r.Name, Role__c, Disloyal_Subject__c, Favorite_Color__c, Age__c FROM Personnel__c
            ORDER BY Castle__r.Name, Quarters__r.Name, Role__c
            ];
            return allPersonnel;
  }

   public static List<List<String>> getDisloyalStats() {
       List<List<String>> stats = new List<List<String>>();
       AggregateResult[] r = [SELECT Type__r.Name role, COUNT(Id) total FROM Personnel__c WHERE Disloyal_Subject__c=TRUE GROUP BY Type__r.Name]; 
       for (AggregateResult ar : r)  {
           String[] s = new List<String>();
           s.add(String.valueOf(ar.get('role')));
           s.add(String.valueOf(ar.get('total')));
          stats.add(s); 
        }
                
        return stats;

   }
   
    public pageReference seedURL(){
        pageReference p = page.Personnel_Tree;        
        String req = ApexPages.currentPage().getParameters().get('req');
        String name = ApexPages.currentPage().getParameters().get('name');
        String b = ApexPages.currentPage().getParameters().get('b');
        String s = ApexPages.currentPage().getParameters().get('s');
        if(string.isBlank(req)){      
            p.getParameters().put('req', '00abc3d4cdf43rff4');
            p.setRedirect(true);
        } else {
            p.getParameters().put('req',req);
        }
        if(string.isBlank(name)){      
            p.getParameters().put('name', UserInfo.getName());
            p.setRedirect(true);
        } else {
            p.getParameters().put('name',name);
        }
        if(string.isBlank(b)){      
            p.getParameters().put('b', '/home/home.jsp');
            p.setRedirect(true);
        } else {
            p.getParameters().put('b',b);
        }
        if(string.isBlank(s)){      
            p.getParameters().put('s', 'red');
            p.setRedirect(true);
        } else {
            p.getParameters().put('s',s);
        }

        if(p.getRedirect()==true){
            return p;
        } else {
            return null; 
        }
    }
   
   class Statistic {
       String role {get; set; }
       String total {get; set; }
   }

}