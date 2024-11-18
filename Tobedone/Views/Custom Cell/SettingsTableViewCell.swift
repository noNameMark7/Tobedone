import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    static let identifier = "SettingsTableViewCell"
        
    let iconContainerView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "Akatsuki Cloud")
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let labelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}


// MARK: - Initial Setup
private extension SettingsTableViewCell {
    
    func initialSetup() {
        configureUI()
    }
    
    func configureUI() {
        contentView.addSubview(labelView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(iconContainerView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
}


// MARK: - Cell Configuration
extension SettingsTableViewCell {
   
}
