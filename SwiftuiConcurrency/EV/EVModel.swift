//
//  EVModel.swift
//  SwiftuiConcurrency
//
//  Created by hb on 09/01/25.
//

import Foundation

enum EVModel {
    
    struct Request {
        var lat: Double
        var lng: Double
    }
    
    
    struct ViewModel : Codable {
        
        let data : [Data]?
        let requestId : String?
        let status : String?
        
        
        enum CodingKeys: String, CodingKey {
            case data = "data"
            case requestId = "request_id"
            case status = "status"
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            data = try values.decodeIfPresent([Data].self, forKey: .data)
            requestId = try values.decodeIfPresent(String.self, forKey: .requestId)
            status = try values.decodeIfPresent(String.self, forKey: .status)
        }
    }
    
    struct Data : Codable {

        let addressComponents : AddressComponent?
        let connectors : [Connector]?
        let formattedAddress : String?
        let googleCid : String?
        let googlePlaceId : String?
        let id : String?
        let latitude : Float?
        let longitude : Float?
        let name : String?
        let openingHours : OpeningHour?
        let phoneNumber : String?
        let photo : String?
        let placeLink : String?
        let rating : String?
        let reviewCount : Int?
        let website : String?


        enum CodingKeys: String, CodingKey {
            case addressComponents
            case connectors = "connectors"
            case formattedAddress = "formatted_address"
            case googleCid = "google_cid"
            case googlePlaceId = "google_place_id"
            case id = "id"
            case latitude = "latitude"
            case longitude = "longitude"
            case name = "name"
            case openingHours = "opening_hours"
            case phoneNumber = "phone_number"
            case photo = "photo"
            case placeLink = "place_link"
            case rating = "rating"
            case reviewCount = "review_count"
            case website = "website"
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            addressComponents = try AddressComponent(from: decoder)
            connectors = try values.decodeIfPresent([Connector].self, forKey: .connectors)
            formattedAddress = try values.decodeIfPresent(String.self, forKey: .formattedAddress)
            googleCid = try values.decodeIfPresent(String.self, forKey: .googleCid)
            googlePlaceId = try values.decodeIfPresent(String.self, forKey: .googlePlaceId)
            id = try values.decodeIfPresent(String.self, forKey: .id)
            latitude = try values.decodeIfPresent(Float.self, forKey: .latitude)
            longitude = try values.decodeIfPresent(Float.self, forKey: .longitude)
            name = try values.decodeIfPresent(String.self, forKey: .name)
            openingHours = try values.decodeIfPresent(OpeningHour.self, forKey: .openingHours)
            phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
            photo = try values.decodeIfPresent(String.self, forKey: .photo)
            placeLink = try values.decodeIfPresent(String.self, forKey: .placeLink)
            rating = try values.decodeIfPresent(String.self, forKey: .rating)
            reviewCount = try values.decodeIfPresent(Int.self, forKey: .reviewCount)
            website = try values.decodeIfPresent(String.self, forKey: .website)
        }
    }
    
    struct OpeningHour : Codable {

        let friday : [String]?
        let monday : [String]?
        let saturday : [String]?
        let sunday : [String]?
        let thursday : [String]?
        let tuesday : [String]?
        let wednesday : [String]?


        enum CodingKeys: String, CodingKey {
            case friday = "Friday"
            case monday = "Monday"
            case saturday = "Saturday"
            case sunday = "Sunday"
            case thursday = "Thursday"
            case tuesday = "Tuesday"
            case wednesday = "Wednesday"
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            friday = try values.decodeIfPresent([String].self, forKey: .friday)
            monday = try values.decodeIfPresent([String].self, forKey: .monday)
            saturday = try values.decodeIfPresent([String].self, forKey: .saturday)
            sunday = try values.decodeIfPresent([String].self, forKey: .sunday)
            thursday = try values.decodeIfPresent([String].self, forKey: .thursday)
            tuesday = try values.decodeIfPresent([String].self, forKey: .tuesday)
            wednesday = try values.decodeIfPresent([String].self, forKey: .wednesday)
        }
    }
    
    struct Connector : Codable {

        let available : String?
        let kw : Int?
        let speed : String?
        let total : Int?
        let type : String?


