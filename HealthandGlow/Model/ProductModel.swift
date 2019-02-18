//
//  ProductModel.swift
//  HealthandGlow
//
//  Created by SENTHILKUMAR on 16/02/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

class DataModel {
    
    var promoText : String?
    var wishlist : Bool?
    var productImageUrl : String?
    var productName : String?
    var finalPrice : Int?
    var actualPrice : Int?
 init(promoText:String,wishlist:Bool,productImageUrl:String,productName:String,finalPrice:Int,actualPrice:Int) {
        
        self.promoText = promoText
        self.wishlist = wishlist
        self.productImageUrl = productImageUrl
        self.productName = productName
        self.finalPrice = finalPrice
        self.actualPrice = actualPrice
        
    }
    
}
