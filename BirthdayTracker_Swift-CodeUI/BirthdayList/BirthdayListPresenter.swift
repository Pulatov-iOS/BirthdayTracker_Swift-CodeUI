protocol BirthdayListPresenter: AnyObject {
    
}

final class DefaultBirthdayListPresenter {
    
    // MARK: - Public properties
    unowned let view: BirthdayListView
    
    init(view: BirthdayListView) {
        self.view = view
    }
}

// MARK: - BirthdayListPresenter
extension DefaultBirthdayListPresenter: BirthdayListPresenter {
    
}
