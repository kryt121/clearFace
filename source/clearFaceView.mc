import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.System;
using Toybox.Time.Gregorian;
using Toybox.ActivityMonitor;

class clearFaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get and show the current time
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$ $2$", [clockTime.hour.format("%02d"), clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setText(timeString);

        var view_battery=View.findDrawableById("Battery") as Text;
        var stats = System.getSystemStats();
        // System.println(stats);
        var battery_string = stats.battery.format("%02d");
        view_battery.setText(battery_string + "%");

        var date = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        
        var dateString = date.year.format("%4d") + "-" + date.month.format("%02d") + "-" + date.day.format("%02d")  ;
        var view_date = View.findDrawableById("Date") as Text;
        view_date.setText(dateString);

        var day=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"][date.day_of_week-1];
        var view_day_of_week = View.findDrawableById("DayOfWeek") as Text;
        view_day_of_week.setText(day);
        //tutaj wyswietlimy ile godzin do wypoczynku
        var activity_stats = ActivityMonitor.getInfo();
        var recoveryString=activity_stats.timeToRecovery;
        var floorsString=activity_stats.floorsClimbed;
        var stepsString=activity_stats.steps/1000;
        var view_recovery = View.findDrawableById("Recovery") as Text;
        view_recovery.setText(recoveryString+"H "+floorsString+"F "+stepsString+"kS");
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
