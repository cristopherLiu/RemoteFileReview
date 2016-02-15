//
//  Extension.swift
//  RemoteFileReview
//
//  Created by hjliu on 2016/2/15.
//  Copyright © 2016年 hjliu. All rights reserved.
//

import UIKit
import Alamofire

extension UIViewController:UIDocumentInteractionControllerDelegate{
    
    private var documentInteractionController : UIDocumentInteractionController{
        
        struct Singleton {
            static let instance = UIDocumentInteractionController()
        }
        return Singleton.instance
    }
    
    func openFile(fileUrl:String,fileName:String? = nil,loadProgress:((Float)->())?){
        
        var localPath: NSURL?
        
        Alamofire.download(.GET, fileUrl, destination: { temporaryURL, response in
            
            let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            
            var pathComponent = ""
            
            //有設定file name
            if let fileName = fileName{
                pathComponent = fileName
            }else{
                
                //取得url的suggestedFilename
                if let suggestedFilename = response.suggestedFilename{
                    if let byte = suggestedFilename.cStringUsingEncoding(NSISOLatin1StringEncoding){
                        if let realFileName = NSString(CString: byte, encoding: NSUTF8StringEncoding){
                            pathComponent = String(realFileName)
                        }
                    }
                }
            }
            
            //本地patch
            localPath = directoryURL.URLByAppendingPathComponent(pathComponent)
            
            return localPath!
        })
            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    //進度百分比
                    let progress = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
                    
                    loadProgress?(progress)
                }
            }
            .response { (request, response, _, error) in
                
                if let localPath = localPath{
                    
                    self.documentInteractionController.delegate = self
                    self.documentInteractionController.URL = localPath
                    
                    //如果不能開啟preview
                    if self.documentInteractionController.presentPreviewAnimated(true) == false{
                        
                        //開啟選單
                        self.documentInteractionController.presentOptionsMenuFromRect(CGRectZero, inView: self.view, animated: true)
                    }
                }
        }
    }
    
    public func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController{
        return self
    }
}
