//
//  PuzzleCollectionViewController.swift
//  CollectionViewCatPicPuzzle
//
//  Created by Joel Bell on 10/5/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var sectionInsets: UIEdgeInsets!
    var spacing: CGFloat!
    var itemSize: CGSize!
    var referenceSize: CGSize!
    var numberOfRows: CGFloat!
    var numberOfColumns: CGFloat!
    
    var headerReusableView: HeaderReusableView!
    var footerReusableView: FooterReusableView!
    
    var imageSlices: [UIImage] = []
    var solvedPuzzle: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        self.collectionView?.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        
        imageSlices = getImageSlices()
        solvedPuzzle = imageSlices
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        randomizeImageSlices()
        self.collectionView?.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        footerReusableView.startTimer()
    }
    
    func getImageSlices() -> [UIImage] {
        var slices: [UIImage] = []
        for number in 1...12 {
            slices.append(UIImage(named: String(number))!)
        }
        return slices
    }
    
    func randomizeImageSlices() {
        
        for index in 0..<imageSlices.count {
            let randomNumber = Int(arc4random_uniform(UInt32(imageSlices.count)))
            if randomNumber != index {
                swap(&imageSlices[index], &imageSlices[randomNumber])
            }
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSlices.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "puzzleCell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.image = imageSlices[indexPath.row]
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            
            headerReusableView = (self.collectionView?.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)) as! HeaderReusableView
            
            return headerReusableView
            
        } else {
            
            footerReusableView = (self.collectionView?.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)) as! FooterReusableView
            
            return footerReusableView
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        self.collectionView?.performBatchUpdates({
            
            let sourceImage = self.imageSlices.remove(at: sourceIndexPath.item)
            self.imageSlices.insert(sourceImage, at: destinationIndexPath.item)
            
            
            }, completion: { completed in
                
                if self.solvedPuzzle == self.imageSlices {
                    
                    self.footerReusableView.timer.invalidate()
                    self.performSegue(withIdentifier: "solvedSegue", sender: nil)
                    
                }
                
        })
        
    }
    
    func configureLayout() {
        
        var screenWidth: CGFloat { return UIScreen.main.bounds.size.width }
        var screenHeight: CGFloat { return UIScreen.main.bounds.size.height }
        
        numberOfRows = 4
        numberOfColumns = 3
        
        spacing = 2
        
        sectionInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let supplementaryViewHeight: CGFloat = 60
        let supplementaryViewWidth: CGFloat = screenWidth
        referenceSize = CGSize(width: supplementaryViewWidth, height: supplementaryViewHeight)
        
        var widthDeductionPerItem: CGFloat {
            
            let totalWidthInsets = sectionInsets.left + sectionInsets.right
            let totalMinimumSpacing = spacing * (numberOfColumns - 1)
            return (totalWidthInsets + totalMinimumSpacing) / numberOfColumns
            
        }
        var heightDeductionPerItem: CGFloat {
            
            let totalHeightInsets = sectionInsets.top + sectionInsets.bottom
            let totalMinimumSpacing = spacing * (numberOfRows - 1)
            let totalHeaderFooter = supplementaryViewHeight * 2
            return (totalHeightInsets + totalMinimumSpacing + totalHeaderFooter) / numberOfRows
            
        }
        
        let itemWidth: CGFloat = screenWidth/numberOfColumns - widthDeductionPerItem
        let itemHeight: CGFloat = screenHeight/numberOfRows - heightDeductionPerItem
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return referenceSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return referenceSize
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "solvedSegue" {
            
            let destinationVC = segue.destination as! SolvedViewController
            destinationVC.image = UIImage(named: "cats")
            destinationVC.time = footerReusableView.timerLabel.text
            
        }
        
    }
    
    
    
}
