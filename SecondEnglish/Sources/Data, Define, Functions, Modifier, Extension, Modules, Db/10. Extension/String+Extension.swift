//
//  String+Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation
import SwiftUI

extension String {
    // 팬투 로컬라이징
//    var localized: String {
//        return Bundle.localizedBundle.localizedString(forKey: self, value: nil, table: nil)
//                return NSLocalizedString(self, comment: "")
//    }
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
    
    var imageOriginalUrl: String {
        return String(format: DefineUrl.Image.Original, self)
    }
    
    var imageOriginalFullUrl: String {
        return String(format: DefineUrl.Image.OriginalFull, self)
    }
    
    var videoOriginUrl: String {
        return String(format: DefineUrl.Video.Original, self)
    }
    
    var videoThumbnail: String {
        return String(format: DefineUrl.Video.Thumbnail, self)
    }
    
    /**
     숫자형 문자열에 3자리수 마다 콤마 넣기
     Double형으로 형변환 되지 않으면 원본을 유지한다.
     
     ```swift
     let stringValue = "10005000.123456789"
     fLog(stringValue.insertComma)
     // 결과 : "10,005,000.123456789"
     ```
     
     */
    var insertComma: String {
        let numberFormatter = NumberFormatter();
        numberFormatter.numberStyle = .decimal
        
        // 소수점이 있는 경우 처리
        if let _ = self.range(of: ".") {
            let numberArray = self.components(separatedBy: ".")
            if numberArray.count == 1 {
                var numberString = numberArray[0]
                if numberString.isEmpty {
                    numberString = "0"
                }
                
                guard let doubleValue = Double(numberString) else {
                    return self
                }
                
                return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
                
            } else if numberArray.count == 2 {
                var numberString = numberArray[0]
                if numberString.isEmpty {
                    numberString = "0"
                }
                
                guard let doubleValue = Double(numberString) else {
                    return self
                }
                
                return (numberFormatter.string(from: NSNumber(value: doubleValue)) ?? numberString) + ".\(numberArray[1])"
            }
        } else {
            guard let doubleValue = Double(self) else {
                return self
            }
            
            return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
        }
        return self
    }
    
    var lastString: String {
        get {
            if self.isEmpty { return self }
            
            let lastIndex = self.index(before: self.endIndex)
            return String(self[lastIndex])
        }
    }
    
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let numberFormatter = NumberFormatter()
            //numberFormatter.numberStyle = .currency
            //numberFormatter.maximumFractionDigits = 2
            numberFormatter.locale = Locale.current
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            numberFormatter.usesGroupingSeparator = true
            
