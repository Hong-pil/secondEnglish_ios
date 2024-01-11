//
//  DefineEnum.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import Darwin

enum bTab {
    case home
    case pet_life
    case pets
    case chatting
    case profile
}

enum LoadingStatus {
    case Close
    case ShowWithTouchable
    case ShowWithUntouchable
    case ShowWithUntouchableUnlimited       //터치불가능하고, 자동 close가 안되는.
}

enum ServiceType: String {
    case dev
    case prod
}

enum CheckCorrectStatus {
    case Check
    case Correct
    case Wrong
}

enum AuthErrorType {
    case ReLogin
    case Refreshed
    case None
}

enum LoginType: String {
    case google, facebook, kakao, apple, twitter, line, email
}

enum SaveLoginType: String {
    case Google, Facebook, Kakao, Apple, Twitter, Line, email
}

enum UserInfoType: String {
    case birthDay, country, gender, interest, userNick, userPhoto
}

enum WalletListType: String {
    case all, paid, used
}

enum WalletType: String {
    case fanit, kdg
}

enum AlimType: String {
    case COMMUNITY, CLUB
}

enum DataCachingTime: Int {
    case None = 0
    case Sec_5 = 5
    case Sec_30 = 30
    case Min_1 = 60
    case Min_3 = 180
    case Min_5 = 300
}

enum BoardLikeInfoType: Int {
    case LikeCount
    case LikeBtnColor
    case DisLikeBtnColor
    case LikeTxtColor
}

enum MainCommunityLikeInfoType: Int {
    case Hour
    case Week
}

enum ImageSizeType: Int {
    case Profile
    case Background
}

enum StorageButtonType: Int {
    case Post
    case Comment
    case Save
}

// 댓글 익명버튼 : Community(O) / Club(X)
enum ReplyWritingViewType: Int {
    case Community
    case Club
    case FantootvFansing
}

enum PostType {
    case Community
    case Club
}

enum EditorType {
    case Write
    case Modify
}

enum EditorWriterType {
    case Normal
    case Manager
    case Admin
}

enum ClubLevelType {
    case Master
    case Member
}


enum MinuteSetType {
    case Minute
    case Reply
    case InReply
    
    func getValue() -> String {
        switch self {
        case .Minute: return "minute"
        case .Reply: return "reply"
        case .InReply: return "inReply"
        }
    }
}

//enum LikeType {
//    case Good
//    case GoodCancel
//    case Bad
//    case BadCancel
//
//    func getValue() -> String {
//        switch self {
//        case .Good: return "good"
//        case .GoodCancel: return "good_cancel"
//        case .Bad: return "bad"
//        case .BadCancel: return "bad_cancel"
//        }
//    }
//}

enum FavoriteType {
    case Favorite
    case FavoriteCancel
    
    func getValue() -> String {
        switch self {
        case .Favorite: return "fav"
        case .FavoriteCancel: return "fav_cancel"
        }
    }
}


enum MinuteSortType: Int {
    case Recommend = 1
    case Latest = 3
    case Oldest = 9
}

enum ReportType: Int {
    case Content = 0        //컨텐츠 신고
    case Comment        //댓글 신고
    case Chatting       //방 참여자 신고
    case Minute
    case MinuteReply
}


enum CommunityCategoryCode: String {
    case C_HOT
    case C_KPOP
    case C_KDRAMA
    case C_KMOVIE
    case C_SHOW
    case C_GAME
    case C_COMICS
    case C_BEAUTY
    case C_SPORT
    case C_FOOD
    case C_LIFE
    case C_DISCUSSION
    case C_NEWS
    case NONE
    
    func getText() -> String {
        switch self {
        case .C_HOT: return "en_hot".localized
        case .C_KPOP: return "en_k_pop".localized
        case .C_KDRAMA: return "en_k_drama".localized
        case .C_KMOVIE: return "en_k_movie".localized
        case .C_SHOW: return "t_tv_show_variety".localized
        case .C_GAME: return "g_game".localized
        case .C_COMICS: return "m_comics".localized
        case .C_BEAUTY: return "b_beauty_fashion".localized
        case .C_SPORT: return "s_sports".localized
        case .C_FOOD: return "a_food".localized
        case .C_LIFE: return "a_life".localized
        case .C_DISCUSSION: return "t_discussion".localized
        case .C_NEWS: return "n_news".localized
        default: return "m_summury".localized
        }
    }
}

enum CommunitySubCategoryCode: String {
    case TALK
    case REVIEW
    case ASK
    case NEWS
    case INFO
    case NONE
    
    func getText() -> String {
        switch self {
        case .TALK: return "j_any_chat".localized
        case .REVIEW: return "r_review".localized
        case .ASK: return "j_question".localized
        case .NEWS: return "n_news".localized
        case .INFO: return "j_info".localized
        default: return "".localized
        }
    }
}

enum CommunityReportType {
    case Post
    case Reply
    
    func getValue() -> String {
        switch self {
        case .Post: return "POST"
        case .Reply: return "REPLY"
        }
    }
}

enum CommunityBoardBlockType {
    case Post
    case Reply
    
    func getValue() -> String {
        switch self {
        case .Post: return "post"
        case .Reply: return "reply"
        }
    }
}

enum CommunityUserBlockType: Int {
    case Post
    case Reply
}

enum CommunityDetailPageDeleteType: Int {
    case Post
    case Reply
}

enum BoardBlockType {
    case Post
    case Reply
    
    func getValue() -> String {
        switch self {
        case .Post: return "post"
        case .Reply: return "reply"
        }
    }
}

enum BoardBlockApiType: Int {
    case Block
    case UnBlock
}


enum CustomStatusBarStype: Int {
    case Light = 0
    case Dark
}

enum ArchiveBoardType: Int {
    case General = 1
    case Image
}

enum ClubDetailRequestType: Int {
    case None
    case Post
    case Reply
}

enum CommunityDetailLikeType: Int {
    case Board          // 게시글 좋아요/싫어요 요청
    case Reply          // 댓글 좋아요/싫어요 요청
    case ChildReply     // 대댓글 좋아요/싫어요 요청
}

enum VideoServiceType: Int {
    case Community = 0
    case Club
    case Minute
}

enum VideoType: Int {
    case Url = 0
    case Cloudflare
    case Youtube
}


enum ClubInfoType: String {
    case Club
    case Fansing
    case FantooTv
    case Hanryutimes
}

enum LandingPageEnum: Int {
    case None
    case Chat
    case BoardHomeClub
    case BoardMainClub
    case BoardCommunity
    case BoardCommunityNotice
    case ReplyClub
    case ReplyCommunity
    case WebView
    case Minute
}

enum SwipeCardSortType: Int {
    case Latest
    case Oldest
}
