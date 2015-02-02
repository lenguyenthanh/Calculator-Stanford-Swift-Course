//
//  OperationEnum.swift
//  Calculator
//
//  Created by Thanh Le on 1/31/15.
//  Copyright (c) 2015 Thanh Le. All rights reserved.
//

import Foundation

enum OperatorEnum: String {
  case Addition = "+"
  case Subtraction = "−"
  case Mutiplication = "×"
  case Division = "÷"
  
  case Sqrt = "√"
  case CubeRoot = "∛"
  case Sin = "Sin"
  case Cos = "Cos"
  case Tan = "Tan"
  case Square = "x²"
  case Cube = "x³"
  
  func display(operand1: String, operand2: String) -> String?{
    switch self{
    case .Subtraction, .Addition:
      return "(" + operand2 + " " + rawValue +  " " + operand1 + ")"
    case .Division,  .Mutiplication:
      return operand2 + " " + rawValue +  " " + operand1
    default:
      return nil
    }
  }
  
  func display(operand: String) -> String?{
    switch self{
    case .Sqrt, .Sin, .Cos, .Tan, .CubeRoot:
      return rawValue + "(" + operand + ")"
    case .Square:
      return operand + "²"
    case .Cube:
      return operand + "³"
    default:
      return nil
    }
  }
  
}