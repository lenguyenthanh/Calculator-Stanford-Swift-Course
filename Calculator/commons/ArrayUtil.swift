//
//  ArrayUtil.swift
//  Calculator
//
//  Created by Thanh Le on 1/31/15.
//  Copyright (c) 2015 Thanh Le. All rights reserved.
//

import Foundation

struct ArrayUtil {
  static func removeLast<T>(array: [T]) -> [T]{
    var tempArray = array
    tempArray.removeLast()
    return tempArray
  }
}