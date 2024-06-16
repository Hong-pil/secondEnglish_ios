//
//  RepoSearchView.swift
//  SecondEnglish
//
//  Created by kimhongpil on 6/13/24.
//

import SwiftUI
import ComposableArchitecture

struct RepoSearchView: View {
    @State var store: StoreOf<RepoSearchFeature>
    
    var body: some View {
        NavigationView {
            Group {
                if(store.isLoading) {
                    ProgressView()
                } else {
                    List {
                        ForEach(store.searchResults, id: \.self) { repo in
                            Text(repo)
                        }
                    }
                }
                Spacer()
            }
            .searchable(text: $store.keyword)
            .navigationTitle("Github Search")
        }
    }
}

#Preview {
    RepoSearchView(
        store: Store(initialState: RepoSearchFeature.State()) {
            RepoSearchFeature()
        }
    )
}
