//
//  RepoSearchFeature.swift
//  SecondEnglish
//
//  Created by kimhongpil on 6/13/24.
//

import ComposableArchitecture

@Reducer
struct RepoSearchFeature {
    
    @ObservableState
    struct State: Equatable {
        // TODO: 지금 앱은 어떤 상태들로 정의되는가?
        // keyword와 searchResults 상태 추가하기
        var keyword = ""
        var searchResults = [String]()
        var isLoading = false
    }
    
    enum Action: BindableAction {
        // TODO: 상태들을 변화시키는 사용자의 액션은 무엇인가?
        // keywordChanged, search 액션 추가하기
        case binding(BindingAction<State>)
        //case keywordChanged(String)
        case search
        case dataLoaded(TaskResult<RepositoryModel>)
    }
    
    @Dependency(\.repoSearchClient) var repoSearchClient
    @Dependency(\.continuousClock) var clock
    private enum SearchDebounceId { case request }
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.keyword):
                if state.keyword == "" {
                    state.isLoading = false
                    state.searchResults = []
                    return .cancel(id: SearchDebounceId.request)
                }
                
                return .run { send in
                    try await self.clock.sleep(for: .seconds(0.5))
                    await send(.search)
                }
                .cancellable(id: SearchDebounceId.request, cancelInFlight: true)
                
            case .search:
                state.isLoading = true
                return Effect.run { [keyword = state.keyword] send in
                    let result = await TaskResult { try await repoSearchClient.search(keyword) }
                    await send(.dataLoaded(result))
                }
                
            case let .dataLoaded(.success(repositoryModel)):
                state.isLoading = false
                state.searchResults = repositoryModel.items.map { $0.name }
                return .none
                
            case .dataLoaded(.failure):
                state.isLoading = false
                state.searchResults = []
                return .none
                
            case .binding:
                return .none
            }
        }
    }
    
}
