import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.System;
using Toybox.Time.Gregorian;
using Toybox.Time.Gregorian as Date;
using Toybox.ActivityMonitor;
using Toybox.Activity;
using Toybox.Weather;

class clearFaceView extends WatchUi.WatchFace {
    function iso_week_number(year, month, day) {
            var first_day_of_year = julian_day(year, 1, 1);
            var given_day_of_year = julian_day(year, month, day);
            var day_of_week = (first_day_of_year + 3) % 7; 
            var week_of_year = (given_day_of_year - first_day_of_year + day_of_week + 4) / 7;
            if (week_of_year == 53) {
                if (day_of_week == 6) {
                    return week_of_year;
                } else if (day_of_week == 5 && is_leap_year(year)) {
                    return week_of_year;
                } else {
                    return 1;
                }
            }
            else if (week_of_year == 0) {
                first_day_of_year = julian_day(year - 1, 1, 1);
                day_of_week = (first_day_of_year + 3) % 7;
                return (given_day_of_year - first_day_of_year + day_of_week + 4) / 7;
            }
            else {
                return week_of_year;
            }
        }
        
        
        private function julian_day(year, month, day) {
            var a = (14 - month) / 12;
            var y = (year + 4800 - a);
            var m = (month + 12 * a - 3);
            return day + ((153 * m + 2) / 5) + (365 * y) + (y / 4) - (y / 100) + (y / 400) - 32045;
        }
        
        
        function is_leap_year(year) {
            if (year % 4 != 0) {
                return false;
            }	else if (year % 100 != 0) {
                return true;
            }else if (year % 400 == 0) {
            return true;
            }
            return false;
        }



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
        
        var battery_array=[240, 159, 148, 139];
        var battery_str= StringUtil.utf8ArrayToString(battery_array);
        var view_battery=View.findDrawableById("Battery") as Text;
        var stats = System.getSystemStats();
        var battery_string = stats.battery.format("%02d");
        view_battery.setText(battery_str+battery_string + "%");
        //data
        
        
        var now = Time.now();
		//var date_long = Date.info(now, Time.FORMAT_LONG);
        var date = Gregorian.info(now, Time.FORMAT_SHORT);
        var week_num = iso_week_number(date.year, date.month, date.day);
        //var week_num="18";
        var dateString = date.year.format("%4d").substring(2, 4) + "-" + date.month.format("%02d") + "-" + date.day.format("%02d")+" W"+week_num ;
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

        var rec_array=[240, 159, 153, 138];
        var rec_str= StringUtil.utf8ArrayToString(rec_array);
        var floor_array=[240, 159, 151, 188];
        var floor_str= StringUtil.utf8ArrayToString(floor_array);
        var step_array=[240, 159, 145, 163];
        var step_str= StringUtil.utf8ArrayToString(step_array);
        view_recovery.setText(rec_str+recoveryString+"H "+floorsString+floor_str+" "+stepsString+"k"+step_str);
        var view_sun = View.findDrawableById("Sun") as Text;
        var sun_str=("SR ---- SS ----"); 
        //tu ustalamy położenie a następnie czas SR wschodu i SS zachodu słońca
        var cur_pos = Activity.Info.currentLocation;
        //sun_str=position.toString();
        //System.println(cur_pos);
        if (cur_pos == null) {
            cur_pos =  new Position.Location(
            {
                :latitude => 51.25,
                :longitude => 22.57,
                :format => :degrees
            }
            );
        } 
        var up_array=[240, 159, 148, 133];
        var up_str= StringUtil.utf8ArrayToString(up_array);
        var down_array=[240, 159, 140, 153];
        var down_str= StringUtil.utf8ArrayToString(down_array);
        var sunrise_moment = Weather.getSunrise(cur_pos, now);
        var sunrise_date = Gregorian.info(sunrise_moment, Time.FORMAT_MEDIUM);
        var sunrise_str = Lang.format(up_str+"$1$$2$", [sunrise_date.hour.format("%02d"), sunrise_date.min.format("%02d")]);
        
        var sunset_moment = Weather.getSunset(cur_pos, now);
        var sunset_date = Gregorian.info(sunset_moment, Time.FORMAT_MEDIUM);
        var sunset_str = Lang.format(down_str+"$1$$2$", [sunset_date.hour.format("%02d"), sunset_date.min.format("%02d")]);
        
        sun_str=sunrise_str+sunset_str;
        //System.println(sun_str);
        view_sun.setText(sun_str);
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
