import Foundation
import UserNotifications

protocol AddBirthdayPresenter: AnyObject {
    func saveBirthdayButtonTapped(_ birthdays: BirthdayDTO)
    func timeIntervalUntilBirthday(_ birthdayDate: Date) -> TimeInterval?
    func scheduleNotification(timeInterval: TimeInterval)
}

final class DefaultAddBirthdayPresenter {
    
    // MARK: - Public properties
    unowned let view: AddBirthdayView
    var closeAddBirthdayScreen: (() -> Void)?
    
    init(view: AddBirthdayView) {
        self.view = view
        permissionSendNotifications()
    }
    
    // MARK: - Helpers
    private func permissionSendNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
           
        }
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
    
    func scheduleNotification(timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("addBirthday.notificationTitle", comment: "")
        content.body = NSLocalizedString("addBirthday.notificationBody", comment: "")
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        let request = UNNotificationRequest(identifier: "birthdayNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
