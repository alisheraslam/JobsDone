//
//  AttachmentMenuHandler.swift
//  SchoolChain
//
//  Created by musharraf on 5/15/17.
//  Copyright © 2017 Stars Developer. All rights reserved.
//

import UIKit
import BSImagePicker
import MediaPlayer
import Photos
import AVFoundation
import DKImagePickerController
import Alertift
import MobileCoreServices

protocol AttachmentMenuProtocol {

    func didPickedImage(image: UIImage, url: URL)
    func didGotLink(url: String)
    func didPickedVideo(id: Int,url: String,imageStr: String)
    func didPickedVideoFromDevice(url: URL)
    func didPickedMusicId(id: String)
   
}

class AttachmentMenuHandler: NSObject, UITextFieldDelegate, UITextViewDelegate
,UIImagePickerControllerDelegate, UINavigationControllerDelegate,VideoAttachAlertViewDelegate, MPMediaPickerControllerDelegate {
   

    
    var item: MPMediaItem?
    
    var views : VideoAttachAlertView!
    var blurEffectView : UIVisualEffectView!
    var delegate : AttachmentMenuProtocol? = nil
//    let delegat: MediaPickVCDelegate? = nil
    
    var vc: UIViewController!
    
    
    
    func setAttatchmentMenu(con: UIViewController, suplimentryView: UIView?, senderr: AnyObject, view: UIView, btnTyp: String?){
        
        self.vc = con
        
        let alert = UIAlertController()
        let imgAct = UIAlertAction(title: "Attach Image", style: .default) { (alert) in
            self.attatchImageOpener(con: con)
        }
//        let linkAct = UIAlertAction(title: "Attach Link", style: .default) { (alert) in
//            self.attatchLinkOpener(con: con)
//        }
        let videoAct = UIAlertAction(title: "Attach Video", style: .default) { (alert) in
            self.attatchVideoOpener(con: con)
        }
//        let musicAct = UIAlertAction(title: "Attach Music", style: .default) { (alert) in
//            let mediaPicker: MPMediaPickerController = MPMediaPickerController.self(mediaTypes:MPMediaType.musicVideo)
//            mediaPicker.delegate = self
//            mediaPicker.allowsPickingMultipleItems = false
//            con.present(mediaPicker, animated: true, completion: nil)
//        }
        var cancelAct = UIAlertAction()
        if DeviceType.iPad {
            cancelAct = UIAlertAction(title: "Cancel", style: .default) { (alert) in
                
            }
        } else {
            cancelAct = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
                
            }
        }
        
        alert.addAction(imgAct)
//        alert.addAction(linkAct)
        alert.addAction(videoAct)
//        alert.addAction(musicAct)
        alert.addAction(cancelAct)
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
            if let popoverPresentationController = alert.popoverPresentationController {
               
                if btnTyp == "barBtn" {
                    popoverPresentationController.sourceView = senderr as? UIView
                    popoverPresentationController.barButtonItem = senderr as? UIBarButtonItem
                } else if btnTyp == "btn" {
                    popoverPresentationController.sourceView = senderr as? UIView
                    popoverPresentationController.sourceRect = senderr.bounds
                    
                }
                    
                
                //                popoverPresentationController.permittedArrowDirections = []
            }
            con.present(alert, animated: true, completion: nil)
            
        } else {
            con.present(alert, animated: true, completion: nil)
        }

        
    }
    
    
