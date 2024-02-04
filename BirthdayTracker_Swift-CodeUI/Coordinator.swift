import UIKit

final class Coordinator {
    
    let rootNavigationController: UINavigationController
    
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    func start() {
        showBirthdayListScreen()
    }
    
    private func showBirthdayListScreen() {
        let view = DefaultBirthdayListView()
        let presenter = DefaultBirthdayListPresenter(view: view)
        view.presenter = presenter
        rootNavigationController.pushViewController(view, animated: true)
        
        presenter.showAddBirthdayPage = { [weak self] in
            self?.showAddBirthdayScreen()
        }
    }
    
    private func showAddBirthdayScreen() {
        let view = DefaultAddBirthdayView()
        let presenter = DefaultAddBirthdayPresenter(view: view)
        view.presenter = presenter
        rootNavigationController.pushViewController(view, animated: true)
        
        presenter.closeAddBirthdayScreen = { [weak self] in
            self?.closeCurrentScreen()
        }
    }
    
    private func closeCurrentScreen() {
        rootNavigationController.popViewController(animated: true)
    }
}
