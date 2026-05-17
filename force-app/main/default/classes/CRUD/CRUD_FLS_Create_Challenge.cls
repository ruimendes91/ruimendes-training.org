public with sharing class CRUD_FLS_Create_Challenge{

    public Id newUser {get;set;}
    
    public List<Personnel__c> getUnReg() {
        unregisteredUsers = new List<Personnel__c>();
       List<Jouster__c> currentParticipants = [ select Participant_Name__r.Name from Jouster__c ];
       List<Personnel__c> currentPersonnel = [ select Id, Name, Favorite_Color__c, Castle__r.Name from Personnel__c limit 15];
       Boolean reg;
       
       System.debug(currentParticipants);
       System.debug(currentPersonnel);
       
       for( Personnel__c p : currentPersonnel)
       {
           reg = false;
           for(Jouster__c j : currentParticipants)
           {
               if(j.Participant_Name__r.Name == p.Name) {
                   reg = true;
                   break;
               }
           }
           
           if(reg == false)
               unregisteredUsers.add(p);
       }
       
       System.debug(unregisteredUsers);
       
       return unregisteredUsers;
    }

    public Jouster__c newParticipant {get;set;}
    public List<Personnel__c> unregisteredUsers;
    
    
    public void register(){
            System.debug(newUser);
            Personnel__c p = [select Name, Favorite_Color__c, Castle__r.Name from Personnel__c where Id =: newUser];
            
            if([select id from Jouster__c where Participant_Name__r.Name =: p.Name] != null)
                insert new Jouster__c(Participant_Name__c=newUser, Color__c=p.Favorite_Color__c, Castle__c=p.Castle__c);
            else
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Jouster already entered in Tournament'));
                
    }
    
    public string[] getPermSets(){
        String[] permSetArray = new List<string>();
        PermSetArray.add('User with Read ONLY Access to the Jousters object'); // description of the needed permission set
        return permSetArray;
    }

}