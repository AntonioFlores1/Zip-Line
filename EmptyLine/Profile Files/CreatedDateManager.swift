//
//  CreatedDateManager.swift
//  EmptyLine
//
//  Created by Donkemezuo Raymond Tariladou on 4/21/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

final class savedDate {
    private init() {}
    
    private static let filename = "CreatedDate.plist"
    private static var dates = [ItemSavedDate]()
    
    static public func fetchDates() -> [ItemSavedDate]{
        let path = DataPersistenceManager.filepathToDcoumentsDirectory(filename:filename).path
        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path) {
                do {
                    dates = try PropertyListDecoder().decode([ItemSavedDate].self, from: data)
                }catch {
                    print("data property list is empty")
                }
                 print("No item was bought on this date ")
            }
        } else {
           print("\(filename) does not exist")
        }
        return dates
    }
    
    static public func save() {
        let path = DataPersistenceManager.filepathToDcoumentsDirectory(filename: filename)
        do {
            let data = try PropertyListEncoder().encode(dates)
            try data.write(to: path, options: Data.WritingOptions.atomic)
        }catch {
            print("property encoding error: \(error.localizedDescription)")
        }
        
    }
    
    static public func add(newDate: ItemSavedDate) {
        if (dates.filter{$0.createdDate == newDate.createdDate}).isEmpty {
            dates.append(newDate)
            save()
        }
    }
    
    
}
