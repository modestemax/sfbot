public
interface IAlgo {

  IAlgo init(Algo__c algo);

  Boolean testBuy(signal__c current, signal__c last, signal__c prev,
                  signal__c[] signals);

  Boolean testSell(signal__c current, signal__c last, signal__c prev,
                   signal__c[] signals);
}
