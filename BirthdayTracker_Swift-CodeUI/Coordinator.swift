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
    }
}
