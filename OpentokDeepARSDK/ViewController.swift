//
//  ViewController.swift
//  OpentokDeepARSDK
//
//  Created by Roberto Perez Cubero on 24/07/2020.
//  Copyright © 2020 Vonage. All rights reserved.
//

import UIKit
import DeepAR
import OpenTok

let kApiKey = ""
let kToken = ""

let deepARLicense = ""

class ViewController: UIViewController, OTSessionDelegate, DeepARDelegate, OTPublisherDelegate {

  // MARK: OT instances
  lazy var otSession = {
    return OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)
  }()

  var otPublisher: OTPublisher?

  var currentFilterIndex: Int = 0
  let filters = ["lion","beach1","beach2","beach3","bg_blue","bg_green","bg_pink","bg_white","bg_yellow","blur_high","blur_light","livingroom","office"]

  lazy var deepARCapturer = {
    return DeepARVideoCapturer()
  }()

  // MARK: DeepAR Instances
  lazy var deepARView = {
    return ARView(frame: UIScreen.main.bounds)
  }()

  lazy var deepARCameraController = {
    return CameraController()
  }()

  @IBOutlet weak var connectBtn: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    deepARView.setLicenseKey(deepARLicense)
    deepARView.delegate = self

    deepARCameraController?.arview = deepARView
    view.insertSubview(deepARView, at: 0)

    deepARView.initialize()
    deepARCameraController?.startCamera()
  }

  @IBAction func startCall(_ sender: Any) {
    otSession?.connect(withToken: kToken, error: nil)
  }

  @IBAction func changeFilter(_ sender: Any) {
    currentFilterIndex = (currentFilterIndex + 1) % filters.count
    let nextFilter = filters[currentFilterIndex]
    deepARView.switchEffect(withSlot: "effect", path: Bundle.main.path(forResource: nextFilter, ofType: ""))
  }

  func doPublishWithARFrame() {
    let settings = OTPublisherSettings()
    settings.name = UIDevice.current.name
    settings.videoCapture = deepARCapturer
    otPublisher = OTPublisher(delegate: self, settings: settings)

    if let pub = otPublisher {
      otSession?.publish(pub, error: nil)
    } else {
      print("Error creating publisher")
    }
  }

  // MARK: Opentok Session Delegate
  func sessionDidConnect(_ session: OTSession) {
    print("Session Connected")
    connectBtn.setTitle("Disconnect", for: .normal)
    doPublishWithARFrame()
  }

  func sessionDidDisconnect(_ session: OTSession) {
    print("Session Disconnected")
  }

  func session(_ session: OTSession, didFailWithError error: OTError) {
    print("Session failed: \(error)")
  }

  func session(_ session: OTSession, streamCreated stream: OTStream) {
  }

  func session(_ session: OTSession, streamDestroyed stream: OTStream) {
  }

  // MARK: Opentok Publisher Delegate
  func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
    print("Publishing failed: \(error)")
  }

  // MARK: DeepAR ARView Delegate
  func didStartVideoRecording() {
  }

  func didFinishVideoRecording(_ videoFilePath: String!) {
  }

  func recordingFailedWithError(_ error: Error!) {
  }

  func didTakeScreenshot(_ screenshot: UIImage!) {
  }

  func faceVisiblityDidChange(_ faceVisible: Bool) {
  }

  func didInitialize() {
    let nextFilter = filters[currentFilterIndex]
    deepARView.switchEffect(withSlot: "effect", path: Bundle.main.path(forResource: nextFilter, ofType: ""))
    deepARView.startFrameOutput(withOutputWidth: 640, outputHeight: 0, subframe: CGRect(x: 0, y: 0, width: 1, height: 1))
  }

  func frameAvailable(_ sampleBuffer: CMSampleBuffer!) {
    autoreleasepool {
      guard let pb = CMSampleBufferGetImageBuffer(sampleBuffer) else {
        print("Invalid Image buffer")
        return
      }
      deepARCapturer.pushFrame(pb)
    }
  }

}

