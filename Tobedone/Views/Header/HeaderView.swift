import UIKit

protocol HeaderViewDelegate: AnyObject {
    func callHeader(by index: Int)
}

class HeaderView: UIView {
    var sectionIndex: Int?
    
    weak var delegate: HeaderViewDelegate?
    
    lazy var buttonView: UIButton = {
        let button = UIButton(
            frame: CGRect(
                x: self.frame.origin.x,
                y: self.frame.origin.y,
                width: self.frame.width,
                height: self.frame.height
            )
        )
        button.titleLabel?.font = FontManager.shared.labelFont(withSize: 14, withWeight: .bold)
        button.contentHorizontalAlignment = .trailing
        button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTappedButton), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(buttonView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTappedButton() {
        if let index = sectionIndex {
            delegate?.callHeader(by: index)
        }
    }
}
