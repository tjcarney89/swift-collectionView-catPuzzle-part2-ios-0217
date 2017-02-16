//
//  PuzzleCollectionViewController.swift
//  CollectionViewCatPicPuzzle
//
//  Created by Joel Bell on 10/5/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import GameKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var headerReusableView: HeaderReusableView!
    var footerReusableView: FooterReusableView!
    var imageSlices: [UIImage] = []
    var correctOrder: [UIImage] = []
    
    
    var sectionInsets: UIEdgeInsets!
    var spacing: CGFloat!
    var itemSize: CGSize!
    var referenceSize: CGSize!
    var numberOfRows: CGFloat!
    var numberOfColumns: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        self.collectionView?.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        self.collectionView?.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        
        for i in 1...12 {
            imageSlices.append(UIImage(named: "\(i)")!)
        }
        
        correctOrder = imageSlices
        
        randomize()
       print("ORIGINAL: \(imageSlices)")
//        print("CORRECT: \(correctOrder)")
        
        
        
   
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSlices.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "puzzleCell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.image = imageSlices[indexPath.item]
        
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
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
       
        

//        print("CURRENT ARRAY: \(imageSlices)")
//        print("CORRECT: \(correctOrder)")
        
//        collectionView.performBatchUpdates({
        
        
        let comingFromIndex = sourceIndexPath.item
        let goingToIndex = destinationIndexPath.item
        let itemFromArray = imageSlices.remove(at: comingFromIndex)
        imageSlices.insert(itemFromArray, at: goingToIndex)
        
        
        
        if imageSlices == correctOrder {
            print("WINNER!")
            footerReusableView.timerLabel.isHidden = true
            performSegue(withIdentifier: "solvedSegue", sender: nil)
        }
            
            
            
//        }, completion: { success in
            
            

        
 //       })
        
        print("CURRENT: \(imageSlices)")
        print("CORRECT: \(correctOrder)")
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SolvedViewController, let indexPath = collectionView?.indexPathsForSelectedItems {
            dest.image = UIImage(named: "cats")
            dest.time = footerReusableView.timerLabel.text
        }
    }
    
    
    
    func configureLayout() {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        
        numberOfRows = 4
        numberOfColumns = 3
        spacing = 2
        sectionInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        referenceSize = CGSize(width: width, height: 60)
        
        
        let headerHeight = referenceSize.height
        let footerHeight = referenceSize.height

        let itemWidth = (width - ((numberOfColumns - 1)*(spacing) + sectionInsets.left + sectionInsets.right))/numberOfColumns
        let itemHeight = (height - ((numberOfRows - 1)*(spacing) + sectionInsets.top + sectionInsets.bottom + headerHeight + footerHeight))/numberOfRows
        
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    func randomize() -> [UIImage] {
        imageSlices = GKRandomSource().arrayByShufflingObjects(in: imageSlices) as! [UIImage]
        return imageSlices
        
    }
    
    
}
