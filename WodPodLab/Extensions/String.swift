//
//  String.swift
//  WodPodLab
//
//  Created by Hugo Perez on 23/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import UIKit


extension String {
    
    /// Adds <p></p> tags and converts \n to </br>
    var htmlConverted: String {
        return "\("<p>")\(self.replacingOccurrences(of: "\n", with: "</br>"))\("</p>")"
    }

    var boolValue: Bool {
        return (self as NSString).boolValue
    }
    
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}
