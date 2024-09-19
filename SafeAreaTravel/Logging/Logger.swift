//
//  Logger.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//
import Foundation
import os.log

import Then

private class LogFormatter {
    static let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }
    
    static func format(level: String, fileName: String, function: String, line: Int, message: String) -> String {
        let timestamp = dateFormatter.string(from: Date())
        return "\(timestamp) \(level) \(fileName).\(function):\(line) - \(message)"
    }
}

/// A shared instance of `Logger`.
let log = Logger()

final class Logger {
    
    private let logQueue = DispatchQueue(label: "com.SafeAreaTravel.logger")
    private let logFileURL: URL
    
    // MARK: - Initialize
    init() {
        // Initialize the log file URL
        let fileManager = FileManager.default
        let logsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Logs")
        
        // Create Logs directory if it doesn't exist
        if !fileManager.fileExists(atPath: logsDirectory.path) {
            try? fileManager.createDirectory(at: logsDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        
        // Set log file URL
        logFileURL = logsDirectory.appendingPathComponent("log.txt")
        
        // Rotate log files if needed
        rotateLogFiles()
    }
    
    // MARK: - Logging
    
    func error(_ items: Any..., file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        log(level: "❤️ ERROR", items: items, file: file, function: function, line: line)
    }
    
    func warning(_ items: Any..., file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        log(level: "💛 WARNING", items: items, file: file, function: function, line: line)
    }
    
    func info(_ items: Any..., file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        log(level: "💙 INFO", items: items, file: file, function: function, line: line)
    }
    
    func debug(_ items: Any..., file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        log(level: "💚 DEBUG", items: items, file: file, function: function, line: line)
    }
    
    func verbose(_ items: Any..., file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        log(level: "💜 VERBOSE", items: items, file: file, function: function, line: line)
    }
    
    func info(_ items: Any..., file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        log(level: "📡 APICall", items: items, file: file, function: function, line: line)
    }
    
    // MARK: - Private methods
    
    private func log(level: String, items: [Any], file: StaticString, function: StaticString, line: UInt) {
        let message = message(from: items)
        let formattedMessage = LogFormatter.format(level: level, fileName: "\(file)", function: "\(function)", line: Int(line), message: message)
        
        #if DEBUG
            print(formattedMessage)
        #endif
    }
    
    private func message(from items: [Any]) -> String {
        return items.map { String(describing: $0) }.joined(separator: " ")
    }
    
    private func writeToFile(message: String) {
        let messageWithNewline = message + "\n"
        guard let data = messageWithNewline.data(using: .utf8) else { return }
        
        if FileManager.default.fileExists(atPath: logFileURL.path) {
            if let fileHandle = try? FileHandle(forWritingTo: logFileURL) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            }
        } else {
            try? data.write(to: logFileURL)
        }
    }
    
    private func rotateLogFiles() {
        let fileManager = FileManager.default
        let logsDirectory = logFileURL.deletingLastPathComponent()
        
        let logFiles = (try? fileManager.contentsOfDirectory(at: logsDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)) ?? []
        let logFileLimit = 7
        
        if logFiles.count >= logFileLimit {
            let sortedLogFiles = logFiles.sorted { (file1, file2) -> Bool in
                let attributes1 = try? file1.resourceValues(forKeys: [.creationDateKey])
                let attributes2 = try? file2.resourceValues(forKeys: [.creationDateKey])
                return attributes1?.creationDate ?? Date() < attributes2?.creationDate ?? Date()
            }
            
            for logFile in sortedLogFiles.prefix(logFiles.count - logFileLimit + 1) {
                try? fileManager.removeItem(at: logFile)
            }
        }
    }
}
