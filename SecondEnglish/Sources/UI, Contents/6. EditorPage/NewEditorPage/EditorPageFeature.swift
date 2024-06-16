//
//  EditorPageFeature.swift
//  SecondEnglish
//
//  Created by kimhongpil on 6/14/24.
//

import ComposableArchitecture

@Reducer
struct EditorPageFeature {
    
    @ObservableState
    struct State: Equatable {
        var koreanTxt = ""
        var englishTxt = ""
        
        // [
        //  {"korean_txt": "", "english_txt": ""},
        //  {"korean_txt": "", "english_txt": ""},
        //  ...
        // ]
        var sentenceList = [Dictionary<String, String>]()
        var activeIndex = 0
        var forceKeyboardUpIndex = 0
        var isCardAdd = false
    }
    
    enum Action: BindableAction {
        case addList
        case updateList(beforeIndex: Int, afterIndex: Int)
        case binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .addList:
                state.isCardAdd = true
                
                state.sentenceList =
                addList(
                    list: state.sentenceList,
                    koTxt: state.koreanTxt,
                    enTxt: state.englishTxt
                )
                
                // 리스트 마지막 카드의 한국어 TextField 키보드 올림
                // 이거 설정 안 하면 키보드 안 올라감
                state.forceKeyboardUpIndex = state.sentenceList.count-1
                
                return .none
            case .updateList(let beforeIndex, let afterIndex):
                
                /// 입력 중이던 텍스트 저장
                state.sentenceList = updateList(
                    list: state.sentenceList,
                    beforeKoTxt: state.koreanTxt,
                    beforeEnTxt: state.englishTxt,
                    beforeIndex: beforeIndex)
                
                /// 이어서 수정하기 위해, 새로 클릭한 곳의 이전 텍스트 불러와서 그대로 저장
                if state.sentenceList.count > afterIndex {
                    if let koTxt = state.sentenceList[afterIndex][DefineKey.sentenceKoKey],
                       let enTxt = state.sentenceList[afterIndex][DefineKey.sentenceEnKey] {
                        
                        state.koreanTxt = koTxt
                        state.englishTxt = enTxt
                    }
                }
                
                return .none
//            case .binding(\.koreanTxt):
//                fLog("idpil::: koreanTxt binding : \(state.koreanTxt)")
//                return .none
//            case .binding(\.englishTxt):
//                fLog("idpil::: englishTxt binding : \(state.englishTxt)")
//                return .none
            case .binding:
                return .none
            }
        }
    }
    
    private func addList(
        list: [Dictionary<String, String>],
        koTxt: String,
        enTxt: String
    ) -> [Dictionary<String, String>] {
        
        var list = list
        list.insert(
            [
                DefineKey.sentenceKoKey: koTxt,
                DefineKey.sentenceEnKey: enTxt
            ]
            , at: (list.count==0) ? 0 : list.count-1
        )
        
        return list
    }
    
    private func updateList(
        list: [Dictionary<String, String>],
        beforeKoTxt: String,    // 입력 중이던 텍스트
        beforeEnTxt: String,    // 입력 중이던 텍스트
        beforeIndex: Int        // 입력 중이던 인덱스
    ) -> [Dictionary<String, String>] {
        
        var list = list
        
        if list.count > beforeIndex {
            list[beforeIndex][DefineKey.sentenceKoKey] = beforeKoTxt
            list[beforeIndex][DefineKey.sentenceEnKey] = beforeEnTxt
        }
        

        /// 입력 중이던 텍스트 저장
//        list.insert(
//            [
//                DefineKey.sentenceKoKey: beforeKoTxt,
//                DefineKey.sentenceEnKey: beforeEnTxt
//            ]
//            , at: beforeIndex
//        )
        
        /// 이어서 수정하기 위해, 새로 클릭한 곳의 이전 텍스트 불러와서 그대로 저장
//        list.insert(
//            [
//                DefineKey.sentenceKoKey: afterKoTxt,
//                DefineKey.sentenceEnKey: afterEnTxt
//            ]
//            , at: afterIndex
//        )
        
        return list
    }
    
}
