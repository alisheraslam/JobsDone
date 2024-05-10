//
// @BundleId SocialNet iOS App
// @copyright  Copyright 2017-2022 Stars Developer
// @license     https://starsdeveloper.com/license/
// @version     2.0 2017-11-10
// @author      Stars Developer, Lahore, Pakistan
//

import UIKit
import MediaPlayer
import Photos

protocol MediaPickVCDelegate {
    func mediaDidPicked(item: URL)
    func media_id(music_id: String)
//    func media
}

class MediaPickVC: UIViewController, MPMediaPickerControllerDelegate {
    
    var item: MPMediaItem?
    var delegate: MediaPickVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mediaPicker: MPMediaPickerController = MPMediaPickerController.self(mediaTypes:MPMediaType.musicVideo)
        mediaPicker.delegate = self
        mediaPicker.allowsPickingMultipleItems = false
        self.present(mediaPicker, animated: true, completion: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MediaPickVC.pop), name: Notification.Name("pop"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = .white
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MPMediaPickerController Delegate methods
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true) {
            // Post notification
            NotificationCenter.default.post(name: Notification.Name("pop"), object: nil)
        }

    }
    func export(_ assetURL: NSURL,titles: String, completionHandler: @escaping (NSURL?, Error?) -> ()) {
        let asset = AVURLAsset(url: assetURL as URL)
        guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            completionHandler(nil, ExportError.unableToCreateExporter as? Error)
            return
        }
        print(asset)
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(titles)?.appendingPathExtension("m4a")

        // remove any existing file at that location
        do {
            try FileManager.default.removeItem(at: fileURL!)
        }
        catch {
            // most likely, the file didn't exist.  Don't sweat it
        }
        
        
        exporter.outputURL = fileURL
        exporter.outputFileType = AVFileType(rawValue: "com.apple.m4a-audio")
        
        exporter.exportAsynchronously {
            print(exporter.status)
            if exporter.status == .completed {
                completionHandler(fileURL as NSURL?, nil)
            } else {
               
                completionHandler(nil, exporter.error)
            }
        }
    }
    
    func exampleUsage(with mediaItem: MPMediaItem) {
        
        if let assetURL = mediaItem.assetURL {
            export(assetURL as NSURL, titles: String(describing: mediaItem.title!)) { fileURL, error in
                guard let fileURL = fileURL, error == nil else {
                    print("export failed: \(String(describing: error))")
                    Utilities.sharedInstance.hideActivityIndicator(uiView: self.view)
                    return
                }
                
                // use fileURL of temporary file here
                print("\(fileURL)")
                
                
                
                self.uploadMusic(url: fileURL as URL)
//                self.delegate?.mediaDidPicked(item: fileURL as URL)
                
//                self.dismiss(animated: true) {
//                    // Post notification
//                    NotificationCenter.default.post(name: Notification.Name("pop"), object: nil)
//                }

            }
        }
    }
    
    enum ExportError: Error {
        case unableToCreateExporter
    }
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        print("you picked: \(mediaItemCollection)")//This is the picked media item.
        item = mediaItemCollection.items[0] as MPMediaItem
        print(item?.artist as Any)
        print(item?.albumArtist as Any)
        print(item?.title as Any)
        print(item?.lyrics as Any)
        
//      self.exampleUsage(with: item!)

    }
    
    func uploadMusic(url: URL?){
        var params = Dictionary<String, AnyObject>()
        
        params["type"] = "wall" as AnyObject
        params["post_attach"] = "1" as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
        ALFWebService.sharedInstance.doPostDataWithMusic(parameters: params as! [String : String], method: "music/playlist/add-song", data: url, name: "Filedata", image: nil, success: { (response) in
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            
            print(response)
        }) { (response) in
            Utilities.sharedInstance.showActivityIndicatory(uiView: self.view)
            print(response)
        }
    }

    @objc func pop(){
        self.navigationController?.popViewController(animated: true, completion: { 
            
        })

    }

}
