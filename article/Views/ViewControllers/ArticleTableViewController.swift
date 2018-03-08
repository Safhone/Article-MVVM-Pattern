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
    
    private let paginationIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private var loadingIndicatorView    = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    private var increasePage = 1
    private var newFetchBool = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.articleListViewModel = ArticleListViewModel()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.preservesSuperviewLayoutMargins   = false
        tableView.separatorInset                    = UIEdgeInsets.zero
        tableView.layoutMargins                     = UIEdgeInsets.zero
        tableView.tableFooterView                   = UIView()
        tableView.estimatedRowHeight                = 111
        tableView.rowHeight                         = UITableViewAutomaticDimension

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "News"
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: NSNotification.Name("reloadData"), object: nil)
        
    }

    @objc func reloadTableView(_ notification: Notification) {
        fetchData(atPage: 1, withLimitation: 15)
        self.increasePage = 1
        
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchData(atPage: 1, withLimitation: 15)
        self.increasePage = 1
        
    }
    
    private func fetchData(atPage: Int, withLimitation: Int) {
        self.articleListViewModel?.getArticle(atPage: atPage, withLimitation: withLimitation) {
            self.loadingIndicatorView.stopAnimating()
            self.paginationIndicatorView.stopAnimating()
            self.refreshControl?.endRefreshing()
       
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.setContentOffset(.init(x: 0, y: -116), animated: true)
            }
            
        }
        
    }
    
    private func getArticleViewModelAt(index: Int) -> ArticleViewModel {
        return (articleListViewModel?.articleAt(index: index))!
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.articleListViewModel?.articleViewModel != nil {
            if (articleListViewModel?.articleViewModel.count)! > 0 {
                self.tableView.separatorStyle = .singleLine
            } else {
                self.tableView.separatorStyle = .none
                return (articleListViewModel?.articleViewModel.count)!
            }
            return (articleListViewModel?.articleViewModel.count)!
        }
        
        return 0

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ArticleTableViewCell
        
        DispatchQueue.main.async {
            cell.configureCell(articleViewModel: self.getArticleViewModelAt(index: indexPath.row))
        }
        
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
        
        newsStoryBoard.newsImage        = self.getArticleViewModelAt(index: indexPath.row).image
        newsStoryBoard.newsTitle        = self.getArticleViewModelAt(index: indexPath.row).title
        newsStoryBoard.newsDescription  = self.getArticleViewModelAt(index: indexPath.row).description
        newsStoryBoard.newsDate         = self.getArticleViewModelAt(index: indexPath.row).created_date
        
        self.navigationController?.pushViewController(newsStoryBoard, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            let alert = UIAlertController(title: "Are you sure to delete?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                DispatchQueue.main.async {
                    self.articleListViewModel?.deleteArticle(id: self.getArticleViewModelAt(index: indexPath.row).id!)
                    self.articleListViewModel?.articleRemoveAt(index: indexPath.row)
                    self.tableView.reloadData()
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, index) in
            if let addViewController = self.storyboard?.instantiateViewController(withIdentifier: "addVC") as? AddArticleViewController {
                addViewController.newsID            = self.getArticleViewModelAt(index: indexPath.row).id!
                addViewController.newsTitle         = self.getArticleViewModelAt(index: indexPath.row).title!
                addViewController.newsDescription   = self.getArticleViewModelAt(index: indexPath.row).description!
                addViewController.newsImage         = self.getArticleViewModelAt(index: indexPath.row).image
                addViewController.isUpdate          = true
                
                self.navigationController?.pushViewController(addViewController, animated: true)
            }
        }
        return [delete, edit]
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        
        if (bottomEdge >= scrollView.contentSize.height) {
            if decelerate && newFetchBool >= 1 && scrollView.contentOffset.y >= self.view.frame.height {
                self.increasePage += 1
                self.tableView.layoutIfNeeded()
                self.tableView.tableFooterView              = paginationIndicatorView
                self.tableView.tableFooterView?.isHidden    = false
                self.tableView.tableFooterView?.center      = paginationIndicatorView.center
                self.paginationIndicatorView.startAnimating()
                fetchData(atPage: increasePage, withLimitation: 15)
                self.newFetchBool = 0
            }
            
        } else if !decelerate {
            newFetchBool = 0
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
    
}
