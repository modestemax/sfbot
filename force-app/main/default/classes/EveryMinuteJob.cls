public
with sharing class EveryMinuteJob implements Schedulable {

private
  Integer delayInMinutes;
private
  CronTrigger mainJob;

public
  ITask[] tasks;

  // Constructor of Main job
public
  EveryMinuteJob(Integer delayInMinutes, Itask[] tasks) {
    this.delayInMinutes = delayInMinutes;
    this.tasks = tasks;
  }

  // Constructor of worker job
private
  EveryMinuteJob(Integer delayInMinutes, Itask[] tasks, CronTrigger parentJob) {
    this(delayInMinutes, tasks);
    mainJob = parentJob;
  }

public
  void execute(SchedulableContext sc) {
    Id jobId = sc.getTriggerId();
    if (mainJob == null || mainJob.Id == jobId) {
      mainJob = [ SELECT CronJobDetail.Name,
                  NextFireTime FROM CronTrigger WHERE Id =:jobId ];
    } else {
      System.abortJob(jobId);
    }

    Datetime nextWorkerRun = Datetime.now().addMinutes(delayInMinutes);
    if (nextWorkerRun.addMinutes(delayInMinutes) < mainJob.NextFireTime) {
      String cronExp = nextWorkerRun.second() + ' ' + nextWorkerRun.minute() +
                       ' ' + nextWorkerRun.hour() + ' ' + nextWorkerRun.day() +
                       ' ' + nextWorkerRun.month() + ' ? ' +
                       nextWorkerRun.year();
      System.schedule(mainJob.CronJobDetail.Name + ' (worker)', cronExp,
                      new EveryMinuteJob(delayInMinutes, tasks, mainJob));
    }

    try {
      // run action here
      for (Itask task : tasks) {
        task.execute();
      }
    } catch (Exception ex) {
      // log errors here
      System.debug('task exception ' + ex);
    }
  }
}