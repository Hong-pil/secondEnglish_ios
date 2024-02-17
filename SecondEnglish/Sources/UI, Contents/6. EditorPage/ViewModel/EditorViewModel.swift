//
//  EditorViewModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/15/24.
//

import Foundation
import Combine

class EditorViewModel: ObservableObject {
    var cancellable = Set<AnyCancellable>()
    
    //alert
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    // View Data
    @Published var typeList: [SwipeCategoryList] = []
    @Published var type2CategoryList: [String] = []
    @Published var categoryList: [Dictionary<String, Any>] = []
    
    init() {
        self.requestCategory()
    }
    
    //MARK: - 카테고리 조회
    func requestCategory() {
        ApiControl.getSwipeCategory()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                
            } receiveValue: { value in
                if value.code == 200 {
                    self.typeList = value.data ?? []
                    
                    // 데이터 가공, 목표 형태
                    // [
                    //  {"type2_category": "", "type3_category_list": ["", ""]},
                    //  {"type2_category": "", "type3_category_list": ["", ""]},
                    //  ...
                    // ]
                    for type in value.data ?? [] {
                        self.type2CategoryList.append(type.type2 ?? "")
                    }
                    self.type2CategoryList = self.type2CategoryList.uniqued() // 중복제거
                    
                    // 카테고리별 영어문장 데이터
                    if self.type2CategoryList.count > 0 {
                        var tmpArr: [String] = []
                        
                        for type2Category in self.type2CategoryList {
                            //fLog("idpil::: type2Category : \(type2Category)")
                            
                            for type in value.data ?? [] {
                                
                                //self.type3CategoryList.append(type.type3 ?? "")
                                
                                if type2Category == (type.type2 ?? "") {
                                    //fLog("idpil::: type3 : \(type.type3 ?? "")")
                                    tmpArr.append(type.type3 ?? "")
                                }
                            }
                            //fLog("idpil::: tmpArr : \(tmpArr)")
                            
                            self.categoryList.append([
                                "type2_category": type2Category,
                                "type3_category_list": tmpArr
                            ])
                            
                            tmpArr = []
                        }
                    }
                    //fLog("idpil::: categoryList : \(self.categoryList)")
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    AlertManager().showAlertMessage(message: self.alertMessage) {
                        self.showAlert = true
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    // 선택된 MainCategory에 대한 SubCategoryList
    func getSubCategoryList(selectedMainCategoryName: String) -> [String] {
        var finalSubCategoryList: [String] = []
        
        for item in self.categoryList {
            
            if let mainCategory = item["type2_category"],
               let subCategoryList = item["type3_category_list"] {
                
                if selectedMainCategoryName == mainCategory as! String {
                    finalSubCategoryList = subCategoryList as! [String]
                }
            }
        }
        
        return finalSubCategoryList
    }
}
