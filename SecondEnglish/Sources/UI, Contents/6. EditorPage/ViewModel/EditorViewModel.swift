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
    @Published var mainCategoryList: [SwipeCategoryList] = []
    @Published var subCategoryList: [SwipeCategoryList] = []
    
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
                    //printPrettyJSON(keyWord: "idpil editor_category :::\n", from: value.data ?? [])
                    
                    self.mainCategoryList = value.data ?? []
                    
                    // 중복제거 (중복되는 데이터 내려오지 않음)
                    //self.mainCategoryList = self.mainCategoryList.uniqued()
                    
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
    
    //MARK: - 서브 카테고리 조회
    func requestCategory(type2: String, isSuccess: @escaping(Bool) -> Void = {_ in}) {
        ApiControl.getSwipeCategory(type2: type2)
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
                    self.subCategoryList = value.data ?? []
                    
                    // 중복제거 (중복되는 데이터가 내려오지 않음)
                    //self.subCategoryList = self.subCategoryList.uniqued()
                    //fLog("idpil::: 서브카테고리 : \(self.subCategoryList)")
                    
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
    func addCardList(type1: String, type2: String, type3: String, type2_sort_num: Int, type3_sort_num: Int, sentence_list: [Dictionary<String, String>], isPostComplete: @escaping((Bool) -> Void)) {
        ApiControl.addCardList(type1: type1, type2: type2, type3: type3, type2_sort_num: type2_sort_num, type3_sort_num: type3_sort_num, sentence_list: sentence_list)
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
    
    //MARK: - 카드 수정
    func editCard(idx: Int, korean: String, english: String, isDone: @escaping(() -> Void)) {
        ApiControl.editCard(idx: idx, korean: korean, english: english)
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
                        fLog("idpil::: 카드 수정 성공 :)")
                        isDone()
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
