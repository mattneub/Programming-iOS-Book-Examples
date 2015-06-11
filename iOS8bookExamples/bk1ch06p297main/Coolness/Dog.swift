

public class Dog {
    public func bark() {
        println ("woof")
    }
    // interestingly, I have to write and declare init explicitly
    // implicit init does not magically carry across the framework boundary
    public init() {}
}