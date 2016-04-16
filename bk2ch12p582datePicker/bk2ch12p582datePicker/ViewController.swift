
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var dp: UIDatePicker!

    
    let which = 2

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        switch which {
        case 1:
            dp.datePickerMode = .date
            // dp.datePickerMode = .DateAndTime
            let dc = NSDateComponents()
            dc.year = 1954
            dc.month = 1
            dc.day = 1
            let c = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
            let d1 = c.date(from: dc)!
            dp.minimumDate = d1
            dp.date = d1
            dc.year = 1955
            let d2 = c.date(from: dc)!
            dp.maximumDate = d2
        case 2:
            dp.datePickerMode = .countDownTimer
        default: break
        }

    }

    @IBAction func dateChanged(_ sender: AnyObject) {
        let dp = sender as! UIDatePicker
        if dp.datePickerMode != .countDownTimer {
            let d = dp.date
            let df = NSDateFormatter()
            df.timeStyle = .fullStyle
            df.dateStyle = .fullStyle
            print(df.string(from: d))
            // Tuesday, August 10, 1954 at 3:16:00 AM GMT-07:00
        } else {
            let t = dp.countDownDuration
            let f = NSDateComponentsFormatter()
            f.allowedUnits = [.hour, .minute]
            f.unitsStyle = .abbreviated
            if let s = f.string(from: t) {
                print(s) // "1h 12m"
            }

        }

    }


}

