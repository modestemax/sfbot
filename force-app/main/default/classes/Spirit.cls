public
with sharing abstract class Spirit extends AlgoBase {
protected
  Decimal current_bbb;
protected
  Decimal last_bbb;
protected
  Decimal prev_bbb;
public
  override void test() {
    current_bbb =
        current.BB_upper__c - (current.BB_upper__c - current.BB_lower__c) / 2;
    last_bbb = last.BB_upper__c - (last.BB_upper__c - last.BB_lower__c) / 2;
    prev_bbb = prev.BB_upper__c - (prev.BB_upper__c - prev.BB_lower__c) / 2;
    super.test();
  }
}