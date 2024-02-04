import UIKit

protocol BirthdayTableViewCellDelegate: AnyObject {
    func didSelectCell(_ cell: BirthdayTableViewCell)
}

final class BirthdayTableViewCell: UITableViewCell {
    
    // MARK: - Private properties
    private let containerView = UIView()
    private let nameLabel = UILabel()
    private let surnameLabel = UILabel()
    private let birthdayDateLabel = UILabel()
    private let daysUntilBirthdayLabel = UILabel()
    
    weak var delegate: BirthdayTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(surnameLabel)
        containerView.addSubview(birthdayDateLabel)
        containerView.addSubview(daysUntilBirthdayLabel)
    }
    
    private func configureConstraints() {
        [containerView, nameLabel, surnameLabel, birthdayDateLabel, daysUntilBirthdayLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            nameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5),

            surnameLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 35),
            surnameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            surnameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.4),
            surnameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            daysUntilBirthdayLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            daysUntilBirthdayLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            daysUntilBirthdayLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.3),
            
            birthdayDateLabel.topAnchor.constraint(equalTo: daysUntilBirthdayLabel.topAnchor, constant: 35),
            birthdayDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            birthdayDateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            birthdayDateLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5),
        ])
    }
    
    private func configureUI() {
        backgroundColor = .clear
        
        containerView.backgroundColor = .birthdayCellBackground
        containerView.layer.shadowColor = UIColor.cellShadow.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 16
        containerView.layer.cornerRadius = 8
        
        daysUntilBirthdayLabel.textAlignment = .right
        birthdayDateLabel.textAlignment = .right
    }
    
    func setInformation(birthday: Birthday) {
        nameLabel.text = birthday.name
        surnameLabel.text = birthday.surname
        
        let daysUntilBirthday = daysUntilBirthday(birthday: birthday.birthdayDate ?? Date()) ?? 0
        daysUntilBirthdayLabel.text = "\(daysUntilBirthday) \(NSLocalizedString("addBirthday.daysUntilBirthdayLabel", comment: ""))"
        if daysUntilBirthday < 30 {
            daysUntilBirthdayLabel.textColor = .red
        }

        birthdayDateLabel.text = "\(dateToFormat(birthday.birthdayDate ?? Date()))"
    }
    
    private func cellTappedHandler() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func cellTapped() {
         delegate?.didSelectCell(self)
     }
    
    private func dateToFormat(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy 'г.'"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    private func daysUntilBirthday(birthday: Date) -> Int? {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let currentYear = calendar.component(.year, from: currentDate)
        let birthdayComponents = calendar.dateComponents([.month, .day], from: birthday)
        var birthdayThisYearComponents = DateComponents()
        birthdayThisYearComponents.year = currentYear
        birthdayThisYearComponents.month = birthdayComponents.month
        birthdayThisYearComponents.day = birthdayComponents.day
        
        guard let birthdayThisYear = calendar.date(from: birthdayThisYearComponents) else {
            return nil
        }
        
        if let difference = calendar.dateComponents([.day], from: currentDate, to: birthdayThisYear).day, difference >= 0 {
            return difference
        } else {
            let nextBirthdayComponents = DateComponents(year: currentYear + 1, month: birthdayComponents.month, day: birthdayComponents.day)
            if let nextBirthday = calendar.date(from: nextBirthdayComponents) {
                return calendar.dateComponents([.day], from: currentDate, to: nextBirthday).day
            }
        }
        return nil
    }
}
