//
//  String.swift
//  Earthshake
//
//  Created by Andrey on 2016-12-30.
//  Copyright © 2016 AP. All rights reserved.
//

import Foundation

extension String
{
    var localized: String
    {
        return NSLocalizedString(self, comment: "")
    }
}
