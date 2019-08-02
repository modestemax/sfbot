public
with sharing class TradingViewFeed implements ITask {
  string exchangeId = 'binance';
  string filter = 'btc$';
  integer timeframe;
public
  TradingViewFeed(integer timeframe) {
    if (timeframe == null)
      this.timeframe = 60 * 24;
    this.timeframe = timeframe;
  }
public
  string getBody() {
    String timeframeFilter;
    if (timeframe == null || timeframe == 60 * 24) {
      timeframeFilter = '';
    } else if (timeframe == 60 * 24 * 7) {
      timeframeFilter = '|1W';
    } else {
      timeframeFilter = '|' + timeframe;
    }
    String body =
        '{' + '"filter": [' + '{ "left": "change"' + timeframeFilter +
        ', "operation": "nempty" },' +
        '{ "left": "exchange", "operation": "equal", "right":"' +
        exchangeId.toUpperCase() + '" },' +
        '{ "left": "name,description", "operation": "match", "right":"' +
        filter + '" }' + '],' + '"symbols": { "query": { "types": [] } },' +
        '"columns":' + getColumns(timeframeFilter) + ',' +
        '"sort": { "sortBy": "change"' + timeframeFilter +
        ', "sortOrder": "desc" },' + '"options": { "lang": "en" },' +
        '"range": [0, 150]' + '}';
    System.debug('body in ' + body);
    return body;
  }
public
  string[] getColumns2() {
    String[] columns2 = new String[]{
        'close', 'change', 'high', 'low', 'ADX', 'ADX-DI', 'ADX+DI', 'RSI',
        'EMA10', 'EMA20', 'MACD.macd', 'MACD.signal', 'open',
        'change_from_open', 'Mom',
        // 'Aroon.Up', 'Aroon.Down',  'Recommend.All','volume', 'VWMA',
        //'Stoch.K', 'Stoch.D', 'Stoch.RSI.K', 'Stoch.RSI.D',
        'BB.lower', 'BB.upper', 'EMA200', 'EMA50', 'EMA100', 'EMA30'};
    return columns2;
  }
public
  string[] getColumns1() {
    String[] columns1 = new String[]{
        'name', 'bid', 'ask' //,  'exchange', 'description', 'Volatility.D'
    };
    return columns1;
  }
public
  string getColumns(String timeframeFilter) {
    String sColumns ='';

    for (string col : getColumns1()) {
      sColumns += '"' + col + '",';
    }
    for (string col : getColumns2()) {
      sColumns += '"' + col + '"' + timeframeFilter + ',';
    }
    sColumns = '[' + sColumns.substringBeforeLast(',') + ']';
    System.debug('comlums ' + sColumns);

    return sColumns;
  }
public
  void execute() {
    System.debug('tv feed');

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://scanner.tradingview.com/crypto/scan');
    request.setMethod('POST');

    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    // Set the body as a JSON object
    request.setBody(getBody());
    HttpResponse response = http.send(request);
    // Parse the JSON response
    System.debug('The status code returned was not expected: ' +
                 response.getStatusCode() + ' ' + response.getStatus());

    if (response.getStatusCode() == 200) {
      updateSignals(response.getBody());
    } else {
      System.debug('trading view error ' + response.getBody());
    }
  }

private
  void updateSignals(String json) {
    TradingViewResult result = TradingViewResult.parse(json);
    signal__c[] signals = new signal__c[]{};
    for (TradingViewResult.Data data : result.data) {

      String[] cols = getColumns1();
      cols.addAll(getColumns2());
      Integer i = 0;
      signal__c s = new signal__c(Timeframe__c = timeframe);
      for (String col : cols) {
        System.debug('result ' + col + ' = ' + data.d[i]);
        string colApi = col;
        switch
          on col {
            when 'name' { s.put('symbol__c', (String)data.d[i]); }
            when else {
              switch
                on col {
                  when 'ADX-DI' { colApi = 'ADX_MINUS_DI'; }
                  when 'ADX+DI' { colApi = 'ADX_PLUS_DI'; }
                  when else {
                    colApi = col.replaceAll('[-+.]', '_');
                  }
                }
              if (data.d[i] != null)
                s.put(colApi + '__c', Decimal.valueOf((String)data.d[i]));
            }
          }

        i++;
      }
      signals.add(s);
    }
    insert signals;
  }
}
