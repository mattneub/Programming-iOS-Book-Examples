//
//  ViewController.swift
//  bk2ch12p582datePicker
//
//  Created by Matt Neuburg on 4/17/15.
//  Copyright (c) 2015 Matt Neuburg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var dp: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let which = 1
        switch which {
        case 1:
            dp.datePickerMode = .Date
            // dp.datePickerMode = .DateAndTime
            let dc = NSDateComponents()
            dc.year = 1954
            dc.month = 1
            dc.day = 1
            let c = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
            let d1 = c.dateFromComponents(dc)!
            dp.minimumDate = d1
            dp.date = d1
            dc.year = 1955
            let d2 = c.dateFromComponents(dc)!
            dp.maximumDate = d2
        case 2:
            dp.datePickerMode = .CountDownTimer
        default: break
        }

    }

    @IBAction func dateChanged(sender: AnyObject) {
        let dp = sender as! UIDatePicker
        if dp.datePickerMode != .CountDownTimer {
            let d = dp.date
            let df = NSDateFormatter()
            df.timeStyle = .FullStyle
            df.dateStyle = .FullStyle
            println(df.stringFromDate(d))
            // Tuesday, August 10, 1954 at 3:16:00 AM GMT-07:00
        } else {
            let t = dp.countDownDuration
            let f = NSDateComponentsFormatter()
            f.allowedUnits = .CalendarUnitHour | .CalendarUnitMinute
            f.unitsStyle = .Abbreviated
            if let s = f.stringFromTimeInterval(t) {
                println(s) // "1h 12m"
            }

        }

    }


}

