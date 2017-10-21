//
//  ViewController.swift
//  Lentach
//
//  Created by Dzianis Baidan on 20.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit

class FeedController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
}

// MARK: -
// MARK: - Feed

extension FeedController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 195
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.taskCell(tableView: tableView, indexPath: indexPath)
    }
    
}

// MARK: -
// MARK: - Cell create

fileprivate extension FeedController {
    
    func taskCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Cell.task.rawValue,
            for: indexPath) as! TaskTableViewCell
        return cell
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension FeedController {
    
    enum Cell: String {
        case task = "TaskTableViewCell"
    }
    
    enum Constant {
        static let cellSize = [Cell.task : CGFloat(195)]
    }
    
    func configure() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
}

