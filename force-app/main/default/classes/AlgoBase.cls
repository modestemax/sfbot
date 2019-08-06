public
with sharing abstract class AlgoBase implements IAlgo {
protected
  Algo_Setting__mdt algoSetting;
public
  signal__c current;
public
  signal__c last;
public
  signal__c prev;
public
  signal__c[] signals;

  static AlgoBase[] algos = new AlgoBase[]{};

public
  static void newSignals(signal__c[] newSignals) {
    for (AlgoBase algo : algos) {
      algo.signals = newsignals;
      algo.current = newsignals[0];
      algo.last = newsignals[1];
      algo.prev = newsignals[2];
    }
  }
public
  AlgoBase init(Algo_Setting__mdt algoSetting) {
    this.algoSetting = algoSetting;
    algos.add(this);
    return this;
  }

public
  Boolean isTest() { return algoSetting.is_test__c; }

public
  virtual void test() {
    if (testBuy()) {
      System.debug('o');
      insert new trade__c(Side__c = 'buy', Status__c = 'open',
                          symbol__c = current.symbol__c, type__c = 'market',
                          Signal_Id__c = current.signal_Id__c, Quantity__c = 1);
    }
  }
public
  abstract Boolean testBuy();

public
  virtual Boolean testSell() { return false; }
}