        enum CodingKeys: String, CodingKey {
            case available = "available"
            case kw = "kw"
            case speed = "speed"
            case total = "total"
            case type = "type"
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            available = try values.decodeIfPresent(String.self, forKey: .available)
            kw = try values.decodeIfPresent(Int.self, forKey: .kw)
            speed = try values.decodeIfPresent(String.self, forKey: .speed)
            total = try values.decodeIfPresent(Int.self, forKey: .total)
            type = try values.decodeIfPresent(String.self, forKey: .type)
        }
    }
    
    struct AddressComponent : Codable {

        let city : String?
        let country : String?
        let district : String?
        let state : String?
        let streetAddress : String?
        let zipcode : String?


        enum CodingKeys: String, CodingKey {
            case city = "city"
            case country = "country"
            case district = "district"
            case state = "state"
            case streetAddress = "street_address"
            case zipcode = "zipcode"
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            city = try values.decodeIfPresent(String.self, forKey: .city)
            country = try values.decodeIfPresent(String.self, forKey: .country)
            district = try values.decodeIfPresent(String.self, forKey: .district)
            state = try values.decodeIfPresent(String.self, forKey: .state)
            streetAddress = try values.decodeIfPresent(String.self, forKey: .streetAddress)
            zipcode = try values.decodeIfPresent(String.self, forKey: .zipcode)
        }
    }
}

