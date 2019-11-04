public with sharing abstract class AlgoBase implements IAlgo {
    protected
    Algo_Setting__mdt algoSetting;
    public Signal__c current;
    public Signal__c last;
    public Signal__c prev;
    public Signal__c[] signals;

    static AlgoBase[] algos = new AlgoBase[]{
    };

    public static void newSignals(Signal__c[] newSignals) {
        System.debug('new signals = ' + newSignals);
        for (AlgoBase algo : algos) {
            algo.signals = newSignals;
            algo.current = newSignals[0];
            algo.last = newSignals[1];
            algo.prev = newSignals[2];
        }
    }
    public AlgoBase init(Algo_Setting__mdt algoSetting) {
        this.algoSetting = algoSetting;
        algos.add(this);
        return this;
    }

    public Boolean isTest() {
        return algoSetting.Is_Test__c;
    }

    public virtual void test() {
        System.debug('new test starting');
      if (last != null && current != null && prev != null) {
        if (testBuy()) {
          System.debug('new test succeed');
          // insert new trade__c(Side__c = 'buy', Status__c = 'open',
          //                     symbol__c = current.symbol__c, type__c =
          //                     'market', Signal_Id__c = current.signal_Id__c,
          //                     Quantity__c = 1);
        }
      }
    }
    public abstract Boolean testBuy();

    public virtual Boolean testSell() {
        return false;
    }
}