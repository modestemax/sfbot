public with sharing class EveryMinuteJob implements Schedulable {
   static String jobNAme = 'trading view feed';
    private static Integer delayInSeconds=5;
    private CronTrigger mainJob;

    public ITask[] tasks;

    // Constructor of Main job
    public EveryMinuteJob(ITask[] tasks) {
        this.tasks = tasks;
    }

    public void execute(SchedulableContext sc) {
        try {
            // run action here
            for (ITask task : tasks) {
                task.execute();
            }
        } catch (Exception ex) {
            // log errors here
            System.debug('task exception ' + ex);
        } finally {
            startJobs();
        }
    }

    public static void startJobs( ) {

        deleteJob( );
        Datetime nextWorkerRun = Datetime.now().addSeconds(delayInSeconds);
        String cronExp =
                // nextWorkerRun.second()
                nextWorkerRun.second() + ' ' + nextWorkerRun.minute() + ' ' + nextWorkerRun.hour() + ' ' +
                        nextWorkerRun.day() + ' ' + nextWorkerRun.month() + ' ? ' +
                        nextWorkerRun.year();
        System.schedule(jobNAme, cronExp, new EveryMinuteJob( new ITask[]{
                new TradingViewFeed(),
                new CloseYesterdayTrades()
        }));

    }
    public static void deleteJob( ) {
        CronTrigger[] mainJob = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = :jobName];
        if (mainJob.size() != 0) System.abortJob(mainJob[0].Id);
    }
}