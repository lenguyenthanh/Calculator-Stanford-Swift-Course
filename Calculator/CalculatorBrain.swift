//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Thanh Le on 1/31/15.
//  Copyright (c) 2015 Thanh Le. All rights reserved.
//

import Foundation

extension Double {
  func format(f: String) -> String {
    return NSString(format: "%\(f)g", self)
  }
}

class CalculatorBrain {
  
  // MARK Op definition
  private enum Op:Printable{
    case Operand(Double)
    case BinaryOperator(OperatorEnum, (Double, Double) -> Double)
    case UnaryOperator(OperatorEnum, (Double) -> Double)
    
    
    var description: String{
      get{
        switch self{
        case .Operand(let value):
          return "\(value)"
        case .BinaryOperator, .UnaryOperator:
          return operatorEnum!.rawValue
        }
      }
    }
    
    var operatorEnum: OperatorEnum?{
      get{
        switch self{
        case .BinaryOperator(let op, _):
          return op
        case .UnaryOperator(let op, _):
          return op
        default:
          return nil
        }
      }
    }
    
    
  }
  
  private var opStack = [Op]()
  private var knownOps = [OperatorEnum:Op]()
  
  init(){
    knownOps = initKnownOps()
  }
  
  private func initKnownOps() -> [OperatorEnum:Op]{
    var ops = [OperatorEnum:Op]()
    func addKnownOp(op: Op){
      if let opEnum = op.operatorEnum{
        ops[opEnum] = op
      }
    }
    addKnownOp(Op.BinaryOperator(OperatorEnum.Mutiplication, *))
    addKnownOp(Op.BinaryOperator(OperatorEnum.Addition, +))
    addKnownOp(Op.BinaryOperator(OperatorEnum.Subtraction) {$1 - $0})
    addKnownOp(Op.BinaryOperator(OperatorEnum.Division) {$1 / $0})
    addKnownOp(Op.UnaryOperator(OperatorEnum.Sqrt, sqrt))
    addKnownOp(Op.UnaryOperator(OperatorEnum.Sin, sin))
    addKnownOp(Op.UnaryOperator(OperatorEnum.Cos, cos))
    addKnownOp(Op.UnaryOperator(OperatorEnum.Tan, tan))
    addKnownOp(Op.UnaryOperator(OperatorEnum.Cube) {pow($0, 3)})
    addKnownOp(Op.UnaryOperator(OperatorEnum.Square) {pow($0, 2)})
    addKnownOp(Op.UnaryOperator(OperatorEnum.CubeRoot) {pow($0, 1/3)})
    return ops
  }
  
  private func evaluate(ops: [Op]) -> (result: Double?,remaining: [Op], display: String?){
    if let op = ops.last{
      let remainingOps = ArrayUtil.removeLast(ops)
      switch op {
      case Op.Operand(let value):
        return (value, remainingOps, value.format(".3"))
      case Op.UnaryOperator(let name, let operation):
        let opEvaluation = evaluate(remainingOps)
        if let operand = opEvaluation.result{
          return (operation(operand), opEvaluation.remaining, name.display(opEvaluation.display!)!)
        }
      case Op.BinaryOperator(let name, let operation):
        let opEvaluation1 = evaluate(remainingOps)
        if let op1 = opEvaluation1.result{
          let opEvaluation2 = evaluate(opEvaluation1.remaining)
          if let op2 = opEvaluation2.result{
            return (operation(op1, op2), opEvaluation2.remaining, name.display(opEvaluation1.display!, operand2: opEvaluation2.display!)!)
          }
        }
      }
    }
    return (nil, ops, nil)
  }
  
  typealias Response = (result: Double?, history: String?)
  
  private func evaluate() -> Response{
    let (result, _, display) = evaluate(opStack)
    return (result, display)
  }
  
  func pushOperand(value: Double) -> Response{
    opStack.append(Op.Operand(value))
    return evaluate()
  }
  
  func pushOperator(value: OperatorEnum?) -> Response{
    if let op = knownOps[value!]{
      opStack.append(op)
    }
    return evaluate()
  }
  
  func refresh(){
    opStack = [Op]()
  }
  
}