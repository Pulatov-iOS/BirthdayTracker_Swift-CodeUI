import Foundation

protocol BirthdayListPresenter: AnyObject {
    func getBirthdays()
    func addBirthdayButtonTapped()
}

final class DefaultBirthdayListPresenter {
    
    // MARK: - Public properties
    unowned let view: BirthdayListView
    var showAddBirthdayPage: (() -> Void)?
    
    init(view: BirthdayListView) {
        self.view = view
    }
    
    private func sortBirthdays(_ birthdays: [Birthday]) -> [Birthday] {
        return birthdays.sorted { (birthday1: Birthday, birthday2: Birthday) in
            let today = Date()
            let birthday1NextBirthday = Calendar.current.nextDate(after: today, matching: DateComponents(month: Calendar.current.component(.month, from: birthday1.birthdayDate ?? Date()), day: Calendar.current.component(.day, from: birthday1.birthdayDate ?? Date())), matchingPolicy: .nextTime)!
            let birthday2NextBirthday = Calendar.current.nextDate(after: today, matching: DateComponents(month: Calendar.current.component(.month, from: birthday2.birthdayDate ?? Date()), day: Calendar.current.component(.day, from: birthday2.birthdayDate ?? Date())), matchingPolicy: .nextTime)!
            return birthday1NextBirthday > birthday2NextBirthday
        }
    }
}

// MARK: - BirthdayListPresenter
extension DefaultBirthdayListPresenter: BirthdayListPresenter {
    
    func getBirthdays() {
        let result = CoreDataManager.instance.getBirthdays()
        
        switch result {
        case .success(let birthdays):
            self.view.updateBirthdayListView(birthdays: sortBirthdays(birthdays))
        case .failure(let failure):
            view.showErrorAlert(error: failure.localizedDescription)
        }
    }
    
    func addBirthdayButtonTapped() {
        showAddBirthdayPage?()
    }
}
