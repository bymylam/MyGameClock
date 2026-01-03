import UIKit

class ViewController: UIViewController {
    
    var topTime = 0
    var botTime = 0
    // Timer object used to track the active player's countdown every second
    var timer: Timer?
    
    // Set isRunning & isTopTurn to default false
    var isRunning = false
    var isTopTurn = false
    
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var botButton: UIButton!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    // Called when TOP player's button is pressed
    @IBAction func topButtonPressed(_ sender: UIButton) {
        // Is the game running? AND is the TOP player turn now?
        if isRunning && isTopTurn {
            isTopTurn = false // switch turn to BOTTOM player
            updateActiveIndicator() // update BOTTOM player to green
            startTimer()
        }
        
        // Disable top, enable bot so they can't be tapped again immediately
        topButton.isEnabled = false
        botButton.isEnabled = true
    }
    
    // Called when BOTTOM player's button is pressed
    @IBAction func botButtonPressed(_ sender: UIButton) {
        // Is the game running? AND is the BOTTOM turn now?
        if isRunning && !isTopTurn {
            isTopTurn = true // switch turn to TOP player
            updateActiveIndicator() // update TOP player to green
            startTimer()
        }
        
        // Disable bot, enable top so they can't be tapped again immediately
        botButton.isEnabled = false
        topButton.isEnabled = true
    }
    
    // Start/Stop the game clock
    @IBAction func startStopPressed(_ sender: UIButton) {
        // Check if the game is currently running
        if isRunning {
            // Game is running, STOP the game
            timer?.invalidate() // stop both current timers
            isRunning = false // update the game state to not running
            startStopButton.setTitle("START", for: .normal)
            
            // Disable both player buttons to prevent being tapped again
            topButton.isEnabled = false
            botButton.isEnabled = false
            
            // Allow the RESET button to be pressed
            resetButton.isEnabled = true
            
            // Disable Edit button when running
            editButton.isEnabled = false
        } else {
            // Game is not running, START the game
            isRunning = true // update game state to running
            startStopButton.setTitle("STOP", for: .normal)
            updateActiveIndicator() // highlight the active timer
            startTimer()
            
            // Enable only the current player's button can run
            topButton.isEnabled = isTopTurn
            botButton.isEnabled = !isTopTurn
            
            // Disable Edit button when running
            editButton.isEnabled = false
        }
    }
    
    // Called when RESET button is pressed
    @IBAction func resetPressed(_ sender: UIButton) {
        timer?.invalidate() // stop both timers
        
        // Reset 2 timers to 30s like originally
        topTime = 0
        botTime = 0
        topButton.setTitle("0", for: .normal)
        topButton.titleLabel?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        botButton.setTitle("0", for: .normal)
        
        // The game state now is set to not running
        isRunning = false
        startStopButton.setTitle("START", for: .normal) // show the 'start' button
        
        // Re-enable START button so it can be pressed after RESET or when the game ends
        startStopButton.isEnabled = true
        
        // Enable 2 buttons so the next game can start
        topButton.isEnabled = true
        botButton.isEnabled = true
        
        // Reset colors to neutral
        topButton.backgroundColor = .white
        botButton.backgroundColor = .white
        
        // Enable to reset again if neccessary
        resetButton.isEnabled = true
        
        // Enable to edit the time
        editButton.isEnabled = true
    }
    
    // ASSISTANCE FUNCTION
    // When either of them run out of time
    func handleTimeUp(forTopPlayer: Bool) {
        timer?.invalidate() // stop both timers
        isRunning = false // update the game state to not running
        startStopButton.setTitle("START", for: .normal)
        
        // Disable the START & EDIT button when the games ends, preventing keeping -1
        startStopButton.isEnabled = false
        editButton.isEnabled = false

        // Show red & message to the player who are out of time
        if forTopPlayer {
            topButton.setTitle("OUT OF TIME", for: .normal)
            topButton.titleLabel?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            topButton.backgroundColor = .red
            botButton.backgroundColor = .white
        } else {
            botButton.setTitle("OUT OF TIME", for: .normal)
            botButton.backgroundColor = .red
            topButton.backgroundColor = .white
        }
            
        // Enable to reset again to start another game
        resetButton.isEnabled = true
    }
    
    // Start the timer for active player
    func startTimer() {
        timer?.invalidate() // stop any existing timers
        
        // Create and start a repeting timer that fires every 1 second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            
            if self.isTopTurn {
                self.topTime -= 1 // decrease top player's time by 1 second
                self.topButton.setTitle("\(self.topTime)", for: .normal) // update top player's label every second
                self.topButton.titleLabel?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                
                if self.topTime <= 0 { // Check if the top player's time run out
                    self.handleTimeUp(forTopPlayer: true) // execute handleTimeUp function
                }
                
            } else {
                self.botTime -= 1 // decrease bottom player's time by 1 second
                self.botButton.setTitle("\(self.botTime)", for: .normal) // update bottom player's label every second
                
                if self.botTime <= 0 { // Check if the bottom player's time run out
                    self.handleTimeUp(forTopPlayer: false) // execute handleTimeUp function
                }
            }
        }
    }
    
    // Updates the background color of the buttons to show which player's turn it is
    // Active turn is Green, Inactive is White
    func updateActiveIndicator() {
        topButton.backgroundColor = isTopTurn ? .green : .white
        botButton.backgroundColor = isTopTurn ? .white : .green
    }
    
    // Enhanced: App Lab - Game Clock Enhancements
    // Separated Page
    @IBAction func rewindForCancelButton(unwindSeque: UIStoryboardSegue) {}
    
    @IBAction func rewindForSaveButton (unwindSeque: UIStoryboardSegue) {
        if let sourceVC = unwindSeque.source as? TimeEditorView {
            let selectedSeconds = sourceVC.selectedSeconds
            topTime = selectedSeconds
            botTime = selectedSeconds
                
            topButton.setTitle("\(topTime)", for: .normal)
            topButton.titleLabel?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            botButton.setTitle("\(botTime)", for: .normal)
        }
    }
    
    // The original view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topButton.setTitle("0", for: .normal)
        topButton.titleLabel?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        botButton.setTitle("0", for: .normal)
        startStopButton.setTitle("START", for: .normal)
        resetButton.setTitle("RESET", for: .normal)
    }
}

