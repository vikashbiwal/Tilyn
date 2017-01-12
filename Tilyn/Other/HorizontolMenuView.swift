//
//  HorizontolMenuView.swift
//  Tilyn
//
//  Created by Yudiz Solutions Pvt. Ltd. on 29/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class HorizontolMenuView: UIView {

    @IBOutlet var collView: UICollectionView!
    let cellWidth = _screenSize.width / 3
   
    fileprivate var items = [MenuItem]()
    
    var actionBlock: (Int)-> Void = {_ in}
    
    //menuItems variable is used to access data from users to display in collection view
    var menuItems: [MenuItem] {
        set {
            self.items = newValue
            self.items.insert(MenuItem(""), at: 0)
            self.items.append(MenuItem(""))
        }
        
        get {
            return items
        }
    }
    
    override func awakeFromNib() {
        collView.register(UINib.init(nibName: "HorizontolMenuCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
    }

   //MARK: Public Function
    //load and add it in desire view.
    class func  loadFromNib()-> HorizontolMenuView {
        let views = Bundle.main.loadNibNamed("HorizontolMenuView", owner: nil, options: nil)
        let hmView = views!.first as! HorizontolMenuView
        //hmView.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        //hmView.layoutIfNeeded()
        return hmView
    }
    
    //Scroll collectionview at specified indexpath
    func scrollAtIndexPath(index: Int) {
        let itemIndex = index + 1
        let indexPath = IndexPath(item: itemIndex, section: 0)
        collView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        resetCellItems()
        
        let item = items[indexPath.row]
        item.selected = true
        
        if let selectedCell = collView.cellForItem(at: indexPath) as? ItemCell {
            selectedCell.lblTitle.font = selectedCell.lblTitle.font.withSize(14 * _widthRatio)
        }

    }
}

//MARK: CollectionView DataSource and Delegate
extension HorizontolMenuView :  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCell
        let item = items[indexPath.row]
        cell.lblTitle.text = item.title
        cell.lblTitle.font = cell.lblTitle.font.withSize((item.selected ? 14  : 12) * _widthRatio)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
        
        if [0, collectionView.numberOfItems(inSection: 0) - 1].contains(indexPath.row) {
            return
        }
        
        resetCellItems()
       
        let item = items[indexPath.row]
        item.selected = true
       
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ItemCell
        selectedCell.lblTitle.font = selectedCell.lblTitle.font.withSize(14 * _widthRatio)
        actionBlock(indexPath.row - 1)
        collView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: self.frame.height)
    }
    
    //Reset all item
    func resetCellItems() {
        items.forEach { (item)  in
            item.selected = false
        }

        let visibleCells = collView.visibleCells as! [ItemCell]
        visibleCells.forEach { (cell) in
            cell.lblTitle.font = cell.lblTitle.font.withSize(12 * _widthRatio)
        }
    }
}

//Cell
class ItemCell: CollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class MenuItem {
    var title = ""
    var imageName = ""
    var selected = false
    
    init(_ title: String,  imageName: String = "",  selected: Bool = false) {
        self.title = title
        self.imageName = imageName
        self.selected = selected
    }
}


class CenterCellCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        if let cv = self.collectionView {
            
            let cvBounds = cv.bounds
            let halfWidth = cvBounds.size.width * 0.5;
            let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth;
            
            if let attributesForVisibleCells = self.layoutAttributesForElements(in: cvBounds) {
                
                var candidateAttributes : UICollectionViewLayoutAttributes?
                for attributes in attributesForVisibleCells {
                    
                    // == Skip comparison with non-cell items (headers and footers) == //
                    if attributes.representedElementCategory != UICollectionElementCategory.cell {
                        continue
                    }
                    
                    if (attributes.center.x == 0) || (attributes.center.x > (cv.contentOffset.x + halfWidth) && velocity.x < 0) {
                        continue
                    }
                    
                    // == First time in the loop == //
                    guard let candAttrs = candidateAttributes else {
                        candidateAttributes = attributes
                        continue
                    }
                    
                    let a = attributes.center.x - proposedContentOffsetCenterX
                    let b = candAttrs.center.x - proposedContentOffsetCenterX
                    
                    if fabsf(Float(a)) < fabsf(Float(b)) {
                        candidateAttributes = attributes;
                    }
                }
                
                // Beautification step , I don't know why it works!
                if(proposedContentOffset.x == -(cv.contentInset.left)) {
                    return proposedContentOffset
                }
                
                return CGPoint(x: floor(candidateAttributes!.center.x - halfWidth), y: proposedContentOffset.y)
            }
        }
        
        // fallback
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
    }
    
}
