//
//  Data+Extension.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/17.
//

import Foundation

extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
    
    mutating func appendBoundary(_ boundary: String) {
        if let data = "\r\n--\(boundary)\r\n".data(using: .utf8) {
            self.append(data)
        }
    }
    
    mutating func appendContentDisposition(fieldName: String, fileName: String? = nil) {
        if fileName == nil {
            if let data = "Content-Disposition: form-data; name=\"\(fieldName)\"\r\n\r\n".data(using: .utf8) {
                self.append(data)
            }
        } else {
            if let data = "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName!).png\"\r\n".data(using: .utf8) {
                self.append(data)
            }
        }
    }
    
    mutating func appendContentType(mimeType: String) {
        if let data = "Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8) {
            self.append(data)
        }
    }
}
