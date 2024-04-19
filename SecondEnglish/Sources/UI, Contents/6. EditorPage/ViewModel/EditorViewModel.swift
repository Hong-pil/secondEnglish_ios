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
    @Published var mainCategoryList: [String] = []
    @Published var subCategoryList: [String] = []
    
    @Published var isEditMode: Bool = false
    @Published var editModeItem: SwipeDataList? = nil
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustSetEditMode(_:)),
                                               name: NSNotification.Name(rawValue: DefineNotification.setEditMode),
                                               object: nil)
    }
    
    @objc func adjustSetEditMode(_ notification: Notification) {
        if let editModeItems: [String: Any] = notification.userInfo![DefineKey.editModeItems] as? [String: Any] {
            
            self.isEditMode = editModeItems["isEditMode"] as? Bool ?? false
            self.editModeItem = editModeItems["editModeItem"] as? SwipeDataList ?? nil
        }
    }
    
    //MARK: - 메인 카테고리 조회
    func requestMainCategory(isSuccess: @escaping(Bool) -> Void = {_ in}) {
        ApiControl.getSwipeMainCategory()
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                
            } receiveValue: { value in
                if value.code == 200 {
                    printPrettyJSON(keyWord: "idpil editor_category :::\n", from: value.data ?? [])
                    // 카테고리 헤더 데이터
                    for type in value.data ?? [] {
                        self.mainCategoryList.append(type.type2 ?? "")
                    }
                    
                    // 중복제거
                    self.mainCategoryList = self.mainCategoryList.uniqued()
                    
                    isSuccess(true)
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
    
    //MARK: - 카테고리 조회
    func requestCategory(category: String, isSuccess: @escaping(Bool) -> Void = {_ in}) {
        ApiControl.getSwipeCategory(category: category)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                
            } receiveValue: { value in
                if value.code == 200 {
                    self.subCategoryList = []
                    self.typeList = value.data ?? []
                    
                    // 카테고리 헤더 데이터
                    for type in value.data ?? [] {
                        self.subCategoryList.append(type.type3 ?? "")
                    }
                    
                    // 중복제거
                    self.subCategoryList = self.subCategoryList.uniqued()
                    
                    isSuccess(true)
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
    
    //MARK: - 내 카드 리스트 등록
    func addCardList(type1: String, type2: String, type3: String, sentence_list: [Dictionary<String, String>], isPostComplete: @escaping((Bool) -> Void)) {
        ApiControl.addCardList(type1: type1, type2: type2, type3: type3, sentence_list: sentence_list)
            .sink { error in
                guard case let .failure(error) = error else { return }
                fLog("requestSliderList error : \(error)")
                
                self.alertMessage = error.message
                AlertManager().showAlertMessage(message: self.alertMessage) {
                    self.showAlert = true
                }
                //isPostComplete(false)
            } receiveValue: { value in
                if value.code == 200 {
                    if value.success ?? false {
                        isPostComplete(true)
                    }
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
    
}