            numberFormatter.positiveFormat = "###,###,###.##"
            if let str = numberFormatter.string(for: value) {
                return str
            }
        }
        return ""
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        
        return nil
    }
    
    
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    
    //MARK: - Validate
    func validatePassword() -> Bool {
        let passwordRegex: String = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[,.!@#$%&*]).{8,20}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func validateEmail() -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    func validateHashTag() -> Bool {
        if containsEmoji() {
            return false
        }
        
//        if containsSpecial() {
//            return false
//        }
        
        return containsOnlyText()
    }
    
    func validateHashTagLength() -> Bool {
        if count >= 2, count <= 15 {
            return true
        }
        
        return false
    }
    
    func containsEmoji() -> Bool {
        contains { $0.isEmoji }
    }
    
    func containsOnlyEmojis() -> Bool {
        return count > 0 && !contains { !$0.isEmoji }
    }
    
    func containsSpecial() -> Bool {
        let regex1 = "[`~!@#$%^&*()_=+[{]}\\|;:'‘’\",<.>/?£¥•-]"
    //let regex1 = "[[]{}#%^*+=_\\|~<>$£¥•.,?!‘-/:;()₩&@“.,?!’]"
        return self.range(of: regex1, options: .regularExpression) != nil
    }
    
    func containsOnlyText() -> Bool {
        var result = true
        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9]$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            self.forEach { char in
                let check = regex.matches(in: String(char), options: [], range: NSRange(location: 0, length: 1))
                if check.count == 0 {
                    print("if check.count == 0 {")
                    result = false
                }
            }
        }
        print("containsOnlyText last : \(result ? "true":"false")")
        return result
    }
    
    
    
    //MARK: - Caclulate
    /**
     * 입력받은 String의 width 값 얻기
     */
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    public enum DateFormatType {
        
        /// The ISO8601 formatted year "yyyy" i.e. 1997
        case isoYear
        
        /// The ISO8601 formatted year and month "yyyy-MM" i.e. 1997-07
        case isoYearMonth
        
        /// The ISO8601 formatted date "yyyy-MM-dd" i.e. 1997-07-16
        case isoDate
        
        /// The ISO8601 formatted date and time "yyyy-MM-dd'T'HH:mmZ" i.e. 1997-07-16T19:20+01:00
        case isoDateTime
        
        /// The ISO8601 formatted date, time and sec "yyyy-MM-dd'T'HH:mm:ssZ" i.e. 1997-07-16T19:20:30+01:00
        case isoDateTimeSec
        
        /// The ISO8601 formatted date, time and sec "yyyy-MM-dd'T'HH:mm:ss" i.e. 1997-07-16T19:20:30+01:00
        case isoDateTimeSec2
        
        /// The ISO8601 formatted date, time and millisec "yyyy-MM-dd'T'HH:mm:ss.SSSZ" i.e. 1997-07-16T19:20:30.45+01:00
        case isoDateTimeMilliSec
        
        /// The dotNet formatted date "/Date(%d%d)/" i.e. "/Date(1268123281843)/"
        case dotNet
        
        /// The RSS formatted date "EEE, d MMM yyyy HH:mm:ss ZZZ" i.e. "Fri, 09 Sep 2011 15:26:08 +0200"
        case rss
        
        /// The Alternative RSS formatted date "d MMM yyyy HH:mm:ss ZZZ" i.e. "09 Sep 2011 15:26:08 +0200"
        case altRSS
        
        /// The http header formatted date "EEE, dd MM yyyy HH:mm:ss ZZZ" i.e. "Tue, 15 Nov 1994 12:45:26 GMT"
        case httpHeader
        
        /// A generic standard format date i.e. "EEE MMM dd HH:mm:ss Z yyyy"
        case standard
        
        /// A custom date format string
        case custom(String)
        
        /// The local formatted date and time "yyyy-MM-dd HH:mm:ss" i.e. 1997-07-16 19:20:00
        case localDateTimeSec
        
        /// The local formatted date  "yyyy-MM-dd" i.e. 1997-07-16
        case localDate
        
        /// The local formatted  time "hh:mm a" i.e. 07:20 am
        case localTimeWithNoon
        
        /// The local formatted date and time "yyyyMMddHHmmss" i.e. 19970716192000
        case localPhotoSave
        
        case birthDateFormatOne
        
        case birthDateFormatTwo
        
        ///
        case messageRTetriveFormat
        
        ///
        case emailTimePreview
        
        var stringFormat:String {
            switch self {
                //handle iso Time
            case .birthDateFormatOne: return "dd/MM/YYYY"
            case .birthDateFormatTwo: return "dd-MM-YYYY"
            case .isoYear: return "yyyy"
            case .isoYearMonth: return "yyyy-MM"
            case .isoDate: return "yyyy-MM-dd"
            case .isoDateTime: return "yyyy-MM-dd'T'HH:mmZ"
            case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ssZ"
            case .isoDateTimeSec2: return "yyyy-MM-dd'T'HH:mm:ss"
            case .isoDateTimeMilliSec: return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            case .dotNet: return "/Date(%d%f)/"
            case .rss: return "EEE, d MMM yyyy HH:mm:ss ZZZ"
            case .altRSS: return "d MMM yyyy HH:mm:ss ZZZ"
            case .httpHeader: return "EEE, dd MM yyyy HH:mm:ss ZZZ"
            case .standard: return "EEE MMM dd HH:mm:ss Z yyyy"
            case .custom(let customFormat): return customFormat
                
                //handle local Time
            case .localDateTimeSec: return "yyyy-MM-dd HH:mm:ss"
            case .localTimeWithNoon: return "hh:mm a"
            case .localDate: return "yyyy-MM-dd"
            case .localPhotoSave: return "yyyyMMddHHmmss"
            case .messageRTetriveFormat: return "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            case .emailTimePreview: return "dd MMM yyyy, h:mm a"
            }
        }
    }
    
    func toDate(_ format: DateFormatType = .isoDate) -> Date?{
        let dateFormatter = CommonFunction.kstDateFormatter()
        dateFormatter.dateFormat = format.stringFormat
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func changeDateFormat(format: DateFormatType = .isoDate, changeFormat: DateFormatType = .isoDate) -> String {
        let dateFormatter = CommonFunction.kstDateFormatter()
        dateFormatter.dateFormat = format.stringFormat
        let convertDate = dateFormatter.date(from: self)   // Date 타입으로 변환
        
        let myDateFormatter = DateFormatter()
        //myDateFormatter.locale = Locale(identifier:"ko_KR") // PM, AM을 언어에 맞게 setting (ex: PM -> 오후)
        myDateFormatter.dateFormat = changeFormat.stringFormat
        
        if let NOconvertDate = convertDate {
            let convertStr = myDateFormatter.string(from: NOconvertDate)
            return convertStr
        }
        else {
            return ""
        }
        
    }
    
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
    /**
     * yyyy-MM-dd'T'HH:mm:ss -> MM.dd
     */
    func changeDateFormat_Custom2(strDate: String) -> String {
        return strDate.changeDateFormat(format: .custom("yyyy-MM-dd'T'HH:mm:ss"), changeFormat: //.custom("MM월 dd일")) // yyyy년 MM월 dd일 a hh시 mm분
            .custom("MM.dd")) // yyyy년 MM월 dd일 a hh시 mm분
    }
    
    func changeDateFormat_Custom(strDate: String) -> String {
        //return strDate.changeDateFormat(format: .custom("yyyy-MM-dd'T'HH:mm:ss"), changeFormat: .custom("MM월 dd일")) // yyyy년 MM월 dd일 a hh시 mm분
        
        var date = Date()
        if strDate.count > 0 {
            //date = strDate.convertDate("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            date = strDate.convertDate("yyyy-MM-dd'T'HH:mm:ss")
        }
        return Date().timeSinceDate(fromDate: date)
    }
    
    func convertDate(_ format:String = "MMM dd, yyyy hh:mm:ss a") -> Date {
        let df = CommonFunction.kstDateFormatter()
        //df.timeZone = TimeZone(abbreviation: "GMT")
        df.dateFormat = format
        
        return df.date(from: self) ?? Date()
    }
    
    func changeDateString(_ format:String = "MMM dd, yyyy hh:mm:ss a", _ toFormat:String = "MMM dd, yyyy hh:mm:ss a") -> String {
        let dateformatter = CommonFunction.kstDateFormatter()
        //df.timeZone = TimeZone(abbreviation: "GMT")
        dateformatter.dateFormat = format
        let date = dateformatter.date(from: self) ?? Date()
        
        let df = DateFormatter()
        df.dateFormat = toFormat
        
        return df.string(from: date)
    }
    
    func getSize() -> CGFloat{
        let font = UIFont.systemFont(ofSize: 16)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: attributes)
        return size.width
    }
    
    
    //MARK: - 1.0
    var videoThumbnailUrl: String {
        var videoUrlId = self
        let iframeUrl = "https://iframe.videodelivery.net/"
        if videoUrlId.hasPrefix(iframeUrl) {
            videoUrlId = videoUrlId.components(separatedBy: ".net/").last ?? ""
        }
        return String(format: DefineUrl.Video.Thumbnail, videoUrlId)
    }
    
    var categoryCodeName: String {
        return CommunityCategoryCode(rawValue: self)?.getText() ?? ""
    }
    
    var subCategoryCodeName: String {
        //let subCate = self.components(separatedBy: "_").last
        return CommunitySubCategoryCode(rawValue: self.components(separatedBy: "_").last ?? self)?.getText() ?? ""
    }
    
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func indexInt(of char: Character) -> Int? {
        return firstIndex(of: char)?.utf16Offset(in: self)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    func validPassword() -> Bool {
        let regEx = "^[A-Za-z0-9]{4,8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        print("password validate = \(predicate.evaluate(with: self))")
        return predicate.evaluate(with: self)
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

extension Character {
    // An emoji can either be a 2 byte unicode character or a normal UTF8 character with an emoji modifier
    // appended as is the case with 3️⃣. 0x203C is the first instance of UTF16 emoji that requires no modifier.
    // `isEmoji` will evaluate to true for any character that can be turned into an emoji by adding a modifier
    // such as the digit "3". To avoid this we confirm that any character below 0x203C has an emoji modifier attached
    var isEmoji: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return scalar.properties.isEmoji && (scalar.value >= 0x203C || unicodeScalars.count > 1)
    }
}
