//
//  ViewController.swift
//  GXCardViewSample
//
//  Created by Gin on 2020/8/5.
//  Copyright © 2020 gin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cardView: GXCardView!
    var cellCount: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cardView.dataSource = self
        self.cardView.delegate = self
        self.cardView.cardViewLayout.visibleCount = 5
        self.cardView.cardViewLayout.lineSpacing = 15.0
        self.cardView.cardViewLayout.interitemSpacing = 10.0
        self.cardView.cardViewLayout.maxAngle = 15.0
        self.cardView.cardViewLayout.maxRemoveDistance = 100.0
        self.cardView.cardViewLayout.isRepeat = true
        
        self.cardView.register(nibCellType: GXCardViewTestCell.self)
        self.cardView.reloadData(animated: true)
    }
    
    @IBAction func leftButtonClicked(_ sender: Any?) {
        self.cardView.removeTopCardViewCell(swipe: .left)
    }
    
    @IBAction func rightButtonClick(_ sender: Any?) {
        self.cardView.removeTopCardViewCell(swipe: .right)
    }
    
    @IBAction func updateButtonClick(_ sender: Any?) {
        self.cardView.reloadData(animated: true, to: self.cellCount/2)
    }
}

extension ViewController: GXCardViewDataSource, GXCardViewDelegate {
    // MARK: - GXCardViewDataSource
    func numberOfItems(in cardView: GXCardView) -> Int {
        return self.cellCount
    }
    func cardView(_ cardView: GXCardView, cellForItemAt index: Int) -> GXCardViewCell {
        let cell = cardView.dequeueReusableCell(cellType: GXCardViewTestCell.self)
        cell.iconIView.image = UIImage(named: String(format: "banner%d.jpeg", index%3))
        cell.numberLabel.text = String(index)
        cell.leftLabel.isHidden = true
        cell.rightLabel.isHidden = true
        
        return cell
    }
    // MARK: - GXCardViewDelegate
    func cardView(_ cardView: GXCardView, didRemoveLast cell: GXCardViewCell, forItemAt index: Int, direction: GXCardViewCell.SwipeDirection) {
        NSLog("didRemove forRowAtIndex = %d, direction = %d", index, direction.rawValue)
        if !cardView.cardViewLayout.isRepeat {
            cardView.reloadData(animated: true)
        }
    }
    func cardView(_ cardView: GXCardView, didRemove cell: GXCardViewCell, forItemAt index: Int, direction: GXCardViewCell.SwipeDirection) {
        NSLog("didRemove forRowAtIndex = %d, direction = %d", index, direction.rawValue)
        if !cardView.cardViewLayout.isRepeat && index == 8 {
            self.cellCount = 20
            cardView.reloadData(animated: true)
        }
    }
    func cardView(_ cardView: GXCardView, didDisplay cell: GXCardViewCell, forItemAt index: Int) {
        NSLog("didDisplay forRowAtIndex = %d", index)
    }
    func cardView(_ cardView: GXCardView, didMove cell: GXCardViewCell, forItemAt index: Int, move point: CGPoint, direction: GXCardViewCell.SwipeDirection) {
        NSLog("move point = %@,  direction = %ld", point.debugDescription, direction.rawValue)
        if let toCell = cell as? GXCardViewTestCell {
            toCell.leftLabel.isHidden = !(direction == .right)
            toCell.rightLabel.isHidden = !(direction == .left)
        }
    }
}

