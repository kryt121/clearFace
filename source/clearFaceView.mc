import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.System;
using Toybox.Time.Gregorian;

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

        var day=["Su","Mo","Tu","We","Th","Fr","Sa"][date.day_of_week-1];
        var dateString = date.year.format("%4d") + "-" + date.month.format("%02d") + "-" + date.day.format("%02d") + "/" + day ;
        var view_date = View.findDrawableById("Date") as Text;
        view_date.setText(dateString);

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
