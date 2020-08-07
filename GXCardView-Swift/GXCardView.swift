//
//  GXCardView.swift
//  GXCardViewSample
//
//  Created by Gin on 2020/8/6.
//  Copyright © 2020 gin. All rights reserved.
//

import UIKit

protocol GXCardViewDataSource: NSObjectProtocol {
    func numberOfItems(in cardView: GXCardView) -> Int
    func cardView(_ cardView: GXCardView, cellForItemAt index: Int) -> GXCardViewCell
}

@objc protocol GXCardViewDelegate: NSObjectProtocol {
    @objc optional func cardView(_ cardView: GXCardView, didRemove cell: GXCardViewCell, forItemAt index: Int, direction: GXCardViewCell.SwipeDirection)
    @objc optional func cardView(_ cardView: GXCardView, didRemoveLast cell: GXCardViewCell, forItemAt index: Int, direction: GXCardViewCell.SwipeDirection)
    @objc optional func cardView(_ cardView: GXCardView, didDisplay cell: GXCardViewCell, forItemAt index: Int)
    @objc optional func cardView(_ cardView: GXCardView, didMove cell: GXCardViewCell, forItemAt index: Int, move point: CGPoint, direction: GXCardViewCell.SwipeDirection)
}

class GXCardView: UIView {
    weak var dataSource: GXCardViewDataSource?
    weak var delegate: GXCardViewDelegate?
    private var nib: UINib?
    private var cellClass: GXCardViewCell.Type?
    private var identifier: String?
    
    private var visibleCells: [GXCardViewCell] {
        return self.containerView.subviews as! [GXCardViewCell]
    }
    
    private var _currentIndex: Int = 0
    private var currentIndex: Int {
        set {
            if self.cardViewLayout.isRepeat {
                let count = self.dataSource?.numberOfItems(in: self) ?? 0
                let maxIndex = count + self.cardViewLayout.visibleCount - 1
                _currentIndex = (newValue == maxIndex) ? 0 : newValue
            }
            else {
                _currentIndex = newValue
            }
        }
        get {
            return _currentIndex
        }
    }
    
    private(set) lazy var containerView: UIView = {
        let view = UIView(frame: self.bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        return view
    }()
    
    private(set) lazy var cardViewLayout: GXCardViewLayout = {
        return GXCardViewLayout()
    }()
    
    private lazy var reusableCells: [GXCardViewCell] = {
        return []
    }()
        
    convenience init(frame: CGRect = .zero, layout: GXCardViewLayout) {
        self.init(frame: frame)
        self.cardViewLayout = layout
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = self.bounds
    }
}

extension GXCardView {
    final func register<T: GXCardViewCell>(classCellType: T.Type) {
        self.cellClass = classCellType
        self.identifier = String(describing: classCellType)
    }
    final func register<T: GXCardViewCell>(nibCellType: T.Type) {
        let cellID = String(describing: nibCellType)
        self.identifier = cellID
        self.nib = UINib.init(nibName: cellID, bundle: nil)
    }
    final func dequeueReusableCell<T: GXCardViewCell>(cellType: T.Type = T.self) -> T {
        let cellID = String(describing: cellType)
        let bareCell = self.dequeueReusableCell(withReuseIdentifier: cellID)
        guard let cell = bareCell as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellID) matching type \(cellType.self). "
                    + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                    + "and that you registered the cell beforehand"
            )
        }
        return cell
    }
    private func dequeueReusableCell(withReuseIdentifier identifier: String) -> GXCardViewCell {
        for (index, cell) in self.reusableCells.enumerated() {
            if cell.reuseIdentifier == identifier {
                self.reusableCells.remove(at: index)
                return cell
            }
        }
        guard self.nib != nil||self.cellClass != nil else {
            fatalError("Failed to dequeue a cell with identifier \(identifier) matching type \(GXCardViewCell.self). ")
        }
        if self.nib != nil {
            let bareCell = self.nib?.instantiate(withOwner: nil, options: nil).first
            guard let cell = bareCell as? GXCardViewCell else {
                fatalError("Check that the reuseIdentifier is set properly in your XIB/Storyboard ")
            }
            cell.reuseIdentifier = identifier
            return cell
        }
        else {
            let cell = self.cellClass!.init()
            cell.setupCardViewCell(withReuseIdentifier: identifier)
            return cell
        }
    }
    var currentFirstIndex: Int {
        guard self.visibleCells.count > 0 else { return 0 }
        var index = self.currentIndex - self.visibleCells.count + 1
        if self.cardViewLayout.isRepeat && index < 0 {
            index = index + (self.dataSource?.numberOfItems(in: self) ?? 0)
        }
        return index
    }
    func cellForItem(at index: Int) -> GXCardViewCell? {
        let visibleIndex = self.visibleIndexAtIndex(index: index)
        guard (visibleIndex >= 0 && visibleIndex < self.visibleCells.count) else {
            return nil
        }
        return self.visibleCells[visibleIndex]
    }
    func removeTopCardViewCell(swipe direction: GXCardViewCell.SwipeDirection) {
        guard self.visibleCells.count > 0 else { return }
        let topCell = self.visibleCells.last
        topCell?.remove(swipe: direction)
    }
    func reloadData(animated: Bool = false, to index: Int? = nil) {
        self.reusableCells.removeAll()
        for subview in self.containerView.subviews {
            subview.removeFromSuperview()
        }
        let count = self.dataSource?.numberOfItems(in: self) ?? 0
        let fristIndex = (index == nil) ? self.currentFirstIndex : index!
        var showMaxCount = fristIndex + self.cardViewLayout.visibleCount
        if !self.cardViewLayout.isRepeat {
            showMaxCount = min(showMaxCount, count)
        }
        for i in fristIndex ..< showMaxCount {
            self.createCardViewCell(at: i, animated: animated)
        }
        self.updateLayoutVisibleCells(animated: animated)
    }
}

