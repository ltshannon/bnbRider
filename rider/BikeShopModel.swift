//
//  BikeShopModel.swift
//  rider
//
//  Created by admin on 12/31/16.
//  Copyright © 2016 BicycleBNB. All rights reserved.
//

import Foundation
import CoreLocation

class BikeShopModel: CoordComparableModel {
    var name: String?
    var location: String?
    var phone: String?
    var url: String?
    
    static func dummyData() -> BikeShopModel {
        let data: BikeShopModel
        data = BikeShopModel.init()
        
        data.url = "http://coconinocycles.com"
        data.name = "Coconino Cycles"
        data.location = "1235 Palmer Ave, Flagstaff, AZ 86001"
        data.phone = "(928)774-7747"
        
        return data
    }
    
    override func coordTitle() -> String? {
        return name
    }
    
    override func coordSnippet() -> String? {
        return phone
    }
}

extension BikeShopModel {
    static func parse(fromJSON json:[String:Any]) -> [BikeShopModel] {
        var result: [BikeShopModel] = []
        if let feed = json["feed"] as? [String:Any],
            let entry = feed["entry"] as? [[String:Any]] {
            for row in entry {
                let approved = (row["gsx$approved"] as? [String:String])?["$t"]
                if(approved?.compare("YES") == ComparisonResult.orderedSame) {
                    var model: BikeShopModel
                    model = BikeShopModel.init()
                    
                    if let address = (row["gsx$address"] as? [String:String])?["$t"] {
                        model.location = address
                    }
                    
                    model.phone = (row["gsx$phone"] as? [String:String])?["$t"]
                    model.name = (row["gsx$name"] as? [String:String])?["$t"]
                    model.url = (row["gsx$website"] as? [String:String])?["$t"]
                    
                    if let lat = (row["gsx$latitude"] as? [String:String])?["$t"],
                        let long = (row["gsx$longitude"] as? [String:String])?["$t"] {
                        if let dlat = Double(lat), let dlong = Double(long) {
                            model.coordinate = CLLocation(latitude: dlat, longitude: dlong)
                        }
                    }
                    
                    result.append(model)
                }
            }
        }
        return result
    }
}

