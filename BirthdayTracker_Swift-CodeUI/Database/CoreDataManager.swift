import CoreData
import UIKit.UIApplication

enum CoreDataError: Error {
    case error(String)
}

final class CoreDataManager {
    
    static let instance = CoreDataManager()
    private init() { }
    
    func saveBirthday(birthdaydto: BirthdayDTO) -> Result<Void, CoreDataError> {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return .failure(.error("AppDelegate not found"))
        }
        
        let manageContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Birthday", in: manageContext)!
        let birthday = NSManagedObject(entity: entity, insertInto: manageContext)
        
        birthday.setValue(birthdaydto.name, forKey: "name")
        birthday.setValue(birthdaydto.surname, forKey: "surname")
        birthday.setValue(birthdaydto.birthdayDate, forKey: "birthdayDate")
        
        do {
            try manageContext.save()
        } catch {
            return .failure(.error("Could not save. \(error)"))
        }
        
        return .success(())
    }
    
    func getBirthdays() -> Result<[Birthday], CoreDataError> {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return .failure(.error("AppDelegate not found"))
        }
        
        let manageContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Birthday")

        let birthdays: [Birthday]
        
        do {
            let objects = try manageContext.fetch(fetchRequest)
            guard let fetchedBirthday = objects as? [Birthday] else {
                return .failure(.error("Could not cast as [Birthday]"))
            }
            birthdays = fetchedBirthday
        } catch {
            return .failure(.error("Could not fetch \(error)"))
        }
        
        return .success(birthdays)
    }
}