fileprivate extension GXCardView {
    func updateReusableCells(at cell: GXCardViewCell) {
        let isAdd = self.reusableCells.contains { (subCell) -> Bool in
            return subCell.reuseIdentifier == cell.reuseIdentifier
        }
        if !isAdd {
            self.reusableCells.append(cell)
        }
    }
    func visibleIndexAtIndex(index: Int) -> Int {
        if self.cardViewLayout.isRepeat && index < self.currentFirstIndex {
            let count = self.dataSource?.numberOfItems(in: self) ?? 0
            return index + count - self.currentFirstIndex
        }
        return index - self.currentFirstIndex
    }
    func cellTransform(at index: Int) -> CGAffineTransform {
        let toIndex = min(self.cardViewLayout.visibleCount - 1, index)
        let spaceWScale = 2.0 * self.cardViewLayout.lineSpacing / self.frame.width
        let spaceHScale = 2.0 * self.cardViewLayout.interitemSpacing / self.frame.height
        let wScale = 1.0 - spaceWScale * CGFloat(toIndex)
        let hScale = 1.0 - spaceHScale * CGFloat(toIndex)
        let yOffset = (self.cardViewLayout.interitemSpacing / hScale) * 2 * CGFloat(toIndex) - 1
        let scaleTransform = CGAffineTransform(scaleX: wScale, y: hScale)
        return scaleTransform.translatedBy(x: 0, y: yOffset)
    }
    func createCardViewCell(at index: Int, animated: Bool) {
        guard self.dataSource != nil else {
            fatalError("Interface dataSource that must be implemented.")
        }
        let count = self.dataSource?.numberOfItems(in: self) ?? 0
        let cellIndex = index % count
        let cell = self.dataSource!.cardView(self, cellForItemAt: cellIndex)
        cell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cell.isUserInteractionEnabled = false
        cell.index = cellIndex
        cell.maxRemoveDistance = self.cardViewLayout.maxRemoveDistance
        cell.maxAngle = self.cardViewLayout.maxAngle
        cell.cellDelegate = self
        
        let maxCount = animated ? (self.cardViewLayout.visibleCount - 1) : self.cardViewLayout.visibleCount
        let width = self.frame.width
        let height = self.frame.height - self.cardViewLayout.interitemSpacing * CGFloat(maxCount)
        cell.frame = CGRect(x: 0, y: 0, width: width, height: height)
        cell.transform = .identity
        let toIndex = animated ? (self.visibleCells.count + 1) : self.visibleCells.count
        cell.transform = self.cellTransform(at: toIndex)
        
        self.containerView.insertSubview(cell, at: 0)
        self.containerView.layoutIfNeeded()
        self.currentIndex = cellIndex
    }
    func updateLayoutVisibleCells(animated: Bool) {
        for (index, cell) in self.visibleCells.enumerated() {
            if (index == self.visibleCells.count - 1) {
                cell.isUserInteractionEnabled = true
                if (delegate?.responds(to: #selector(delegate?.cardView(_:didDisplay:forItemAt:))))! {
                    self.delegate?.cardView?(self, didDisplay: cell, forItemAt: cell.index)
                }
            }
            let showIndex = self.visibleCells.count - index - 1
            let transform = self.cellTransform(at: showIndex)
            if (animated) {
                UIView.animate(withDuration: GX_DefaultDuration) {
                    cell.transform = transform
                }
            } else {
                cell.transform = transform
            }
        }
    }
}

extension GXCardView: GXCardViewCellDelagate {
    func cardViewCell(_ cell: GXCardViewCell, didRemoveAt direction: GXCardViewCell.SwipeDirection) {
        let cellIndex = cell.index
        self.updateReusableCells(at: cell)

        let count = self.dataSource?.numberOfItems(in: self) ?? 0
        if self.cardViewLayout.isRepeat {
            self.createCardViewCell(at: self.currentIndex + 1, animated: true)
        }
        else {
            if self.currentIndex < count - 1 {
                self.createCardViewCell(at: self.currentIndex + 1, animated: true)
            }
        }
        self.updateLayoutVisibleCells(animated: true)

        if (delegate?.responds(to: #selector(delegate?.cardView(_:didRemove:forItemAt:direction:))))! {
            self.delegate?.cardView?(self, didRemove: cell, forItemAt: cellIndex, direction: direction)
        }
        if cellIndex == count - 1 {
            if (delegate?.responds(to: #selector(delegate?.cardView(_:didRemoveLast:forItemAt:direction:))))! {
                self.delegate?.cardView?(self, didRemoveLast: cell, forItemAt: cellIndex, direction: direction)
            }
        }
    }
    func cardViewCell(_ cell: GXCardViewCell, didMoveAt point: CGPoint, direction: GXCardViewCell.SwipeDirection) {
        if (delegate?.responds(to: #selector(delegate?.cardView(_:didMove:forItemAt:move:direction:))))! {
            self.delegate?.cardView?(self, didMove: cell, forItemAt: cell.index, move: point, direction: direction)
        }
    }
}
