//
//  ViewController.swift
//  Calculator
//
//  Created by 李志勤 on 15/8/18.
//  Copyright (c) 2015年 李志勤. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var historyDisp: UILabel!

    var userIsInTheMiddleOfTypingANumber: Bool = false
    var hasDecimalFlag: Bool = false

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            display.text = display.text! + digit
        }
        else{
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }

    }

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber
        {
            enter()
        }
        
        switch operation
        {
        case "×":
//方法一
//            performOperation(multiply)  //方法一
        
//方法二
//            performOperation({ (opt1: Double, opt2: Double)->Double in
//                return opt1*opt2
//                }) // 方法二 closure(闭包)
            //做法：
            //1 将multiply函数之后的包括参数 返回值 函数体 复制
            //2 粘贴到原来函数调用的multiply处 替换multiply
            //3 将函数体的{左花括号 从返回值类型之后移至 参数之前
            //4 在返回值类型之后添加单词 in
            
//方法三
//            performOperation({(opt1, opt2) in return opt1*opt2 }) // 由方法二＋swift的类型推断特性 将参数类型和返回值类型省略得出的方法三
        
//方法四
//            performOperation({(opt1,opt2) in opt1*opt2 })//如果所有的函数体代码只有一句return语句，那么编译器知道你返回什么，所以可将return关键字省略
            
//方法五
//            performOperation({ $0*$1 })
            //swift不强制参数必须有命名，所以可将opt1替换为$0, opt2替换为$1 opt3替换为$3 等等
            //1 opt1 opt2 用$0 $1替换
            //2 删除括号中的参数 (opt1, opt2) in
            //{}代表这是一个函数，然后有两个参数$0 $1，因为是传递给performOperation函数so根据类型推断参数是Double类型，返回Double类型
            
//方法六
//            performOperation(){ $0*$1 }
            //如果一个函数的最后一个参数是函数，如performOperation 可将作为参数的函数体移至括号()的外面
//方法七
            performOperation{ $0*$1 }
            //如果仅有最后一个参数时，可将原函数的()省略
//            break // 似乎这里不需要一个break关键字
        case "÷": performOperation{ $1/$0 }
        case "+": performOperation{ $0+$1 }
        case "−": performOperation{ $1-$0 }
        case "√": performOperation{ sqrt($0) }
        case "sin": performOperation{ sin($0) }
        case "cos": performOperation{ cos($0) }
        default:break
        }
        
    }
    
    @IBAction func clearOpt() {
        userIsInTheMiddleOfTypingANumber=false;
        display.text="0"
        operandStack.removeAll()
        historyDisp.text!.removeAll()
        hasDecimalFlag=false
    }
    @IBAction func operandPI() {
        if userIsInTheMiddleOfTypingANumber
        {
            enter()
        }
        displayValue = M_PI
        enter()
    }
    
    @IBAction func decimal() {
        if !hasDecimalFlag
        {
            if !userIsInTheMiddleOfTypingANumber
            {
                display.text = "0."
                userIsInTheMiddleOfTypingANumber=true
            }
            else
            {
                display.text! += "."
            }
            hasDecimalFlag = true
        }
    }
    
    func performOperation(operation: (Double, Double)->Double)
    {
        if operandStack.count >= 2
        {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        let clickVal = sender.currentTitle!
        historyDisp.text = historyDisp.text!+clickVal
    }
    
    private func performOperation(operation: Double -> Double)
    {//注意这个方法与视频中稍许不同，增加了private属性 因为objc和swift在继承上的不同
        if operandStack.count >= 1
        {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }

    
    func multiply(opt1: Double, opt2: Double)->Double
    {
        return opt1*opt2
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber=false
        hasDecimalFlag=false
        operandStack.append(displayValue)
        println("operandStack=\(operandStack)")
    }
    
    var displayValue: Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
        }
    }
}

