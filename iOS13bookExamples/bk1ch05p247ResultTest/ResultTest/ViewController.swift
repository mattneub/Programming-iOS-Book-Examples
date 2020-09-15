

import UIKit

// let's study Swift 5's new Result type
// its purpose is to allow a result, either success or failure,
// to be "returned" from an asynchronous operation

// problem with async is that you cannot throw
// (simply put, this is because there is no one "there" to catch at throwing time)

// so instead we propose to call the completion handler
// with something that can contain an Error in case of failure...
// and thus the error is carried "back" to the caller coherently


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // the problem
    func doSomeNetworking(completion:@escaping (Data) -> ()) {
        URLSession.shared.dataTask(with: URL(string:"https://www.apple.com")!) { data, _, err in
            if let data = data {
                completion(data)
            }
            // great, but what if there's an error?
            if let err = err {
                // throw err // illegal
                // Invalid conversion from throwing function ... to non-throwing function type
                // and of course we cannot magically turn it into a throwing function...
                // because the type of the completion handler of `dataTask(with:)` is not up to us
                _ = err
            }
        }.resume()
    }
    
    // the old solution
    func doSomeNetworkingNOT(completion:@escaping (Data?, Error?) -> ()) {
        URLSession.shared.dataTask(with: URL(string:"https://www.apple.com")!) { data, _, err in
            completion(data, err)
        }.resume()
    }

    
    // the solution: the form of the completion handler _is_ up to us, so...
    func doSomeNetworking2(completion:@escaping (Result<Data,Error>) -> ()) {
        URLSession.shared.dataTask(with: URL(string:"https://www.apple.com")!) { data, resp, err in
            if let data = data {
                completion(.success(data))
            }
            if let err = err {
                completion(.failure(err))
            }
        }.resume()
    }
    
    // a better way to write this is to take advantage of the fact
    // that a `let` can be initialized in a subsequent line
    func doSomeNetworking3(completion:@escaping (Result<Data,Error>) -> ()) {
        URLSession.shared.dataTask(with: URL(string:"https://www.apple.com")!) { data, _, err in
            let result : Result<Data,Error>
            if let data = data {
                result = .success(data)
            }
            else if let err = err {
                result = .failure(err)
            } else {
                fatalError("something incomprehensible happened") // shut the compiler up
            }
            completion(result)
        }.resume()
    }
    
    // but there is an even cooler way: we can just write the whole thing out
    // as a throwing expression and stuff it into the Result!
    func doSomeNetworking4(completion:@escaping (Result<Data,Error>) -> ()) {
        URLSession.shared.dataTask(with: URL(string:"https://www.apple.com")!) { data, _, err in
            let result = Result<Data,Error> {
                if let err = err {
                    throw err
                }
                return data!
            }
            completion(result)
        }.resume()
    }

    // now then: how would you _call_ doSomeNetworking?
    func callDoSomeNetworking() {
        self.doSomeNetworking3 { result in
            // great, but how do we "open" the Result package and see what's inside?
            // well, we _could_ use a switch
            switch result {
            case .success(let data):
                print("success")
                // do something with the data
                _ = data
            case .failure(let err):
                print(err)
            }
            
            // however, there's a way cooler way: call `get`
            do {
                let data = try result.get()
                print("success")
                // do something with the data
                _ = data
            } catch {
                print(error)
            }
        }
    }

    
    // a variant: we can transform the error we receive to an error type of our own devising
    // (can do the same thing for the success type)
    enum MyError : Error {
        case somethingWentWrong(String)
    }
    func doSomeNetworking5(completion:@escaping (Result<Data,MyError>) -> ()) {
        URLSession.shared.dataTask(with: URL(string:"https://www.apple.com")!) { data, resp, err in
            let result : Result<Data,Error>
            if let data = data {
                result = .success(data)
            }
            else if let err = err {
                result = .failure(err)
            } else {
                fatalError("something incomprehensible happened")
            }
            // turn our Result<Data,Error> into a Result<Data,MyError>
            // this will only matter if there is a failure, but we are agnostic about that
            let transformedResult = result.mapError { err in
                return MyError.somethingWentWrong(err.localizedDescription)
            }
            completion(transformedResult)
        }.resume()
    }

    // or we can use `Result(catching:)` as in example 4
    // mapping is in fact the _only_ way to use `Result(catching)` to form a result...
    // ...with an error type other than Error
    func doSomeNetworking6(completion:@escaping (Result<Data,MyError>) -> ()) {
        URLSession.shared.dataTask(with: URL(string:"https://www.apple.com")!) { data, resp, err in
            let result = Result<Data,Error> {
                if let err = err {
                    throw err
                }
                return data!
            }
            let transformedResult = result.mapError { err in
                return MyError.somethingWentWrong(err.localizedDescription)
            }
            completion(transformedResult)
        }.resume()
    }


}

