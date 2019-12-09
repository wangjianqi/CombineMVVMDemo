//
//  DrugCellViewModel.swift
//  RxSwiftMVVMDemo
//
//  Created by wujuan on 2019/7/25.
//  Copyright © 2019 guahao. All rights reserved.
//

import Foundation
import Combine

@available(iOS 13.0, *)
// ViewModel
class DrugCellViewModel: NSObject {
    // model
    var drugModel: DrugModel

    // 编辑
    private let editHeadingPublisher: PassthroughSubject<DrugCellViewModel, Never>
    var editPublisher: AnyPublisher<DrugCellViewModel, Never>

    // 删除
    private let deleteHeadingPublisher: PassthroughSubject<DrugCellViewModel, Never>
    var deletePublisher: AnyPublisher<DrugCellViewModel, Never>

    
    init(drugModel:DrugModel) {
        self.drugModel = drugModel

        editHeadingPublisher = PassthroughSubject<DrugCellViewModel, Never>()
        editPublisher = editHeadingPublisher.eraseToAnyPublisher()
        
        deleteHeadingPublisher = PassthroughSubject<DrugCellViewModel, Never>()
        deletePublisher = deleteHeadingPublisher.eraseToAnyPublisher()
    }
    // 增加
    func addDrug() {
        self.drugModel.drugCount += 1
        editHeadingPublisher.send(self)
    }
    // 减少
    func minusDrug() {
        if drugModel.drugCount > 0 {
            self.drugModel.drugCount -= 1
            editHeadingPublisher.send(self)
        }
    }

    func deleteDrug(){
        deleteHeadingPublisher.send(self)
    }
}

