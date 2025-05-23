import UIKit

extension UIColor {
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var value: UInt64 = 0
        
        if (cString.hasPrefix("#")) {
            cString.removeFirst()
        }
        
        if ((cString.count) != 6) {
            self.init("ff0000")
            return
        }
        
        Scanner(string: cString).scanHexInt64(&value)
        
        self.init(red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(value & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}





