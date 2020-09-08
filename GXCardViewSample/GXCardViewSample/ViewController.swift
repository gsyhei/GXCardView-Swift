//
//  ViewController.swift
//  GXCardViewSample
//
//  Created by Gin on 2020/8/5.
//  Copyright © 2020 gin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var cardView: GXCardCView!
    var cellCount: Int = 10
    
    private lazy var cardLayout: GXCardLayout = {
        let layout = GXCardLayout()
        layout.visibleCount = 4
        layout.maxAngle = 15.0
        layout.isRepeat = false
        layout.maxRemoveDistance = self.cardView.frame.width/4
        layout.cardInsets = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: 10)
        
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cardView.dataSource = self
        self.cardView.delegate = self
        self.cardView.setCardLayout(cardLayout: self.cardLayout)
        self.cardView.register(nibCellType: GXCardTestCell.self)
        self.cardView.reloadData()
    }
    
    @IBAction func leftButtonClicked(_ sender: Any?) {
        self.cardView.removeTopCardViewCell(swipe: .left)
    }
    
    @IBAction func rightButtonClick(_ sender: Any?) {
        self.cardView.removeTopCardViewCell(swipe: .right)
    }
    
    @IBAction func updateButtonClick(_ sender: Any?) {
        self.cardView.scrollToItem(at: self.cellCount/2, animated: true)
    }
    
    @IBAction func topChange(_ sender: UISlider) {
        self.topLabel.text = String(Int(sender.value))
        self.cardLayout.cardInsets.top = CGFloat(sender.value)
        self.cardView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func leftChange(_ sender: UISlider) {
        self.leftLabel.text = String(Int(sender.value))
        self.cardLayout.cardInsets.left = CGFloat(sender.value)
        self.cardView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func rightChange(_ sender: UISlider) {
        self.rightLabel.text = String(Int(sender.value))
        self.cardLayout.cardInsets.right = CGFloat(sender.value)
        self.cardView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func bottomChange(_ sender: UISlider) {
        self.bottomLabel.text = String(Int(sender.value))
        self.cardLayout.cardInsets.bottom = CGFloat(sender.value)
        self.cardView.collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension ViewController: GXCardCViewDataSource, GXCardCViewDelegate {
    // MARK: - GXCardViewDataSource
    func numberOfItems(in cardView: GXCardCView) -> Int {
        return self.cellCount
    }
    func cardView(_ cardView: GXCardCView, cellForItemAt indexPath: IndexPath) -> GXCardCell {
        let cell = cardView.dequeueReusableCell(for: indexPath, cellType: GXCardTestCell.self)
        cell.iconIView.image = UIImage(named: String(format: "banner%d.jpeg", indexPath.item%3))
        cell.numberLabel.text = String(indexPath.item)
        cell.leftLabel.isHidden = true
        cell.rightLabel.isHidden = true
        
        return cell
    }
    
    // MARK: - GXCardViewDelegate
    func cardView(_ cardView: GXCardCView, didRemoveLast cell: GXCardCell, forItemAt index: Int, direction: GXCardCell.SwipeDirection) {
        NSLog("didRemove forRowAtIndex = %d, direction = %d", index, direction.rawValue)
        if !cardView.cardLayout.isRepeat {
            cardView.reloadData()
            cardView.scrollToItem(at: 0, animated: false)
        }
    }
    func cardView(_ cardView: GXCardCView, didRemove cell: GXCardCell, forItemAt index: Int, direction: GXCardCell.SwipeDirection) {
        NSLog("didRemove forRowAtIndex = %d, direction = %d", index, direction.rawValue)
        if !cardView.cardLayout.isRepeat && index == 8 {
            self.cellCount = 20
            cardView.reloadData()
        }
    }
    func cardView(_ cardView: GXCardCView, didMove cell: GXCardCell, forItemAt index: Int, move point: CGPoint, direction: GXCardCell.SwipeDirection) {
        NSLog("move point = %@,  direction = %ld", point.debugDescription, direction.rawValue)
        if let toCell = cell as? GXCardTestCell {
            toCell.leftLabel.isHidden = !(direction == .right)
            toCell.rightLabel.isHidden = !(direction == .left)
        }
    }
    func cardView(_ cardView: GXCardCView, didDisplay cell: GXCardCell, forItemAt index: Int) {
        NSLog("didDisplay forRowAtIndex = %d", index)
    }
    func cardView(_ cardView: GXCardCView, didSelectItemAt index: Int) {
        NSLog("didSelectItemAt index = %d", index)
    }
}

