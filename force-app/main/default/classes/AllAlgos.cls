public
with sharing class AllAlgos implements ITask {
  AlgoBase[] algos;
public
  allAlgos() {
    for (Algo_Setting__mdt a : [
           select Name__c,
           Is_Test__c from Algo_Setting__mdt where is_active__c = true
         ]) {
      try {
        algos.add(((AlgoBase)Type.forName(a.Name__c).newInstance()).init(a));

      } catch (Exception e) {
        System.debug(LoggingLevel.ERROR, ''+ e);
      }
    }
  }
public
  void execute() {

    AlgoBase.newSignals(
        [select Name from signal__c order by signal_Id__c desc limit 3]);

    for (AlgoBase algo : algos) {
      algo.Test();
    }
  }
public
  static void runAll() {
    AllAlgos all = new AllAlgos();
    all.execute();
  }
}