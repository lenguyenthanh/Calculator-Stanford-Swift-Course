//
//  ViewController.swift
//  Calculator
//
//  Created by Thanh Le on 1/28/15.
//  Copyright (c) 2015 Thanh Le. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var display: UILabel!
  
  var userIsInTheMiddleOfTypingNumber: Bool = false
  let brain = CalculatorBrain()
  
  @IBAction func appendDigit(sender: UIButton) {
    let digit = sender.currentTitle!
    println("digit = \(digit)")
    
    if !userIsInTheMiddleOfTypingNumber{
      display.text = digit
      userIsInTheMiddleOfTypingNumber = true
    }else{
      display.text = display.text! + digit
    }
  }
  
  private func validate(digit: String){
    
  }
  
  @IBAction func operate(sender: UIButton) {
    let operation = sender.currentTitle!
    if userIsInTheMiddleOfTypingNumber{
      enter()
    }
    if let operation = sender.currentTitle{
      operate(operation)
    }
  }
  
  private func operate(operation: String){
    let operatorEnum = OperatorEnum(rawValue: operation)
    if let result = brain.pushOperator(operatorEnum){
      displayValue = result
    }else{
      displayValue = nil
    }
  }
  
  @IBAction func clear() {
    displayValue = 0
    brain.refresh()
  }
  
  @IBAction func enter() {
    userIsInTheMiddleOfTypingNumber = false
    if let value = displayValue{
      if let result = brain.pushOperand(value){
        displayValue = result
      }else{
        displayValue = nil
      }
    }
  }
  
  var displayValue: Double?{
    get{
      if let number = NSNumberFormatter().numberFromString(display.text!){
        return number.doubleValue
      }else{
        return nil
      }
    }
    set{
      if let value = newValue{
        display.text = "\(value)"
      }else{
        display.text = "Cannot calculate"
        brain.refresh()
      }
      userIsInTheMiddleOfTypingNumber = false
    }
  }
}

