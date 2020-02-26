public with sharing class AllAlgos implements ITask {
    AlgoBase[] algos = new List< AlgoBase>();

    public allAlgos() {
        for (Algo_Setting__mdt algoSetting : [
                SELECT Name__c, Is_Test__c,Timeframe__c,Max_age_In_Minutes__c,Close_position_based_on_age__c,Stop_Loss__c,
                        Take_Profit__c,Is_active__c,Trade_Count__c,Trailing_Stop_Loss__c,Trailing_Stop_Loss_Value__c,Enter_Trade_At_Change__c
                FROM Algo_Setting__mdt
                WHERE Is_active__c = TRUE
        ]) {
            try {
                algos.add(((AlgoBase) Type.forName(algoSetting.Name__c.trim().replaceAll('\\s+', '_'))
                        .newInstance())
                        .init(algoSetting));
            } catch (Exception e) {
                System.debug(LoggingLevel.ERROR, '' + e);
            }
        }
    }
    public void execute() {
        AlgoBase.newSignals([
                SELECT Id,CreatedDate, Name, Symbol__c, Bid__c, Ask__c, Close__c, Change__c,Change_abs__c, High__c, Low__c, Open__c, EMA10__c, EMA20__c,
                        EMA200__c, EMA50__c, EMA100__c, EMA30__c, BB_lower__c, BB_upper__c, ADX__c, ADX_MINUS_DI__c, ADX_PLUS_DI__c,
                        Change_from_Open__c, RSI__c, Mom__c, MACD_macd__c, MACD_signal__c, Timeframe__c, Time__c, signal_Id__c,rank__c
                FROM Signal__c /* WHERE Change_abs__c>0.00000100 */
                ORDER BY Change__c DESC
        ]);

        AlgoBase.prepareAndTest();

    }
    public static void runAll() {
        System.debug('run all algos');
        AllAlgos all = new allAlgos();
        all.execute();
    }
}