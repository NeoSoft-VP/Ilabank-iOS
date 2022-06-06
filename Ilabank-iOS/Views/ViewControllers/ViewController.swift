//
//  ViewController.swift
//  Ilabank-iOS
//
//  Created by Neosoft on 06/06/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var searchBar: UISearchBar!
    var photoViewModel = PhotoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.initUI()
    }
    
    private func initUI() {
        
        // prepare list view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        
        // request data and start loader
        photoViewModel.showLoading = { [weak self] in
            self?.activityIndicator.startAnimating()
        }
        
        // loader will hide when request is completed
        photoViewModel.hideLoading = { [weak self] in
            self?.activityIndicator.stopAnimating()
            if let error = self?.photoViewModel.error {
                self?.showAlert(with: "Server Error", and: error)
            }
        }
        
        // if there is a succccess response reload table data
        photoViewModel.reloadTableView = {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return UIView(frame: CGRect.zero)
        }
        
        let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60)
        let view = UIView(frame: rect)
        view.backgroundColor = .white
        
        // Prepare search bar
        let rectSearch = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 51)
        searchBar = UISearchBar(frame: rectSearch)
        searchBar.showsCancelButton = true
        searchBar.autoresizingMask = UIView.AutoresizingMask.flexibleRightMargin;
        searchBar.placeholder = "Enter your search keywords here..."
        searchBar.delegate = self
    
        view.addSubview(searchBar)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 60
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        return self.photoViewModel.isSearching ? self.photoViewModel.filterPhotos.count : (self.photoViewModel.photos?.count ?? 0)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // load horizontal Corousal Collection Cell
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "corousalCell", for: indexPath) as! CorousalTableViewCell
            cell.delegate = self
            return cell
        }
        
        // load list data cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageDetailTableViewCell
        cell.prepareCell(with: self.photoViewModel, at: indexPath);
        return cell
    }
}

extension ViewController: CorousalProtocol {
    
    //when user swipe left or right, table list content should change accordingly.
    func slide(with index: Int) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.photoViewModel.isSearching = false
        
        let data = self.photoViewModel.slideData[index].data
        self.photoViewModel.photos = data
        self.tableView.reloadData()
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchString = searchBar.searchTextField.text else { return }
        searchBar.resignFirstResponder()
        self.photoViewModel.filterPhotos = self.photoViewModel.searchBy(searchString)
        self.tableView.reloadData()
        
        searchBar.text = searchString
    }
    
    // when there is a text in search bar paint filtered data
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchString = searchBar.searchTextField.text else { return }
        self.photoViewModel.filterPhotos = self.photoViewModel.searchBy(searchString)
        if self.photoViewModel.filterPhotos.count == 0 {
            print("No result found")
            self.photoViewModel.isSearching = false
            searchBar.text = ""
            if !searchString.isEmpty {
                self.showAlert(with: "No result found!", and: "Use more specific keywords and try again!")
            }
        } else {
            searchBar.text = searchString
        }
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.photoViewModel.isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    // when there is a text in search bar paint filtered data
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            print("No result found")
            self.photoViewModel.isSearching = false
            searchBar.text = ""
        } else {
            self.photoViewModel.isSearching = true
            self.photoViewModel.filterPhotos = self.photoViewModel.searchBy(searchText)
        }
        self.tableView.reloadData()
    }
    
}