//    MARK: - ATTATCH IMAGE UTILITY
    
    func attatchImageOpener(con:UIViewController){
    
//        let vc = BSImagePickerViewController()
//        
//        vc.takePhotos = true
//        vc.maxNumberOfSelections = 1
//        var _: String?
//        con.bs_presentImagePickerController(vc, animated: true, select: { (asset: PHAsset) -> Void in
//           
//            
//        }, deselect: { (asset: PHAsset) -> Void in
//            
//        }, cancel: { (assets: [PHAsset]) -> Void in
//            // User cancelled. And thmessageTxtis where the assets currently selected.
//        }, finish: { (assets: [PHAsset]) -> Void in
//            
//            _ = self.getURLofPhoto(mPhasset: assets[0], completionHandler: { (url) in
//                print(url!)
//                let image = Utilities.getAssetThumbnail(asset: assets[0])
//                print(image)
//                self.imagePicked(image: image, url: url! as URL)
//                
//            })
//            
//        }, completion: nil)
    }
    func getURLofPhoto(mPhasset : PHAsset, completionHandler : @escaping ((_ responseURL : NSURL?) -> Void)){
    
        if mPhasset.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
        }
            mPhasset.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput, info) in
                completionHandler(contentEditingInput!.fullSizeImageURL! as NSURL)
            })
       
        }
    
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePicked(image: UIImage, url: URL){
        print(delegate!)
        delegate?.didPickedImage(image: image, url: url)
    }
    
    //    MARK: - ATTATCH LINK UTILITY
    
    func attatchLinkOpener(con:UIViewController){
        
        Alertift.alert(title: "Attach Link", message: "Enter url:")
            .textField { textField in
                textField.placeholder = "Enter URL"
            }
            .action(.cancel("Cancel"))
            .action(.default("Done"), textFieldsHandler: { //textFields in
                //let url = textFields?.first?.text ?? ""
                //if url.isEmpty {
                    Alertift.alert(title: "Error", message: "Please enter url:")
                        .action(.cancel("Dismiss"))
                        .show()
                //} else {
                    //self.urlPicked(url: url)
                    
                //}
            })
            .show(on: con, completion: nil)

    }
    
    func urlPicked(url: String){
        self.delegate?.didGotLink(url: url)
    }
    
    
    //    MARK: - ATTATCH VIDEO UTILITY
    func attatchVideoOpener(con:UIViewController){
        if DeviceType.iPad {
            Alertift.alert(title: "", message: "Select Source")
                .action(.default("External Source"), handler: {
                    Alertift.alert(title: "Attach Video Url", message: "Enter url:")
                        .textField { textField in
                            textField.placeholder = "Enter URL"
                        }
                        .action(.cancel("Cancel"))
                        .action(.default("Done"), textFieldsHandler: { //textFields in
                            //                            let url = textFields?.first?.text ?? ""
                            //                            if url.isEmpty {
                            Alertift.alert(title: "Error", message: "Please enter url:")
                                .action(.cancel("Dismiss"))
                                .show(on: con, completion: nil)
                            //                            } else {
                            //                                
                            //                                
                            //                                let video_url = URL(string: url)
                            //                                
                            //                                self.attachVideo(urlStr: url, type: "iframely", url: video_url!)
                            //                            }
                        })
                        .show(on: con, completion: nil)
                })
//                .action(.default("My Device")){
//                    Alertift.alert(title: "", message: "Select Source")
//                        .action(.default("Open Gallery")) {
//                            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
//                                print("captureVideoPressed and camera available.")
//
//                                let imagePicker = UIImagePickerController()
//                                //                        imagePicker.
//                                imagePicker.delegate = self
//                                imagePicker.sourceType = .photoLibrary
//                                imagePicker.mediaTypes = [kUTTypeMovie as String]
//                                imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
//
//
//                                con.present(imagePicker, animated: true, completion: nil)
//                            }
//                        }.action(.default("Open Camera")) {
//                            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//                                let imagePicker = UIImagePickerController()
//
//                                imagePicker.delegate = self
//                                imagePicker.sourceType = .camera
//
//                                con.present(imagePicker, animated: true, completion: nil)
//
//                            } else {
//                                Utilities.showAlertWithTitle(title: "Sorry", withMessage: "No camera Found", withNavigation: con)
//                            }
//                        }
//                        .action(.cancel("Cancel")) {
//
//                        }
//                        .show(on: con, completion: nil)
//
//                }
                .action(.cancel("Cancel"), handler: {
                    
                })
                .show(on: con, completion: nil)
        } else {
            Alertift.actionSheet(title: "", message: "Select Source")
                .action(.default("External Source")) {
                    Alertift.alert(title: "Attach Video Url", message: "Enter url:")
                        .textField { textField in
                            textField.placeholder = "Enter URL"
                        }
                        .action(.cancel("Cancel"))
                        .action(.default("Done"), textFieldsHandler: { //textFields in
//                            let url = textFields?.first?.text ?? ""
//                            if url.isEmpty {
                                Alertift.alert(title: "Error", message: "Please enter url:")
                                    .action(.cancel("Dismiss"))
                                    .show(on: con, completion: nil)
//                            } else {
//                                
//                                
//                                let video_url = URL(string: url)
//                                
//                                self.attachVideo(urlStr: url, type: "iframely", url: video_url!)
//                            }
                        })
                        .show(on: con, completion: nil)
                }
//                .action(.default("My Device")){
//                    Alertift.actionSheet(title: "", message: "Select Source")
//                        .action(.default("Open Gallery")) {
//                            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
//                                print("captureVideoPressed and camera available.")
//
//                                let imagePicker = UIImagePickerController()
//                                //                        imagePicker.
//                                imagePicker.delegate = self
//                                imagePicker.sourceType = .photoLibrary
//                                imagePicker.mediaTypes = [kUTTypeMovie as String]
//                                imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
//
//
//                                con.present(imagePicker, animated: true, completion: nil)
//                            }
//                        }.action(.default("Open Camera")) {
//                            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//                                let imagePicker = UIImagePickerController()
//
//                                imagePicker.delegate = self
//                                imagePicker.sourceType = .camera
//
//                                con.present(imagePicker, animated: true, completion: nil)
//
//                            } else {
//                                Utilities.showAlertWithTitle(title: "Sorry", withMessage: "No camera Found", withNavigation: con)
//                            }
//                        }
//                        .action(.cancel("Cancel")) {
//
//                        }
//                        .show(on: con, completion: nil)
//
//                }
                .action(.cancel("Cancel")) {
                    
                }
            
                .show(on: con, completion: nil)
        }
        
        

        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
       vc.dismiss(animated: true, completion: nil)
        if info[UIImagePickerController.InfoKey.mediaURL.rawValue] == nil {
            var url: URL?
            self.attachVideo(urlStr: "", type: "upload", url: url)
        } else {
            let videoUrl = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as! URL
            self.attachVideo(urlStr: "", type: "upload", url: videoUrl)
        }
       
        
    }
    func didPressedCancelButton() {
        
        views.removeFromSuperview()
        blurEffectView.removeFromSuperview()
    }
    func didPressedChooseTypeButton() {
        
    }
    
    func attachVideo(urlStr: String, type: String, url: URL?){
        
        if url == nil {
            Utilities.showAlertWithTitle(title: "Sorry", withMessage: "Please Pick Video from Gallery!", withNavigation: vc)
            return

        }
        
        var params = Dictionary<String, AnyObject>()
        
        params["post_attach"] = 1 as AnyObject
        
        
        if type == "iframely" {
            params["type"] = type as AnyObject
            params["url"] = url as AnyObject
            
            Utilities.sharedInstance.showActivityIndicatory(uiView: vc.view)
            print(params)
            
            ALFWebService.sharedInstance.doPostData(parameters: params, method: "videos/create", success: { (response) in
                print(response)
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.vc.view)
                if let status_code = response.object(forKey: "status_code") as? Int {
                    if status_code == 200 {
                        if let body = response.object(forKey: "body") as? Dictionary<String,AnyObject> {
                            if let response = body["response"] as? Dictionary<String,AnyObject> {
                                print(response["video_id"]!)
                                let imgStr = response["image"] as? String

                                self.delegate?.didPickedVideo(id: response["video_id"]! as! Int, url: urlStr, imageStr: imgStr!)
                                
                            }
                        }
                    } else {
                        Utilities.showAlertWithTitle(title: "Sorry", withMessage: "Error Occured, Try Again", withNavigation: self.vc)
                    }
                }
                
            }, fail: { (response) in
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.vc.view)
                print(response)
                
            })

        } else {
            params["type"] = type as AnyObject
            var name : String?
            name = "filedata"
           
            Utilities.sharedInstance.showActivityIndicatory(uiView: vc.view)
            AFNWebService.sharedInstance.doPostDataWithMedia(parameters: params, method: "videos/create", media: url, name: name!, success: { (response) in
                print(response)
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.vc.view)
                if let status_code = response.object(forKey: "status_code") as? Int {
                    if status_code == 200 {
                        if let body = response.object(forKey: "body") as? Dictionary<String,AnyObject> {
                            if let response = body["response"] as? Dictionary<String,AnyObject> {
                                print(response["video_id"]!)
                                
                                let imgStr = response["image"] as? String
                                
                                self.delegate?.didPickedVideo(id: response["video_id"]! as! Int, url: urlStr, imageStr: imgStr!)
                                
                            }
                        }
                    } else {
                        Utilities.showAlertWithTitle(title: "Sorry", withMessage: "Error Occured, Try Again", withNavigation: self.vc)
                    }
                }

                
            }, fail: { (response) in
                
                print(response)
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.vc.view)
            })
        }
        
    }
    func didPressedDoneButton(attachedView: VideoAttachAlertView) {
        
        
        if attachedView.urlTextField.text == ""{
         
            Utilities.showAlertWithTitle(title: "Missing", withMessage: "Please enter url", withNavigation: self.vc)
            return
        }
        
        views.removeFromSuperview()
        blurEffectView.removeFromSuperview()
        
        let video_url = attachedView.urlTextField.text
        _ = URL(string: video_url!)
        
        var params = Dictionary<String, AnyObject>()
        
        params["post_attach"] = 1 as AnyObject
        params["url"] = video_url as AnyObject
        if attachedView.chooseTypeButton.currentTitle == "Youtube" {
            params["type"] = 1 as AnyObject
        } else if attachedView.chooseTypeButton.currentTitle == "Vimeo" {
            params["type"] = 2 as AnyObject
        }
        
        Utilities.sharedInstance.showActivityIndicatory(uiView: vc.view)
        print(params)
        
        ALFWebService.sharedInstance.doPostData(parameters: params, method: "videos/create", success: { (response) in
            print(response)
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.vc.view)
            if let status_code = response.object(forKey: "status_code") as? Int {
                if status_code == 200 {
                    if let body = response.object(forKey: "body") as? Dictionary<String,AnyObject> {
                        if let response = body["response"] as? Dictionary<String,AnyObject> {
                            print(response["video_id"]!)

                          
                            let imgStr = response["image"] as? String
                            
                            self.delegate?.didPickedVideo(id: response["video_id"]! as! Int, url: video_url!, imageStr: imgStr!)
                            
                        }
                    }
                } else {
                    Utilities.showAlertWithTitle(title: "Sorry", withMessage: "Error Occured, Try Again", withNavigation: self.vc)
                }
            }
            
        }, fail: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.vc.view)
            print(response)
            
        })
        

    }
    
    func didPressedChooseVideoButton() {
        
    }


    
