//
//  mainNSWindow.swift
//  animationHelper
//
//  Created by George Torres on 8/30/16.
//  Copyright © 2016 George. All rights reserved.
//

import Foundation

import AppKit


class mainNSWindow: NSWindow
{
    @IBOutlet weak var selectFilesButton: NSButton!
    @IBOutlet weak var imageViewer: NSImageView!
    var imageArray = [NSImage]()
    var currentImageframe : Int = 0
    var currentTimer = NSTimer()
    var debug = false
    
 
    @IBOutlet weak var filePrefixEntry: NSTextField!
    @IBOutlet weak var numberOfViewsEntry: NSTextField!
    @IBOutlet weak var framesPerDirectionEntry: NSTextField!
    @IBOutlet weak var fileSorterSelectFolderButton: NSButton!
    @IBOutlet weak var animatedButton1: NSAnimatedButton!
    @IBOutlet weak var animatedButton2: NSAnimatedButton!
    @IBOutlet weak var animatedButton3: NSAnimatedButton!
    @IBOutlet weak var aniamtedButton4: NSAnimatedButton!
    var aniamtedButtonArray = [NSAnimatedButton]()
    var currentAnimatedButton = Int()
    var imageArrayToUseForCurrentAnimation = [NSImage]()
    var lastFileURL = NSURL?()
    
