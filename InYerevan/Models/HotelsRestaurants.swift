//
//  HotelsRestaurants.swift
//  InYerevan
//
//  Created by HarutMikichyan on 1/10/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//


struct HotelsType {
    var id: String
    var hotelName: String
    var hotelStar: String
    var hotelPhoneNumber: String
    var openingHoursHotel: String
    var hotelLocationLong: Double
    var hotelLocationLat: Double
    var priceHotel: Double
    var hotelRateSum: Double
    var hotelRateCount: Int
    var hotelImageUrl: [String]
    var hotelRate: Double
}

struct RestaurantsType {
    var id: String
    var restaurantName: String
    var restaurantPhoneNumber: String
    var openingHoursRestaurant: String
    var restaurantLocationLong: Double
    var restaurantLocationLat: Double
    var priceRestaurant: Double
    var restaurantRateSum: Double
    var restaurantRateCount: Int
    var restaurantImageUrl: [String]
    var restaurantRate: Double
}

struct CurrencyType {
    var id: String
    var currencyEUR: Double
    var currencyUSD: Double
    var currencyRUR: Double
}

extension HotelsType: Comparable {
    static func < (lhs: HotelsType, rhs: HotelsType) -> Bool {
        return lhs.hotelRate > rhs.hotelRate
    }
}

extension RestaurantsType: Comparable {
    static func < (lhs: RestaurantsType, rhs: RestaurantsType) -> Bool {
        return lhs.restaurantRate > rhs.restaurantRate
    }
}
