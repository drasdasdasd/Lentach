//
//  TaskTableViewCell.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
    }

}

// MARK: -
// MARK: - Collection View data source

extension TaskTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Cell.task.rawValue,
            for: indexPath) as! TaskCollectionViewCell
        return cell
    }
    
}

// MARK: -
// MARK: - Constatn

extension TaskTableViewCell {
    
    enum Cell: String {
        case task = "TaskCollectionViewCell"
    }
    
}
