

import UIKit

// playing with the new iOS 15 Foundation formatting syntax

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dates
        
        let d = Date.now
        do {
            let s = d.formatted() // abbreviated, no time zone, local
            print(s) // 9/1/2021, 4:02 PM
        }
        do {
            let s = d.formatted(.dateTime.day(.defaultDigits).month(.wide))
            print(s) // September 1 - your order is irrelevant, you are localized
        }
        do {
            let s = d.formatted(.dateTime.timeZone(.identifier(.long)))
            print(s) // America/Los_Angeles
        }
        do {
            // iso8601
            let s = d.formatted(
                .iso8601.dateSeparator(.dash).timeSeparator(.colon)
                    .dateTimeSeparator(.standard).timeZoneSeparator(.colon))
            print(s) // 2021-09-01T23:02:44Z
        }
        do {
            // verbatim means a format string
            // but even then you don't have to know all the ins and outs;
            // uses interpolation! needs a clear type if you declare separately,
            // so that the interpolations work
            let formatString : Date.FormatString = """
            \(day: .defaultDigits) \
            \(month: .wide), \
            \(year: .defaultDigits) at \
            \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .oneBased)):\
            \(minute: .twoDigits) \
            \(timeZone: .localizedGMT(.long))
            """
            let format = Date.VerbatimFormatStyle(format: formatString, locale: .autoupdatingCurrent, timeZone: .autoupdatingCurrent, calendar: .init(identifier:.gregorian))
            let s = d.formatted(format)
            print(s) // 1 September, 2021 at 16:02 GMT-07:00
        }
        
        do { // relative date
            let d2 = d - 1000000 // or whatever
            let s = d2.formatted(.relative(presentation: .named, unitsStyle: .wide))
            print(s) // 2 weeks ago (or whatever)
        }
        
        do { // relative date
            let d2 = d - 1000000 // or whatever
            let s = d2.formatted(.relative(presentation: .numeric, unitsStyle: .narrow))
            print(s) // 2 wk. ago (or whatever)
        }

        // date intervals: you start with a range (I didn't know about this)
        let d2 = d + 100
        let r = d..<d2
        
        do {
            let s = r.formatted()
            print(s) // 9/1/21, 4:02 – 4:04 PM
        }
        
        do {
            let s = r.formatted(.interval)
            print(s) // same, and I am unsure how to format it further
        }
        
        do {
            let s = r.formatted(.timeDuration)
            print(s) // 1:40, minutes and seconds
            // but I am unsure how to format _that_
        }
        
        do {
            // the question is how to do this sort of thing
            // feels like they've left out a lot of functionality
            func secondsToHourMinFormat(time: TimeInterval) -> String? {
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.hour, .minute]
                formatter.zeroFormattingBehavior = .pad
                formatter.unitsStyle = .positional
                return formatter.string(from: time)
            }
            let d = 3680.0
            let s = secondsToHourMinFormat(time: d)
            print(s as Any) // 01:01
            
        }
        
        do { // date components
            let s = r.formatted(.components(style: .narrow, fields: .init([.hour, .minute])))
            print(s) // 1min - limited in ability to format??? seems wrong as it is
            // where are features like includesApproximationPhrase, includesTimeRemainingPhrase ????
        }
                

        do {
            let format = Date.IntervalFormatStyle(date: .omitted, time: .standard, locale: .autoupdatingCurrent, calendar: .init(identifier: .gregorian), timeZone: .autoupdatingCurrent)
            let s = r.formatted(format)
            print(s) // 4:02:44 PM – 4:04:24 PM, cute but not exactly up to me
        }
        
        // numbers, including percent and currency
        
        let pi = Double.pi
        
        do {
            let s = pi.formatted()
            print(s) // 3.141593
        }
        
        do {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            let s = formatter.string(from: pi as NSNumber)
            print(s) // 3.14
        }
        
        do {
            let s = pi.formatted(.number.precision(.fractionLength(2)))
            print(s) // 3.14
        }

        do {
            let s = pi.formatted(.number.precision(.fractionLength(3)))
            print(s) // 3.142
            
        }
        
        do {
            let s = pi.formatted(.number.precision(.fractionLength(3)).rounded(rule: .down))
            print(s) // 3.141
        }
        
        do {
            let s = pi.formatted(.number.precision(.fractionLength(10)).scale(4).sign(strategy: .always()).notation(.scientific))
            print(s) // +1.2566370614E1 :))))
        }

        do {
            let s = 1_000_000.formatted(.number.grouping(.automatic))
            print(s) // 1,000,000 — whereas `.never` means no commas
        }
        
        do {
            let s = 45.formatted(.percent)
            print(s) // 45%
        }

        do {
            let s = 45.formatted(.currency(code: "USD"))
            print(s) // $45.00
        }
        
        // person name components
        
        var comp = PersonNameComponents()
        comp.familyName = "Neuburg"
        comp.givenName = "Matt"
        comp.namePrefix = "Mr."
        do {
            let s = comp.formatted(.name(style: .abbreviated))
            print(s) // MN
        }
        do {
            let s = comp.formatted(.name(style: .short))
            print(s) // Matt
        }
        do {
            let s = comp.formatted(.name(style: .long))
            print(s) // Mr. Matt Neuburg
        }

        // bytes
        // I don't think any law requires UInt64 but it is obviously best
        let b : UInt64 = 1_000_254_221
        do {
            let s = b.formatted(.byteCount(style: .decimal))
            print(s) // 1 GB
        }
        do {
            let s = b.formatted(.byteCount(style: .decimal, allowedUnits: .init([.kb, .mb]), spellsOutZero: true, includesActualByteCount: true))
            print(s) // 1,000.3 MB (1,000,254,221 bytes)
            // hmm, no, it's giving me 1 GB; what happened to allowed units?
        }

        // measurement
        let m = Measurement(value: 4.8765, unit: UnitLength.inches)
        do {
            let s = m.formatted(
                .measurement(
                    width: .wide,
                    usage: .general,
                    numberFormatStyle: .init().precision(.fractionLength(2)).rounded(rule: .awayFromZero, increment: 0.1)))
            print(s) // 4.90 inches
        }
        
        do {
            let m1 = Measurement(value:5, unit: UnitLength.miles)
            let m2 = Measurement(value:6, unit: UnitLength.kilometers)
            let total = m1 + m2
            let mf = MeasurementFormatter()
            let s = mf.string(from:total) // "8.728 mi"
            print(s)
            do {
                let s = total.formatted(.measurement(
                    width: .abbreviated,
                    numberFormatStyle: .number.precision(.fractionLength(1...3))))
                print(s)
            }
        }

        
        // list
        let pep = ["Manny", "Moe", "Jack"]
        do {
            let s = pep.formatted(.list(type: .and, width: .standard))
            print(s) // Manny, Moe, and Jack
        }
        
        // now let's try going the other way; I'll use a date string
        let ds = "Jan 2, 2014"
        do {
            let format : Date.FormatString =
                "\(month: .abbreviated) \(day: .defaultDigits), \(year: .defaultDigits)"
            var strat = Date.ParseStrategy(format: format, timeZone: .current)
            print(strat.format) // can find out what the format string is!
            strat.locale = .current // language needed, obviously!
            if let date = try? Date(ds, strategy: strat) {
                print(date.formatted()) // 1/2/2014, 12:00 AM
            } else {
                print("yeh nah")
            }
        }
        
        // you can also call parse on a format style
        let ds2 = "Jul 2, 2021, 11:30 AM"
        do {
            let style = Date.FormatStyle(date: .abbreviated, time: .shortened)
            // if in doubt, print something out!
            // print(Date.now.formatted(style))
            if let date = try? style.parse(ds2) {
                print(date.formatted()) // 7/2/2021, 11:30 AM
            } else {
                print("oh well")
            }
        }
        
        // one final point; the pieces can be all attributed so you can find them
        do {
            let style = Date.FormatStyle(date: .abbreviated, time: .shortened).attributed
            let attrib = Date.now.formatted(style)
            if let (_,range) = (attrib.runs[\.dateField].filter{$0.0 == .month}.first) {
                print(String(attrib.characters[range])) // Sep
            }
//            if let (_, range) = monthField {
//                print(attrib[range])
//            }
//            for run in attrib.runs {
//                if let what = run.dateField, what == .month {
//                    let r = run.range // so here's where it is
//                    print("month part is", String(attrib.characters[r]))
//                }
//            }
        }
        
        // ===== actual book examples ======
        
        do {
            let s = Date.now.formatted(date:.numeric, time:.omitted)
            // 7/6/2021
            print(s)
        }
        
        do {
            let s = Date.now.formatted(.dateTime.day().month())
            // Jul 6
            print(s)
        }
        
        do {
            let s = Date.now.formatted(Date.VerbatimFormatStyle(
                format: """
                \(month: .defaultDigits)/\(day: .defaultDigits)/\(year: .defaultDigits)
                """,
                locale: .autoupdatingCurrent,
                timeZone: .autoupdatingCurrent,
                calendar: .autoupdatingCurrent))
            // 7/6/2021
            print(s)
        }
        
        do {
            let s = Date.now.formatted(date:.long, time:.complete)
            print(s)
        }
        
        do {
            let s = "7/14/2021"
            let d = try?(Date(s, strategy: Date.ParseStrategy(
                format: """
                \(month: .defaultDigits)/\(day: .defaultDigits)/\(year: .defaultDigits)
                """,
                timeZone: .autoupdatingCurrent,
                isLenient: false)))
            if let d = d {
                print("yep", d)
            } else {
                print("nope")
            }
        }
        
        do {
            let formatString : Date.FormatString = """
                \(month: .defaultDigits)/\(day: .defaultDigits)/\(year: .defaultDigits)
                """
            let strategy = Date.ParseStrategy(format: formatString, timeZone: .current)
            print(strategy.format)
        }
    }


}

