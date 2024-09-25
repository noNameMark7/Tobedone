import UIKit

class FontManager {
    
    static let shared = FontManager()
    
    private init() {}
    
    func navigationBarTitleAttributes(large: Bool = false) -> [NSAttributedString.Key: Any] {
        let fontSize: CGFloat = large ? 28 : 18
        return [
            .font: UIFont(
                name: "AvenirNext-DemiBold", size: fontSize
            ) ?? UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: UIColor.label
        ]
    }
    
    func labelFont(
        withSize: CGFloat,
        withWeight: UIFont.Weight = .regular
    ) -> UIFont {
        UIFont(
            name: "AvenirNext-Regular", size: withSize
        ) ?? UIFont.systemFont(ofSize: withSize, weight: withWeight)
    }
}
