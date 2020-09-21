//
//  UICardLayout.swift
//  GXCardViewSample
//
//  Created by Gin on 2020/9/7.
//  Copyright © 2020 gin. All rights reserved.
//

//
//  UICardLayout.swift
//  GXCardViewSample
//
//  Created by Gin on 2020/9/7.
//  Copyright © 2020 gin. All rights reserved.
//

import UIKit

let GX_DefaultDuration: TimeInterval = 0.25
let GX_SpringDuration: TimeInterval  = 0.5
let GX_SpringWithDamping: CGFloat    = 0.5
let GX_SpringVelocity: CGFloat       = 0.8
let GX_ScreenWidth  = UIScreen.main.bounds.size.width
let GX_ScreenHeight = UIScreen.main.bounds.size.height

public class GXCardLayout: UICollectionViewLayout {
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
}

public extension GXCardLayout {
    
    override func prepare() {
        self.collectionView?.bounces = false
        self.collectionView?.clipsToBounds = false
        self.collectionView?.isPagingEnabled = true
        self.collectionView?.isScrollEnabled = false
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.size.width, height: CGFloat(self.number + 1) * self.size.height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes: [UICollectionViewLayoutAttributes] = []
        let index: Int = Int(ceil(self.offset.y / self.size.height))
        var showMax: Int = index + self.visibleCount
        if !self.isRepeat && (showMax > self.number) {
            showMax = self.number
        }
        for i in index..<showMax {
            let indexPath = IndexPath(item: i % self.number, section: 0)
            guard let attribute = self.layoutAttributesForItem(at: indexPath) else { continue }
            attribute.zIndex = self.number - i
            attributes.append(attribute)
        }
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let firstIndex: Int = Int(ceil(self.offset.y / self.size.height))
        var index = (indexPath.item - firstIndex)
        if index < 0 { index = (self.number - firstIndex + indexPath.item) % self.visibleCount }
        var percent = (self.offset.y.truncatingRemainder(dividingBy:self.size.height) / self.size.height)
        if index == self.visibleCount - 1 {
            attributes.alpha = (percent > 0) ? percent : 1.0
        }
        if percent < 1 && percent > 0 { percent = 1 - percent }
        let indexPercent: CGFloat = CGFloat(index) + percent
        let insets: UIEdgeInsets = self.cardCellInsets(for: indexPercent)
        let size = self.bounds.inset(by: insets).size
        let transform = CGAffineTransform(scaleX: size.width/self.size.width, y: size.height/self.size.height)
        attributes.frame = self.bounds
        attributes.transform = transform
        let centerX = attributes.center.x + (insets.left - insets.right)/2
        let centerY = attributes.center.y + (insets.top - insets.bottom)/2
        attributes.center = CGPoint(x: centerX, y: centerY)

        return attributes
    }
}

fileprivate extension GXCardLayout {
    var size: CGSize {
        return self.collectionView?.frame.size ?? .zero
    }
    var number: Int {
        return self.collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    var offset: CGPoint {
        return self.collectionView?.contentOffset ?? .zero
    }
    var bounds: CGRect {
        return self.collectionView?.bounds ?? .zero
    }
    func cardCellInsets(for indexPercent: CGFloat) -> UIEdgeInsets {
        var insets: UIEdgeInsets = .zero
        if self.cardInsets.top < 0 {
            insets.top -= self.cardInsets.top * (CGFloat(self.visibleCount - 1) - indexPercent)
        }
        else {
            insets.top = self.cardInsets.top * indexPercent
        }
        if self.cardInsets.left < 0 {
            insets.left -= self.cardInsets.left * (CGFloat(self.visibleCount - 1) - indexPercent)
        }
        else {
            insets.left = self.cardInsets.left * indexPercent
        }
        if self.cardInsets.right < 0 {
            insets.right -= self.cardInsets.right * (CGFloat(self.visibleCount - 1) - indexPercent)
        }
        else {
            insets.right = self.cardInsets.right * indexPercent
        }
        if self.cardInsets.bottom < 0 {
            insets.bottom -= self.cardInsets.bottom * (CGFloat(self.visibleCount - 1) - indexPercent)
        }
        else {
            insets.bottom = self.cardInsets.bottom * indexPercent
        }
        return insets
    }
}
