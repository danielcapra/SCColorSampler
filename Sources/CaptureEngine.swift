//
//  CaptureEngine.swift
//  
//
//  Created by Daniel Capra on 29/10/2023.
//

import Foundation
import ScreenCaptureKit

internal class CaptureEngine: NSObject {
    private var stream: SCStream?
    private var streamOutput: CaptureEngineStreamOutput?
    
    private var continuation: AsyncThrowingStream<CGImage, Error>.Continuation?
    
    func startCapture(configuration: SCStreamConfiguration, filter: SCContentFilter) -> AsyncThrowingStream<CGImage, Error> {
        
        AsyncThrowingStream<CGImage, Error> { continuation in
            self.continuation = continuation
            
            streamOutput = CaptureEngineStreamOutput(continuation: continuation)
            guard let streamOutput = streamOutput else { 
                // Very weird !
                continuation.finish()
                return
            }
            streamOutput.capturedImageHandler = { continuation.yield($0) }
            
            do {
                stream = SCStream(filter: filter, configuration: configuration, delegate: streamOutput)
                
                // Add a stream output to capture screen content.
                try stream?.addStreamOutput(
                    streamOutput,
                    type: .screen,
                    sampleHandlerQueue: DispatchQueue.global(qos: .userInteractive)
                )
                stream?.startCapture()
            } catch {
                continuation.finish(throwing: error)
            }
        }
    }
    
    func updateConfiguration(
        newConfig: SCStreamConfiguration,
        newFilter: SCContentFilter
    ) async {
        do {
            async let updateConfig: Void? = stream?.updateConfiguration(newConfig)
            async let updateFilter: Void? = stream?.updateContentFilter(newFilter)
            let (_, _) = (try await updateConfig, try await updateFilter)
        } catch {
            continuation?.finish(throwing: error)
        }
    }
    
    func stopCapture() async {
        do {
            try await stream?.stopCapture()
            continuation?.finish()
        } catch {
            continuation?.finish(throwing: error)
        }
    }
}

fileprivate class CaptureEngineStreamOutput: NSObject, SCStreamOutput, SCStreamDelegate {
    var capturedImageHandler: ((CGImage) -> Void)?
    var continuation: AsyncThrowingStream<CGImage, Error>.Continuation?
    
    init(continuation: AsyncThrowingStream<CGImage, Error>.Continuation) {
        self.continuation = continuation
    }
    
    // StreamOutput implementation
    func stream(
        _ stream: SCStream,
        didOutputSampleBuffer sampleBuffer: CMSampleBuffer,
        of outputType: SCStreamOutputType
    ) {
        
        // Return early if the sample buffer is invalid.
        guard sampleBuffer.isValid else { return }
        
        // Determine which type of data the sample buffer contains.
        switch outputType {
        case .screen:
            // Create a CGImage for a video sample buffer.
            guard let image = createImage(for: sampleBuffer) else { return }
            capturedImageHandler?(image)
        default:
            break
        }
    }
    
    private func createImage(for sampleBuffer: CMSampleBuffer) -> CGImage? {
        // Retrieve the array of metadata attachments from the sample buffer.
        guard let attachmentsArray = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer,
                                                                             createIfNecessary: false) as? [[SCStreamFrameInfo: Any]],
              let attachments = attachmentsArray.first else { return nil }
        
        // Validate the status of the frame. If it isn't `.complete`, return nil.
        guard let statusRawValue = attachments[SCStreamFrameInfo.status] as? Int,
              let status = SCFrameStatus(rawValue: statusRawValue),
              status == .complete else { return nil }
        
        // Get the pixel buffer that contains the image data.
        guard let imageBuffer = sampleBuffer.imageBuffer else { return nil }
        
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        
        return cgImage
    }
    
    func stream(_ stream: SCStream, didStopWithError error: Error) {
        continuation?.finish(throwing: error)
    }
}
