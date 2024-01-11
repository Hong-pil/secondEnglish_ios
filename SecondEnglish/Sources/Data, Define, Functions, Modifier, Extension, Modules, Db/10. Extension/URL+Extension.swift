//
//  URL+Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import UIKit


extension URL {
    
    var hasTweetId: Bool {
        do{
            let str = self.path
            let regexStr = "^/(?:#!/)?(\\w+)/status(es)?/(\\d+)$"
            
            let range = NSRange(str.startIndex..., in: str)
            
            let regex = try NSRegularExpression(pattern: regexStr)
            let results = regex.rangeOfFirstMatch(in: str, range: range)
            
            return results.location != NSNotFound
        }
        catch{
            return false
        }
    }
    
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil }
        
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            
            let components = pair.components(separatedBy: "=")
            
            if (components.count < 2) {
                return nil
            }
            
            let key = components[0]
            
            let value = components[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
    
    static func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .cachesDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    // Creation failed. Print error & return nil
                    fLog(error.localizedDescription)
                    return nil
                }
            }
            // Folder either exists, or was created. Return URL
            return folderURL
        }
        // Will only be called if document directory not found
        return nil
    }
    
    static func deleteFolder(folderName: String) -> Bool {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .cachesDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if fileManager.fileExists(atPath: folderURL.path) {
                do {
                    try fileManager.removeItem(atPath: folderURL.path)
                } catch {
                    // Creation failed. Print error & return nil
                    fLog(error.localizedDescription)
                    return false
                }
            }
            // Folder either exists, or was created. Return URL
            return true
        }
        // Will only be called if document directory not found
        return false
    }
    
    func fileSizeInMB() -> String {
        let p = self.path
        
        let attr = try? FileManager.default.attributesOfItem(atPath: p)
        
        if let attr = attr {
            let fileSize = Float(attr[FileAttributeKey.size] as! UInt64) / (1024.0 * 1024.0)
            
            return String(format: "%.2f MB", fileSize)
        } else {
            return "Failed to get size"
        }
    }
}
