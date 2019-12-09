//
//  DrugViewModel.swift
//  RxSwiftMVVMDemo
//
//  Created by wujuan on 2019/7/25.
//  Copyright © 2019 guahao. All rights reserved.
//

import UIKit
import Combine

@available(iOS 13.0, *)
class DrugViewModel: ObservableObject {
    // 数据源
    @Published var items: [DrugCellViewModel] = []
    @Published var totalCount: String = ""
    // 获取数据
    func reloadDataSource() {
        self.request().sink { (items) in
            self.items = items
            self.totalCount = self.getTotalCount(items: items)
        }
    }
    
    func editDrugCount(item: DrugCellViewModel) {
        var arr = [DrugCellViewModel]()
        for model in self.items {
            if model.drugModel.drugId == item.drugModel.drugId {
                arr.append(item)
            } else {
                // 保存
                arr.append(model)
            }
        }
        self.items = arr
        self.totalCount = self.getTotalCount(items: self.items)
    }
    
    func deleteDrug(item: DrugCellViewModel) {
        if let index = self.items.firstIndex(of:item) {
            self.items.remove(at:index)
            self.totalCount = self.getTotalCount(items: self.items)
        }
    }

    func getTotalCount(items: [DrugCellViewModel]) -> String {
        var sum = 0;
        var priceSum = 0.00;

        for cellViewModel in items {
            sum += cellViewModel.drugModel.drugCount
            let price : Double =  (cellViewModel.drugModel.maxPrice) * Double(cellViewModel.drugModel.drugCount)
            priceSum += price
        }
        return "共\(items.count)味药，\(sum)g，药品参考总价:\(priceSum)元"
    }
    
    func request() -> AnyPublisher<[DrugCellViewModel], Never> {
        
        let path = Bundle.main.path(forResource: "drugList", ofType: "json")!
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let drugs: Drugs = try JSONDecoder().decode(Drugs.self, from: data )
            var viewModels = [DrugCellViewModel]()
            for drug in drugs.items {
                viewModels.append(DrugCellViewModel.init(drugModel: drug))
            }
            let pub = Just<[DrugCellViewModel]>(viewModels)
            return pub.eraseToAnyPublisher()

        }catch let error{
            print("读取本地数据错误",error)
            return Just([]).eraseToAnyPublisher()
        }
    }
}
