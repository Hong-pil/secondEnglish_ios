//
//  LandingManager.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

class LandingManager: ObservableObject {
    
    static let shared = LandingManager()
    
    //MARK: - Show & Value
    @Published var showClubPost:Bool = false
    @Published var showClubReply:Bool = false
    @Published var goBackClubPost:Bool = false
    @Published var showClubHomePost:Bool = false
    @Published var showCommunityPost:Bool = false
    @Published var showCommunityReply:Bool = false
    @Published var showCommunityNotice:Bool = false
    @Published var showHomeEventBanner:Bool = false
    
    @Published var showClubComment:Bool = false
    @Published var showCommunityComment:Bool = false
    
    @Published var showClubBoard:Bool = false
    @Published var showCommunityBoard:Bool = false
    
    @Published var showClub:Bool = false
    @Published var showClubJoinManagement:Bool = false
    
    @Published var showHome:Bool = false
    
    @Published var showWeb:Bool = false
    @Published var showMinute:Bool = false
    
    @Published var chatId:String = ""

    @Published var showChatting:Bool = false
    
    @Published var moveToParams: Dictionary<String, String> = [:]
    @Published var moveToPage: LandingPageEnum = .None
    
    var code:String = ""
    var postId:String = ""
    var clubId:String = ""
    var replyId:String = ""
    var minuteId:String = ""
    var tabIndex:String = ""
    var webUrl:String = ""
    var outLink:Bool = false
    
    let moveDelay = 0.7
    
    
    //https://docs.google.com/spreadsheets/d/1Z-AgET_E2F7rYojdlwd7ObpxHECyDp0gXstVhUxkWQI/edit#gid=292157343
    
