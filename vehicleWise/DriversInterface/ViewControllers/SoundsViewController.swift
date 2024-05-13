import UIKit

import AVFoundation
// Data model for sound data
struct Sound {
    let name: String
    let soundName: String
}
// Custom UITableViewCell subclass for displaying sound data

class SoundCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Setup cell UI elements or constraints here
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// UITableViewController subclass for managing a list of sounds

class SoundsTableViewController: UITableViewController {
    // Array of Sound objects

    let sounds: [Sound] = [
        Sound(name: "Alarm", soundName: "beep"),
        Sound(name: "Canopy", soundName: "Canopy"),
        Sound(name: "Old Phone", soundName: "Old Phone"),
        Sound(name: "Pinball", soundName: "Pinball"),
        Sound(name: "Piano Riff", soundName: "Piano Riff"),
    ]
    // Audio player instance
    var audioPlayer: AVAudioPlayer?
    // Timer for stopping the audio player automatically
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Register SoundCell class for cell reuse
        tableView.register(SoundCell.self, forCellReuseIdentifier: "SoundCell")
    }
    // table view data source
        
    // Number of rows in the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    // Configure each cell in the table view

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SoundCell", for: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    // Configure the content of each cell

    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        cell.textLabel?.text = sounds[indexPath.row].name
    }
    // Handle selection of a row

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let soundName = sounds[indexPath.row].soundName
        playSound(named: soundName)
        
        // Deselect the row after selection
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Schedule a timer to stop the audio player after 5 seconds
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(stopSound), userInfo: nil, repeats: false)
    }
    // Stop the currently playing sound

    @objc func stopSound() {
        audioPlayer?.stop()
        timer?.invalidate()
        timer = nil
    }
    // Play a sound with the given name

    func playSound(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Sound file not found.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
