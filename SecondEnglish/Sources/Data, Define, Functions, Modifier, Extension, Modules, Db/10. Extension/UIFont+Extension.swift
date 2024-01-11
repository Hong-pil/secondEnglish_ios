//
//  UIFont+Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import UIKit

extension UIFont {
  class var title13240Bold: UIFont {
    return UIFont(name: "NotoSansKR-Bold", size: 32.0)!
  }
  class var title22432Bold: UIFont {
    return UIFont(name: "NotoSansKR-Bold", size: 24.0)!
  }
  class var title32028Bold: UIFont {
    return UIFont(name: "NotoSansKR-Bold", size: 20.0)!
  }
  class var title41824Medium: UIFont {
    return UIFont(name: "NotoSansKR-Medium", size: 18.0)!
  }
  class var title51622Medium: UIFont {
    return UIFont(name: "NotoSansKR-Medium", size: 16.0)!
  }
  class var title5Roboto1622Medium: UIFont {
    return UIFont(name: "Roboto-Medium", size: 16.0)!
  }
  class var body11622Regular: UIFont {
    return UIFont(name: "NotoSansKR-Regular", size: 16.0)!
  }
  class var buttons1420Medium: UIFont {
    return UIFont(name: "NotoSansKR-Medium", size: 14.0)!
  }
  class var body21420Regular: UIFont {
    return UIFont(name: "NotoSansKR-Regular", size: 14.0)!
  }
  class var caption11218Regular: UIFont {
    return UIFont(name: "NotoSansKR-Regular", size: 12.0)!
  }
  class var caption21116Regular: UIFont {
    return UIFont(name: "NotoSansKR-Regular", size: 11.0)!
  }
    
    
    
    
    enum FontType {
        
        case R72
        case B50
        case B36
        case B34
        case B28
        case R24
        case B22
        case B20
        case R20
        case B18
        case M18
        case B17
        case R17
        case B16
        case M16
        case R16
        case B15
        case M15
        case R15
        case B14
        case M14
        case R14
        case R13
        case B12
        case R12
        case M12
        case B11
        case R11
        case R10
        case R9
        
        
        //Enum Method
        func getValue() -> (String, CGFloat) {
            
            let B:String = "AppleSDGothicNeo-Bold"
            let M:String = "AppleSDGothicNeo-Medium"
            let R:String = "AppleSDGothicNeo-Regular"
            //let L:String = "AppleSDGothicNeo-Light"
            
            switch self {
            case .R72: return ( type : R, size : 72 )
            case .B50: return ( type : B, size : 50 )
            case .B36: return ( type : B, size : 36 )
            case .B34: return ( type : B, size : 34 )
            case .B28: return ( type : B, size : 28 )
            case .R24: return ( type : R, size : 24 )
            case .B22: return ( type : B, size : 22 )
            case .B20: return ( type : B, size : 20 )
            case .R20: return ( type : R, size : 20 )
            case .B18: return ( type : B, size : 18 )
            case .M18: return ( type : M, size : 18 )
            case .B17: return ( type : B, size : 17 )
            case .R17: return ( type : R, size : 17 )
            case .B16: return ( type : B, size : 16 )
            case .M16: return ( type : M, size : 16 )
            case .R16: return ( type : R, size : 16 )
            case .B15: return ( type : B, size : 15 )
            case .R15: return ( type : R, size : 15 )
            case .M15: return ( type : M, size : 15 )
            case .B14: return ( type : B, size : 14 )
            case .R14: return ( type : R, size : 14 )
            case .M14: return ( type : M, size : 14 )
            case .R13: return ( type : R, size : 13 )
            case .B12: return ( type : B, size : 12 )
            case .M12: return ( type : M, size : 12 )
            case .R12: return ( type : R, size : 12 )
            case .R9: return ( type : R, size : 9)
            case .B11: return ( type : B, size : 11 )
            case .R11: return ( type : R, size : 11 )
            case .R10: return ( type : R, size : 10 )
            }
        }
    }
    
    /**
     폰트 처리 함수
     */
    static func setFontType(_ type:FontType) -> UIFont {
        //return UIFont(name: type.getValue().0, size: type.getValue().1 * CommonSize.getRatioValue())!
        return UIFont(name: type.getValue().0, size: type.getValue().1)!
    }
}


//extension UIFont {
//    class var title3240Bold: UIFont {
//        return UIFont(name: "NotoSansKR-Bold", size: 32.0)!
//    }
//    class var title12432Bold: UIFont {
//        return UIFont(name: "NotoSansKR-Bold", size: 24.0)!
//    }
//    class var title22028Bold: UIFont {
//        return UIFont(name: "NotoSansKR-Bold", size: 20.0)!
//    }
//    class var title31824Medium: UIFont {
//        return UIFont(name: "NotoSansKR-Medium", size: 18.0)!
//    }
//    class var title41622Medium: UIFont {
//        return UIFont(name: "NotoSansKR-Medium", size: 16.0)!
//    }
//    class var title51622Medium: UIFont {
//        return UIFont(name: "Roboto-Medium", size: 16.0)!
//    }
//    class var body11622Regular: UIFont {
//        return UIFont(name: "NotoSansKR-Regular", size: 16.0)!
//    }
//    class var buttons1420Medium: UIFont {
//        return UIFont(name: "NotoSansKR-Medium", size: 14.0)!
//    }
//    class var body21420Regular: UIFont {
//        return UIFont(name: "NotoSansKR-Regular", size: 14.0)!
//    }
//    class var caption11218Regular: UIFont {
//        return UIFont(name: "NotoSansKR-Regular", size: 12.0)!
//    }
//    class var caption21116Regular: UIFont {
//        return UIFont(name: "NotoSansKR-Regular", size: 11.0)!
//    }
//}