    @IBOutlet weak var backgroundImageViewer: NSImageView!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        aniamtedButtonArray = [animatedButton1, animatedButton2, animatedButton3, aniamtedButton4]
        //Green
        
        
        imageViewer.wantsLayer = true
        //imageViewerBackgroundColor.wantsLayer = true
        //imageViewerBackgroundColor.layer?.backgroundColor = CGColorCreateGenericRGB(50, 50, 50, 0.9)
        
        
        numberOfViewsEntry.intValue = 4
        framesPerDirectionEntry.intValue = 4
    }

    
    @IBAction func animatedButtonPressed(sender: NSAnimatedButton) {
        
      
        if(sender.animationArray.count > 0)
        {
           imageArrayToUseForCurrentAnimation = sender.animationArray
        } else{
            Swift.print("has nothing")
        }
        
        
    }
    
    @IBAction func selectedFilesButtonPressed(sender: NSButton) {
        
    openAndSelectFile()
    }

    
    
    @IBAction func fileSorterSelectFolderButtonPresed(sender: NSButton) {
        
        let myFileDialog: NSOpenPanel = NSOpenPanel()
        var cleanPath = NSURL()
        var cleanPathString = String()
        
        
        Swift.print("Green")
        Swift.print("Wtf")
        
        
        myFileDialog.allowsMultipleSelection = true
        myFileDialog.canChooseFiles = true
        myFileDialog.canChooseDirectories = false
        myFileDialog.runModal()
        
        
        for currentCount in 0...myFileDialog.URLs.count - 1
            {
                Swift.print("\(myFileDialog.URLs[currentCount]) \n")
            }
        
        
        cleanPath = myFileDialog.URLs[0].URLByDeletingLastPathComponent!
        cleanPathString  = cleanPath.path!
        cleanPathString.appendContentsOf("/")
        cleanPathString.hasPrefix("/")
        
        
   
        
        //create A backup directory
     let fileManager = NSFileManager.defaultManager()
        do{
            try fileManager.createDirectoryAtPath(("\(cleanPathString)backup"), withIntermediateDirectories: false, attributes: nil)
        }
            
        catch {
           // errorLabel.stringValue =  "failed to create backup directory"
        }
        
        //move all selected files to backup directory
        
        for i in 0...myFileDialog.URLs.count - 1
        {
            let endURL = myFileDialog.URLs[i].lastPathComponent
            
            
            Swift.print("\(endURL)green")
            do{
                try fileManager.copyItemAtPath(myFileDialog.URLs[i].path!, toPath: ("\(cleanPathString)backup/\(endURL!)"))
                
            }catch {
                //  errorLabel.stringValue = "failed to copy items to directory"
            }
        }
        
        //create directonal folders
        
        for i in 0...numberOfViewsEntry.intValue - 1
        {
            do{
                try fileManager.createDirectoryAtPath(("\(cleanPathString)0\(i).atlas"), withIntermediateDirectories: false, attributes: nil)
            }
                
            catch {
                // errorLabel.stringValue = "failed to create directional directory"
            }

            
            
        }
        
    
        //change names of selected files
        
       var currentFileNumber = Int()
        
        for i in 0...numberOfViewsEntry.intValue - 1
            
        {
            
            Swift.print("ruynning in nuymber of views")
          
            
                for x in 0...framesPerDirectionEntry.intValue - 1
                {
                     let endURL = myFileDialog.URLs[Int(currentFileNumber)].pathExtension
                    
                    Swift.print("running in directional")
                    do {
                        try fileManager.moveItemAtPath(myFileDialog.URLs[currentFileNumber].path!, toPath: "\(cleanPathString)0\(i).atlas/\(filePrefixEntry.stringValue)_0\(i)_\(x).\(endURL!)")
                                               }
                    catch
                    {
                          //  errorLabel.stringValue = "failed to move files to directional directories"
                        }
                    currentFileNumber = currentFileNumber + 1
            }
        }
        

        

        
    }
    
   var isoOrNot = Bool()
    @IBAction func checkerButtonPressed(sender: NSButton) {
        if (!isoOrNot)
        {
       backgroundImageViewer.image = NSImage.init(named: "checkeredBackground")
            isoOrNot = !isoOrNot
        } else{
            backgroundImageViewer.image = NSImage.init(named: "isocheckered")
            isoOrNot = !isoOrNot
        }
        imageViewer.layer?.backgroundColor = CGColorCreateGenericRGB(0, 0, 0, 0.0)
    }
    
    @IBAction func greyButtonPressed(sender: NSButton) {
        backgroundImageViewer.image = nil
        imageViewer.layer?.backgroundColor = CGColorCreateGenericRGB(244 / 255, 244 / 255, 244 / 255, 2.5)
    }
    @IBAction func colorWell(sender: NSColorWell) {
       
        let currentColor = sender.color
        
        imageViewer.layer!.backgroundColor = CGColorCreateGenericRGB(currentColor.redComponent, currentColor.greenComponent, currentColor.blueComponent, currentColor.alphaComponent)
       // imageViewer.layer!.backgroundColor = sender.
    }
    
    

    func openAndSelectFile(){
        currentImageframe = 0
        currentTimer.invalidate()
        imageArray = []
        
        Swift.print("green")
        
        let myFileDialog: NSOpenPanel = NSOpenPanel()
        
        myFileDialog.allowsMultipleSelection = true
        myFileDialog.canChooseFiles = true
        myFileDialog.canChooseDirectories = true
        myFileDialog.prompt = "Select"
        if (lastFileURL != nil)
        {
            myFileDialog.directoryURL = lastFileURL!.URLByDeletingLastPathComponent
            
        }
        myFileDialog.runModal()
        
        lastFileURL = myFileDialog.URL!.URLByDeletingLastPathComponent!
        
        
        //Swift.print(myFileDialog.URLs)
       // Swift.print("/n %s" + String(myFileDialog.URLs[2]))
        
      
        
       //var newImage = NSImage.init(contentsOfURL: myFileDialog.URL!)
       //imageViewer.image = newImage
        
        let animationFrames = myFileDialog.URLs.count
        var currentCount = 0
        
        while (currentCount < animationFrames) {
            
            let newImage = NSImage(contentsOfURL: myFileDialog.URLs[currentCount])
            self.imageArray.append(newImage!)
            currentCount = currentCount + 1
        }
        
    imageViewer.image = imageArray[0]
    
        imageArrayToUseForCurrentAnimation = imageArray
    
        aniamtedButtonArray[currentAnimatedButton].animationArray = imageArrayToUseForCurrentAnimation
        aniamtedButtonArray[currentAnimatedButton].image =  aniamtedButtonArray[currentAnimatedButton].animationArray[0]
    
        currentAnimatedButton = currentAnimatedButton + 1
        
    
        if (currentAnimatedButton > aniamtedButtonArray.count - 1)
        {
            currentAnimatedButton = 0
        }
     startTimer()
        
        
    }

    func startAnimating()
    {
        if (currentImageframe >= imageArrayToUseForCurrentAnimation.count)
        {
            currentImageframe = 0
        }
        
       imageViewer.image = imageArrayToUseForCurrentAnimation[currentImageframe]
        
        
        currentImageframe = currentImageframe + 1
        
        if (currentImageframe >= imageArrayToUseForCurrentAnimation.count)
        {
            currentImageframe = 0
        }
        
        
    }
    

    

    func startTimer()
    {
        
     
        
        let newTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(self.startAnimating), userInfo: nil, repeats: true)
        currentTimer = newTimer
 
    }
    
}