public with sharing class Test_algo extends AlgoBase {
public test_algo() {}

public override Boolean testBuy() {
    if (current.EMA10__c > last.EMA20__c && prev.EMA100__c > 0) {
      return true;
    }

    return false;
  }

public override Boolean testSell() { return false; }
}