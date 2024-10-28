import UIKit

// MARK: - UITableViewCell

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 9
        view.clipsToBounds = true
        return view
    }()

    private let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontManager.shared.labelFont(withSize: 15, withWeight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontManager.shared.labelFont(withSize: 12, withWeight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    let isPriorityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "Akatsuki Cloud")
        imageView.isHidden = true
        return imageView
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateAppearance(for: traitCollection)
    }
}


// MARK: - Initial Setup

private extension CustomTableViewCell {
    
    func initialSetup() {
        configureUI()
    }
    
    func configureUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(taskLabel)
        containerView.addSubview(noteLabel)
        containerView.addSubview(isPriorityImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            
            taskLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 7),
            taskLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            
            noteLabel.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 5),
            noteLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            noteLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            noteLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -7),
            
            isPriorityImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 7),
            isPriorityImageView.leadingAnchor.constraint(equalTo: taskLabel.trailingAnchor, constant: 5),
            isPriorityImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            isPriorityImageView.heightAnchor.constraint(equalToConstant: 15.9),
            isPriorityImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        updateAppearance(for: traitCollection)
    }
    
    func updateAppearance(for traitCollection: UITraitCollection) {
        if traitCollection.userInterfaceStyle == .dark {
            containerView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        } else {
            containerView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.5)
        }
    }
}


// MARK: - Cell Configuration

extension CustomTableViewCell {
    
    func configurationOfValuesWith(_ item: ToDoListItem) {
        taskLabel.text = item.name
        noteLabel.text = item.note
        isPriorityImageView.isHidden = !item.isPriority
    }
}
