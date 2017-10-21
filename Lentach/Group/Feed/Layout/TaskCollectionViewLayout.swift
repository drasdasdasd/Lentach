//
//  TaskCollectionViewLayout.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit

class TaskCollectionViewLayout: UICollectionViewLayout {
    
    var itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 130) {
        didSet {
            invalidateLayout()
        }
    }
    
    var currentIndex = 0
    
    private var cellCount = 0
    private var boundsSize = CGSize(width: 0, height: 0)
    
    public override func prepare() {
        self.cellCount = self.collectionView!.numberOfItems(inSection: 0)
        self.boundsSize = self.collectionView!.bounds.size
    }
    
    public override var collectionViewContentSize: CGSize {
        let verticalItemsCount = Int(floor(boundsSize.height / itemSize.height))
        let horizontalItemsCount = Int(floor(boundsSize.width / itemSize.width))
        
        let itemsPerPage = verticalItemsCount * horizontalItemsCount
        let numberOfItems = cellCount
        let numberOfPages = Int(ceil(Double(numberOfItems) / Double(itemsPerPage)))
        
        var size = boundsSize
        size.width = CGFloat(numberOfPages) * boundsSize.width
        return size
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var allAttributes = [UICollectionViewLayoutAttributes]()
        for i in 0...(cellCount-1) {
            let indexPath = IndexPath(row: i, section: 0)
            let attr = self.computeLayoutAttributesForCellAt(indexPath: indexPath)
            allAttributes.append(attr)
        }
        return allAttributes
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return computeLayoutAttributesForCellAt(indexPath: indexPath)
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    private func computeLayoutAttributesForCellAt(indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
            let row = indexPath.row
            let bounds = self.collectionView!.bounds
            
            let verticalItemsCount = Int(floor(boundsSize.height / itemSize.height))
            let horizontalItemsCount = Int(floor(boundsSize.width / itemSize.width))
            let itemsPerPage = verticalItemsCount * horizontalItemsCount
            
            let columnPosition = row % horizontalItemsCount
            let rowPosition = (row/horizontalItemsCount)%verticalItemsCount
            let itemPage = Int(floor(Double(row)/Double(itemsPerPage)))
            
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
            var frame = CGRect()
            if indexPath.row == 0 {
                frame.origin.x = CGFloat(itemPage) * bounds.size.width + CGFloat(columnPosition) * itemSize.width + 20
            } else {
                frame.origin.x = CGFloat(itemPage) * bounds.size.width + CGFloat(columnPosition) * itemSize.width + 20
            }
            frame.origin.y = CGFloat(rowPosition) * itemSize.height + 25
            frame.size = itemSize
            attr.frame = frame
            
            return attr
    }
    
}
