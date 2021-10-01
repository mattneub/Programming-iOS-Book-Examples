
import Foundation

class Server {
    private init() {}
    static let shared = Server.init()
    private static let serverQueue = DispatchQueue.global(qos: .background)
    func getListOfNumbers(from:Int, to:Int, completion: @escaping (Range<Int>) -> Void) {
        let delay = Int.random(in: 1..<4)
        Self.serverQueue.asyncAfter(deadline: .now() + .seconds(delay)) {
            completion(from..<to)
        }
    }
    func doubleThisNumber(_ i: Int, completion: @escaping (Int) -> Void) {
        let delay = Int.random(in: 1..<10)
        Self.serverQueue.asyncAfter(deadline: .now() + .seconds(delay)) {
            completion(2*i)
        }
    }
}

