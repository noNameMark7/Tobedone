import UIKit

protocol HeaderViewDelegate: AnyObject {
    func callHeader(by index: Int)
}

class HeaderView: UIView {
    
    // MARK: - Properties
    var sectionIndex: Int?
    
    weak var delegate: HeaderViewDelegate?
    
    // MARK: - UI Components
    lazy var sectionsButtonView: UIButton = {
        let button = UIButton(type: .system)
        
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .black
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 7)
        
        button.configuration = configuration
        //button.titleLabel?.font = FontManager.shared.labelFont(withSize: 22, withWeight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTappedButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sectionsButtonView)
        
        NSLayoutConstraint.activate([
            sectionsButtonView.topAnchor.constraint(equalTo: self.topAnchor),
            sectionsButtonView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            sectionsButtonView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),
            sectionsButtonView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -8)
        ])
        
        // Set the cornerRadius in layoutSubviews to ensure it adapts to the button's final size
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Apply cornerRadius once layout completes
        sectionsButtonView.layer.cornerRadius = 5
    }
    
    @objc private func didTappedButton() {
        if let index = sectionIndex {
            delegate?.callHeader(by: index)
        }
    }
}
