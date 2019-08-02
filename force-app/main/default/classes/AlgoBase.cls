public
with sharing abstract class AlgoBase implements IAlgo {
protected
  Algo__c algo;
public
  static signal__c current;
public
  static signal__c last;
public
  static signal__c prev;
public
  static signal__c[] signals;

public
  static void newSignals(signal__c[] newSignals) {
    // Signals = [select Name from signal__c order by signal_Id__c desc limit
    // 5];
    signals = newsignals;
    current = Signals[0];
    last = Signals[1];
    prev = Signals[2];
  }
public
  AlgoBase init(Algo__c algo) {
    this.algo = algo;
    return this;
  }

public
  Boolean isTest() { return algo.is_test__c; }

public
  void test() {
    if (testBuy()) {
      System.debug('o');
      // insert new trade__c(Algo__c = algo, symbol__c = current.symbol__c,
      //                     signal__c = current);
    }
  }
public
  abstract Boolean testBuy();

public
  virtual Boolean testSell() { return false; }
}
