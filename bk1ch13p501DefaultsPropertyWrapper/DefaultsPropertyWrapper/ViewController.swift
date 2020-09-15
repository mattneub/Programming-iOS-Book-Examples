

import UIKit

/*
 It is nice to have a generalized property wrapper for setting and fetching
 user defaults.
 In particular, we'd like to avoid repetition of the dance where you
 encode to data to save, and fetch by fetching the data and decoding.
 However, not every value is directly encodable; for instance, you can't
 encode a simple String.
 Therefore we interpose a generic wrapper object.
 See https://stackoverflow.com/a/59475086/341994
 */

@propertyWrapper
struct Default<T: Codable> {
    private struct Wrapper<T> : Codable where T : Codable {
        let wrapped : T
    }
    let key: String
    let defaultValue: T
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data
                else { return defaultValue }
            let value = try? PropertyListDecoder().decode(Wrapper<T>.self, from: data)
            return value?.wrapped ?? defaultValue
        }
        set {
            do {
                let data = try PropertyListEncoder().encode(Wrapper(wrapped:newValue))
                UserDefaults.standard.set(data, forKey: key)
            } catch {
                print(error)
            }
        }
    }
}

struct Defaults {
    @Default(key: "userIsSignedIn", defaultValue: false)
    static var isSignedIn: Bool
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // launch twice to test
        print(Defaults.isSignedIn)
        Defaults.isSignedIn = true
    }


}

