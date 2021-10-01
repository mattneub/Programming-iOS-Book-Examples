

import UIKit
import Combine
import Contacts

class ViewController: UIViewController {
    func checkAccess() -> Result<Bool, Error> {
        Result<Bool, Error> {
            let status = CNContactStore.authorizationStatus(for:.contacts)
            switch status {
            case .authorized: return true
            case .notDetermined: return false
            default:
                enum NoPoint : Error { case userRefusedAuthorization }
                throw NoPoint.userRefusedAuthorization
            }
        }
    }
    func requestAccessFuture() -> Future<Bool, Error> {
        Future<Bool, Error> { promise in
            CNContactStore().requestAccess(for:.contacts) { ok, err in
                if err != nil {
                    promise(.failure(err!))
                } else {
                    promise(.success(ok)) // will be true
                }
            }
        }
    }
    func getMyEmailAddresses() -> Result<[CNLabeledValue<NSString>], Error> {
        Result<[CNLabeledValue<NSString>], Error> {
            let pred = CNContact.predicateForContacts(matchingName:"John Appleseed")
            let jas = try CNContactStore().unifiedContacts(matching:pred, keysToFetch: [
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactEmailAddressesKey as CNKeyDescriptor
            ])
            guard let ja = jas.first else {
                enum NotFound : Error { case oops }
                throw NotFound.oops
            }
            return ja.emailAddresses
        }
    }
    var storage = Set<AnyCancellable>()
    lazy var authorizationPublisher = {
        self.checkAccess().publisher
            .flatMap { (gotAccess:Bool) -> AnyPublisher<Bool, Error> in
                if gotAccess {
                    let just = Just(true).setFailureType(to:Error.self).eraseToAnyPublisher()
                    return just
                } else {
                    let req = self.requestAccessFuture().eraseToAnyPublisher()
                    return req
                }
            }
    }()
    @IBAction func giveItAGo(_ sender:Any) {
        self.authorizationPublisher
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .compactMap { (auth:Bool) -> Result<[CNLabeledValue<NSString>], Error>? in
                if auth {
                    return self.getMyEmailAddresses()
                }
                return nil
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(err) = completion {
                    print("error:", err)
                }
            }, receiveValue: { result in
                if case let .success(emails) = result {
                    print("got emails:", emails)
                }
            })
            .store(in: &self.storage)
    }
}