//    MARK: - MUSIC ATTACH UTILITY
    func mediaDidPicked(item: URL) {
        
    }
    func media_id(music_id: String) {
        
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
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.vc.view)
        if let assetURL = mediaItem.assetURL {
            export(assetURL as NSURL, titles: String(describing: mediaItem.title!)) { fileURL, error in
                guard let fileURL = fileURL, error == nil else {
                    print("export failed: \(String(describing: error))")
                    Utilities.sharedInstance.hideActivityIndicator(uiView: self.vc.view)
                    return
                }
                Utilities.sharedInstance.hideActivityIndicator(uiView: self.vc.view)
                // use fileURL of temporary file here
                print("\(fileURL)")
                var _: String?
//                do {
//                    url = try String(contentsOf: fileURL as URL)
//                } catch {
//                    print(error.localizedDescription)
//                }
                self.uploadMusic(url: fileURL as URL)
                
                
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
        vc.dismiss(animated: true, completion: nil)
        self.exampleUsage(with: item!)
        
    }
    
    func uploadMusic(url: URL?){
        var params = Dictionary<String, AnyObject>()
        
        params["type"] = "wall" as AnyObject
        params["post_attach"] = "1" as AnyObject
        Utilities.sharedInstance.showActivityIndicatory(uiView: self.vc.view)
        ALFWebService.sharedInstance.doPostDataWithMusic(parameters: params as! [String : String], method: "music/playlist/add-song", data: url, name: "Filedata", image: nil, success: { (response) in
            Utilities.sharedInstance.hideActivityIndicator(uiView: self.vc.view)
            print(response)
            
            if let status_code = response.object(forKey: "status_code") as? Int {
                if status_code == 200 {
                    if let body = response.object(forKey: "body") as? Dictionary<String,AnyObject> {
                        let song_id = body["song_id"]! as? Int
                        self.delegate?.didPickedMusicId(id: String(describing: song_id!))
                    }
                }
            }
            
//            self.delegate?.didPickedMusic(url: url!)
            
        }) { (response) in
             Utilities.sharedInstance.hideActivityIndicator(uiView: self.vc.view)
            print(response)
        }
    }
    
}
