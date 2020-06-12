//
//  ScreenRecorderViewController.swift
//  Runner
//
//  Created by Developer Admin on 26/05/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import ReplayKit
import UIKit

class ScreenRecorderViewController: UIViewController, RPPreviewViewControllerDelegate {

    let recorder = RPScreenRecorder.shared()
     var isRecording = false
     var isMute = false
    
    @IBOutlet weak var micBtn: UIButton!
    @IBOutlet weak var playPauseBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func startRecording(messageString: @escaping(_ message: String)->()) -> Void {
        guard recorder.isAvailable else {
            print("Recording is not available at this time.")
            return
        }
        if (isMute) {
            recorder.isMicrophoneEnabled = false
        } else {
            recorder.isMicrophoneEnabled = true
        }
        recorder.startRecording{ [unowned self] (error) in
            guard error == nil else {
                print("There was an error starting the recording.")
                return
            }
            self.isRecording = true
            messageString("Recording...")
            print("Started Recording Successfully")
        }
    }
    
    func stopRecording(messageString: @escaping(_ messsage: String)->()) ->Void {
        recorder.stopRecording { [unowned self] (preview, error) in
                   print("Stopped recording")

                   guard let previewView = preview else {
                       print("Preview controller is not available.")
                       return
                   }
                   messageString("Stopped")
                   let alert = UIAlertController(title: "Recording Finished", message: "Would you like to edit or delete your recording?", preferredStyle: .alert)

                   let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction) in
                       self.recorder.discardRecording(handler: { () -> Void in
                           print("Recording suffessfully deleted.")
                       })
                   })

                   let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (action: UIAlertAction) -> Void in
                    previewView.previewControllerDelegate = self
                       self.present(previewView, animated: true, completion: nil)
                   })

                   alert.addAction(editAction)
                   alert.addAction(deleteAction)
                   self.present(alert, animated: true, completion: nil)
                   
                   self.isRecording = false
               }
        
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        if (isRecording) {
            self.stopRecording(messageString: {
                message in
                print(message)
                self.playPauseBtn.backgroundColor = UIColor.green

            })
        } else {
            self.startRecording(messageString: {
                messsage in
                print(messsage)
                self.playPauseBtn.backgroundColor = UIColor.red

            })
        }
    }
    
    
    @IBAction func micAction(_ sender: UIButton) {
        if(isMute){
            self.recorder.isMicrophoneEnabled = true
            self.isMute = false
            self.micBtn.backgroundColor = UIColor.red
        } else {
            self.recorder.isMicrophoneEnabled = false
            self.isMute = true
            self.micBtn.backgroundColor = UIColor.green
        }
    }
    
}
