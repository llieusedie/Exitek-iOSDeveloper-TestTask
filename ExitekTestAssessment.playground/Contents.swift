import UIKit


// MARK: - Task:
// Implement mobile phone storage protocol
// Requirements:
// - Mobiles must be unique (IMEI is an unique number)
// - Mobiles must be stored in memory

protocol MobileStorage {
    func getAll() -> Set<Mobile>
    func findByImei(_ imei: String) -> Mobile?
    func save(_ mobile: Mobile) throws -> Mobile
    func delete(_ product: Mobile) throws
    func exists(_ product: Mobile) -> Bool
}

struct Mobile: Hashable {
let imei: String
let model: String
}

//MARK: - Solution

enum PossibleErrors: Error {
    case IMEINotFound
    case IMEIExist
}

final class Mobiles: MobileStorage {
    private var phones = Set<Mobile>()
    
    
    func getAll() -> Set<Mobile> {
        self.phones
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        return phones.first(where: { $0.imei == imei })
        
    }
    
    func save(_ mobile: Mobile) throws -> Mobile {
        if !exists(mobile) {
            phones.insert(mobile)
            return mobile
        } else {
            throw PossibleErrors.IMEIExist
        }
    }
    
    func delete(_ product: Mobile) throws {
        if exists(product) {
            phones.remove(product)
        } else {
            throw PossibleErrors.IMEINotFound
        }
    }
    
    func exists(_ product: Mobile) -> Bool {
          phones.contains(product)
      }
}

//MARK: - Testing

var storage = Mobiles()
//initialize 2 unique phones
let phone0 = Mobile(imei: "2468", model: "Iphone")
let phone1 = Mobile(imei: "1357", model: "Samsung")

//save both to the memory
try storage.save(phone0)
try storage.save(phone1)

//display everything that's been saved
storage.getAll()

//delete one and display the change afterwards
try storage.delete(phone0)
storage.getAll()

//checks if the actual phone exists
assert((storage.exists(phone0)) == false, "Error, should be false")
assert((storage.exists(phone1)) == true, "Error, should be true")

//finds by imei
storage.findByImei("1357")

//delete and try to find the same device by the imei
try storage.delete(phone1)

//after the deletion, compiler finds nil instead of the phone instance
storage.findByImei("1357")

