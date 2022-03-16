# GXCardView
卡片式布局(探探附近/QQ配对)，可以设置卡片堆叠效果，可以设置循环效果。
有建议可以联系QQ交流群:1101980843，喜欢就给个star哦，谢谢关注！
<p align="center">
<img src="https://github.com/gsyhei/GXCardView-Swift/blob/master/QQ.jpeg">
</p>

先上demo菜单效果
--
<p align="center">
<img src="https://github.com/gsyhei/GXCardView-Swift/blob/master/GXCardView-Swift.gif">
</p>

Requirements
--
<p align="left">
<a href="https://github.com/gsyhei/GXCardView-Swift"><img src="https://img.shields.io/badge/platform-ios%209.0-yellow.svg"></a>
<a href="https://github.com/gsyhei/GXCardView-Swift"><img src="https://img.shields.io/github/license/johnlui/Pitaya.svg?style=flat"></a>
<a href="https://github.com/gsyhei/GXCardView-Swift"><img src="https://img.shields.io/badge/language-Swift%204.2-orange.svg"></a>
</p>

Usage in you Podfile:
--

```
pod 'GXCardView-Swift'
```
* 其它版本 [OC版本](https://github.com/gsyhei/GXCardView)
```

```
关于会变形的问题，这里要说明一下。为了使动画平滑故而使用的CGAffineTransform，那么想要使内容不变形必须按照实际情况设置cardInsets: UIEdgeInsets。
假设Card的CGSize(w, h), 那么设置的 (top + bottom) / w == (left + right) / h，这样每个cardCell的长宽比例相等才能不变形。
--

pod 'GXCardView'
```
GXCardViewDataSource
--

```swift
func numberOfItems(in cardView: GXCardView) -> Int
func cardView(_ cardView: GXCardView, cellForItemAt indexPath: IndexPath) -> GXCardCell
```

GXCardViewDelegate
--

```swift
@objc optional func cardView(_ cardView: GXCardView, didSelectItemAt index: Int)
@objc optional func cardView(_ cardView: GXCardView, didRemove cell: GXCardCell, forItemAt index: Int, direction: GXCardCell.SwipeDirection)
@objc optional func cardView(_ cardView: GXCardView, didRemoveLast cell: GXCardCell, forItemAt index: Int, direction: GXCardCell.SwipeDirection)
@objc optional func cardView(_ cardView: GXCardView, didDisplay cell: GXCardCell, forItemAt index: Int)
@objc optional func cardView(_ cardView: GXCardView, didMove cell: GXCardCell, forItemAt index: Int, move point: CGPoint, direction: GXCardCell.SwipeDirection)
```

可以设置参数
--

```swift
/// 卡片可见数量(默认3)
 open var visibleCount: Int = 3
 /// 卡片与卡片之间的insets(从上至下，正负皆可)
 open var cardInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: 10)
 /// 侧滑最大角度(默认15°)
 open var maxAngle: CGFloat = 15.0
 /// 是否重复(默认false)
 open var isRepeat: Bool = false
 /// 最大移除距离(默认屏幕的1/4)
 open var maxRemoveDistance: CGFloat = GX_ScreenWidth * 0.25
 /// 是否需要移除动画结束才可以再次拖拽
 open var isPanAnimatedEnd: Bool = false

```

License
--
MIT


