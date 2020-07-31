//
//  DeepARVideoCapturer.swift
//  OpentokDeepARSDK
//
//  Created by rpc on 24/07/2020.
//  Copyright © 2020 vonage. All rights reserved.
//

import Foundation
import OpenTok

class DeepARVideoCapturer: NSObject, OTVideoCapture {
  fileprivate var captureStarted = false
  fileprivate var otFrame: OTVideoFrame?
  
  
  var videoCaptureConsumer: OTVideoCaptureConsumer?
  
  func initCapture() {
  }
  
  func releaseCapture() {
  }
  
  func start() -> Int32 {
    captureStarted = true
    return 0
  }
  
  func stop() -> Int32 {
    captureStarted = false
    return 0
  }
  
  func isCaptureStarted() -> Bool {
    return captureStarted
  }
  
  func captureSettings(_ videoFormat: OTVideoFormat) -> Int32 {
    return 0
  }
  
  func pushFrame(_ pb: CVPixelBuffer) {
    // 1
    if otFrame == nil {
      let otFormat = OTVideoFormat()
      otFormat.pixelFormat = .ARGB
      otFormat.imageWidth = UInt32(CVPixelBufferGetWidth(pb))
      otFormat.imageHeight = UInt32(CVPixelBufferGetHeight(pb))
      otFormat.bytesPerRow = [CVPixelBufferGetBytesPerRow(pb)]
      
      otFrame = OTVideoFrame(format: otFormat)
    }
    
    guard let frame = otFrame else {
      print("Error creating video frame")
      return
    }
    
    // 2
    CVPixelBufferLockBaseAddress(pb, .readOnly)
    if let frameData = CVPixelBufferGetBaseAddress(pb) {
      frame.orientation = .up
      frame.clearPlanes()
      frame.planes?.addPointer(frameData)
      
      // 3
      videoCaptureConsumer?.consumeFrame(frame)
    }
    CVPixelBufferUnlockBaseAddress(pb, .readOnly)
  }
}
