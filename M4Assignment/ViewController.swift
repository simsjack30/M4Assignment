//
//  ViewController.swift
//  M4Assignment
//
//  Created by John Sims on 2/1/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var background: UIImageView!
    
    var dateTimeTimer: Timer?
    var countdownTimer: Timer?
    var remainingTime: TimeInterval?
    var player: AVAudioPlayer?
    var colorUpdateTimer: Timer?

    
    @IBAction func startButton(_ sender: Any) {
        if startStopButton.currentTitle == "Start Timer" {
            remainingTime = datePicker.countDownDuration
            startCountdownTimer()
        }
        else {
            startStopButton.setTitle("Start Timer", for: .normal)
            countDownLabel.text = "Click to start timer"
            player?.stop()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDateTimeTimer()
        startStopButton.setTitle("Start Timer", for: .normal)
        countDownLabel.text = "Click to start timer"
        configureAudioPlayer()
        startColorUpdateTimer()
    }
    
    func startDateTimeTimer() {
        dateTimeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateDateTimeLabel), userInfo: nil, repeats: true)
    }
    
    func startCountdownTimer() {
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdownLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdownLabel() {
        guard let time = remainingTime, time > 0 else {
            countdownTimer?.invalidate()
            countdownTimer = nil
            countDownLabel.text = "Time's up!"
            startStopButton.setTitle("Stop Music", for: .normal)
            player?.play()
            return
        }
        
        remainingTime = time - 1
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        countDownLabel.text = String(format: "Time Remaining: %02i:%02i:%02i", hours, minutes, seconds)
    }
    
    @objc func updateDateTimeLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
        dateTimeLabel.text = dateFormatter.string(from: Date())
    }
    
    func configureAudioPlayer() {
        guard let soundURL = Bundle.main.url(forResource: "guitar", withExtension: "wav") else {
            print("Unable to locate audio file")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: soundURL)
            player?.numberOfLoops = -1
            player?.prepareToPlay()
        } catch {
            print("Error initializing audio player: \(error)")
        }
    }

    
    @objc func updateBackgroundColor() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a"
        let currentTime = dateFormatter.string(from: Date())

        if currentTime == "AM" {
            background.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
        } else {
            background.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        }
    }
    
    func startColorUpdateTimer() {
        colorUpdateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateBackgroundColor), userInfo: nil, repeats: true)
        updateBackgroundColor()
    }
}
