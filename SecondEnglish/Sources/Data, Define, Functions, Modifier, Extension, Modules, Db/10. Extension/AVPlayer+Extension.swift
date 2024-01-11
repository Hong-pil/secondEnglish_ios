//
//  AVPlayer+Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import UIKit
import AVKit
import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}


extension AVPlayerViewController {
    func enterFullScreen(animated: Bool) {
        perform(NSSelectorFromString("enterFullScreenAnimated:completionHandler:"), with: animated, with: nil)
    }
    func exitFullScreen(animated: Bool) {
        perform(NSSelectorFromString("exitFullScreenAnimated:completionHandler:"), with: animated, with: nil)
    }
}
