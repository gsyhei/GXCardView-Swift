# GXCardView
卡片式布局(探探附近/QQ配对)，跟tableView一个用法，根据网友反应已经添加了重复循环属性，最新还添加了平滑加载更多数据。有建议可以联系QQ交流群:1101980843。

# 喜欢就给个star哦，QQ交流群:1101980843

先上demo菜单效果（比较朴素，请别在意）
--

![](/GXCardView-Swift.gif '描述')


Requirements
--
- iOS 9.0 or later
- Xcode 11.0 or later
- Swift 5.0

Usage in you Podfile:
--

```
pod 'GXCardView-Swift'
```
* 其它版本 [OC版本](https://github.com/gsyhei/GXCardView)
```
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
```

License
--
MIT


