//
//  WPErrors.swift
//  WodPodLab
//
//  Created by Hugo Perez on 30/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import Foundation


public enum DataError: Error {
    case EMPTY
}


extension DataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .EMPTY:
            return NSLocalizedString("Data was empty in that container", comment: "Usually empty firebase responses")
        }
    }
}
