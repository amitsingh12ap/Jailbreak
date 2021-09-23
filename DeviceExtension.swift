//
//  DeviceExtension.swift
//  JailbreakValidator
//
//  Created by Amit Singh on 23/09/21.
//

import UIKit

extension UIDevice {
    var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    var isJailBroken: Bool {
        get {
            if UIDevice.current.isSimulator { return false }
            if JailBreakValidator.canOpenCydiaApp() { return true }
            if JailBreakValidator.isContainsSuspiciousApps() { return true }
            if JailBreakValidator.isSuspiciousSystemPathsExists() { return true }
            return JailBreakValidator.canEditSystemFiles()
        }
    }
}

private struct JailBreakValidator {
    static func canOpenCydiaApp() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "cydia://")!)
    }
    
    static func isContainsSuspiciousApps() -> Bool {
        return jailBrokenSupportingApps.map{ (path) in
            return FileManager.default.fileExists(atPath: path)
        }.count > 0
    }
    
    static func isSuspiciousSystemPathsExists() -> Bool {
        return suspiciousSystemPathsToCheck.map{ (path) in
            return FileManager.default.fileExists(atPath: path)
        }.count > 0
    }
    
    static func canEditSystemFiles() -> Bool {
        let jailBreakText = "Developer Insider"
        do {
            try jailBreakText.write(toFile: jailBreakText, atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }
    
    static var jailBrokenSupportingApps: [String] {
        return ["/Applications/Cydia.app",
                "/Applications/blackra1n.app",
                "/Applications/FakeCarrier.app",
                "/Applications/Icy.app",
                "/Applications/IntelliScreen.app",
                "/Applications/MxTube.app",
                "/Applications/RockApp.app",
                "/Applications/SBSettings.app",
                "/Applications/WinterBoard.app"
        ]
    }
    
    static var suspiciousSystemPathsToCheck: [String] {
        return ["/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                "/private/var/lib/apt",
                "/private/var/lib/apt/",
                "/private/var/lib/cydia",
                "/private/var/mobile/Library/SBSettings/Themes",
                "/private/var/stash",
                "/private/var/tmp/cydia.log",
                "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                "/usr/bin/sshd",
                "/usr/libexec/sftp-server",
                "/usr/sbin/sshd",
                "/etc/apt",
                "/bin/bash",
                "/Library/MobileSubstrate/MobileSubstrate.dylib"
        ]
    }
}
