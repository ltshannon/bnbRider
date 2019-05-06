//
//  WebService.swift
//  rider
//
//  Created by admin on 1/3/17.
//  Copyright © 2017 BicycleBNB. All rights reserved.
//

import Foundation
import Alamofire

class WebService {
    static func getGroupRides(completion: ((_ success:Bool, _ result: [GroupRideModel]?) -> Void)?) {
//        AF.request(GlobalConstants.BNB_LIST_RIDE_URL).responseString { response in
        AF.request(GlobalConstants.GOOGLE_SHEET_URL).responseString { response in

            if response.data != nil,
                let html = response.value {
                print("Success listings-events")
                print(html)
                completion?(true, GroupRideModel.parse(fromHTML: html))
            } else {
                completion?(false, [])
            }
 
        }
    }
    
    static func getProperties(completion: ((_ success:Bool, _ result: [AccommodationModel]?) -> Void)?) {
/*
        AF.request(GlobalConstants.BNB_LIST_PROPERTY_URL).responseSting { response in
            if response.result.isSuccess,
                let html = response.result.value {
                print("Success listings-properties")
                completion?(true, AccommodationModel.parse(fromHTML: html))
            } else {
                completion?(false, [])
            }
        }
*/
    }
    
    static func getBikeShops(completion: ((_ success:Bool, _ result: [BikeShopModel]?) -> Void)?) {

        AF.request(GlobalConstants.GOOGLE_SHEET_BIKE_SHOP).responseJSON { response in
            if response.data != nil {
                let json = response.value as! [String: Any] 
                print("Success listings-bikeshops")
                print(json)
                completion?(true, BikeShopModel.parse(fromJSON: json))
            } else {
                completion?(false, [])
            }
        }
 
    }
    
    static func getRaces(completion: ((_ success:Bool, _ result: [RaceModel]?) -> Void)?) {
/*
        AF.request(GlobalConstants.BNB_LIST_RACE_URL).responseString { response in
            if response.result.isSuccess,
                let html = response.result.value {
                print("Success listings-events")
                completion?(true, RaceModel.parse(fromHTML: html))
            } else {
                completion?(false, [])
            }
        }
 */
    }
}
