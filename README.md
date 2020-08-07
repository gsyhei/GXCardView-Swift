# GXCardView
卡片式布局(探探附近/QQ配对)，跟tableView一个用法，根据网友反应已经添加了重复循环属性，最新还添加了平滑加载更多数据。有建议可以联系QQ：279694479。

# 喜欢就给个star哦，QQ：279694479

先上demo菜单效果（比较朴素，请别在意）
--

![](/GXCardView_swift.gif '描述')


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
* 其它版本 [OC版本](https://github.com/gsyhei/GXCardView-Swift)
```
pod 'GXCardView'
```
GXCardViewDataSource
--

```swift
func numberOfItems(in cardView: GXCardView) -> Int
func cardView(_ cardView: GXCardView, cellForItemAt index: Int) -> GXCardViewCell
```

GXCardViewDelegate
--

```swift
@objc optional func cardView(_ cardView: GXCardView, didRemove cell: GXCardViewCell, forItemAt index: Int, direction: GXCardViewCell.SwipeDirection)
@objc optional func cardView(_ cardView: GXCardView, didRemoveLast cell: GXCardViewCell, forItemAt index: Int, direction: GXCardViewCell.SwipeDirection)
@objc optional func cardView(_ cardView: GXCardView, didDisplay cell: GXCardViewCell, forItemAt index: Int)
@objc optional func cardView(_ cardView: GXCardView, didMove cell: GXCardViewCell, forItemAt index: Int, move point: CGPoint, direction: GXCardViewCell.SwipeDirection)
```

重载数据 
--

```swift
func reloadData(animated: Bool = false, to index: Int? = nil)
```

可以设置参数
--

```swift
/// 卡片可见数量(默认3)
open var visibleCount: Int = 3
/// 行间距(默认10.0，可自行计算scale比例来做间距)
open var lineSpacing: CGFloat = 10.0
/// 列间距(默认10.0，可自行计算scale比例来做间距)
open var interitemSpacing: CGFloat = 10.0
/// 侧滑最大角度(默认15°)
open var maxAngle: CGFloat = 15.0
/// 最大移除距离(默认屏幕的1/4)
open var maxRemoveDistance: CGFloat = GX_ScreenWidth * 0.25
/// 是否重复(默认false)
open var isRepeat: Bool = false
```

License
--
MIT


