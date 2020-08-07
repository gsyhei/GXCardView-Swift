//
//  GXCardViewLayout.swift
//  GXCardViewSample
//
//  Created by Gin on 2020/8/6.
//  Copyright © 2020 gin. All rights reserved.
//

import UIKit

let GX_DefaultDuration: TimeInterval = 0.25
let GX_SpringDuration: TimeInterval  = 0.5
let GX_SpringWithDamping: CGFloat    = 0.5
let GX_SpringVelocity: CGFloat       = 0.8
let GX_ScreenWidth  = UIScreen.main.bounds.size.width
let GX_ScreenHeight = UIScreen.main.bounds.size.height

class GXCardViewLayout: NSObject {
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
}
