import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var colorPicker: UISegmentedControl!
    @IBOutlet weak var brushSizeSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemBackground
    }

    @IBAction func colorChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            canvasView.changeColor(color: .black)
        case 1:
            canvasView.changeColor(color: .red)
        case 2:
            canvasView.changeColor(color: .blue)
        case 3:
            canvasView.changeColor(color: .green)
        default:
            break
        }
    }

    @IBAction func brushSizeChanged(_ sender: UISlider) {
        canvasView.changeBrushSize(size: CGFloat(sender.value))
    }

    @IBAction func clearCanvas(_ sender: UIButton) {
        canvasView.clear()
    }
}

class CanvasView: UIView {

    private var lines = [Line]()
    private var strokeColor = UIColor.black
    private var strokeWidth: CGFloat = 5.0

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setLineCap(.round)
        context.setLineWidth(strokeWidth)
        context.setStrokeColor(strokeColor.cgColor)

        for line in lines {
            context.beginPath()
            context.move(to: line.start)
            context.addLine(to: line.end)
            context.strokePath()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        lines.append(Line(start: point, end: point))
        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self),
              var lastLine = lines.popLast()
        else { return }
        lastLine.end = point
        lines.append(lastLine)
        setNeedsDisplay()
    }

    func changeColor(color: UIColor) {
        strokeColor = color
    }

    func changeBrushSize(size: CGFloat) {
        strokeWidth = size
    }

    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }
}

struct Line {
    var start: CGPoint
    var end: CGPoint
}
