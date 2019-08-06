public
with sharing class Test_algo extends AlgoBase {
public
  test_algo() {}

public
  override Boolean testBuy() {
    if (current.ema10__c > last.ema20__c && prev.ema100__c > 0) {
      return true;
    }

    return false;
  }

public
  override Boolean testSell() { return false; }
}