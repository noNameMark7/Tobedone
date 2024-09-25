import UIKit

// MARK: - UITableViewCell

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9803921569, blue: 0.4352941176, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let taskLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.shared.labelFont(withSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.shared.labelFont(withSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let isPriorityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Akatsuki Cloud")
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
}


// MARK: - Initial Setup

extension CustomTableViewCell {
    
    func initialSetup() {
        configureUI()
    }
    
    func configureUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(taskLabel)
        containerView.addSubview(noteLabel)
        containerView.addSubview(isPriorityImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
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
    }
}


// MARK: - Cell Configuration

extension CustomTableViewCell {
    
    func configurationOfValuesWith(_ model: ToDoListItem) {
        taskLabel.text = model.name
        noteLabel.text = model.note
        isPriorityImageView.isHidden = !model.isPriority
    }
}
