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
    var brain = CalculatorBrain()

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
        
        if let result=brain.performOperation(operation)
        {
            displayValue = result
        }
        else
        {
            displayValue=0
        }
    }
    
    @IBAction func clearOpt() {
        userIsInTheMiddleOfTypingANumber=false;
        display.text="0"
        brain.clear()
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
    
    @IBAction func buttonClicked(sender: UIButton) {
        let clickVal = sender.currentTitle!
        historyDisp.text = historyDisp.text!+clickVal
    }
    
 
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber=false
        hasDecimalFlag=false
        if let result=brain.pushOperand(displayValue)
        {
            displayValue=result
        }
        else
        {
            displayValue=0
        }
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

