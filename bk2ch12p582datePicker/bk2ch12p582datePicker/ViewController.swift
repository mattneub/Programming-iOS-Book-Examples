
import UIKit

extension UIControl {
    func addAction(for event: UIControl.Event,
                   handler: @escaping UIActionHandler) {
        self.addAction(UIAction(handler:handler), for:event)
    }
}


class ViewController: UIViewController {
    @IBOutlet weak var dp: UIDatePicker!
    @IBOutlet weak var dp2: UIDatePicker!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dp2.datePickerMode = .time
        dp2.preferredDatePickerStyle = .inline
        dp2.minuteInterval = 30
        dp2.addAction(for: .valueChanged) { action in
            print((action.sender as! UIDatePicker).date)
        }
        
        var which : Int { return 2 }

        switch which {
        case 1:
            // dp.preferredDatePickerStyle = .inline
            dp.datePickerMode = .date
            // dp.datePickerMode = .dateAndTime
            var dc = DateComponents(year:1954, month:1, day:2)
            let c = Calendar(identifier:.gregorian)
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

    @IBAction func dateChanged(_ sender: Any) {
        let dp = sender as! UIDatePicker
        if dp.datePickerMode != .countDownTimer {
            let d = dp.date
            let df = DateFormatter()
            df.timeStyle = .full
            df.dateStyle = .full
            print(df.string(from: d))
            // Tuesday, August 10, 1954 at 3:16:00 AM GMT-07:00
        } else {
            let t = dp.countDownDuration
            let f = DateComponentsFormatter()
            f.allowedUnits = [.hour, .minute]
            f.unitsStyle = .abbreviated
            if let s = f.string(from: t) {
                print(s) // "1h 12m"
            }

        }

    }


}

