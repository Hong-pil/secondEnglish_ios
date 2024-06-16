//
//  PublicSite_FeatureView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 6/13/24.
//

import SwiftUI
import ComposableArchitecture

struct PublicSite_FeatureView: View {
    let store: StoreOf<PublicSite_Feature>
    
    var body: some View {
        VStack {
            Section {
                Text("\(store.count)")
                Button("Decrement") { store.send(.decrementButtonTapped) }
                Button("Increment") { store.send(.incrementButtonTapped) }
            }
            
            Section {
                Button("Number fact") { store.send(.numberFactButtonTapped) }
            }
            
            if let fact = store.numberFact {
                Text(fact)
            }
        }
    }
}

#Preview {
    PublicSite_FeatureView(
        store: Store(initialState: PublicSite_Feature.State()) {
            PublicSite_Feature()
        }
    )
}
