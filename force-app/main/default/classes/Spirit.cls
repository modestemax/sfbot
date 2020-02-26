public
with sharing abstract class Spirit extends AlgoBase {
    protected Decimal current_bbb;
    protected Decimal last_bbb;
    protected Decimal prev_bbb;
    public override void test() {
        current_bbb =
                current.bb_upper__c - (current.bb_upper__c - current.bb_lower__c) / 2;
        last_bbb = last.bb_upper__c - (last.bb_upper__c - last.bb_lower__c) / 2;
        prev_bbb = prev.bb_upper__c - (prev.bb_upper__c - prev.bb_lower__c) / 2;
        super.test();
    }
}