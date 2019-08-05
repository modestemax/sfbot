public
with sharing class AllAlgos implements ITask {
  AlgoBase[] algos;
public
  allAlgos() {
    for (Algo__c a :
         [ select name, is_test__c from algo__c where is_active__c = true ]) {
      algos.add(((AlgoBase)Type.forName(a.Name).newInstance()).init(a));
    }
  }
public
  void execute() {
     AlgoBase.newSignals(
        [select Name from signal__c order by signal_Id__c desc limit 5]);
        
    for (AlgoBase algo : algos) {
      algo.Test();
    }
  }
}