// demo response
/**
 {"status":"OK","request_id":"01dd43e8-60c4-454c-a6f5-a5b29785b990","data":[{"id":"0x89c259812fed6abd:0xa19922d17d845d30","name":"EV Connect Charging Station","connectors":[{"type":"CHAdeMO","total":1,"available":0,"kw":150,"speed":"Very fast"},{"type":"CCS","total":1,"available":0,"kw":150,"speed":"Very fast"},{"type":"CHAdeMO","total":3,"available":3,"kw":50,"speed":"Fast"},{"type":"CCS","total":3,"available":3,"kw":50,"speed":"Fast"},{"type":"J1772","total":2,"available":1,"kw":12,"speed":"Medium"},{"type":"J1772","total":6,"available":4,"kw":7.4,"speed":"Slow"}],"formatted_address":"107 Essex St, New York, NY 10002","address_components":{"district":"Manhattan","street_address":"107 Essex St","city":"New York","zipcode":"10002","state":"New York","country":"US"},"latitude":40.719318699999995,"longitude":-73.9881965,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c259812fed6abd:0xa19922d17d845d30","phone_number":"+18668167584","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":3.1,"review_count":13,"website":"https://www.evconnect.com","photo":"https://lh5.googleusercontent.com/p/AF1QipNFzbA3cssxPtsrvueNRF32nkkapRwsq1wC_4gp=w4032-h3024-k-no","google_place_id":"ChIJvWrtL4FZwokRMF2EfdEimaE","google_cid":"11644376594692463920"},{"id":"0x89c25a1c923a76af:0x11a1c3ce944864af","name":"ChargePoint Charging Station","connectors":[{"type":"CCS","total":1,"available":null,"kw":23.9,"speed":"Medium"}],"formatted_address":"20 River Terrace Apt 3E, New York, NY 10282","address_components":{"district":"Manhattan","street_address":"20 River Terrace Apt 3E","city":"New York","zipcode":"10282","state":"New York","country":"US"},"latitude":40.716305299999995,"longitude":-74.016194,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c25a1c923a76af:0x11a1c3ce944864af","phone_number":"+18887584389","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":3,"review_count":4,"website":"https://na.chargepoint.com/charge_point?id=1:111757&action=VIEW","photo":"https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=ocYeRYhglCQgo69QDU73vw&cb_client=search.gws-prod.gps&w=86&h=86&yaw=22.136114&pitch=0&thumbfov=100","google_place_id":"ChIJr3Y6khxawokRr2RIlM7DoRE","google_cid":"1270511861913642159"},{"id":"0x89c25a2787498e69:0xc5d34e34fc306102","name":"Tesla Supercharger","connectors":[{"type":"Tesla","total":2,"available":null,"kw":72,"speed":"Fast"}],"formatted_address":"106 Mott St, New York, NY 10013","address_components":{"district":"Manhattan","street_address":"106 Mott St","city":"New York","zipcode":"10013","state":"New York","country":"US"},"latitude":40.7174949,"longitude":-73.9973076,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c25a2787498e69:0xc5d34e34fc306102","phone_number":"+12122198940","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":2,"review_count":11,"website":"https://www.tesla.com","photo":"https://lh5.googleusercontent.com/p/AF1QipN5OxEFfv3fZ9u8VbM2dGr4SgUgfoh7Q6tc81-v=w4048-h3036-k-no","google_place_id":"ChIJaY5JhydawokRAmEw_DRO08U","google_cid":"14254823235034046722"},{"id":"0x89c25b60a254bfcd:0x1915940026b9f67e","name":"Tesla Supercharger","connectors":[{"type":"Tesla","total":4,"available":null,"kw":72,"speed":"Fast"}],"formatted_address":"250 Vesey St, New York, NY 10080","address_components":{"district":"Manhattan","street_address":"250 Vesey St","city":"New York","zipcode":"10080","state":"New York","country":"US"},"latitude":40.7143051,"longitude":-74.01639569999999,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c25b60a254bfcd:0x1915940026b9f67e","phone_number":"+18777983752","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":1.9,"review_count":9,"website":"https://www.tesla.com","photo":"https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=cRlKbswI2nedD1Za1TKDZg&cb_client=search.gws-prod.gps&w=86&h=86&yaw=107.08614&pitch=0&thumbfov=100","google_place_id":"ChIJzb9UomBbwokRfva5JgCUFRk","google_cid":"1807513553829754494"},{"id":"0x89c25a229c651dd3:0x5675f8756d59ec21","name":"Blink Charging Station","connectors":[{"type":"Tesla","total":3,"available":null,"kw":16,"speed":"Medium"}],"formatted_address":"25 Beekman St, New York, NY 10038","address_components":{"district":"Manhattan","street_address":"25 Beekman St","city":"New York","zipcode":"10038","state":"New York","country":"US"},"latitude":40.710636,"longitude":-74.00619499999999,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c25a229c651dd3:0x5675f8756d59ec21","phone_number":"+18889982546","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":4,"review_count":9,"website":"https://www.blinkcharging.com","photo":"https://lh5.googleusercontent.com/p/AF1QipOole0QNVHW6vquUiqauqXW_1bH55Qvfe3kxsWY=w4032-h3024-k-no","google_place_id":"ChIJ0x1lnCJawokRIexZbXX4dVY","google_cid":"6230158842766421025"},{"id":"0x89c259877924e52f:0x51f8212c10a58def","name":"Blink Charging Station","connectors":[{"type":"J1772","total":1,"available":0,"kw":19.2,"speed":"Medium"},{"type":"J1772","total":1,"available":1,"kw":8.64,"speed":"Slow"}],"formatted_address":"59 Allen St, New York, NY 10002","address_components":{"district":"Manhattan","street_address":"59 Allen St","city":"New York","zipcode":"10002","state":"New York","country":"US"},"latitude":40.717152999999996,"longitude":-73.991869,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c259877924e52f:0x51f8212c10a58def","phone_number":"+18777983752","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":1.4,"review_count":9,"website":"https://www.blinkcharging.com","photo":"https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=ij8dxCpZdFAmtcPveGDMKQ&cb_client=search.gws-prod.gps&w=86&h=86&yaw=286.5362&pitch=0&thumbfov=100","google_place_id":"ChIJL-UkeYdZwokR742lECwh-FE","google_cid":"5906507384437968367"},{"id":"0x89c259f2a148f5bb:0x44a70436e5ec433b","name":"Blink Charging Station","connectors":[{"type":"J1772","total":2,"available":1,"kw":8.64,"speed":"Slow"}],"formatted_address":"375 Hudson St, New York, NY 10014","address_components":{"district":"Manhattan","street_address":"375 Hudson St","city":"New York","zipcode":"10014","state":"New York","country":"US"},"latitude":40.7286308,"longitude":-74.00761779999999,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c259f2a148f5bb:0x44a70436e5ec433b","phone_number":"+18889982546","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":3.3,"review_count":6,"website":"http://www.blinkcharging.com","photo":"https://lh5.googleusercontent.com/p/AF1QipPzp53eIzxTZMIBPfyInKtCVbVvG7DnYSZmq3Uf=w3072-h4096-k-no","google_place_id":"ChIJu_VIofJZwokRO0Ps5TYEp0Q","google_cid":"4946927349521990459"},{"id":"0x89c259f5855e5e9b:0xaf8cef6ed02f032a","name":"Blink Charging Station","connectors":[{"type":"J1772","total":1,"available":0,"kw":6.64,"speed":"Slow"}],"formatted_address":"40 Harrison St, New York, NY 10013","address_components":{"district":"Manhattan","street_address":"40 Harrison St","city":"New York","zipcode":"10013","state":"New York","country":"US"},"latitude":40.7191046,"longitude":-74.0112166,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c259f5855e5e9b:0xaf8cef6ed02f032a","phone_number":"+18889982546","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":4.7,"review_count":3,"website":"https://www.blinkcharging.com","photo":"https://lh5.googleusercontent.com/p/AF1QipNOsc-MTTE_g6wI5qekRo5pIKHLq8zjDtgvWAyt=w3024-h4032-k-no","google_place_id":"ChIJm15ehfVZwokRKgMv0G7vjK8","google_cid":"12649748712595063594"},{"id":"0x89c2599732d61129:0xb37ae7903967fd7f","name":"ViaLynk Charging Station","connectors":[{"type":"J1772","total":4,"available":0,"kw":7.68,"speed":"Slow"}],"formatted_address":"2 5th Ave, New York, NY 10011","address_components":{"district":"Manhattan","street_address":"2 5th Ave","city":"New York","zipcode":"10011","state":"New York","country":"US"},"latitude":40.732369999999996,"longitude":-73.99678,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c2599732d61129:0xb37ae7903967fd7f","phone_number":"+15186913119","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":null,"review_count":0,"website":"https://lynkwell.com","photo":"https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=501sAn8csfVg03hNAHqXLw&cb_client=search.gws-prod.gps&w=86&h=86&yaw=237.43752&pitch=0&thumbfov=100","google_place_id":"ChIJKRHWMpdZwokRf_1nOZDnerM","google_cid":"12932903886572223871"},{"id":"0x89c25990316d8999:0x2100e5dd35a41d01","name":"ChargePoint Charging Station","connectors":[{"type":"J1772","total":4,"available":2,"kw":6.48,"speed":"Slow"}],"formatted_address":"2 Washington Square Village, New York, NY 10012","address_components":{"district":"Manhattan","street_address":"2 Washington Square Village","city":"New York","zipcode":"10012","state":"New York","country":"US"},"latitude":40.728283,"longitude":-73.99725099999999,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c25990316d8999:0x2100e5dd35a41d01","phone_number":"+18887584389","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":null,"review_count":0,"website":"https://na.chargepoint.com/charge_point?id=1:10088841&action=VIEW","photo":"https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=pSmjF8e--SPfijcs7rl9zg&cb_client=search.gws-prod.gps&w=86&h=86&yaw=87.76021&pitch=0&thumbfov=100","google_place_id":"ChIJmYltMZBZwokRAR2kNd3lACE","google_cid":"2378153341502102785"},{"id":"0x89c25a160f31c9bd:0x48dd6311efb62b5e","name":"Porsche Destination Charging","connectors":[{"type":"Type 2","total":6,"available":null,"kw":11,"speed":"Medium"}],"formatted_address":"96 Front St, New York, NY 10005","address_components":{"district":"Manhattan","street_address":"96 Front St","city":"New York","zipcode":"10005","state":"New York","country":"US"},"latitude":40.7045253,"longitude":-74.007376,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c25a160f31c9bd:0x48dd6311efb62b5e","phone_number":"+19143500852","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":null,"review_count":0,"website":"https://porsche.com/destinationcharging","photo":"https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=lcgo1Bp9srf5Z-PEHNuqFw&cb_client=search.gws-prod.gps&w=86&h=86&yaw=334.17184&pitch=0&thumbfov=100","google_place_id":"ChIJvckxDxZawokRXiu27xFj3Ug","google_cid":"5250461669271153502"},{"id":"0x89c2599bad93e185:0x8b8a263d7c848b77","name":"Blink Charging Station","connectors":[{"type":"J1772","total":1,"available":1,"kw":8.64,"speed":"Slow"},{"type":"J1772","total":1,"available":1,"kw":6.62,"speed":"Slow"}],"formatted_address":"445 Lafayette St, New York, NY 10003","address_components":{"district":"Manhattan","street_address":"445 Lafayette St","city":"New York","zipcode":"10003","state":"New York","country":"US"},"latitude":40.729625399999996,"longitude":-73.991329,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c2599bad93e185:0x8b8a263d7c848b77","phone_number":"+18889982546","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":5,"review_count":1,"website":"http://www.blinkcharging.com","photo":"https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=Khapar-_uEKl79dEyX92bA&cb_client=search.gws-prod.gps&w=86&h=86&yaw=127.457436&pitch=0&thumbfov=100","google_place_id":"ChIJheGTrZtZwokRd4uEfD0mios","google_cid":"10054891163581975415"},{"id":"0x89c25a220cfc3ab7:0xff80ef840716dfc","name":"Blink Charging Station","connectors":[{"type":"J1772","total":1,"available":0,"kw":6.78,"speed":"Slow"},{"type":"J1772","total":1,"available":0,"kw":6.6,"speed":"Slow"}],"formatted_address":"New York, NY 10087","address_components":{"district":"Manhattan","street_address":null,"city":"New York","zipcode":"10087","state":"New York","country":"US"},"latitude":40.712775199999996,"longitude":-74.0059728,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c25a220cfc3ab7:0xff80ef840716dfc","phone_number":"+18889982546","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":null,"review_count":0,"website":"https://blinkcharging.com","photo":"https://lh5.googleusercontent.com/p/AF1QipO4dXgL9UJTI2_CYu8DQt4V5L_a0tqyofIrjplr=w720-h388-k-no","google_place_id":"ChIJtzr8DCJawokR_G1xQPgO-A8","google_cid":"1150686164189015548"},{"id":"0x89c25a194a8e61ab:0x41c63ac693c18759","name":"Blink Charging Station","connectors":[{"type":"J1772","total":1,"available":1,"kw":6.45,"speed":"Slow"}],"formatted_address":"75 Park Pl, New York, NY 10007","address_components":{"district":"Manhattan","street_address":"75 Park Pl","city":"New York","zipcode":"10007","state":"New York","country":"US"},"latitude":40.714462999999995,"longitude":-74.01098,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c25a194a8e61ab:0x41c63ac693c18759","phone_number":"+18889982546","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":4.7,"review_count":3,"website":"http://www.blinkcharging.com","photo":"https://lh5.googleusercontent.com/p/AF1QipOuUb0GXgN3Cvin2b66l5qP8iwFg8wtEZ9U3m5c=w2252-h4000-k-no","google_place_id":"ChIJq2GOShlawokRWYfBk8Y6xkE","google_cid":"4739540282410895193"},{"id":"0x89c25a1c5a1dc6f5:0xdf8d03c7d5b30f77","name":"Blink Charging Station","connectors":[{"type":"J1772","total":1,"available":1,"kw":8.23,"speed":"Slow"},{"type":"J1772","total":1,"available":1,"kw":6.7,"speed":"Slow"},{"type":"J1772","total":1,"available":0,"kw":6.6,"speed":"Slow"}],"formatted_address":"325 North End Ave, New York, NY 10282","address_components":{"district":"Manhattan","street_address":"325 North End Ave","city":"New York","zipcode":"10282","state":"New York","country":"US"},"latitude":40.71695,"longitude":-74.01494799999999,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c25a1c5a1dc6f5:0xdf8d03c7d5b30f77","phone_number":"+18889982546","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":5,"review_count":1,"website":"http://www.blinkcharging.com","photo":"https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=a9t4uiHby5Uw58u-bODOJg&cb_client=search.gws-prod.gps&w=86&h=86&yaw=295.25516&pitch=0&thumbfov=100","google_place_id":"ChIJ9cYdWhxawokRdw-z1ccDjd8","google_cid":"16108535598992789367"},{"id":"0x89c25a1a90e781a1:0x3bf96782a6f505e4","name":"Tesla Destination Charger","connectors":[{"type":"Tesla","total":3,"available":null,"kw":16,"speed":"Medium"}],"formatted_address":"339 S End Ave, New York, NY 10280","address_components":{"district":"Manhattan","street_address":"339 S End Ave","city":"New York","zipcode":"10280","state":"New York","country":"US"},"latitude":40.711144999999995,"longitude":-74.01633199999999,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c25a1a90e781a1:0x3bf96782a6f505e4","phone_number":"+18008366666","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":null,"review_count":0,"website":"https://www.tesla.com","photo":"https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=HZx1pKOaShVyeK75xYbgew&cb_client=search.gws-prod.gps&w=86&h=86&yaw=294.0119&pitch=0&thumbfov=100","google_place_id":"ChIJoYHnkBpawokR5AX1poJn-Ts","google_cid":"4321599128283186660"},{"id":"0x89c25a20e0ba7235:0xad923a675738e20a","name":"FLO Charging Station","connectors":[{"type":"J1772","total":4,"available":null,"kw":7.4,"speed":"Slow"}],"formatted_address":"130 Leonard St, New York, NY 10013","address_components":{"district":"Manhattan","street_address":"130 Leonard St","city":"New York","zipcode":"10013","state":"New York","country":"US"},"latitude":40.716079,"longitude":-74.0021639,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c25a20e0ba7235:0xad923a675738e20a","phone_number":"+18448253356","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":1,"review_count":1,"website":"https://flo.ca","photo":"https://lh5.googleusercontent.com/p/AF1QipOtQ7Jt9pNkwYmZzVeNL9nLrtce1P1qIuWhdhb7=w4032-h3024-k-no","google_place_id":"ChIJNXK64CBawokRCuI4V2c6kq0","google_cid":"12507123330680676874"},{"id":"0x89c2599436e3504f:0xbf503ce00e15b1be","name":"Blink Charging Station","connectors":[{"type":"J1772","total":1,"available":1,"kw":3.35,"speed":"Slow"}],"formatted_address":"160 W 10th St, New York, NY 10014","address_components":{"district":"Manhattan","street_address":"160 W 10th St","city":"New York","zipcode":"10014","state":"New York","country":"US"},"latitude":40.7348833,"longitude":-74.0016337,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c2599436e3504f:0xbf503ce00e15b1be","phone_number":"+18889982546","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":null,"review_count":0,"website":"http://www.blinkcharging.com","photo":"https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=cTslG6yiE4zwZoOrEApj1w&cb_client=search.gws-prod.gps&w=86&h=86&yaw=275.7856&pitch=0&thumbfov=100","google_place_id":"ChIJT1DjNpRZwokRvrEVDuA8UL8","google_cid":"13785585392387731902"},{"id":"0x89c25a11eae251a5:0xcdd13848a227d396","name":"Tesla Destination Charger","connectors":[{"type":"Tesla","total":3,"available":null,"kw":16,"speed":"Medium"}],"formatted_address":"70 Little W St, New York, NY 10280","address_components":{"district":"Manhattan","street_address":"70 Little W St","city":"New York","zipcode":"10280","state":"New York","country":"US"},"latitude":40.7066309,"longitude":-74.0169138,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c25a11eae251a5:0xcdd13848a227d396","phone_number":"+12123498316","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":null,"review_count":0,"website":"https://www.tesla.com","photo":"https://lh5.googleusercontent.com/p/AF1QipPzgffHYgU9A0F4UKUuhKYnuBXWDEzOy_SRihLE=w768-h1024-k-no","google_place_id":"ChIJpVHi6hFawokRltMnokg40c0","google_cid":"14830696932517073814"},{"id":"0x89c2598bdb106f43:0x993515537b6df912","name":"Tesla Destination Charger","connectors":[{"type":"Tesla","total":3,"available":null,"kw":13,"speed":"Medium"}],"formatted_address":"40 Mercer St, New York, NY 10025","address_components":{"district":"Manhattan","street_address":"40 Mercer St","city":"New York","zipcode":"10025","state":"New York","country":"US"},"latitude":40.7214429,"longitude":-74.0009566,"place_link":"https://www.google.com/maps/place/data=!3m1!4b1!4m2!3m1!1s0x89c2598bdb106f43:0x993515537b6df912","phone_number":"+12122193413","opening_hours":{"Thursday":["Open 24 hours"],"Friday":["Open 24 hours"],"Saturday":["Open 24 hours"],"Sunday":["Open 24 hours"],"Monday":["Open 24 hours"],"Tuesday":["Open 24 hours"],"Wednesday":["Open 24 hours"]},"rating":null,"review_count":0,"website":"https://www.tesla.com/charging","photo":"https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=mWXJSisIh3rTB7KMmDtYsw&cb_client=search.gws-prod.gps&w=86&h=86&yaw=129.23563&pitch=0&thumbfov=100","google_place_id":"ChIJQ28Q24tZwokREvlte1MVNZk","google_cid":"11039753509865912594"}]}
 
 */
