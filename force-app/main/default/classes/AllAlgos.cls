public with sharing class AllAlgos implements ITask {
  AlgoBase[] algos = new AlgoBase[]{};
public allAlgos() {
    for (Algo_Setting__mdt a : [
           SELECT Name__c,
           Is_Test__c FROM Algo_Setting__mdt WHERE Is_active__c = TRUE
         ]) {
      try {
        algos.add(
            ((AlgoBase)Type.forName(a.Name__c.trim().replaceAll('\\s+', '_'))
                 .newInstance())
                .init(a));

      } catch (Exception e) {
        System.debug(LoggingLevel.ERROR, ''+ e);
      }
    }
  }
public void execute() {

    AlgoBase.newSignals([
      SELECT Id,
      Name,
      Symbol__c,
      Bid__c,
      Ask__c,
      Close__c,
      Change__c,
      High__c,
      Low__c,
      Open__c,
      EMA10__c,
      EMA20__c,
      EMA200__c,
      EMA50__c,
      EMA100__c,
      EMA30__c,
      BB_lower__c,
      BB_upper__c,
      ADX__c,
      ADX_MINUS_DI__c,
      ADX_PLUS_DI__c,
      Change_from_Open__c,
      RSI__c,
      Mom__c,
      MACD_macd__c,
      MACD_signal__c,
      Timeframe__c,
      Time__c,
      signal_Id__c FROM Signal__c ORDER BY signal_Id__c DESC LIMIT 3
    ]);
    System.debug('algos = ' + algos);
    for (AlgoBase algo : algos) {
      algo.test();
    }
  }
public static void runAll() {
    System.debug('run all algos');
    AllAlgos all = new allAlgos();
    all.execute();
  }
}