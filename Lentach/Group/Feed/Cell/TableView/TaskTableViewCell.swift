//
//  TaskTableViewCell.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    // - UI
    @IBOutlet weak var collectionView: UICollectionView!
    
    // - Data
    var tasks = [TaskModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func set(tasks: [TaskModel]) {
        self.tasks = tasks
        self.collectionView.reloadData()
    }

}

// MARK: -
// MARK: - Collection View data source

extension TaskTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Cell.task.rawValue,
            for: indexPath) as! TaskCollectionViewCell
        cell.set(task: self.tasks[indexPath.row])
        return cell
    }
    
}

// MARK: -
// MARK: - Collection View data source

extension TaskTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let celHeight = CGFloat(194)
        return CGSize(width: collectionView.frame.size.width, height: celHeight)
    }
    
}


// MARK: -
// MARK: - Constatn

extension TaskTableViewCell {
    
    enum Cell: String {
        case task = "TaskCollectionViewCell"
    }
    
}
