import AVKit

extension AVAudioApplication  {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}


/**
 
 
 extension AVAudioSession {
     func hasPermissionToRecord() async -> Bool {
         await withCheckedContinuation { continuation in
             requestRecordPermission { authorized in
                 continuation.resume(returning: authorized)
             }
         }
     }
 }


 */
