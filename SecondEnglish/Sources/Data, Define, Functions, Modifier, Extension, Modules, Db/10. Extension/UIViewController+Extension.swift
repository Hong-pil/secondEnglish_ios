//
//  UIViewController+Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import UIKit

extension UIViewController {
    // MARK: - 커스텀 UIAction이 뜨는 UIAlertController
    func presentAlert(title: String? = nil, message: String? = nil,
                      isCancelActionIncluded: Bool = false,
                      preferredStyle style: UIAlertController.Style = .alert,
                      with actions: UIAlertAction ...) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        if isCancelActionIncluded {
            let actionCancel = UIAlertAction(title: "c_cancel".localized, style: .cancel, handler: nil)
            alert.addAction(actionCancel)
        }
        self.present(alert, animated: true, completion: nil)
    }
}

//extension ARResultController {
//    func presentShareSheet(for url: URL) {
//        let objectsToShare: [Any] = [url]
//        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//        activityVC.popoverPresentationController?.sourceView = view
//        present(activityVC, animated: true, completion: nil)
//    }
//}
