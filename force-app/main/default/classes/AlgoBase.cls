public
with sharing abstract class AlgoBase implements IAlgo {
    protected
    Algo_Setting__mdt algoSetting;
    public Signal__c current;
    public Signal__c last;
    public Signal__c prev;
    public static Signal__c[] signals;
    public static Map<String, Signal__c[]> signalMap;

    static AlgoBase[] algos = new List< AlgoBase>();

    public static void newSignals(Signal__c[] newSignals) {
        System.debug('new signals = ' + newSignals);
        signals = newSignals;
        signalMap = new Map<String, Signal__c[]>();
        for (Signal__c signal : newSignals) {
            if (!signalMap.containsKey(signal.Symbol__c)) {
                signalMap.put(signal.Symbol__c, new List<Signal__c>());
            }
            signalMap.get(signal.Symbol__c).add(signal);
        }
    }


    public static void prepareAndTest() {
        System.debug('algos = ' + algos);
        Set<String> symbols = signalMap.keySet();
        for (AlgoBase algo : algos) {
            System.debug('##test Start! ' + algo.algoSetting.Name__c + '( ' + algo.algoSetting.Timeframe__c + ')');
            for (String symbol : symbols) {
                algo.current = getCurrentSignalBySymbol(symbol, algo.algoSetting.Timeframe__c);
                algo.last = getLastSignalBySymbol(symbol, algo.algoSetting.Timeframe__c);
                algo.prev = getPreviousSignalBySymbol(symbol, algo.algoSetting.Timeframe__c);
                if (algo.algoSetting.Timeframe__c == algo.current.Timeframe__c) {
                    algo.test();
                }
            }
        }
    }
//    public static Set<String> getSymbols() {
//        Set<String> symbols = new Set<String>();
//        for (Signal__c signal : signals) {
//            symbols.add(signal.Symbol__c);
//        }
//        return symbols;
//    }


    public static Signal__c getPreviousSignalBySymbol(String symbol, Decimal timeframe) {
        return getSignalAtPositionBySymbol(symbol, 2, timeframe);
    }
    public static Signal__c getLastSignalBySymbol(String symbol, Decimal timeframe) {
        return getSignalAtPositionBySymbol(symbol, 1, timeframe);
    }
    public static Signal__c getCurrentSignalBySymbol(String symbol, Decimal timeframe) {
        return getSignalAtPositionBySymbol(symbol, 0, timeframe);
    }
    public static Signal__c getSignalAtPositionBySymbol(String symbol, Integer position, Decimal timeframe) {
        Signal__c[]signals = signalMap.get(symbol);
        if (signals != null && signals.size() > 0) {
            Map<Decimal, Signal__c> signalsIdMap = new Map<Decimal, Signal__c>();

            for (Signal__c signal : signals) {
                if (signal.Timeframe__c == timeframe) {
                    signalsIdMap.put(signal.signal_Id__c, signal);
                }
            }
            List<Decimal> signalIds = new List<Decimal>(signalsIdMap.keySet());
            signalIds.sort();
            Integer index = signalIds.size() - (position + 1);
            if (0 <= index && index < signalIds.size()) {
                return signalsIdMap.get(signalIds[index]);
            }
        }
        return null;

    }
//    public static Signal__c[] getSignalsForSymbol(String symbol) {
//        Signal__c[] signals = new List< Signal__c>();
//        for (Signal__c signal : AlgoBase.signals) {
//            if (signal.Symbol__c == symbol) {
//                signals.add(signal);
//            }
//        }
//        signals.sort();
//        return signals;
//    }

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
//        if (last != null && current != null && prev != null) {
        if (current != null) {
            System.debug('#test buy Start! ' + algoSetting.Name__c + '( ' + algoSetting.Timeframe__c + ')' + current.Symbol__c);
            if (testBuyCatch()) {
                System.debug('new test succeed');
                if ([
                        SELECT Id
                        FROM Trade__c
                        WHERE Status__c = 'open'
                        AND Algo__c = :algoSetting.Name__c
                ].size() < algoSetting.Trade_Count__c) {
                    if ([
                            SELECT Id
                            FROM Trade__c
                            WHERE Symbol__c = :current.Symbol__c AND Status__c = 'open'
                            AND Algo__c = :algoSetting.Name__c
                    ].size() == 0) {

                        insert new Trade__c(Side__c = 'buy', Status__c = 'open',
                                Symbol__c = current.Symbol__c, Type__c = 'market',
                                Signal_Id__c = current.signal_Id__c,
                                Algo__c = algoSetting.Name__c,
                                Take_Profit__c = algoSetting.Take_Profit__c,
                                Stop_Loss__c = algoSetting.Stop_Loss__c,
                                System_Stop_Loss__c = algoSetting.Stop_Loss__c,
                                System_Take_Profit__c = algoSetting.Take_Profit__c,
                                Close_position_based_on_age__c = algoSetting.Close_position_based_on_age__c,
                                Max_age_In_Minutes__c = algoSetting.Max_age_In_Minutes__c,
                                Is_Test__c = algoSetting.Is_Test__c,
                                Bid__c = current.Bid__c,
                                Price__c = current.Bid__c,
                                Trailing_Stop_Loss__c = algoSetting.Trailing_Stop_Loss__c,
                                Trailing_Stop_Loss_Value__c = algoSetting.Trailing_Stop_Loss_Value__c,
                                Quantity__c = 1,
                                Start_At_Change__c = current.Change__c
                        );
                    }
                }
            }
        }
    }

    public Boolean testBuyCatch() {
        try {
            return testBuy();
        } catch (Exception ex) {
            return false;
        }
    }
    public abstract Boolean testBuy();

    public virtual Boolean testSell() {
        return false;
    }
}