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
                        self.getNews()
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
                        self.tableView.reloadData()
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
        return 1 + self.news.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 195
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return self.taskCell(tableView: tableView, indexPath: indexPath)
        } else {
            let news = self.news[indexPath.row - 1]
            if news.medias.count == 0 {
                return self.news(tableView: tableView, indexPath: indexPath)
            } else {
                return self.newsWithMedia(tableView: tableView, indexPath: indexPath)
            }
        }
    }
    
}

// MARK: -
// MARK: - Cell create

fileprivate extension FeedController {
    
    func taskCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Cell.task.rawValue,
            for: indexPath) as! TaskTableViewCell
        cell.set(tasks: self.tasks)
        return cell
    }
    
    func newsWithMedia(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Cell.newsWithMedia.rawValue,
            for: indexPath) as! NewsWithMediaCell
        cell.set(news: self.news[indexPath.row - 1])
        return cell
    }
    
    func news(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Cell.news.rawValue,
            for: indexPath) as! NewsCell
        return cell
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension FeedController {
    
    enum Cell: String {
        case task = "TaskTableViewCell"
        case newsWithMedia = "NewsWithMediaCell"
        case news = "NewsCell"
    }
    
    enum Constant {
        static let cellSize = [Cell.task : CGFloat(195)]
    }
    
    func configure() {
        self.addPlusButton()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
        
    func addPlusButton() {
        let buttonSize = CGSize(width: 121, height: 116)
        let plusButton = UIButton()
        plusButton.setImage(#imageLiteral(resourceName: "plusButton"), for: .normal)
        plusButton.frame = CGRect(
            x: (UIScreen.main.bounds.width - buttonSize.width) / 2,
            y: UIScreen.main.bounds.height - 110,
            width: buttonSize.width,
            height: buttonSize.height)
        self.navigationController?.view.addSubview(plusButton)
    }
    
}

