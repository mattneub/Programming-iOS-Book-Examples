
import UIKit
import Combine

func makeGetListFuture() -> AnyPublisher<Range<Int>,Never> {
    Deferred {
        Future<Range<Int>,Never> { promise in
            Server.shared.getListOfNumbers(from: 1, to: 10) {
                promise(.success($0))
            }
        }
    }.eraseToAnyPublisher()
}
func makeDoubleThisFuture(for i:Int) -> AnyPublisher<Int,Never> {
    Deferred {
        Future<Int,Never> { promise in
            Server.shared.doubleThisNumber(i) {
                promise(.success($0))
            }
        }
    }.eraseToAnyPublisher()
}


class ViewController: UIViewController {
    
    let server = Server.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    


    @IBAction func doButton(_ sender: Any) {
        // array comes back immediately, empty
        self.server.getListOfNumbers(from: 1, to: 10) { result in
            print(result)
            var arr = [Int]()
            for i in result {
                self.server.doubleThisNumber(i) { result2 in
                    print(result2)
                    arr.append(result2)
                }
            }
            DispatchQueue.main.async {
                print(arr)
            }
        }
    }
    
    @IBAction func doButton2(_ sender: Any) {
        // array comes back at end, numbers are in random order
        let group = DispatchGroup()
        self.server.getListOfNumbers(from: 1, to: 10) { result in
            print(result)
            var arr = [Int]()
            for i in result {
                group.enter()
                self.server.doubleThisNumber(i) { result2 in
                    print(result2)
                    arr.append(result2)
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                print(arr)
            }
        }
    }
    @IBAction func doButton3(_ sender: Any) {
        // array comes back at end, numbers are in correct order (takes longer, of course)
        let group = DispatchGroup()
        self.server.getListOfNumbers(from: 1, to: 10) { result in
            print(result)
            var arr = [Int]()
            for i in result {
                group.enter()
                self.server.doubleThisNumber(i) { result2 in
                    print(result2)
                    arr.append(result2)
                    group.leave()
                }
                group.wait() // *
            }
            group.notify(queue: .main) {
                print(arr)
            }
        }
    }
    var storage = Set<AnyCancellable>()
    let subject = PassthroughSubject<Void,Never>()
    @IBAction func doButton4(_ sender: Any) {
        // array comes back at end, numbers are in random order
        // so this is the equivalent of the standard DispatchGroup looping pattern!
        self.storage.removeAll()
        subject
            .flatMap { () -> AnyPublisher<Range<Int>,Never> in
                makeGetListFuture()
            }
            .print()
            .flatMap { (r:Range<Int>) -> AnyPublisher<Int,Never> in
                Publishers.Sequence(sequence: r).eraseToAnyPublisher()
            }
            .flatMap { (i:Int) -> AnyPublisher<Int,Never> in
                makeDoubleThisFuture(for:i)
            }
            .print()
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { print($0) }
            .store(in:&storage)
        subject.send()
        subject.send(completion: .finished) // otherwise `collect` never knows when to happen
    }
    @IBAction func doButton5(_ sender: Any) {
        // array comes back at end, numbers are in correct order
        // so this is the equivalent of the standard DispatchGroup+wait looping pattern!
        self.storage.removeAll()
        subject
            .flatMap { () -> AnyPublisher<Range<Int>,Never> in
                makeGetListFuture()
            }
            .print()
            .flatMap { (r:Range<Int>) -> AnyPublisher<Int,Never> in
                Publishers.Sequence(sequence: r).eraseToAnyPublisher()
            }
            // this next line is the only change from the previous example
            .flatMap(maxPublishers:.max(1)) { (i:Int) -> AnyPublisher<Int,Never> in
                makeDoubleThisFuture(for:i)
            }
            .print()
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { print($0) }
            .store(in:&storage)
        subject.send()
        subject.send(completion: .finished) // otherwise `collect` never knows when to happen
    }
    // ======
    @IBAction func doButton3b(_ sender: Any) {
        // return results in order _without_ serializing the looped async calls
        // how? use index to keep track of which value goes where
        let group = DispatchGroup()
        self.server.getListOfNumbers(from: 1, to: 10) { result in
            print(result)
            var pairs = [(offset:Int, element:Int)]()
            for pair in result.enumerated() {
                group.enter()
                self.server.doubleThisNumber(pair.element) { result2 in
                    print(result2)
                    pairs.append((offset:pair.offset, element:result2))
                    group.leave()
                }
            }
            group.wait()
            print("here")
            // sort the pairs by index and extract the values!
            let arr = pairs.sorted { $0.offset < $1.offset }.map {$0.element}
            group.notify(queue: .main) {
                print(arr)
            }
        }
    }
    @IBAction func doButton5b(_ sender: Any) {
        // equivalent of previous
        self.storage.removeAll()
        subject
            .flatMap { () -> AnyPublisher<Range<Int>,Never> in
                makeGetListFuture()
            }
            .print()
            .flatMap { (r:Range<Int>) -> AnyPublisher<(offset:Int, element:Int),Never> in
                Publishers.Sequence(sequence: r.enumerated())
                    .eraseToAnyPublisher()
            }
            .print()
            .flatMap { (pair:(offset:Int, element:Int)) -> AnyPublisher<(Int,Int),Never> in
                makeDoubleThisFuture(for:pair.element)
                    .map { i in (pair.offset,i)}
                    .eraseToAnyPublisher()
            }
            .print()
            .collect()
            .map { (arr:[(offset:Int,element:Int)]) -> [Int] in
                arr.sorted { $0.offset < $1.offset }.map { $0.element }
            }
            .receive(on: DispatchQueue.main)
            .sink { print($0) }
            .store(in:&storage)
        subject.send()
        subject.send(completion: .finished) // otherwise `collect` never knows when to happen
    }

}

