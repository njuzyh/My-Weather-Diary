//
//  DiaryViewController.swift
//  My Weather Diary
//
//  Created by zyh on 2019/1/10.
//  Copyright © 2019 njuzyh. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class DiaryViewController: UIViewController, SFSpeechRecognizerDelegate, AVAudioRecorderDelegate{
    
    @IBOutlet weak var titile: UILabel!
    
    @IBOutlet weak var finishButton: UIBarButtonItem!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var speakButton: UIButton!
    
    //用于apple语言识别的变量
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "zh-CN"))
    //可以将识别请求的结果返回给你，它带来了极大的便利，必要时，可以取消或停止任务。
    private var recognitionTask: SFSpeechRecognitionTask?
    //对象用于处理语音识别请求，为语音识别提供音频输入
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    // 音频引擎 用于进行音频输入
    private let audioEngine = AVAudioEngine()
    
    var recordingFile = AVAudioFile()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("编写日记")
        
        titile.textColor = mainColor
        if weather.now != nil && weather.update != nil
        {
            titile.text = (weather.now?.cond_txt)! + " " + weather.update!.loc!
        }
        else
        {
            titile.text = "晴 2019-01-01 00:00"
        }
        // Do any additional setup after loading the view.
    }
  
    @IBAction func speak(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            speakButton.isEnabled = false
            speakButton.setTitle("开始说话", for: .normal)
        } else {
            startRecording()
            speakButton.setTitle("说完了", for: .normal)
        }
    }
    
    @IBAction func finishWriting(_ sender: Any) {
        
    }
    
    // MARK: - *** 获取用户权限 ***
    func authRequest(){
        speakButton.isEnabled = false
        speechRecognizer?.delegate = self

        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isBtnEndable = false
            switch authStatus{
            case.authorized:
                isBtnEndable = true
            case .denied:
                isBtnEndable = false
                print("User denied access to speech recognition")
            case .restricted:
                isBtnEndable = false
                print("Speech recognition restricted on this device")
            case .notDetermined:
                isBtnEndable = false
            }
            OperationQueue.main.addOperation {
                self.speakButton.isEnabled = isBtnEndable
            }
        }
    }
    
    // MARK: - *** 处理语音识别 ***
    func startRecording(){
        if recognitionTask != nil{
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        }catch{
            fatalError("会话创建失败")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("创建音频缓存失败")
        }
        //结果报告
        recognitionRequest.shouldReportPartialResults = true
        
        //开启授权任务
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.speakButton.isEnabled = true
            }
        })
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
            
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
            
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            speakButton.isEnabled = true
        } else {
            speakButton.isEnabled = false
        }
    }
    
    
    @IBAction func record(sender: AnyObject) {
        self.createRecordingFile()
        
        self.audioEngine.mainMixerNode.installTap(onBus: 0, bufferSize: 1024, format: self.audioEngine.mainMixerNode.outputFormat(forBus: 0)) { (buffer, time) -> Void in
            do {
                try self.recordingFile.write(from: buffer)
            } catch (let error) {
                print("RECORD ERROR", error);
            }
            return
        }
    }
    
   @IBAction func stop(sender: AnyObject) {
        self.audioEngine.mainMixerNode.removeTap(onBus: 0)
    }
    
    func createRecordingFile() {
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            var url = URL(fileURLWithPath: dir)
            url.appendPathComponent("my_file.caf")
            let format = self.audioEngine.outputNode.inputFormat(forBus: 0)
            do {
                self.recordingFile = try AVAudioFile(forWriting: url, settings:format.settings)
            } catch (let error) {
                print("CREATE RECORDING FILE ERROR", error);
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
