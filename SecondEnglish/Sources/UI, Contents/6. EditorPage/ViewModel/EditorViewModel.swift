//
//  EditorViewModel.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/15/24.
//

import Foundation

class EditorViewModel: ObservableObject {
    @Published var txtTitle: String = ""
    @Published var txtContents: String = ""
    
    @Published var showWriteCancel = false
    
    
    
    func checkMinimalData() -> Bool {
        return !txtTitle.isEmpty || !txtContents.isEmpty
    }
}
