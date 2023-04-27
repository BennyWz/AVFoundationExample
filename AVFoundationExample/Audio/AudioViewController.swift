//
//  AudioViewController.swift
//  AVFoundationExample
//
//  Created by Benny Reyes on 29/03/23.
//

import AVFoundation
import UIKit

/// Separamos un poco la implementación de Audio e Imagenes en este proyecto
/// de demostración, para un mejor entendimiento
class AudioViewController: UIViewController {
    // Reproducción
    var player:AVAudioPlayer?
    // Captura
    @IBOutlet weak var buttonRecord:UIButton!
    let session = AVAudioSession.sharedInstance()
    var audioRecorder:AVAudioRecorder?
    let recordName:String = "AudioExample"
    
    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Audio"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: - Checar Permiso
        checkPermission()
    }
    
    
    // MARK: - Reproduccion
    func loadAudio(name:String, ext:String = "mp3"){
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else { return }
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            if audioPlayer.prepareToPlay() {
                audioPlayer.play()
                player = audioPlayer
                player?.play()
            }
        } catch let error {
            print(error)
        }
        
    }
    
    // MARK: - Controles de reproduccion de audio local
    @IBAction func btnPlayLocalButtonAction(_ sender: Any) {
        // TODO: - Reproduccion
        guard player != nil else {
            loadAudio(name: "aplausos")
            return
        }
        player?.play()
    }
    
    @IBAction func btnPauseLocalButtonAction(_ sender: Any) {
        player?.pause()
    }
    
    @IBAction func btnStopLocalButtonAction(_ sender: Any) {
        player?.stop()
    }
    
    // MARK: - Controles de Grabacion de audio
    @IBAction func toogleRecording(){
        if audioRecorder == nil {
            startRecording()
        }else{
            stopRecording()
        }
    }
    
    @IBAction func btnPlayRecordedAudio(_ sender: Any) {
        if player == nil {
            loadAudio(name: recordName, ext: "mp4")
        }
    }
    
    
    // MARK: - Captura
    func checkPermission(){
        switch session.recordPermission{
        case .granted:
            // Grabar audio
            break
        case .denied:
            // Enviar alerta de settings
            break
        case .undetermined:
            requestPermission()
            break
        @unknown default:
            // Actualizaciones futuras
            break
        }
    }
    
    func requestPermission(){
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            session.requestRecordPermission { [weak self] allowed in
                self?.buttonRecord.isEnabled = allowed
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func startRecording(){
        guard let recordURL = FileManager.getDocumentsDirectory(appendPath: "\(recordName).mp4") else { return }
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC), /// El formato del audio
            AVSampleRateKey: 12000, /// Sample rate in Hertz
            AVNumberOfChannelsKey: 1, /// Numero de canales
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue /// Calidad
        ]
        do{
            audioRecorder = try AVAudioRecorder(url: recordURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            buttonRecord.setImage(UIImage(named: "stop.circle.fill"), for: .normal)
        } catch let error {
            print(error)
        }
    }
    
    func stopRecording(){
        guard let audioRecorder = audioRecorder else { return }
        audioRecorder.stop()
        buttonRecord.setImage(UIImage(named: "play.circle.fill"), for: .normal)
        self.audioRecorder = nil
    }
    
}

extension AudioViewController: AVAudioRecorderDelegate{
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // Nos avisa cuando la grabación terminó o se detuvo
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        // En caso de que suceda un error en la grabación
    }
    
}


