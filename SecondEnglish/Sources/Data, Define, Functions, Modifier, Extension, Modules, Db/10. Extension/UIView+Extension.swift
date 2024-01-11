//
//  UIView+Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import UIKit

extension UIView {
    func setGradients(cgColors:[CGColor], isVertical:Bool) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = cgColors
        
        if isVertical {
        }
        else {
            gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        }
        
        gradient.frame = bounds
        layer.sublayers?.removeAll()
        layer.addSublayer(gradient)
    }
    
//    static func getBlockView(text:String = "") -> UIView {
//
//        //blind View
//        let blindView = UIView().then {
//            $0.backgroundColor = UIColor(named: "color_black_65")
////            $0.isUserInteractionEnabled = false
//            $0.isHidden = true
//        }
//
//        let blindSubView = UIView().then {
//            $0.backgroundColor = .clear
//            blindView.addSubview($0)
//
//            $0.snp.makeConstraints { make in
//                make.centerY.equalToSuperview()
//                make.leading.trailing.equalToSuperview()
//            }
//        }
//
//        let blindImageView = UIImageView().then {
//            $0.backgroundColor = .clear
//            $0.image = UIImage(named: "block")
//            blindSubView.addSubview($0)
//
//            $0.snp.makeConstraints { make in
//                make.centerX.equalToSuperview()
//                make.top.equalToSuperview()
//                make.width.height.equalTo(DefineSize.getSize(size: 60))
//            }
//        }
//
//        let _ = UILabel().then {
//            $0.font = UIFont.setFontType(.R15)
//            $0.textColor = UIColor(named: "color_white_100")
//            $0.textAlignment = .center
//            $0.lineBreakMode = .byWordWrapping
//            $0.numberOfLines = 0
//
//            if text.count > 0 {
//                $0.text = text
//            }
//            else {
//                $0.text = "se_c_blocked_post".localized
//            }
//
//
//            blindSubView.addSubview($0)
//
//            $0.snp.makeConstraints { maker in
//                maker.top.equalTo(blindImageView.snp.bottom).offset(DefineSize.getSize(size: 5))
//                maker.leading.trailing.equalToSuperview()
//                maker.bottom.equalToSuperview()
//                maker.height.greaterThanOrEqualTo(10)
//            }
//        }
//
//        return blindView
//    }
//
//    static func getBlockAccountView(text:String = "") -> UIView {
//
//        //blind View
//        let blindView = UIView().then {
//            $0.backgroundColor = UIColor(named: "color_black_65")
////            $0.isUserInteractionEnabled = false
//            $0.isHidden = true
//        }
//
//        let blindSubView = UIView().then {
//            $0.backgroundColor = .clear
//            blindView.addSubview($0)
//
//            $0.snp.makeConstraints { make in
//                make.centerY.equalToSuperview()
//                make.leading.trailing.equalToSuperview()
//            }
//        }
//
//        let blindImageView = UIImageView().then {
//            $0.backgroundColor = .clear
//            $0.image = UIImage(named: "block")
//            blindSubView.addSubview($0)
//
//            $0.snp.makeConstraints { make in
//                make.centerX.equalToSuperview()
//                make.top.equalToSuperview()
//                make.width.height.equalTo(DefineSize.getSize(size: 60))
//            }
//        }
//
//        let _ = UILabel().then {
//            $0.font = UIFont.setFontType(.R15)
//            $0.textColor = UIColor(named: "color_white_100")
//            $0.textAlignment = .center
//            $0.lineBreakMode = .byWordWrapping
//            $0.numberOfLines = 0
//
//            if text.count > 0 {
//                $0.text = text
//            }
//            else {
//                $0.text = "se_c_post_of_blocked_user".localized
//            }
//
//
//            blindSubView.addSubview($0)
//
//            $0.snp.makeConstraints { maker in
//                maker.top.equalTo(blindImageView.snp.bottom).offset(DefineSize.getSize(size: 5))
//                maker.leading.trailing.equalToSuperview()
//                maker.bottom.equalToSuperview()
//                maker.height.greaterThanOrEqualTo(10)
//            }
//        }
//
//        return blindView
//    }
//
//    static func justWatchedView() -> UIView {
//
//        //blind View
//        let blindView = UIView().then {
//            $0.backgroundColor = UIColor(named: "color_black_65")
//            $0.isUserInteractionEnabled = false
//            $0.isHidden = true
//        }
//
//        let blindSubView = UIView().then {
//            $0.backgroundColor = .clear
//            blindView.addSubview($0)
//
//            $0.snp.makeConstraints { make in
//                make.centerY.equalToSuperview()
//                make.leading.trailing.equalToSuperview()
//            }
//        }
//
//        let blindImageView = UIImageView().then {
//            $0.backgroundColor = .clear
//            $0.image = UIImage(named: "minute_just_watched_play")
//            blindSubView.addSubview($0)
//
//            $0.snp.makeConstraints { make in
//                make.centerX.equalToSuperview()
//                make.top.equalToSuperview()
//                make.width.height.equalTo(32.0)
//            }
//        }
//
//        let _ = UILabel().then {
//            $0.font = UIFont.setFontType(.M12)
//            $0.textColor = UIColor(named: "color_white_100")
//            $0.textAlignment = .center
//            $0.lineBreakMode = .byWordWrapping
//            $0.numberOfLines = 0
//            $0.text = "b_just_watched".localized
//
//            blindSubView.addSubview($0)
//
//            $0.snp.makeConstraints { maker in
//                maker.top.equalTo(blindImageView.snp.bottom).offset(DefineSize.getSize(size: 5))
//                maker.leading.trailing.equalToSuperview()
//                maker.bottom.equalToSuperview()
//                maker.height.greaterThanOrEqualTo(10)
//            }
//        }
//
//        return blindView
//    }
    
    static func instantiateFromNib() -> UIView {
        let views = Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)
        return views?.first! as! UIView
    }
}
