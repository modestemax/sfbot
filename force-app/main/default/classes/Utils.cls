/**
 * Created by max on 11/6/19.
 */

public with sharing class Utils {
    public static Long timeDiffMinutes(Datetime fromTime, Datetime toTime) {
        Long dt1Long = fromTime.getTime();
        Long dt2Long = toTime.getTime();
        Long milliseconds = dt2Long - dt1Long;
        Long seconds = milliseconds / 1000;
        Long minutes = seconds / 60;
        Long hours = minutes / 60;
        Long days = hours / 24;
        return minutes;
    }
    public static Long HourFromNow(Datetime fromTime) {

        Long minutes = timeDiffMinutes(fromTime, Datetime.now());
        Long hours = minutes / 60;
        Long days = hours / 24;
        return hours;
    }
    public static Long minutesFromNow(Datetime fromTime) {
        return timeDiffMinutes(fromTime, Datetime.now());
    }
}