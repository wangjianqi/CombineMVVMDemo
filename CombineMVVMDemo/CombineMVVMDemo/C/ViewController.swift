//
//  ViewController.swift
//  RxSwiftMVVMDemo
//
//  Created by wujuan on 2019/7/25.
//  Copyright © 2019 guahao. All rights reserved.
//

import UIKit
import Combine

@available(iOS 13.0, *)
class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel: DrugViewModel = DrugViewModel()
    var cellViewModels: [DrugCellViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configView()
        setupViewModel()
    }
    
    func configView() {
        self.title = "添加中草药"
        let resetBar = UIBarButtonItem(barButtonSystemItem:.refresh, target: self, action: #selector(resetAction))
        navigationItem.leftBarButtonItem = resetBar
        
        let addBar = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDrugAction))
        navigationItem.rightBarButtonItem = addBar
        tableView.register(UINib(nibName: CellIdentifiers.DrugTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.DrugTableViewCell)
    }
    
    func setupViewModel() {
        
        viewModel.$items.receive(on: RunLoop.main).sink { items in
            self.cellViewModels = items
            self.tableView.reloadData()
        }
        viewModel.$totalCount.receive(on: RunLoop.main).sink { value in
            self.titleLabel.text = value
        }
        
        viewModel.reloadDataSource()
    }
    
    @objc func resetAction() {
        viewModel.reloadDataSource()

    }
    
    @objc func addDrugAction() {
        //跳转到下一页
    }
}


@available(iOS 13.0, *)
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.DrugTableViewCell, for: indexPath)
       
        if let cell = cell as? DrugTableViewCell {
            let rowViewModel = cellViewModels[indexPath.row]
            print(rowViewModel)
            cell.setup(viewModel: rowViewModel)
            rowViewModel.editPublisher.receive(on: RunLoop.main).sink { vm in
                self.viewModel.editDrugCount(item: vm)
            }
            
            rowViewModel.deletePublisher.receive(on: RunLoop.main).sink { vm in
                self.viewModel.deleteDrug(item: vm)
            }
            
        }
        return cell
    }
}
