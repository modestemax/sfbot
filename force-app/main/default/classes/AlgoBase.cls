public
with sharing abstract class AlgoBase implements IAlgo {
protected
  Algo__c algo;
  static signal__c current;
  static signal__c last;
  static signal__c prev;
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
    if (testBuy(current, last, prev, Signals)) {
      System.debug('o');
    }
  }
public
  abstract Boolean testBuy(signal__c current, signal__c last, signal__c prev,
                           signal__c[] signals);

public
  abstract Boolean testSell(signal__c current, signal__c last, signal__c prev,
                            signal__c[] signals);
}
