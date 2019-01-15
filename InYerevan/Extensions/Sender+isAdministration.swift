//
//  Sender+isAdministration.swift
//  InYerevan
//
//  Created by Vahram Tadevosian on 1/15/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import Foundation
import MessageKit

extension Sender {
    func isAdministration() -> Bool {
        return User.administration.contains(self.displayName)
    }
}
