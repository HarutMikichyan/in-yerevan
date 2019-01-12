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
    var hotelPhoneNumber: String
    var openingHoursHotel: String
    var hotelLocationLong: Double
    var hotelLocationLat: Double
}

struct TopRestaurantsType {
    var id: String
    var restaurantName: String
}

struct RestaurantsType {
    var id: String
    var restaurantName: String
    var restaurantPhoneNumber: String
    var openingHoursRestaurant: String
    var restaurantLocationLong: Double
    var restaurantLocationLat: Double
}
