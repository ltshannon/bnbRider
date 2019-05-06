//
//  GroupRideModel.swift
//  rider
//
//  Created by admin on 12/30/16.
//  Copyright © 2016 BicycleBNB. All rights reserved.
//

import Foundation
import Kanna
import CoreLocation
import CSV

class GroupRideModel: CoordComparableModel {
    var name: String?
    var dayTime: String?
    var url: String?
    var eventUrl: String?
    var location: String?
    var lengthOfRide: String?
    var discipline: String?
    var notes: String?
    
    
    static func dummyData() -> GroupRideModel {
        let data: GroupRideModel
        data = GroupRideModel.init()
        data.name = "Los Altos \"The Valley Ride\""
        data.dayTime = "Wednesdays (during daylight savings) 18:00"
        data.url = "http://norcalcyclingnews.com/norcal-group-rides"
        data.location = "Peet's Coffee, Los Altos (During Daylight Savings), Los Altos, CA"
        data.lengthOfRide = "28 mi"
        data.discipline = "Road"
        data.notes = "Wednesday at 6pm during daylight savings"
        return data
    }
    
    override func coordTitle() -> String? {
        return name
    }
    
    override func coordSnippet() -> String? {
        return dayTime
    }
}

/*
<tr>
    <td>Performance Bicycle Great Ride Series<br/>
        <a href="http://bicyclebnb.com/event-listings/performance-bicycle-great-ride-series/#add_review" ><button class="btn">Add Review</button></a>
    </td>
    <td>Saturdays </td>
    <td>
        <a href="http://www.meetup.com/Performance-Great-Ride-Series-San-Diego/" target="_blank">Click for website</a>
    </td>
    <td>Performance Bicycle3619 Midway Drive, San Diego, CA, US, 92110</td>
    <td></td>
    <td>14 mi</td>
    <td>Road</td>
    <td></td>
</tr>
*/
extension GroupRideModel {
    static func extractLatLang(fromHTML html: String) -> [Int : (Double, Double)] {
        var result: [Int : (Double, Double)] = [:]
        
        do {
            let regex = try NSRegularExpression(pattern: "position = new google.maps.LatLng\\(([0-9.-]*),([0-9.-]*)\\);[\n\t\r ]*var marker_([0-9]{1,})")
            let nsSearchedString = html as NSString
            let searchedRange = NSMakeRange(0, html.characters.count)
            let matches = regex.matches(in:html, options:[], range:searchedRange)
            for match in matches {
//                let matchText = nsSearchedString.substring(with:match.range);
//                print("match: \(matchText)");
                
                let group1 : NSRange = match.range(at: 1)
                let matchText1 = nsSearchedString.substring(with: group1)
//                print("matchText1: \(matchText1)")
                
                let group2 = match.range(at: 2)
                let matchText2 = nsSearchedString.substring(with: group2)
//                print("matchText2: \(matchText2)")
                
                let group3 = match.range(at: 3)
                let matchText3 = nsSearchedString.substring(with: group3)
//                print("matchText3: \(matchText3)")
                
                if let index = Int(matchText3), let lat = Double(matchText1), let long = Double(matchText2) {
                    result[index] = (lat, long)
                }
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
        }
        
        return result
    }
    
    static func parse(fromHTML html: String) -> [GroupRideModel] {
        
        var result: [GroupRideModel] = []
        
        let optionalString: String? = html
        if  let dataArr = optionalString?.components(separatedBy: "\r\n").map({ $0.components(separatedBy: "\t") })
        {
            for row in dataArr
            {
                var model: GroupRideModel
                model = GroupRideModel.init()
                model.name = row[0]
                model.eventUrl = row[14]
                let day = row[2]
                let time = row[3]
                model.dayTime = day + "/" + time
                model.url = row[14]
                model.location = row[6]
                model.lengthOfRide = row[4]
                model.discipline = row[15]
                model.notes = row[16]
                if let lat = Double(row[7]), let long = Double(row[8]) {
                    model.coordinate = CLLocation(latitude: lat, longitude: long)
                }
                result.append(model)
            }
        }
        
        return result
        
/*
        let csv = try! CSVReader(string: html,
                                 hasHeaderRow: true) // It must be true.
        
        var result: [GroupRideModel] = []
        while let row = csv.next(){
            var model: GroupRideModel
            model = GroupRideModel.init()
            model.name = row[0]
            model.eventUrl = row[14]
            let day = row[2]
            let time = row[3]
            model.dayTime = day + "/" + time
            model.url = row[14]
            model.location = row[6]
            model.lengthOfRide = row[4]
            model.discipline = row[15]
            model.notes = row[16]
            if let lat = Double(row[7]), let long = Double(row[8]) {
                model.coordinate = CLLocation(latitude: lat, longitude: long)
            }
            result.append(model)
        }
        
        return result
*/
/*
        let latLangs = extractLatLang(fromHTML: html)
        
        var result: [GroupRideModel] = []
//        result.append(dummyData())

        do {
            if let doc = try? HTML(html: html, encoding: .utf8) {
            if let snTable = doc.at_css("table[id='shortcode_list']") {
                for (index, tr) in snTable.css("tr").enumerated() {
                    //index == 0 -> TH
                    if index > 0 {
                        var model: GroupRideModel
                        model = GroupRideModel.init()
                        model.name = tr.at_css("td:nth-child(1)")?.text?.replacingOccurrences(of: "Add Review", with: "")
                        model.eventUrl = tr.at_css("td:nth-child(1)>a")?["href"]
                        model.dayTime = tr.at_css("td:nth-child(2)")?.text
                        model.url = tr.at_css("td:nth-child(3)>a")?["href"]
                        model.location = tr.at_css("td:nth-child(4)")?.text
                        model.lengthOfRide = tr.at_css("td:nth-child(6)")?.text
                        model.discipline = tr.at_css("td:nth-child(7)")?.text
                        model.notes = tr.at_css("td:nth-child(8)")?.text
                        
                        print("\(index): \(model.name) \(model.location)")
                        if let (lat, long) = latLangs[index - 1] {
                            model.coordinate = CLLocation(latitude: lat, longitude: long)
                            print("=>\(index): \(model.coordinate)")
                        }
                        
                        
                        result.append(model)
                    }
                }
            }
        }

        }

        return result
 */
    }

}

