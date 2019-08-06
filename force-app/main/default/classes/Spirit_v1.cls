public
with sharing class Spirit_v1 extends AlgoBase {
public
  Spirit_v1() {}

public
  override Boolean testBuy() {
    if (last != null && current != null && prev != null) {
      System.debug('test SpiritV1 buy Start!' + algoSetting + current);
      if ((last.ema30__c < last.ema10__c) && (last.ema30__c >= last.ema20__c)) {
      }
      //   if (last.ema20__c > last.bbb)
      if ((last.bb_upper__c > prev.bb_upper__c) &&
          (last.ema10__c > prev.ema10__c))
        if (current.close__c <= current.bb_upper__c)
          if (((current.bb_upper__c / current.bb_lower__c) - 1) * 100 >= 2)
            return true;
    }

    return false;
  }

public
  override Boolean testSell() { return false; }
}