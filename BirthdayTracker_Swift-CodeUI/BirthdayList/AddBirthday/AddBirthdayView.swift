import UIKit
import UserNotifications

protocol AddBirthdayView: AnyObject {
    func showErrorAlert(error: String)
}

final class DefaultAddBirthdayView: UIViewController {
    
    // MARK: - Public properties
    var presenter: AddBirthdayPresenter!
    
    // MARK: - Private properties
    private let hintLabel = UILabel()
    private let nameTextField = UITextField()
    private let surnameTextField = UITextField()
    private let birthdayDateDatePicker = UIDatePicker()
    private let saveBirthdayButton = UIButton()
    
    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        configureConstraints()
        configureUI()
        setupDatePicker()
        permissionSendNotifications()
        hideKeyboard()
    }
    
    // MARK: - Helpers
    private func addSubviews() {
        view.addSubview(hintLabel)
        view.addSubview(nameTextField)
        view.addSubview(surnameTextField)
        view.addSubview(birthdayDateDatePicker)
        view.addSubview(saveBirthdayButton)
    }
    
    private func configureConstraints() {
        [hintLabel, nameTextField, surnameTextField, birthdayDateDatePicker, saveBirthdayButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            hintLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hintLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            nameTextField.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 20),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            nameTextField.heightAnchor.constraint(equalToConstant: 35),
            
            surnameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            surnameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            surnameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            surnameTextField.heightAnchor.constraint(equalToConstant: 35),
            
            birthdayDateDatePicker.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 15),
            birthdayDateDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            birthdayDateDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            
            saveBirthdayButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            saveBirthdayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveBirthdayButton.widthAnchor.constraint(equalToConstant: 100),
            saveBirthdayButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureUI() {
        title = NSLocalizedString("addBirthday.titleLabel", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .addBirthdayViewBackground
        
        hintLabel.text = NSLocalizedString("addBirthday.hintLabel", comment: "")
        hintLabel.font = .systemFont(ofSize: 20)
        hintLabel.textAlignment = .center
        hintLabel.textColor = .hintLabelText
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("addBirthday.nameTextField", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: UIColor(resource: .textFieldPlaceholder)])
        nameTextField.textAlignment = .center
        nameTextField.backgroundColor = .textFieldBackground
        nameTextField.tintColor = .textFieldText
        nameTextField.layer.cornerRadius = 8
        
        surnameTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("addBirthday.surnameTextField", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: UIColor(resource: .textFieldPlaceholder)])
        surnameTextField.textAlignment = .center
        surnameTextField.backgroundColor = .textFieldBackground
        surnameTextField.tintColor = .textFieldText
        surnameTextField.layer.cornerRadius = 8
        
        saveBirthdayButton.setTitle(NSLocalizedString("addBirthday.saveBirthdayButton", comment: ""), for: .normal)
        saveBirthdayButton.backgroundColor = .saveBirthdayButtonBackground
        saveBirthdayButton.setTitleColor(.saveBirthdayButtonText, for: .normal)
        saveBirthdayButton.layer.cornerRadius = 8
    }
    
    private func setupDatePicker() {
        birthdayDateDatePicker.preferredDatePickerStyle = .wheels
        birthdayDateDatePicker.datePickerMode = .date
        birthdayDateDatePicker.maximumDate = Date()
        
        saveBirthdayButton.addTarget(self, action: #selector(saveBirthdayButtonTapped), for: .touchUpInside)
    }
    
    @objc private func saveBirthdayButtonTapped() {
        if nameTextField.text != "" {
            let birthday = BirthdayDTO(name: nameTextField.text ?? "", surname: surnameTextField.text ?? "", birthdayDate: birthdayDateDatePicker.date)
            presenter.saveBirthdayButtonTapped(birthday)
            scheduleNotification(timeInterval: presenter.timeIntervalUntilBirthday(birthday.birthdayDate) ?? TimeInterval())
        }
    }
    
    private func permissionSendNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
           
        }
    }
    
    private func scheduleNotification(timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("addBirthday.notificationTitle", comment: "")
        content.body = NSLocalizedString("addBirthday.notificationBody", comment: "")
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        let request = UNNotificationRequest(identifier: "birthdayNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
    private func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - AddBirthdayView
extension DefaultAddBirthdayView: AddBirthdayView {
    
    func showErrorAlert(error: String) {
        let alert = UIAlertController(title: "Warning!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
