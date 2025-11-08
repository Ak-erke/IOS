//
//  ViewController.swift
//  player
//
//  Created by Ақерке Амиртай on 06.11.2025.
//
import UIKit
import AVFoundation

struct Track {
    let title: String
    let artist: String
    let coverImage: String
    let fileName: String
}

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    
    // MARK: - Player Variables
    var player: AVAudioPlayer?
    var timer: Timer?
    var currentTrackIndex = 0
    var isShuffle = false
    var isRepeat = false
    
    // MARK: - Playlist
    let tracks: [Track] = [
        Track(title: "Like Jennie", artist: "Jennie", coverImage: "like_jennie", fileName: "like_jennie"),
        Track(title: "Gabriela", artist: "Katseye", coverImage: "gabriela", fileName: "gabriela"),
        Track(title: "Starboy", artist: "The Weeknd feat. Daft Punk", coverImage: "starboy", fileName: "starboy"),
        Track(title: "Blinding Lights", artist: "The Weeknd", coverImage: "blinding_lights", fileName: "blinding_lights"),
        Track(title: "Save Your Tears", artist: "The Weeknd", coverImage: "save_your_tears", fileName: "save_your_tears")
    ]
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadTrack()
    }
    // MARK: - Setup
    func setupUI() {
        progressView.progress = 0.0
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        trackImageView.layer.cornerRadius = 16
        trackImageView.clipsToBounds = true
    }
    // MARK: - Load Track
    func loadTrack() {
        let track = tracks[currentTrackIndex]
        trackImageView.image = UIImage(named: track.coverImage)
        titleLabel.text = track.title
        artistLabel.text = track.artist
        progressView.progress = 0
        currentTimeLabel.text = "0:00"
        
        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: "wav") else {
            print("⚠️ Файл не найден: \(track.fileName)")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
            durationLabel.text = formatTime(player?.duration ?? 0)
        } catch {
            print("Ошибка загрузки трека: \(error)")
        }
    }
    // MARK: - Timer
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            guard let player = self.player else { return }
            self.progressView.progress = Float(player.currentTime / player.duration)
            self.currentTimeLabel.text = self.formatTime(player.currentTime)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    // MARK: - Format Time
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    // MARK: - Controls
    @IBAction func playPauseTapped(_ sender: UIButton) {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
            stopTimer()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            startTimer()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        if isShuffle {
            currentTrackIndex = Int.random(in: 0..<tracks.count)
        } else {
            currentTrackIndex = (currentTrackIndex + 1) % tracks.count
        }
        playCurrentTrack()
    }
    
    @IBAction func prevTapped(_ sender: UIButton) {
        currentTrackIndex = (currentTrackIndex - 1 + tracks.count) % tracks.count
        playCurrentTrack()
    }
    
    @IBAction func shuffleTapped(_ sender: UIButton) {
        isShuffle.toggle()
        let iconName = isShuffle ? "shuffle.circle.fill" : "shuffle"
        sender.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
    @IBAction func repeatTapped(_ sender: UIButton) {
        isRepeat.toggle()
        let iconName = isRepeat ? "repeat.circle.fill" : "repeat"
        sender.setImage(UIImage(systemName: iconName), for: .normal)
    }
    // MARK: - Helpers
    func playCurrentTrack() {
        loadTrack()
        player?.play()
        startTimer()
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if isRepeat {
            player.currentTime = 0
            player.play()
        } else {
            nextTapped(UIButton())
        }
    }
}
