public
with sharing class Test_algo extends AlgoBase {
public
  test_algo() {}

public
  override Boolean testBuy(signal__c current, signal__c last, signal__c prev,
                           signal__c[] signals) {
    System.debug('test buy ' + algo);
    return false;
  }

public
  override Boolean testSell(signal__c current, signal__c last, signal__c prev,
                            signal__c[] signals) {
    return false;
  }
}
