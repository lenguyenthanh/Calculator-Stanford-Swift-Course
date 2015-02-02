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
  @IBOutlet weak var history: UILabel!
  
  var userIsInTheMiddleOfTypingNumber = false
  var isPi = false
  let brain = CalculatorBrain()
  
  @IBAction func appendDigit(sender: UIButton) {
    let digit = sender.currentTitle!
    println("digit = \(digit)")
    if isPi{
      isPi = false
      enter()
    }
    if !userIsInTheMiddleOfTypingNumber{
      display.text = digit
      userIsInTheMiddleOfTypingNumber = true
    }else{
      display.text = display.text! + digit
    }
  }
  
  @IBAction func addDot() {
    if !userIsInTheMiddleOfTypingNumber{
      display.text = "0."
      userIsInTheMiddleOfTypingNumber = true
    }else{
      let temp = display.text! + "."
      if let value = getNumberFromString(temp){
        display.text = temp
      }
    }
  }
  
  @IBAction func operate(sender: UIButton) {
    let operation = sender.currentTitle!
    if userIsInTheMiddleOfTypingNumber || isPi{
      enter()
    }
    if let operation = sender.currentTitle{
      operate(operation)
    }
  }
  
  private func operate(operation: String){
    let operatorEnum = OperatorEnum(rawValue: operation)
    let response = brain.pushOperator(operatorEnum)
    display(response)
  }
  
  private func display(response: CalculatorBrain.Response){
    if let result = response.result{
      displayValue = result
      history.text = response.history!
    }else{
      displayValue = nil
    }
  }
  
  @IBAction func addPi() {
    if userIsInTheMiddleOfTypingNumber{
      enter()
    }
    displayValue = M_PI
    isPi = true
  }
  
  
  @IBAction func clear() {
    displayValue = 0
    history.text = "0"
    refrestEnterState()
    brain.refresh()
  }
  
  @IBAction func enter() {
    refrestEnterState()
    if let value = displayValue{
      let response = brain.pushOperand(value)
      display(response)
    }
  }
  
  private func refrestEnterState(){
    userIsInTheMiddleOfTypingNumber = false
    isPi = false
  }
  
  var displayValue: Double?{
    get{
      return getNumberFromString(display.text!)
    }
    set{
      if let value = newValue{
        display.text = "\(value)"
      }else{
        clear()
        display.text = "Cannot calculate"
      }
      userIsInTheMiddleOfTypingNumber = false
    }
  }
  
  private func getNumberFromString(string: String) -> Double?{
    if let number = NSNumberFormatter().numberFromString(string){
      return number.doubleValue
    }else{
      return nil
    }
  }
}

