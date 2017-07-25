//
//  DatabaseManager.swift
//  movies
//
//  Created by Thibaud Saint-Etienne on 12/07/2017.
//  Copyright © 2017 Thibaud Saint-Etienne. All rights reserved.
//

import Foundation
import SQLite

class DatabaseManager {
    
    static let instance: DatabaseManager = DatabaseManager()
    private let db: Connection?
    
    private let tableMovie = Table("movie")
    private let movieId = Expression<Int64>("id")
    private let movieTitle = Expression<String?>("title")
    private let movieOverview = Expression<String?>("overview")
    private let movieReleasedate = Expression<String?>("release_date")
    private let moviePosterPath = Expression<String?>("poster_path")
    private let movieGenres = Expression<String?>("genres")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/Application.sqlite3")
        } catch {
            db = nil
            NSLog(">> SQLite : \(error)")
        }
    }
    
    func createTableMovie() {
        do {
            try db!.run(tableMovie.create { t in
                t.column(movieId, primaryKey: true)
                t.column(movieTitle)
                t.column(movieOverview)
                t.column(movieReleasedate)
                t.column(moviePosterPath)
                t.column(movieGenres)
            })
            NSLog(">> SQLite : Table movie created")
        } catch {
            NSLog(">> SQLite : \(error)")
        }
    }
    
    func execute(query: String) -> Array<Any> {
        var arr : [(Any)] = []
        do {
            let sql = try db!.prepare(query)
            for row in sql {
                arr.append(row)
            }
        } catch {
            NSLog(">> SQLite : \(error)")
        }
        return arr
    }
    
}
