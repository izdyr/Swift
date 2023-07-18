import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    
    var isTypingNumber = false
    var firstNumber: Double = 0
    var secondNumber: Double = 0
    var operatorSymbol = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func numberButtonTapped(_ sender: UIButton) {
        let number = sender.currentTitle!
        if isTypingNumber {
            displayLabel.text = displayLabel.text! + number
        } else {
            displayLabel.text = number
            isTypingNumber = true
        }
    }
    
    @IBAction func operatorButtonTapped(_ sender: UIButton) {
        isTypingNumber = false
        firstNumber = Double(displayLabel.text!)!
        operatorSymbol = sender.currentTitle!
    }
    
    @IBAction func equalsButtonTapped(_ sender: UIButton) {
        secondNumber = Double(displayLabel.text!)!
        var result: Double = 0
        switch operatorSymbol {
        case "+":
            result = firstNumber + secondNumber
        case "-":
            result = firstNumber - secondNumber
        case "×":
            result = firstNumber * secondNumber
        case "÷":
            result = firstNumber / secondNumber
        default:
            break
        }
        displayLabel.text = String(result)
        isTypingNumber = false
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        displayLabel.text = "0"
        isTypingNumber = false
        firstNumber = 0
        secondNumber = 0
        operatorSymbol = ""
    }
}
