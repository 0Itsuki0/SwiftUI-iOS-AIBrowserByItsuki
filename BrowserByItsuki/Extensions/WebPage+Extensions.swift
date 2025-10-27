//
//  WebPage+Extensions.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//



import SwiftUI
import WebKit

extension WebPage {
    var canNavigateBackward: Bool {
        self.lastBackwardDestination != nil
    }
    var canNavigateForward: Bool {
        self.firstForwardDestination != nil
    }
    
    var lastBackwardDestination: URL? {
        self.backForwardList.backList.last?.url
    }
    var firstForwardDestination: URL? {
        self.backForwardList.forwardList.first?.url
    }
}


extension WebPage.Configuration {
    static var defaultConfiguration: WebPage.Configuration {
        var configuration = WebPage.Configuration()
        
        var navigationPreference = WebPage.NavigationPreferences()
        navigationPreference.allowsContentJavaScript = true
        navigationPreference.preferredHTTPSNavigationPolicy = .keepAsRequested
        navigationPreference.preferredContentMode = .mobile
        configuration.defaultNavigationPreferences = navigationPreference
        
        configuration.dataDetectorTypes = .all
        configuration.allowsInlinePredictions = true
        configuration.supportsAdaptiveImageGlyph = true
        configuration.mediaPlaybackBehavior = .automatic
        
        return configuration
    }
}
