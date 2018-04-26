//
//  User.swift
//  WhatAmIEating
//
//  Created by Bárbara Ferreira on 31/03/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import Foundation

class User {
    var email: String
    var name: String
    var uid: String
    var shareFromDetails: Int
    var shareFromPhoto: Int
    
    init(email: String, name: String, uid: String){
        self.email = email
        self.name = name
        self.uid = uid
        self.shareFromDetails = 0
        self.shareFromPhoto = 0
    }
}

