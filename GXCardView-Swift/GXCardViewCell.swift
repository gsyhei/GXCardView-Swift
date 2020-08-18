//
//  GXCardViewCell.swift
//  GXCardViewSample
//
//  Created by Gin on 2020/8/5.
//  Copyright © 2020 gin. All rights reserved.
//

import UIKit

fileprivate extension CGPoint {
    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

extension GXCardViewCell {
    @objc enum SwipeDirection: Int {
        case none  = 0
        case left  = 1
        case right = 2
    }
}

protocol GXCardViewCellDelagate: NSObjectProtocol {
    func cardViewCell(_ cell: GXCardViewCell, didRemoveAt direction: GXCardViewCell.SwipeDirection)
    func cardViewCell(_ cell: GXCardViewCell, didMoveAt point: CGPoint, direction: GXCardViewCell.SwipeDirection)
}

class GXCardViewCell: UIView {
    private(set) var currentPoint: CGPoint = .zero
    var reuseIdentifier: String?
    weak var cellDelegate: GXCardViewCellDelagate?
    var maxAngle: CGFloat = 0
    var maxRemoveDistance: CGFloat = 0
    var index: Int = 0
    
    convenience init(frame: CGRect = .zero, withReuseIdentifier identifier: String) {
        self.init(frame: frame)
        self.setupCardViewCell(withReuseIdentifier: identifier)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addPanGestureRecognizer()
    }
    
    func setupCardViewCell(withReuseIdentifier identifier: String) {
        self.reuseIdentifier = identifier
        self.addPanGestureRecognizer()
    }
    
    private func addPanGestureRecognizer() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizer(pan:)))
        self.addGestureRecognizer(pan)
    }
    
    @objc private func panGestureRecognizer(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            self.currentPoint = .zero
        case .changed:
            let movePoint = pan.translation(in: pan.view)
            self.didPanStateChanged(move: movePoint)
            pan.setTranslation(.zero, in: pan.view)
        case .ended:
            self.didPanStateEnded()
        default:
            self.restorePosition()
        }
    }
}

extension GXCardViewCell {
    func remove(swipe direction: SwipeDirection) {
        self.remove(direction: direction, isPan: false)
    }
}

fileprivate extension GXCardViewCell {
    func degreesToRadians(angle: CGFloat) -> CGFloat {
        return (angle / 180.0 * CGFloat.pi)
    }
    func transform(direction: SwipeDirection) -> CGAffineTransform {
        switch direction {
        case .left:
            let transRotation = CGAffineTransform(rotationAngle: -degreesToRadians(angle: self.maxAngle))
            return transRotation.translatedBy(x: self.frame.height, y: self.frame.height*0.25)
        case .right:
            let transRotation = CGAffineTransform(rotationAngle: degreesToRadians(angle: self.maxAngle))
            return transRotation.translatedBy(x: self.frame.height, y: self.frame.height*0.25)
        default: return .identity
        }
    }
    func endCenter(direction: SwipeDirection) -> CGPoint {
        switch direction {
        case .left:
            let endCenterX = -(GX_ScreenWidth*0.5 + self.frame.width)
            return CGPoint(x: endCenterX, y: self.center.y)
        case .right:
            let endCenterX = GX_ScreenWidth*0.5 + self.frame.width*1.5
            return CGPoint(x: endCenterX, y: self.center.y)
        default: return .zero
        }
    }
    func didPanStateChanged(move point: CGPoint) {
        self.currentPoint += point
        var moveScale: CGFloat = self.currentPoint.x / self.maxRemoveDistance
        if abs(moveScale) > 1.0 {
            moveScale = (moveScale > 0) ? 1.0 : -1.0
        }
        let angle = degreesToRadians(angle: self.maxAngle) * moveScale
        let transRotation = CGAffineTransform(rotationAngle: angle)
        self.transform = transRotation.translatedBy(x: self.currentPoint.x, y: self.currentPoint.y)
        
        if (self.currentPoint.x < -self.maxRemoveDistance) {
            self.cellDelegate?.cardViewCell(self, didMoveAt: self.currentPoint, direction: .left)
        }
        else if (self.currentPoint.x > self.maxRemoveDistance) {
            self.cellDelegate?.cardViewCell(self, didMoveAt: self.currentPoint, direction: .right)
        }
        else {
            self.cellDelegate?.cardViewCell(self, didMoveAt: self.currentPoint, direction: .none)
        }
    }
    func didPanStateEnded() {
        if (self.currentPoint.x < -self.maxRemoveDistance) {
            self.remove(direction: .left, isPan: true)
        }
        else if (self.currentPoint.x > self.maxRemoveDistance) {
            self.remove(direction: .right, isPan: true)
        }
        else {
            self.restorePosition()
        }
    }
    func restorePosition() {
        UIView.animate(
            withDuration: GX_SpringDuration, delay: 0,
            usingSpringWithDamping: GX_SpringWithDamping,
            initialSpringVelocity: GX_SpringVelocity,
            options: .curveEaseOut,
            animations: {
                self.transform = .identity
        })
    }
    func didRemove(direction: SwipeDirection) {
        self.transform = .identity
        self.removeFromSuperview()
        self.cellDelegate?.cardViewCell(self, didRemoveAt: direction)
    }
    func remove(direction: SwipeDirection, isPan stateEnded: Bool) {
        let snapshotView = self.snapshotView(afterScreenUpdates: false) ?? UIView()
        snapshotView.transform = self.transform
        self.superview?.superview?.addSubview(snapshotView)
        self.didRemove(direction: direction)
        
        let toTransform: CGAffineTransform = self.transform(direction: direction)
        let toCenter = self.endCenter(direction: direction)
        UIView.animate(withDuration: GX_DefaultDuration, animations: {
            snapshotView.center = toCenter
            if !stateEnded {
                snapshotView.transform = toTransform
            }
        }) { (finished) in
            snapshotView.removeFromSuperview()
        }
    }
}
