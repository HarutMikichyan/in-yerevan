//
//  HotelsRestaurants.swift
//  InYerevan
//
//  Created by HarutMikichyan on 1/10/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import Foundation

struct TopHotelsType {
    var id: String
    var hotelName: String
}

struct HotelsType {
    var id: String
    var hotelName: String
    var hotelStar: String
}

struct HotelDescriptionType {
    var id: String
    var hotelName: String
    var hotelStar: String
    var hotelPhoneNumber: String
    var openingHoursHotel: String
    var hotelLocation: String
}

struct TopRestaurantsType {
    var id: String
    var hotelName: String
}

struct RestaurantsType {
    var id: String
    var hotelName: String
    var hotelPhoneNumber: String
}

struct RestaurantsDescriptionType {
    var id: String
    var hotelName: String
    var hotelPhoneNumber: String
    var openingHoursHotel: String
    var hotelLocation: String
}
