//
//  ViewController.swift
//  article
//
//  Created by Safhone on 3/5/18.
//  Copyright © 2018 Safhone. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleTableViewController: UITableViewController {

    private var articleListViewModel: ArticleListViewModel?
    private var articleViewModel    : [ArticleViewModel]?
    
    private let paginationIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private var loadingIndicatorView    = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    private var increasePage = 1
    private var newFetchBool = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.articleListViewModel = ArticleListViewModel()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.preservesSuperviewLayoutMargins = false
        tableView.separatorInset                  = UIEdgeInsets.zero
        tableView.layoutMargins                   = UIEdgeInsets.zero
        tableView.tableFooterView                 = UIView()
        tableView.estimatedRowHeight              = 110
        tableView.rowHeight                       = UITableViewAutomaticDimension

        fetchData(atPage: increasePage, withLimitation: 15)
        
        let x = self.view.frame.width / 2
        let y = self.view.frame.height / 2
        
        loadingIndicatorView.center           = CGPoint(x: x, y: y - 100)
        loadingIndicatorView.hidesWhenStopped = true
        view.addSubview(loadingIndicatorView)
        loadingIndicatorView.startAnimating()
        
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.gray]
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to Refresh", attributes: attributes)
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl!)
        
    }

    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchData(atPage: 1, withLimitation: 15)
        self.increasePage = 1
        
    }
    
    private func fetchData(atPage: Int, withLimitation: Int) {
        self.articleListViewModel?.getArticle(atPage: atPage, withLimitation: withLimitation) {
            if atPage != 1 {
                self.articleViewModel? += (self.articleListViewModel?.articleViewModel)!
            } else {
                self.articleViewModel = []
                self.articleViewModel = self.articleListViewModel?.articleViewModel
            }

            self.loadingIndicatorView.stopAnimating()
            self.paginationIndicatorView.stopAnimating()
            self.refreshControl?.endRefreshing()

            self.tableView.reloadData()
            self.tableView.setContentOffset(.init(x: 0, y: -116), animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articleViewModel != nil {
            if (articleViewModel?.count)! > 0 {
                self.tableView.separatorStyle = .singleLine
            } else {
                self.tableView.separatorStyle = .none
                return (articleViewModel?.count)!
            }
            return (articleViewModel?.count)!
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ArticleTableViewCell
        cell.configureCell(articleViewModel: articleViewModel![indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        newFetchBool = 0
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        newFetchBool += 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsStoryBoard = self.storyboard?.instantiateViewController(withIdentifier: "newsVC") as! NewsViewController
        
        newsStoryBoard.newsImage       = self.articleViewModel![indexPath.row].image
        newsStoryBoard.newsTitle       = self.articleViewModel![indexPath.row].title
        newsStoryBoard.newsDescription = self.articleViewModel![indexPath.row].description
        newsStoryBoard.newsDate        = self.articleViewModel![indexPath.row].created_date?.formatDate(getTime: true)
        
        self.navigationController?.pushViewController(newsStoryBoard, animated: true)
        
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        
        if (bottomEdge >= scrollView.contentSize.height) {
            if decelerate && newFetchBool >= 1 && scrollView.contentOffset.y >= self.view.frame.height && articleListViewModel?.articleViewModel.count != 0 {
                self.increasePage += 1
                self.tableView.layoutIfNeeded()
                self.tableView.tableFooterView           = paginationIndicatorView
                self.tableView.tableFooterView?.isHidden = false
                self.tableView.tableFooterView?.center   = paginationIndicatorView.center
                self.paginationIndicatorView.startAnimating()
                fetchData(atPage: increasePage, withLimitation: 15)
                self.newFetchBool = 0
            }
            
        } else if !decelerate {
            newFetchBool = 0
        }
        
    }

}

