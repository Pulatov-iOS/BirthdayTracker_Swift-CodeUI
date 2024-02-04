import UIKit

protocol BirthdayListView: AnyObject {
    func updateBirthdayListView(birthdays: [Birthday])
    func showErrorAlert(error: String)
}

final class DefaultBirthdayListView: UIViewController {
    
    // MARK: - Public properties
    var presenter: BirthdayListPresenter!
    
    // MARK: - Private properties
    private var birthdays = [Birthday]() {
        didSet {
            tableView.reloadData()
        }
    }
    private let tableView = UITableView()
    
    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        configureUI()
        setupTableView()
        addBirthdayButtonAddToScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.getBirthdays()
    }
    
    // MARK: - Helpers
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureUI() {
        title = NSLocalizedString("birthdayList.titleLabel", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .birthdayListViewBackground
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.register(BirthdayTableViewCell.self, forCellReuseIdentifier: "CustomCell")
    }
    
    private func addBirthdayButtonAddToScreen() {
        let addBirthdayButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBirthdayButtonTapped))
        navigationItem.rightBarButtonItem = addBirthdayButton
    }
    
    @objc private func addBirthdayButtonTapped() {
        presenter.addBirthdayButtonTapped()
    }
}

// MARK: - BirthdayListView
extension DefaultBirthdayListView: BirthdayListView {
    
    func updateBirthdayListView(birthdays: [Birthday]) {
        self.birthdays = birthdays
    }
    
    func showErrorAlert(error: String) {
        let alert = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Table ViewDelegate/DataSource
extension DefaultBirthdayListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birthdays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! BirthdayTableViewCell
        cell.delegate = self
        cell.setInformation(birthday: birthdays[indexPath.row])
        return cell
    }
}

// MARK: - BirthdayTableViewCellDelegate
extension DefaultBirthdayListView: BirthdayTableViewCellDelegate {
    
    func didSelectCell(_ cell: BirthdayTableViewCell) {
        guard let _ = tableView.indexPath(for: cell) else { return }
    }
}
