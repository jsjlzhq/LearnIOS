//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 李志勤 on 15/8/22.
//  Copyright (c) 2015年 李志勤. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: Printable
    {
    case Operand(Double)
    case UnaryOperation(String, Double -> Double)
    case BinaryOperation(String, (Double, Double) ->Double)
        
    var description:String
    {
        get
        {
            switch self
            {
            case .Operand(let operand):
                return "\(operand)"
            case .UnaryOperation(let symbol, _):
                return symbol
            case .BinaryOperation(let symbol, _):
                return symbol
            }
        }
    }
    }
    
    private var knownOps = [String:Op]()
    private var opStack = [Op]()
    
    init()
    {
        func learnOp(op:Op)
        {
            knownOps[op.description] = op;
        }
        learnOp(Op.BinaryOperation("×", *))//{ $0*$1}  &&&运算符也是函数&&&
        learnOp(Op.BinaryOperation("÷", { $1/$0}))//由于顺序不同，不能简单的使用/代替
        learnOp(Op.BinaryOperation("+", +))//{ $0+$1}
        learnOp(Op.BinaryOperation("−", { $1-$0}))//
        learnOp(Op.UnaryOperation("√", sqrt))//{sqrt($0)}
        learnOp(Op.UnaryOperation("sin", sin))//{sin($0)}
        learnOp(Op.UnaryOperation("cos", cos))//{cos($0)}
    }
    
    func pushOperand(operand: Double) ->Double?
    {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol:String)->Double?
    {
       if let operation = knownOps[symbol] //不加if operation的类型是Op? if之后即为Op类型
       {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func evaluate() -> Double?
    {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func clear()
    {
        opStack.removeAll()
    }
    
    private func evaluate(ops: [Op]) -> (result:Double?, remainOps:[Op])
    {
        if !ops.isEmpty
        {
            var remainOps = ops
            let op = remainOps.removeLast()
            switch op
            {
            case .Operand(let operand):
                    return (operand, remainOps)
            case .UnaryOperation(_, let operation):
                    let operandEvaluation = evaluate(remainOps)
                    if let operand=operandEvaluation.result
                    {
                        return (operation(operand), operandEvaluation.remainOps)
                    }
            case .BinaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainOps)
                if let operand1=operandEvaluation.result
                {
                    let operandEvaluation2 = evaluate(operandEvaluation.remainOps)
                    if let operand2=operandEvaluation2.result
                    {
                        return (operation(operand1,operand2), operandEvaluation2.remainOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
}