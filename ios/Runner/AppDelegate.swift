import UIKit
import Flutter
import ReplayKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, RPPreviewViewControllerDelegate {
    
    let recorder = RPScreenRecorder.shared()
    private var isRecording = false
    private var isMute = false
    var scView = ScreenRecorderViewController()
    var assetWriter:AVAssetWriter!
    var videoInput:AVAssetWriterInput!

    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window.rootViewController as? FlutterViewController {
        let nativeChannel = FlutterMethodChannel(name: "flutter.native/helper", binaryMessenger: controller.binaryMessenger)
        weak var weakSelf = self
        nativeChannel.setMethodCallHandler({
            call, result in
            if ("helloFromNativeCode" == call.method) {
                let strNative = weakSelf?.helloFromNativeCode()
                result(strNative)
            } else if ("screenRecordingFromNative" == call.method) {
                /* this is for ASScreenRecorder
                let recorder = ASScreenRecorder.sharedInstance()
                if(recorder?.isRecording ?? false) {
                    recorder?.stopRecording {
                        print("Stopped")
                        recorder?.playEndSound()
                       result("Stopped")
                    }
                } else {
                    recorder?.startRecording()
                    print("Recording...")
                    recorder?.playStartSound()
                    result("Recording...")
                }
                */
                /* for replaykit
                if (weakSelf?.isRecording == false) {
                    weakSelf?.startRecording(messageString: {
                        message in
                        print(message)
                        result(message)
                    })
                } else {
                    weakSelf?.stopRecording(messageString: {
                        message in
                        result(message)
                    })
                } // upto here Replaykit*/
                let randomNumber = arc4random_uniform(9999);
                let  fileName = "coolScreenRecording\(randomNumber)"
                if (weakSelf?.isRecording == false) {
                    weakSelf?.startRecording(withFileName: fileName) { (error) in
                       // recordingHandler(error)
                        //self.recordCompleted = onCompletion
                        print("completed")
                        result(error)
                    }
                } else {
                    weakSelf?.stopRecording { (error) in
                        print("Recording Stopped")
                        result(error)
                    }
                }
            } else if ("muteOrUnMuteFromNative" == call.method){
                if(self.isMute) {
                    self.recorder.isMicrophoneEnabled = true
                    self.isMute = false
                    result("UnMute")
                } else {
                    self.recorder.isMicrophoneEnabled = false
                    self.isMute = true
                    result("Mute")
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        })

    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func helloFromNativeCode() -> String {
        return "Hello From iOS"
    }
    
    
    
    func startRecording1(messageString: @escaping(_ message: String)->()) -> Void {
               
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
    
    
    func stopRecording1(messageString: @escaping(_ messsage: String)->()) ->Void {
        recorder.stopRecording { [unowned self] (preview, error) in
           print("Stopped recording")
           
           guard preview != nil else {
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
            // crash is happened here ( When edit button clicked)
                preview?.previewControllerDelegate = self
                self.window.rootViewController?.present(preview ?? RPPreviewViewController(), animated: true, completion: nil)
           })

           alert.addAction(editAction)
           alert.addAction(deleteAction)
           self.window.rootViewController?.present(alert, animated: true, completion: nil)
           self.isRecording = false
        }
    }
    
    //New method
    
    //MARK: Screen Recording
        func startRecording(withFileName fileName: String, recordingHandler:@escaping (String?)-> Void)
        {
            if #available(iOS 11.0, *)
            {
                
                let fileURL = URL(fileURLWithPath: ReplayFileUtil.filePath(fileName))
                assetWriter = try! AVAssetWriter(outputURL: fileURL, fileType:
                    AVFileType.mp4)
                let videoOutputSettings: Dictionary<String, Any> = [
                    AVVideoCodecKey : AVVideoCodecType.h264,
                    AVVideoWidthKey : UIScreen.main.bounds.size.width,
                    AVVideoHeightKey : UIScreen.main.bounds.size.height
                ];
                
                videoInput  = AVAssetWriterInput (mediaType: AVMediaType.video, outputSettings: videoOutputSettings)
                videoInput.expectsMediaDataInRealTime = true
                assetWriter.add(videoInput)
                self.isRecording = true
                recordingHandler("Recording...")

                recorder.startCapture(handler: { (sample, bufferType, error) in
    //                print(sample,bufferType,error)
                    
                    if CMSampleBufferDataIsReady(sample)
                    {
                        if self.assetWriter.status == AVAssetWriter.Status.unknown
                        {
                            self.assetWriter.startWriting()
                            self.assetWriter.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sample))
                        }
                        
                        if self.assetWriter.status == AVAssetWriter.Status.failed {
                            print("Error occured, status = \(self.assetWriter.status.rawValue), \(self.assetWriter.error!.localizedDescription) \(String(describing: self.assetWriter.error))")
                            return
                        }
                        
                        if (bufferType == .video)
                        {
                            if self.videoInput.isReadyForMoreMediaData
                            {
                                self.videoInput.append(sample)
                            }
                        }
                    }
                    
                }) { (error) in
                    //recordingHandler(error?.localizedDescription)
    //                debugPrint(error)
                }
            } else
            {
                // Fallback on earlier versions
            }
        }
        
        func stopRecording(handler: @escaping (String?) -> Void)
        {
            if #available(iOS 11.0, *)
            {
                recorder.stopCapture
                {    (error) in
                        self.assetWriter.finishWriting
                    {
                        self.isRecording = false
                        print("finished")
                        handler("stop")
                        
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
    
    
    
}
