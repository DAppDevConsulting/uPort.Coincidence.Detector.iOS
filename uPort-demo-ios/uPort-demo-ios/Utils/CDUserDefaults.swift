//
//  CdUportUserDefaults.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/17/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

class CDUserDefaults: NSObject {
    
    private let keyFirstLaunch = "FirstLaunch"
    private let keyAskMeAlways = "AskMeAlways"
    private let keyName = "Name"
    private let keyPhone = "Phone"
    private let keyCountry = "Country"
    private let keyImageURL = "ImageURL"
    
    private func synchronize() {
        UserDefaults.standard.synchronize()
    }
    
    var isLaunchedBefore: Bool {
        get {
            return (UserDefaults.standard.bool(forKey: keyFirstLaunch))
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: keyFirstLaunch)
            synchronize()
        }
    }
    
    var askMeAlways: Bool {
        get {
            UserDefaults.standard.register(defaults: [keyAskMeAlways: true])
            return (UserDefaults.standard.bool(forKey: keyAskMeAlways))
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: keyAskMeAlways)
            synchronize()
        }
    }
    
    //MARK: - save local user info data
    var userName: String? {
        get {
            return UserDefaults.standard.value(forKey: keyName) as? String
        }
        set (newToken) {
            UserDefaults.standard.setValue(newToken, forKey: keyName)
            synchronize()
        }
    }
    
    var userPhone: String? {
        get {
            return UserDefaults.standard.value(forKey: keyPhone) as? String
        }
        set (newToken) {
            UserDefaults.standard.setValue(newToken, forKey: keyPhone)
            synchronize()
        }
    }
    
    var userCountry: String? {
        get {
            return UserDefaults.standard.value(forKey: keyCountry) as? String
        }
        set (newToken) {
            UserDefaults.standard.setValue(newToken, forKey: keyCountry)
            synchronize()
        }
    }
    
    var imageURL: String? {
        get {
            return UserDefaults.standard.value(forKey: keyImageURL) as? String
        }
        set (newToken) {
            UserDefaults.standard.setValue(newToken, forKey: keyImageURL)
            synchronize()
        }
    }
    
    func getUserInfo() -> UserInfo {
        let userInfo = UserInfo()
        userInfo.name = userName
        userInfo.phone = userPhone
        userInfo.country = userCountry
        userInfo.imageUrl = imageURL
        return userInfo
    }
    
    func saveUserInfo(_ userInfo: UserInfo) {
        userName = userInfo.name
        userPhone = userInfo.phone
        userCountry = userInfo.country
        imageURL = userInfo.imageUrl
    }
    
    func clearUserInfo() {
        userName = nil
        userPhone = nil
        userCountry = nil
        imageURL = nil
    }
    
    func buildUserInfoJSON() -> [String: AnyObject] {
        guard let userName = userName, let userCountry = userCountry, let userPhone = userPhone, let userURL = imageURL  else { return [:]}
        return [
            UserInfoJSONKeys.name: userName as AnyObject,
            UserInfoJSONKeys.country: userCountry as AnyObject,
            UserInfoJSONKeys.phone: userPhone as AnyObject,
            UserInfoJSONKeys.image: [UserInfoJSONKeys.url: userURL as AnyObject] as AnyObject
        ]
    }
}
