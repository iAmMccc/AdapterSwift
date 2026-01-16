# iOS 等比例UI适配方案



苹果手机的机型越来越多，屏幕尺寸越来越大。很多时候苦于需要精准的适配各个屏幕尺寸的UI，通常根据某一种倍数计算的结果并不能满足精准的需求, 随着iPhone设备不同尺寸的增加 这种需求更加迫切。

主流的适配方案是针对不同尺寸屏幕进行等比例适配 ，按照基准屏幕宽度计算出一个比例值，再按照这个比例值计算出其他宽度的值。

本篇文章的核心是如何更优雅的，方便的，少侵入性的完成适配。



## 解决思路

我们将对以下值进行等比例适配

* Int

* CGFloat

* Double

* Float

* CGSize

* CGRect

* UIFont （只改变pointSize）

我们期望的调用方式是这样的：

```
1.adapter
(1.0).adapter
CGSize(width: 1, height: 1).adapter
CGRect(x: 0, y: 0, width: 1, height: 1).adapter
UIFont.systemFontSize.adapter
```

并要求适配之后的数据类型跟适配前保持一致。



## 实现效果

### 同一机型适配前后的区别

![同一机型适配前后的区别](https://github.com/intsig171/AdapterSwift/assets/87351449/3641fec3-074b-4a0c-8332-afc8d1eefd9f)




### 不同机型适配之后
![不同机型适配之后](https://github.com/intsig171/AdapterSwift/assets/87351449/26d04cb8-fdd0-4bbd-b835-6a30786ce686)




## 实现方案



### 适配类

可以通过 `Adapter.share.base = 375`  改变基准屏幕宽度。

```
public struct Adapter {
    public static var share = Adapter()
    
    /// 参考标准（UI是以哪个屏幕设计UI的）
    public var base: Double = 375
    
    /// 记录适配比例
    fileprivate var adapterScale: Double?
}
```



### 适配协议

提供适配协议，提供对外出口。

```
public protocol Adapterable {
    associatedtype AdapterType
    var adapter: AdapterType { get }
}
```

添加扩展，计算是适配比例。

```
extension Adapterable {
    func adapterScale() -> Double {       
        if let scale = Adapter.share.adapterScale {
            return scale
        } else {
            let width = UIScreen.main.bounds.size.width
            /// 参考标准以 iPhone 6 的宽度为基准
            let referenceWidth: Double = Adapter.share.base
            let scale = width / referenceWidth
            Adapter.share.adapterScale = scale
            return scale
        }
    }
}
```



### 进行适配

```
extension Int: Adapterable {
    public typealias AdapterType = Int
    public var adapter: Int {
        let scale = adapterScale()
        let value = Double(self) * scale
        return Int(value)
    }
}

extension CGFloat: Adapterable {
    public typealias AdapterType = CGFloat
    public var adapter: CGFloat {
        let scale = adapterScale()
        let value = self * scale
        return value
    }
}

extension Double: Adapterable {
    public typealias AdapterType = Double
    public var adapter: Double {
        let scale = adapterScale()
        let value = self * scale
        return value
    }
}

extension Float: Adapterable {
    public typealias AdapterType = Float
    public var adapter: Float {
        let scale = adapterScale()
        let value = self * Float(scale)
        return value
    }
}

extension CGSize: Adapterable {
    public typealias AdapterType = CGSize
    public var adapter: CGSize {
        let scale = adapterScale()
        let width = self.width * scale
        let height = self.height * scale
        return CGSize(width: width, height: height)
    }
}

extension CGRect: Adapterable {
    public typealias AdapterType = CGRect
    public var adapter: CGRect {

        /// 不参与屏幕rect
        if self == UIScreen.main.bounds {
            return self
        }
        let scale = adapterScale()
        let x = origin.x * scale
        let y = origin.y * scale
        let width = size.width * scale
        let height = size.height * scale
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

extension UIFont: Adapterable {
    public typealias AdapterType = UIFont
    public var adapter: UIFont {
        let scale = adapterScale()
        let pointSzie = self.pointSize * scale
        let fontDescriptor = self.fontDescriptor
        return UIFont(descriptor: fontDescriptor, size: pointSzie)
    }
}
```



## 注意项

适配的原理是根据屏幕宽度进行缩放。因此如果你的UI是基于屏幕宽度的（屏幕宽度等分之后横向充满屏幕），会导致总值超出屏幕。

同样的道理，如果只适配子视图，不适配父视图，也有可能出现同样的问题。

* 禁止适配屏幕。

* 禁止适配基于屏幕宽度和高度计算出来的值。

* 禁止只适配子视图，不适配父视图（父视图不是滑动视图的情况）。

![适配注意项](https://github.com/intsig171/AdapterSwift/assets/87351449/b7447fa5-5551-4d30-878c-598d15194989)



```
let aView = UIView()
aView.backgroundColor = UIColor.blue
view.addSubview(aView)


let bView = UIView()
bView.backgroundColor = UIColor.yellow
view.addSubview(bView)

let cView = UIView()
cView.backgroundColor = UIColor.orange
view.addSubview(cView)

var width = (UIScreen.main.bounds.size.width - 20) / 3
aView.snp.makeConstraints { make in
    make.left.equalTo(10)
    make.height.equalTo(100)
    make.top.equalTo(300)
    make.width.equalTo(width)
}

bView.snp.makeConstraints { make in
    make.height.top.width.equalTo(aView)
    make.left.equalTo(aView.snp.right)
}

cView.snp.makeConstraints { make in
    make.height.top.width.equalTo(aView)
    make.left.equalTo(bView.snp.right)
}
```





## 如何使用？

### 集成

```
pod 'AdapterSwift'
```

### 使用

```
import AdapterSwift

imageView.snp.makeConstraints { make in
    make.left.equalTo(10.adapter)
    make.top.equalTo(100.adapter)
    make.size.equalTo(CGSize(width: 100, height: 100).adapter)
}
```

