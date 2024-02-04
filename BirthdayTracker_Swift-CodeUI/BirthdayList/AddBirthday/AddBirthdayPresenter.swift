import Foundation

protocol AddBirthdayPresenter: AnyObject {
    func saveBirthdayButtonTapped(_ birthdays: BirthdayDTO)
    func timeIntervalUntilBirthday(_ birthdayDate: Date) -> TimeInterval?
}

final class DefaultAddBirthdayPresenter {
    
    // MARK: - Public properties
    unowned let view: AddBirthdayView
    var closeAddBirthdayScreen: (() -> Void)?
    
    init(view: AddBirthdayView) {
        self.view = view
    }
}

// MARK: - AddBirthdayPresenter
extension DefaultAddBirthdayPresenter: AddBirthdayPresenter {
    
    func saveBirthdayButtonTapped(_ birthdays: BirthdayDTO) {
        let result = CoreDataManager.instance.saveBirthday(birthdaydto: birthdays)
        switch result {
        case .success(_):
            closeAddBirthdayScreen?()
        case .failure(let failure):
            view.showErrorAlert(error: failure.localizedDescription)
        }
    }
    
    func timeIntervalUntilBirthday(_ birthdayDate: Date) -> TimeInterval? {
          let currentDate = Date()
          let calendar = Calendar.current

          let birthdayComponents = calendar.dateComponents([.month, .day], from: birthdayDate)
          let currentYear = calendar.component(.year, from: currentDate)

          var birthdayThisYearComponents = DateComponents()
          birthdayThisYearComponents.year = currentYear
          birthdayThisYearComponents.month = birthdayComponents.month
          birthdayThisYearComponents.day = birthdayComponents.day

          if let birthdayThisYear = calendar.date(from: birthdayThisYearComponents) {
              if birthdayThisYear < currentDate {
                  let nextBirthdayYear = currentYear + 1
                  birthdayThisYearComponents.year = nextBirthdayYear
                  if let nextBirthdayThisYear = calendar.date(from: birthdayThisYearComponents) {
                      return nextBirthdayThisYear.timeIntervalSince(currentDate)
                  }
              } else {
                  return birthdayThisYear.timeIntervalSince(currentDate)
              }
          }
          return nil
      }
}