    //MARK: - Reset
    func reset() {
        code = ""
        postId = ""
        clubId = ""
        replyId = ""
        minuteId = ""
        tabIndex = ""
        webUrl = ""
        outLink = false
        goBackClubPost = false
        showClubHomePost = false
    }
    
    
    //MARK: - Method
    func check(isAlertPage:Bool=false, params: Dictionary<String, String>) {
        fLog("\n--- checkLink -------------------------\nparams : \(params)\n")
        
        self.moveToParams = params
        
        let type = params[DefineKey.type] ?? ""
        
        // 채팅
        if type == DefineKey.chat {
//            if(showChatting) {
//                ChatSocketManager.shared.leave(conversationId: ChatManager.shared.conversationId)
//                let chatId = params[DefineKey.chatId] ?? ""
//                ChatManager.shared.conversationId =  Int(chatId)!
//                fLog("landing chatId : \(chatId)")
//                ChatSocketManager.shared.loadConversation()
//                showChatting = true
//            } else {
//                let chatId = params[DefineKey.chatId] ?? ""
//                ChatManager.shared.conversationId =  Int(chatId)!
//                fLog("landing chatId : \(chatId)")
//                ChatSocketManager.shared.loadConversation()
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + moveDelay) {
//                    self.showChatting = true
//                }
//            }
        }
        //게시글 상세 이동 (클럽/커뮤니티/커뮤니티공지) ----------------------------------------------
        else if type == DefineKey.post {
            let part = params[DefineKey.part] ?? ""
            if part == DefineKey.club {
                let categoryCode = params[DefineKey.categoryCode] ?? ""
                let clubId = params[DefineKey.clubId] ?? ""
                let postId = params[DefineKey.postId] ?? ""
                
                if categoryCode.count > 0, clubId.count > 0, postId.count > 0 {
                    fLog("\n--- 클럽 게시글 이동 -------------------\ncategoryCode : \(categoryCode), clubId : \(clubId), postId : \(postId)\n")
                    
                    self.reset()
                    self.code = categoryCode
                    self.clubId = clubId
                    self.postId = postId
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + moveDelay) {
//                        if clubId == "fantoo_tv" || clubId == "fansing" {
//                            self.showClubHomePost = true
//                        } else {
//                            self.showClubPost = true
//                        }
//                    }
                    if clubId == "fantoo_tv" || clubId == "fansing" {
                        //self.showClubHomePost = true
                        self.moveToPage = .BoardHomeClub
                    } else {
                        //self.showClubPost = true
                        self.moveToPage = .BoardMainClub
                    }
                    
                    /**
                     * '메인 홈 - 알림 페이지'에서 들어온 경우에는 초기상태로 되돌리지 않음.
                     * 상세화면 이동 후 메인화면으로 되돌아오는 문제가 있음
                     */
                    if isAlertPage {
                        self.moveToLandingPage()
                    } else {
                        UserManager.shared.showInitialViewState = Date()
                    }
                    
                }
            }
            else if part == DefineKey.community {
                let code = params[DefineKey.code] ?? ""
                let postId = params[DefineKey.postId] ?? ""
                
                if code.count > 0, postId.count > 0 {
                    fLog("\n--- 커뮤니티 게시글 이동 -------------------\ncode : \(code), postId : \(postId)\n")
                    
                    self.reset()
                    self.code = code
                    self.postId = postId
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + moveDelay) {
//                        self.showCommunityPost = true
//                    }
                    self.moveToPage = .BoardCommunity
                    
                    if isAlertPage {
                        self.moveToLandingPage()
                    } else {
                        UserManager.shared.showInitialViewState = Date()
                    }
                }
            }
            else if part == DefineKey.communityNotice {
                let code = params[DefineKey.code] ?? ""
                let postId = params[DefineKey.postId] ?? ""
                
                /**
                 * 커뮤니티 공지는 code 값이 없는 경우도 있음
                 * - code 있는 경우 : 각 카테고리 Detail 인 경우
                 * - code 없는 경우 : 전체공지 Detail 인 경우
                 */
                if postId.count > 0 {
                    fLog("\n--- 커뮤니티 공지 게시글 이동 -------------------\ncode : \(code), postId : \(postId)\n")
                    
                    self.reset()
                    
                    if code.count > 0 {
                        self.code = code
                    }
                    
                    self.postId = postId

//                    DispatchQueue.main.asyncAfter(deadline: .now() + moveDelay) {
//                        self.showCommunityNotice = true
//                    }
                    self.moveToPage = .BoardCommunityNotice
                    
                    if isAlertPage {
                        self.moveToLandingPage()
                    } else {
                        UserManager.shared.showInitialViewState = Date()
                    }
                }
            }
        }
        //댓글 상세 이동 (클럽/커뮤니티) ----------------------------------------------
        else if type == DefineKey.reply {
            let part = params[DefineKey.part] ?? ""
            if part == DefineKey.club {
                let categoryCode = params[DefineKey.categoryCode] ?? ""
                let clubId = params[DefineKey.clubId] ?? ""
                let postId = params[DefineKey.postId] ?? ""
                let replyId = params[DefineKey.replyId] ?? ""
                
                if categoryCode.count > 0, clubId.count > 0, postId.count > 0 {
                    fLog("\n--- 클럽 댓글 이동 -------------------\ncategoryCode : \(categoryCode), clubId : \(clubId), postId : \(postId)\n")
                    
                    self.reset()
                    self.code = categoryCode
                    self.clubId = clubId
                    self.postId = postId
                    self.replyId = replyId
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + moveDelay) {
//                        if clubId == "fantoo_tv" || clubId == "fansing" {
//                            self.showClubHomePost = true
//                        } else {
//                            self.showClubReply = true
//                        }
//                    }
                    if clubId == "fantoo_tv" || clubId == "fansing" {
                        //self.showClubHomePost = true
                        self.moveToPage = .BoardHomeClub
                    } else {
                        //self.showClubReply = true
                        self.moveToPage = .ReplyClub
                    }
                    
                    if isAlertPage {
                        self.moveToLandingPage()
                    } else {
                        UserManager.shared.showInitialViewState = Date()
                    }
                }
            }
            else if part == DefineKey.community {
                
                let replyId = params[DefineKey.replyId] ?? ""
                let postId = params[DefineKey.postId] ?? ""
                let code = params[DefineKey.code] ?? ""
                
                if replyId.count > 0, postId.count > 0 {
                    //fLog("\n--- 커뮤니티 댓글 이동 -------------------\nreplyId : \(replyId), postId : \(postId), code : \(code)\n")
                    
                    self.reset()
                    self.replyId = replyId
                    self.postId = postId
                    self.code = code
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + moveDelay) {
//                        self.showCommunityReply = true
//                    }
                    self.moveToPage = .ReplyCommunity
                    
                    if isAlertPage {
                        self.moveToLandingPage()
                    } else {
                        UserManager.shared.showInitialViewState = Date()
                    }
                }
            }
        }
        //게시판 이동 (클럽/커뮤니티) ----------------------------------------------
        else if type == DefineKey.board {
            let part = params[DefineKey.part] ?? ""
            if part == DefineKey.club {
                let categoryCode = params[DefineKey.categoryCode] ?? ""
                let clubId = params[DefineKey.clubId] ?? ""
                
                if categoryCode.count > 0, clubId.count > 0 {
                    fLog("\n--- 클럽 게시판 이동 -------------------\ncategoryCode : \(categoryCode), clubId : \(clubId)\n")
                }
            }
            else if part == DefineKey.community {
                let code = params[DefineKey.code] ?? ""
                
                if code.count > 0 {
                    fLog("\n--- 커뮤니티 게시판 이동 -------------------\ncode : \(code)\n")
                }
            }
        }
        //클럽 이동 ----------------------------------------------
        else if type == DefineKey.club {
            let clubId = params[DefineKey.clubId] ?? ""
            
            if clubId.count > 0 {
                fLog("\n--- 클럽 이동 -------------------\nclubId : \(clubId)\n")
                self.reset()
                self.clubId = clubId
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + moveDelay) {
//                    self.showClubHomePost = true
//                }
                self.moveToPage = .BoardHomeClub
                
                if isAlertPage {
                    self.moveToLandingPage()
                } else {
                    UserManager.shared.showInitialViewState = Date()
                }
            }
        }
        //가입승인 대기 ----------------------------------------------
        else if type == DefineKey.club_join_manage {
            let clubId = params[DefineKey.clubId] ?? ""
            
            if clubId.count > 0 {
                fLog("\n--- 가입승인대기 이동 -------------------\nclubId : \(clubId)\n")
                self.reset()
                self.clubId = clubId
                
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + moveDelay) {
//                    self.showClubHomePost = true
//                }
                self.moveToPage = .BoardHomeClub
                
                if isAlertPage {
                    self.moveToLandingPage()
                } else {
                    UserManager.shared.showInitialViewState = Date()
                }
            }
        }
        //홈 ----------------------------------------------
        else if type == DefineKey.home {
            let tab = params[DefineKey.tab] ?? ""
            
            if tab.count > 0 {
                fLog("\n--- 홈(탭) 이동 -------------------\ntab : \(tab)\n")
            }
        }
        //웹뷰 ----------------------------------------------
        else if type == DefineKey.web || type == DefineKey.openWeb {
            let url = params[DefineKey.url] ?? ""
            let view = params[DefineKey.view] ?? ""
            
            if url.count > 0 {
                fLog("\n--- 웹뷰 이동 -------------------\nurl : \(url), view : \(view)\n")
                self.reset()
                self.webUrl = url
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + moveDelay) {
//                    self.showHomeEventBanner = true
//                }
                self.moveToPage = .WebView
                
                if isAlertPage {
                    self.moveToLandingPage()
                } else {
                    UserManager.shared.showInitialViewState = Date()
                }
            }
        }
        //Minute ----------------------------------------------
        else if type == DefineKey.minute {
            let idx = params[DefineKey.idx] ?? ""
            
            if idx.count > 0 {
                fLog("\n--- Minute 이동 -------------------\nidx : \(idx)\n")
                
                self.reset()
                self.minuteId = idx
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + moveDelay) {
//                    self.showMinute = true
//                }
                self.moveToPage = .Minute
                
                if isAlertPage {
                    self.moveToLandingPage()
                } else {
                    UserManager.shared.showInitialViewState = Date()
                }
            }
        }
    }
    
    func moveToLandingPage() {
        switch self.moveToPage {
        case .BoardHomeClub:
            self.showClubHomePost = true
        case .BoardMainClub:
            self.showClubPost = true
        case .BoardCommunity:
            self.showCommunityPost = true
        case .BoardCommunityNotice:
            self.showCommunityNotice = true
        case .ReplyClub:
            self.showClubReply = true
        case .ReplyCommunity:
            self.showCommunityReply = true
        case .WebView:
            self.showHomeEventBanner = true
        case .Minute:
            self.showMinute = true
        default:
            fLog("")
        }
    }
}
