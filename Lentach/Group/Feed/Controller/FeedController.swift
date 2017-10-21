//
//  ViewController.swift
//  Lentach
//
//  Created by Dzianis Baidan on 20.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit
import Moya
import SVProgressHUD
import SwiftyJSON
import ObjectMapper

class FeedController: UIViewController {

    // - UI
    @IBOutlet weak var tableView: UITableView!
    
    // - Data
    fileprivate let provider = MoyaProvider<ServerService>()
    fileprivate var tasks = [TaskModel]()
    fileprivate var news = [NewsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.getTasks()
    }
    
}

// MARK: -
// MARK: - Get data

fileprivate extension FeedController {
    
    func getTasks() {
        self.provider.request(.listOfTask) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    let json = JSON(moyaResponse.data).object
                    if let tasks = Mapper<TaskModel>().mapArray(JSONObject: json) {
                        self.tasks = tasks
                    }
                } else {
                    SVProgressHUD.showError(withStatus: "Ошибка")
                }
            case .failure(_):
                SVProgressHUD.showError(withStatus: "Ошибка")
            }
        }
    }
    
    func getNews() {
        self.provider.request(.listOfNews) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    let json = JSON(moyaResponse.data).object
                    if let news = Mapper<NewsModel>().mapArray(JSONObject: json) {
                        self.news = news
                    }
                } else {
                    SVProgressHUD.showError(withStatus: "Ошибка")
                }
            case .failure(_):
                SVProgressHUD.showError(withStatus: "Ошибка")
            }
        }
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

