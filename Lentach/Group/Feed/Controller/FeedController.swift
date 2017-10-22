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
    fileprivate var plusButton: UIButton!
    
    // - Data
    fileprivate let provider = MoyaProvider<ServerService>()
    fileprivate var tasks = [TaskModel]()
    fileprivate var news = [NewsModel]()
    fileprivate var user = UserDefaultsManager().getUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.getTasks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addPlusButton()
        self.getTasks()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.plusButton.removeFromSuperview()
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
                        self.news = news.reversed()
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
// MARK: - Vote

fileprivate extension FeedController {
    
    func vote(isUp: Bool, news: NewsModel) {
        SVProgressHUD.show()
        self.provider.request(.vote(isUp: isUp, newsId: news.id)) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    news.rating.isVoted = true
                    if isUp {
                        news.rating.up += 1
                    } else {
                        news.rating.down += 1
                    }
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = self.news[indexPath.row - 1]
        let browser = MediaCreator().browser(news: news)
        self.navigationController?.pushViewController(browser, animated: true)
    }
    
}

// MARK: -
// MARK: - Push main controller

fileprivate extension FeedController {
    
    func pusTaskController(task: TaskModel) {
        let controller = UIStoryboard(storyboard: .task).instantiateInitialViewController() as! TaskController
        controller.task = task
        self.navigationController?.pushViewController(controller, animated: true)
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
        cell.pushTaskControllerHandler = { self.pusTaskController(task: $0) }
        return cell
    }
    
    func newsWithMedia(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Cell.newsWithMedia.rawValue,
            for: indexPath) as! NewsWithMediaCell
        cell.set(news: self.news[indexPath.row - 1])
        cell.voteHandler = { self.vote(isUp: $0, news: $1) }
        return cell
    }
    
    func news(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Cell.news.rawValue,
            for: indexPath) as! NewsCell
        cell.set(news: self.news[indexPath.row - 1])
        cell.voteHandler = { self.vote(isUp: $0, news: $1) }
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
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
        
    func addPlusButton() {
        let buttonSize = CGSize(width: 121, height: 116)
        plusButton = UIButton()
        plusButton.setImage(#imageLiteral(resourceName: "plusButton"), for: .normal)
        plusButton.frame = CGRect(
            x: (UIScreen.main.bounds.width - buttonSize.width) / 2,
            y: UIScreen.main.bounds.height - 110,
            width: buttonSize.width,
            height: buttonSize.height)
        plusButton.addTarget(self, action: #selector(self.plusButtonAction(_:)), for: .touchDown)
        self.navigationController?.view.addSubview(plusButton)
    }
    
    @objc func plusButtonAction(_ button: UIButton) {
        let cameraController = UIStoryboard(storyboard: .camera).instantiateInitialViewController()
        self.navigationController?.pushViewController(cameraController!, animated: true)
    }
    
}

