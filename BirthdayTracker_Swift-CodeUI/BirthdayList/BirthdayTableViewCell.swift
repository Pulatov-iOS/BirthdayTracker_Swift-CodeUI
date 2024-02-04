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
        addSubview(containerView)
        addSubview(nameLabel)
        addSubview(surnameLabel)
        addSubview(birthdayDateLabel)
        addSubview(daysUntilBirthdayLabel)
    }
    
    private func configureConstraints() {
        [containerView, nameLabel, surnameLabel, birthdayDateLabel, daysUntilBirthdayLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            nameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5),
            
            surnameLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 10),
            surnameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            surnameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            surnameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5),
            
            daysUntilBirthdayLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            daysUntilBirthdayLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            daysUntilBirthdayLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.2),
            
            birthdayDateLabel.topAnchor.constraint(equalTo: daysUntilBirthdayLabel.topAnchor, constant: 10),
            birthdayDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            birthdayDateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            birthdayDateLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.4),
        ])
    }
    
    private func configureUI() {
        backgroundColor = .clear
        
        backgroundColor = .birthdayCellBackground
        containerView.layer.shadowColor = UIColor.cellShadow.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 16
        containerView.layer.cornerRadius = 8
    }
    
    func setInformation() {
        
    }
    
    private func cellTappedHandler() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func cellTapped() {
         delegate?.didSelectCell(self)
     }
}
