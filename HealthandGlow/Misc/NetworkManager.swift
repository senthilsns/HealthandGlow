//
//  NetworkManager.swift
//
//  Created by SENTHILKUMAR on 19/01/19.
//  Copyright © 2019 Personal. All rights reserved.
//


import UIKit
import SystemConfiguration

class NetworkManager{
    
    //MARK: Shared Instance
    class var SharedInstance: NetworkManager {
        struct Global {
            static let instance = NetworkManager()
        }
        return Global.instance
    }
    
    
    //MARK: Reachability Check
    func isNetworkReachable() -> Bool {
        
        if Reachability.isConnectedToNetwork() == true {
            return true
        } else {
            return false
        }
        
    }

}


open class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress , {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
}

