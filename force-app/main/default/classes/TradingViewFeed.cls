public with sharing class TradingViewFeed implements ITask {
    static String exchangeId = 'binance';
//    static String filter = 'btc$';
//    static String filter = '^((GTOBTC)|(FTMBTC)|(MTHBTC)|(OSTBTC)|(YOYOBTC)|(CHZBTC)|(QSPBTC)|(SNMBTC)|(REQBTC)|(CMTBTC)|(QLCBTC)|(VITEBTC)|(DATABTC)|(POABTC)|(VIBEBTC)|(SNTBTC)|(GOBTC)|(MATICBTC)|(ARPABTC)|(TRXBTC)|(AMBBTC)|(NKNBTC)|(ASTBTC)|(VIBBTC)|(AGIBTC)|(LOOMBTC)|(BLZBTC)|(BCPTBTC)|(POLYBTC)|(BTSBTC)|(RVNBTC)|(LENDBTC)|(CVCBTC)|(LRCBTC)|(SYSBTC)|(PERLBTC)|(DUSKBTC)|(FETBTC)|(BQXBTC)|(APPCBTC)|(DLTBTC)|(HBARBTC)|(MANABTC)|(ADABTC)|(TNTBTC)|(RENBTC)|(ARDRBTC)|(XEMBTC)|(LTOBTC)|(RCNBTC)|(OAXBTC)|(GNTBTC)|(XLMBTC)|(WRXBTC)|(POWRBTC)|(CTXCBTC)|(ADXBTC)|(NAVBTC)|(AIONBTC)|(ENJBTC)|(THETABTC)|(ELFBTC)|(ARNBTC)|(STXBTC)|(WABIBTC)|(RDNBTC)|(STORJBTC)|(ONGBTC)|(INSBTC)|(AEBTC)|(EDOBTC)|(GRSBTC)|(STEEMBTC)|(NXSBTC)|(VIABTC)|(ARKBTC)|(BRDBTC)|(WANBTC)|(BATBTC)|(IOTABTC)|(XRPBTC)|(ZRXBTC)|(BANDBTC)|(BNTBTC)|(OGNBTC)|(NULSBTC)|(ALGOBTC)|(EVXBTC)|(ICXBTC)|(MTLBTC)|(PIVXBTC)|(STRATBTC)|(KNCBTC)|(PPTBTC)|(ENGBTC)|(TOMOBTC)|(GXSBTC)|(NASBTC)|(WTCBTC)|(RLCBTC)|(SKYBTC)|(MDABTC)|(BEAMBTC)|(KMDBTC)|(NEBLBTC)|(BCDBTC)|(ONTBTC)|(KAVABTC)|(NANOBTC)|(LUNBTC)|(OMGBTC)|(WAVESBTC)|(GVTBTC)|(LSKBTC)|(HCBTC))';
    static String filter = '^((MTHBTC)|(OSTBTC)|(YOYOBTC)|(CHZBTC)|(QSPBTC)|(SNMBTC)|(REQBTC)|(CMTBTC)|(QLCBTC)|(VITEBTC)|(DATABTC)|(POABTC)|(VIBEBTC)|(SNTBTC)|(GOBTC)|(MATICBTC)|(ARPABTC)|(TRXBTC)|(AMBBTC)|(NKNBTC)|(ASTBTC)|(VIBBTC)|(AGIBTC)|(LOOMBTC)|(BLZBTC)|(BCPTBTC)|(POLYBTC)|(BTSBTC)|(RVNBTC)|(LENDBTC)|(CVCBTC)|(LRCBTC)|(SYSBTC)|(PERLBTC)|(DUSKBTC)|(FETBTC)|(BQXBTC)|(APPCBTC)|(DLTBTC)|(HBARBTC)|(MANABTC)|(ADABTC)|(TNTBTC)|(RENBTC)|(ARDRBTC)|(XEMBTC)|(LTOBTC)|(RCNBTC)|(OAXBTC)|(GNTBTC)|(XLMBTC)|(WRXBTC)|(POWRBTC)|(CTXCBTC)|(ADXBTC)|(NAVBTC)|(AIONBTC)|(ENJBTC)|(THETABTC)|(ELFBTC)|(ARNBTC)|(STXBTC)|(WABIBTC)|(RDNBTC)|(STORJBTC)|(ONGBTC)|(INSBTC)|(AEBTC)|(EDOBTC)|(GRSBTC)|(STEEMBTC)|(NXSBTC)|(VIABTC)|(ARKBTC)|(BRDBTC)|(WANBTC)|(BATBTC)|(IOTABTC)|(XRPBTC)|(ZRXBTC)|(BANDBTC)|(BNTBTC)|(OGNBTC)|(NULSBTC)|(ALGOBTC)|(EVXBTC)|(ICXBTC)|(MTLBTC)|(PIVXBTC)|(STRATBTC)|(KNCBTC)|(PPTBTC)|(ENGBTC)|(TOMOBTC)|(GXSBTC)|(NASBTC)|(WTCBTC)|(RLCBTC)|(SKYBTC)|(MDABTC)|(BEAMBTC)|(KMDBTC)|(NEBLBTC)|(BCDBTC)|(ONTBTC)|(KAVABTC)|(NANOBTC)|(LUNBTC)|(OMGBTC)|(WAVESBTC)|(GVTBTC)|(LSKBTC)|(HCBTC))';
    static Set<Integer> timeframes = new Set<Integer>();

    static void initTimeframes() {
        for (Algo_Setting__mdt setting : [SELECT Timeframe__c FROM Algo_Setting__mdt WHERE Is_active__c = TRUE]) {
            timeframes.add((Integer) setting.Timeframe__c);
        }
        System.debug('#timeframes ' + timeframes);
    }

    static String getRequestBody(Integer timeframe) {
        String timeframeFilter;
        if (timeframe == null || timeframe == 60 * 24) {
            timeframeFilter = '';
        } else if (timeframe == 60 * 24 * 7) {
            timeframeFilter = '|1W';
        } else {
            timeframeFilter = '|' + timeframe;
        }
        String body = '{' + '"filter": [' +
                '{ "left": "change' + timeframeFilter + '", "operation": "nempty" }' +
                ',{ "left": "exchange", "operation": "equal", "right":"' + exchangeId.toUpperCase() + '" }' +
                ',{ "left": "name,description", "operation": "match", "right":"' + filter + '" }' +
//                ',{"left":"change_abs","operation":"greater","right":1e-7}' +
                '],' +
                '"symbols": { "query": { "types": [] } },' +
                '"columns":' + getColumnsAsJSON(timeframeFilter) + ',' +
                '"sort": { "sortBy": "change' + timeframeFilter + '", ' +
                '"sortOrder": "desc" },' + '"options": { "lang": "en" },' +
                '"range": [0, 200]'
                + '}';
        // System.debug('body in ' + body);
        return body;
    }

    static String[] getTimeframeDependentColumns() {
        return new String[]{
                'close', 'change', 'change_abs', 'high', 'low', 'ADX', 'ADX-DI', 'ADX+DI', 'RSI',
                'EMA10', 'EMA20', 'MACD.macd', 'MACD.signal', 'open',
                'change_from_open', 'Mom',
                // 'Aroon.Up', 'Aroon.Down',  'Recommend.All','volume', 'VWMA',
                //'Stoch.K', 'Stoch.D', 'Stoch.RSI.K', 'Stoch.RSI.D',
                'BB.lower', 'BB.upper', 'EMA200', 'EMA50', 'EMA100', 'EMA30'
        };
    }

    static String[] getStaticColumns() {
        return new String[]{
                'name', 'bid', 'ask' //,  'exchange', 'description', 'Volatility.D'
        };
    }

    static String getColumnsAsJSON(String timeframeFilter) {
        String[] columns = getStaticColumns();

        for (String col : getTimeframeDependentColumns()) {
            columns.add(col + timeframeFilter);
        }
        // System.debug('comlums ' + columns);
        return JSON.serialize(columns);
    }

    @Future(Callout = true)
    static void callOut(Integer timeframe) {
        System.debug('##tv feed TF=' + timeframe);
        if (timeframe == null)
            timeframe = 60 * 24;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://scanner.tradingview.com/crypto/scan');
        request.setMethod('POST');

        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        request.setBody(getRequestBody(timeframe));
        HttpResponse response = http.send(request);
        // System.debug('The status code returned was : ' + response.getStatusCode()
        // + ' ' + response.getStatus());

        if (response.getStatusCode() == 200) {
            updateSignals(timeframe, response.getBody());
        } else {
            System.debug('trading view error ' + response.getBody());
        }
    }
    static Long timeframeDuration(Integer timeframe) {
        return timeframe * 60 * 1000L;
    }

    static Long getSignalId(Integer timeframe) {
        Datetime dt = Datetime.now();
        Long ctime = dt.getTime();
        return ctime / timeframeDuration(timeframe);
    }
    static Datetime getSignalTime(Long id, Integer timeframe) {
        return Datetime.newInstance(id * timeframeDuration(timeframe));
    }

    static void updateSignals(Integer timeframe, String json) {
        TradingViewResult result = TradingViewResult.parse(json);
        Signal__c[] signals = new Signal__c[]{
        };
        Long signalId = getSignalId(timeframe);
        Datetime signalTime = getSignalTime(signalId, timeframe);

        Integer rank = 0;
        for (TradingViewResult.Data data : result.data) {
            String[] cols = getStaticColumns();
            cols.addAll(getTimeframeDependentColumns());
            Integer i = 0;
            String name = data.s + ':' + signalId;

            Signal__c signal = new Signal__c(Name = name, Time__c = signalTime, Timeframe__c = timeframe, rank__c = ++rank);
            for (String col : cols) {
                // System.debug('result ' + col + ' = ' + data.d[i]);
                String colApi = col;
                switch
                on col {
                    when 'name' {
                        signal.put('symbol__c', (String) data.d[i]);
                    }
                    when else {
                        switch
                        on col {
                            when 'ADX-DI' {
                                colApi = 'ADX_MINUS_DI';
                            }
                            when 'ADX+DI' {
                                colApi = 'ADX_PLUS_DI';
                            }
                            when else {
                                colApi = col.replaceAll('[-+.]', '_');
                            }
                        }
                        if (data.d[i] != null) {
                            signal.put(colApi + '__c', Decimal.valueOf((String) data.d[i]));
                        }
                    }
                }
                i++;
            }
            signals.add(signal);
        }
        signals.sort();
        // insert signals;
        insertOrUpdate(signals);
    }

    static void insertOrUpdate(Signal__c[] signals) {
        Map<String, Signal__c> newMap = new Map<String, Signal__c>();
        for (Signal__c signal : signals) {
            System.debug('new signal ' + signal.Name);
            newMap.put(signal.Name, signal);
        }

        for (Signal__c old : [SELECT Name FROM Signal__c WHERE Name IN :newMap.keySet()]) {
            Signal__c signal = newMap.get(old.Name);
            if (signal != null) {
                System.debug('update signal ' + signal.Name);
                signal.Id = old.Id;
            }
        }
        upsert newMap.values();
    }

    public static void execute() {
        initTimeframes();
        for (Integer timeframe : timeframes) {
            callOut(timeframe);
        }
    }
    public static void execute(Integer timeframe) {
        callOut(timeframe);
    }
}