//
//  StringExtension.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/22/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import Foundation

extension String {
  func alphaNumOnlyValidation() -> Bool {
    let regex = NSRegularExpression(pattern: "[^0-9a-zA-Z\n]", options: nil, error: nil)
    let match = regex?.numberOfMatchesInString(self, options: nil, range: NSRange(location: 0, length: countElements(self)))
    if (match > 0) {
      return false
    } else {
      return true
    }
  }
}