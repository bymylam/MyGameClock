import UIKit

class TimeEditorView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIPickerView!
    
    var selectedSeconds: Int = 0
    
    // Picker Data Source Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // 1 for minutes, 1 for seconds
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Component 0 (minutes): 0...59
        // Component 1 (seconds): 0...59
        return 60
    }
    
    // Picker Delegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%02d", row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let minutes = timePicker.selectedRow(inComponent: 0)
        let seconds = timePicker.selectedRow(inComponent: 1)
        selectedSeconds = minutes * 60 + seconds
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    // Save Button Action (unwide seque)
    @IBAction func savePressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.dataSource = self
        timePicker.delegate = self

        timeLabel.text = "00:00"
        
        pickerView(timePicker, didSelectRow: 0, inComponent: 0)
    }
}
