//
//  DefineUrl.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

struct DefineUrl {
    
    struct Domain {
        #if PROD
            static let Api = "https://dolbwa.duckdns.org"
            
            static let Login = "https://fauth-web.fantoo.co.kr"
//            static let Api = "https://fapi.fantoo.co.kr"
//            static let Trans = "http://ntrans.fantoo.co.kr:5000"
//            static let Upload = "https://api.cloudflare.com"
//            static let Chat = "http://146.56.160.93:1145"
//            static let Minute2 = "https://fapp-api.fantoo.co.kr"
//            static let Event = "https://fevent.fantoo.co.kr"
//            static let EventVote = Event + "/vote"
//            static let EventList = Event + "/event"
//            static let ClubPersonalInfo = Event + "/document/club-policy"
//            static let Terms = "https://fauth.fantoo.co.kr"
        #else
            static let Api = "https://dolbwa.duckdns.org" // url을 prod,dev 용 두 개 만들어서 관리해야 됨
            
            static let Login = "https://fauth-web-dev.fantoo.co.kr"
//            static let Api = "https://fapi-dev.fantoo.co.kr"
//            static let Trans = "http://ntrans.fantoo.co.kr:5000"
//            static let Upload = "https://api.cloudflare.com"
//            static let Chat = "http://146.56.160.93:1145"
//            static let Minute2 = "https://fapp-dev-api.fantoo.co.kr"
//            static let Event = "https://fevent-dev.fantoo.co.kr"
//            static let EventVote = Event + "/vote"
//            static let EventList = Event + "/event"
//            static let ClubPersonalInfo = Event + "/document/club-policy"
//            static let Terms = "https://fauth-dev.fantoo.co.kr"
        #endif
    }
    
    
    
    struct Path {
        static let UploadImage = "client/v4/accounts/1df62cde067ca406bffd7f00ba21152e/images/v1"
        static let UploadStream = "client/v4/accounts/1df62cde067ca406bffd7f00ba21152e/stream"
    }
    
    struct Image {
        static let Original = "https://imagedelivery.net/peZXyXogT-VgnN1sGn2T-Q/%@/public"
        static let OriginalFull = "https://imagedelivery.net/peZXyXogT-VgnN1sGn2T-Q/%@/full"
    }
    
    // availableTestURL
    //"https://customer-y628kmdfbqq6rn1n.cloudflarestream.com/9111c413d3c0eb59e099066d050bb3f5/manifest/video.m3u8"
    struct Video {
        static let Original = "https://customer-y628kmdfbqq6rn1n.cloudflarestream.com/%@/manifest/video.m3u8"
        
        static let Thumbnail = "https://customer-y628kmdfbqq6rn1n.cloudflarestream.com/%@/thumbnails/thumbnail.jpg"
    }
    
    
    // Thumbnail Image Url sample :
    // https://imagedelivery.net/peZXyXogT-VgnN1sGn2T-Q/29a2c0b0-5777-4bb1-f522-3b84739f2700/thumbnail
    // Default Image Url sample :
    // https://imagedelivery.net/peZXyXogT-VgnN1sGn2T-Q/29a2c0b0-5777-4bb1-f522-3b84739f2700/public
    static let ApiImageDomain = "https://imagedelivery.net/peZXyXogT-VgnN1sGn2T-Q/"
    
    
    
    struct Term {
        static let Service = "https://www.naver.com/"
        static let Privacy = "https://www.youtube.com/"
        static let Youth = "https://news.naver.com/main/list.naver?mode=LPOD&mid=sec&sid1=001&sid2=140&oid=001&isYeonhapFlash=Y&aid=0013324105"
        static let Event = "https://n.news.naver.com/mnews/article/001/0013324121?rc=N&ntype=RANKING"
    }
}
