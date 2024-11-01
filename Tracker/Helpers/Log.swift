//
//  Log.swift
//  Tracker
//
//  Created by Alexander Bralnin on 01.11.2024.
//



import Foundation

final class Log {
    private static let shared = Log()
    
    class func info(message: String,
                    filePath: String = #file,
                    line: Int = #line,
                    function: String = #function) {
        let file = getFileName(from: filePath)
        
        print ("""
               \(Date().timeStampString) \
               INFO: \(file):\(line) - \(function): \
               \(message)
               """)
    }
    
    class func error(error: Error,
                     message: String? = nil,
                     filePath: String = #file,
                     line: Int = #line,
                     function: String = #function) {
        let file = getFileName(from: filePath)
        print ("""
               \(Date().timeStampString) \
               ERROR: \(file):\(line) - \(function): \
               \(error.localizedDescription)  \(message ?? "")
               """)
    }
    
    class func warn(message: String,
                    filePath: String = #file,
                    line: Int = #line,
                    function: String = #function) {
        let file = getFileName(from: filePath)
        
        print ("""
               \(Date().timeStampString) \
               WARN: \(file):\(line) - \(function): \
               \(message)
               """)
    }
    
    //MARK: - Private functions
    private class func getFileName(from filePath: String) -> String {
        guard let url = URL(string: filePath) else {
            return filePath
        }
        
        return url.lastPathComponent
    }
}
