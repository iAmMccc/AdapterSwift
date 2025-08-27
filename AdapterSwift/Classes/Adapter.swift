

import Foundation


/** 要适配的类型
 * Int
 * CGFloat
 * Double
 * Float
 * CGSize
 * CGRect
 * UIFont （保留字体的其他属性，只改变pointSize）
 * CGPoint
 */


import UIKit

public struct Adapter {
    public static var share = Adapter()
    public var base: Double = 375
    public var mode: AdapterMode = .width
    
    public enum AdapterMode {
        case width, height
    }
    
    fileprivate func currentScale() -> Double {
        let screen = UIScreen.main.bounds.size
        switch mode {
        case .width:
            return screen.width / base
        case .height:
            return screen.height / base
        }
    }
}

public protocol Adapterable {
    associatedtype AdapterType
    var adapter: AdapterType { get }
}

extension Adapterable {
    func adapterScale() -> Double {
        Adapter.share.currentScale()
    }
}

// MARK: - 数值类型
extension Int: Adapterable {
    public var adapter: Int {
        Int((Double(self) * adapterScale()))
    }
}
extension CGFloat: Adapterable {
    public var adapter: CGFloat {
        self * adapterScale()
    }
}
extension Double: Adapterable {
    public var adapter: Double {
        self * adapterScale()
    }
}
extension Float: Adapterable {
    public var adapter: Float {
        self * Float(adapterScale())
    }
}

// MARK: - 尺寸类型
extension CGSize: Adapterable {
    public var adapter: CGSize {
        CGSize(width: width.adapter, height: height.adapter)
    }
}
extension CGRect: Adapterable {
    public var adapter: CGRect {
        self == UIScreen.main.bounds ? self :
        CGRect(x: origin.x.adapter, y: origin.y.adapter,
               width: size.width.adapter, height: size.height.adapter)
    }
}
extension CGPoint: Adapterable {
    public var adapter: CGPoint {
        CGPoint(x: x.adapter, y: y.adapter)
    }
}

extension UIEdgeInsets: Adapterable {
    public var adapter: UIEdgeInsets {
        UIEdgeInsets(top: top.adapter, left: left.adapter,
                     bottom: bottom.adapter, right: right.adapter)
    }
}
extension UIFont: Adapterable {
    public var adapter: UIFont {
        withSize(pointSize.adapter)
    }
}


import UIKit

extension UIView {
    /// 递归适配当前视图及其所有子视图
    public func adapterAll() {
        // 1. Frame 适配
        self.frame = self.frame.adapter
        
        // 2. 字体适配（UILabel / UIButton / UITextField / UITextView）
        if let label = self as? UILabel {
            label.font = label.font.adapter
        } else if let button = self as? UIButton {
            if let font = button.titleLabel?.font {
                button.titleLabel?.font = font.adapter
            }
        } else if let textField = self as? UITextField {
            if let font = textField.font {
                textField.font = font.adapter
            }
        } else if let textView = self as? UITextView {
            textView.font = textView.font?.adapter
        }
        
        // 3. EdgeInsets 适配（UIButton 的内容内边距、title 边距、image 边距）
        if let button = self as? UIButton {
            button.contentEdgeInsets = button.contentEdgeInsets.adapter
            button.titleEdgeInsets = button.titleEdgeInsets.adapter
            button.imageEdgeInsets = button.imageEdgeInsets.adapter
        }
        
        // 4. 递归子视图
        for subview in subviews {
            subview.adapterAll()
        }
    }
}
