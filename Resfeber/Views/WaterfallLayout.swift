//
//  WaterfallLayout.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 11/9/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

protocol WaterfallLayoutDelegate: AnyObject {
    
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class WaterfallLayout: UICollectionViewLayout {
    
    // MARK: - Properties
    weak var delegate: WaterfallLayoutDelegate?
    private let numberOfColumns = 2 // For Pinterest-style waterfall layout, there are 2 columns
    private let cellPadding: CGFloat = 6
    private var cache: [UICollectionViewLayoutAttributes] = [] // Array to cache calculated attributes
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        
        guard let collectionView = collectionView else {
            return 0
        }
        
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // MARK: Methods
    
    override func prepare() {
        // Check if cache is empty. Only calculates layout attributes if empty.
        guard cache.isEmpty,
              let collectionView = collectionView
        else {
            return
        }
        
        // Calculate xOffset and yOffset arrays for each column
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        // Loops through all items in section. Only one section in this layout.
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            // Set indexPath
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate?.collectionView(
                collectionView,
                heightForPhotoAtIndexPath: indexPath) ?? 180 // 180 is default cell height if no delegate set
            
            let height = cellPadding * 2 + photoHeight
        
            
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // Creates an instance of UICollectionViewLayoutAttributes, sets the frame and appends attributes to cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // Sets contenHeight to account for frame of new calculated item
            contentHeight = max(contentHeight, frame.maxY)
            
            // Advances yOffset based on the new frame
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect)
    -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
    -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
}
