//
//  FileManagerExtension.swift
//  AVFoundationExample
//
//  Created by Benny Reyes on 29/03/23.
//

import Foundation

extension FileManager{
    
    static func getDocumentsDirectory(appendPath:String = "") -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("BAZ || documents URL: \(paths.first?.absoluteString ?? "N/A")")
        return paths.first?.appending(component: appendPath)
    }
    
    static func ifFileExist(_ path:String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
}



