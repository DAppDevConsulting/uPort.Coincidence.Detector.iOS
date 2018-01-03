//
//  MotionRecognizer.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/26/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

struct MotionRecognizerConstants {
    static let ResourceName: String = "shape_triangle"
    static let ExtensionName: String = "json"
    static let KeyName: String = "name"
    static let KeyPoints: String = "points"
}

protocol MotionRecognizerDelegate {
    func recognizer(_ manager: MotionRecognizer, templateFoundWithName name: String)
    func recognizer(_ manager: MotionRecognizer, templateNotFound text: String)
}

class MotionRecognizer {
    
    static let shared = MotionRecognizer()
    private var loadedTemplates = [SwiftUnistrokeTemplate]()

    var delegate: MotionRecognizerDelegate?
    
    private init() {
       readTemplateJson()
    }
    
    func  createStrokeRecognizer(points: [StrokePoint]) {
        let strokeRecognizer = SwiftUnistroke(points: points)
        
        do {
            let (template,distance) = try strokeRecognizer.recognizeIn(templates: self.loadedTemplates, useProtractor:  false)
            
            if let unwrappedTemplate = template {
                print("[FOUND] Template found is \(unwrappedTemplate.name) with distance: \(distance!)")
                delegate?.recognizer(self, templateFoundWithName: unwrappedTemplate.name)
            } else {
                delegate?.recognizer(self, templateNotFound: "Сannot recognize this gesture. Please try again!")
            }
        } catch (let error as NSError) {
            print("[FAILED] Error: \(error.localizedDescription)")
            delegate?.recognizer(self, templateNotFound: "Сannot recognize this gesture. Please try again!")
        }
    }
    
    private func readTemplateJson() {
        do {
            if let file = Bundle.main.url(forResource: MotionRecognizerConstants.ResourceName, withExtension: MotionRecognizerConstants.ExtensionName) {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    guard let templateName = object[MotionRecognizerConstants.KeyName] as? String, let templateRawPoints = object[MotionRecognizerConstants.KeyPoints] as? [AnyObject] else { return }
                    var templatePoints: [StrokePoint] = []
                    for rawPoint in templateRawPoints {
                        guard let rawPointConverted = rawPoint as? [AnyObject] else { return }
                        guard let x = rawPointConverted.first as? Double, let y = rawPointConverted.last as? Double else { return }
                        templatePoints.append(StrokePoint(x: x, y: y))
                    }
                    let templateObj = SwiftUnistrokeTemplate(name: templateName, points: templatePoints)
                    loadedTemplates.append(templateObj)
                    print("  - Loaded template '\(templateName)' with \(templateObj.points.count) templatePoints inside")
                    print(object)
                } else if let object = json as? [Any] {
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }

}
