//
//  TweetsTabViewController.swift
//  GraySky
//
//  Created by Umut Konmuş on 29.01.2025.
//

import UIKit

class TweetsTabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetsTabViewModelDelegate {
    private let viewModel = TweetsTabViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TwitterTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self
        fetchData()
    }
    
    func fetchData() {
        viewModel.fetchData()
    }
    
    func didFetchData(_ data: [Entry]) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath) as? TwitterTableViewCell{
            cell.configure(with: viewModel.data[indexPath.row])
            cell.layer.borderColor = UIColor.black.cgColor
            cell.selectionStyle = .none
            return cell
            
        }
        return UITableViewCell()
    }

}
