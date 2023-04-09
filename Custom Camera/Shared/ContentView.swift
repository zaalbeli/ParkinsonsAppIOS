//
//  ContentView.swift
//  Shared
//
//  Created by Zaal Abhi Arnav on 04/07/23.
//
import CoreML
import SwiftUI
import AVFoundation
import RealmSwift
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore
import UIKit
import Foundation



extension UIImage {
    
    func resizeImageTo(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    
    func toCVPixelBuffer() -> CVPixelBuffer? {
           let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
           var pixelBuffer : CVPixelBuffer?
           let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
           guard status == kCVReturnSuccess else {
               return nil
           }

           if let pixelBuffer = pixelBuffer {
               CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
               let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)

               let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
               let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

               context?.translateBy(x: 0, y: self.size.height)
               context?.scaleBy(x: 1.0, y: -1.0)

               UIGraphicsPushContext(context!)
               self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
               UIGraphicsPopContext()
               CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

               return pixelBuffer
           }

           return nil
       }
}


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    //FirebaseApp.configure()
    return true
  }
}
struct ContentView: View {
    var body: some View {
        NavigationView{
                    VStack{
                        HomeScreen()
                        .navigationBarTitle("SpiralScope")
                        .offset(y:-200)
                        NavigationLink(destination: InstructionView(), label:{Text("Next")})
                    }
                }
    }
}
struct InstructionScreen: View{
    var body: some View {
        
        VStack{
            Color.red

            Image("BaseImage1").resizable().frame(width: 150.0, height: 150.0)
                .aspectRatio(contentMode: .fit)
            Image("BaseImage2").resizable().frame(width: 150.0, height: 150.0)
                .aspectRatio(contentMode: .fit)
            Text("Try your absolute best to draw a spiral.\nPlease use the images as a reference.").aspectRatio(contentMode: .fit)

            //Image("globe").resizable()
        }
    }
}
struct InstructionView: View {
    var body: some View {

        NavigationView{
                    VStack{
                        InstructionScreen()
                        .navigationBarTitle("Instructions")
                        .offset(y:-200)
                        NavigationLink(destination: CameraView(), label:{Text("Next")})
                        
                    }
                }
    }
}

struct HomeScreen: View{
    var body: some View {
        
        Color.red
        VStack{
            Image("SpiralLogo").resizable().frame(width: 150.0, height: 150.0)
                .aspectRatio(contentMode: .fit)
            Text("Do you have Parkinsons?\nTry our simple test and find out if u weird").aspectRatio(contentMode: .fit)
        }
    }
}
struct ResultView: View{
    @State var retrievedImages = [UIImage]()
    var body: some View {
        /*Retrieve data from database and process data*/
        
        let db = Firestore.firestore()
        
       /* db.collection("images").getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                var paths = [String]()
                
                for doc in snapshot!.documents{
                    
                    paths.append(doc["url"] as! String)
                }
                
                for path in paths{
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(path)
                    
                    fileRef.getData(maxSize: 5*1024*1024){ data, error in
                        if error == nil && data != nil{
                            
                            if let image = UIImage(data: data!){
                                
                                DispatchQueue.main.async {
                                    retrievedImages.append(image)
                                }
                            }
                        }
                    }
                }
                
            }
        }
        
        
        HStack{
            //Loop throught the images and display them
            ForEach(retrievedImages, id: \.self){image in
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 300, height: 300)
                    
                
            }
        }*/
        
        VStack{
            Text("results").aspectRatio(contentMode: .fit)
        }
        //get data from database
        //Get image data in storage for each image referece
        //Diaply image
        
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CameraView: View {
        
    @StateObject var camera = CameraModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some View{
        
        ZStack{
            Color.red
                .navigationTitle("Take your picture")
            // Going to Be Camera preview...
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack{
                
                if camera.isTaken{
                    
                    HStack {
                        
                        Spacer()
                        
                        Button(action: camera.reTake, label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        })
                        .padding(.trailing,10)
                    }
                }
                
                Spacer()
             
                
                HStack{
                    
                    // if taken showing save and again take button...
                    
                    if camera.isTaken{
                        NavigationView{
                            
                        }
                            Button(action: {if !camera.isSaved{camera.savePic()}
                                print("Clicked the safe button")
                            }, label: {
                                Text(camera.isSaved ? (String(camera.getOutput().0*100).prefix(2) + "%" + "   " + camera.getOutput().1) : "Get Result")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .padding(.vertical,10)
                                    .padding(.horizontal,20)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                                
                            }
                        )
                        Spacer()
                        
                       /* NavigationView(){
                            NavigationLink(destination: ResultView(), label:{Text("Next")})
                        }*/
                        
                        
                        .padding(.leading)
                        Spacer()
                        
                    }
                    else{
                        
                        Button(action: camera.takePic, label: {
                            
                            ZStack{
                                
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                
                                Circle()
                                    .stroke(Color.white,lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        })
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear(perform: {
            
            camera.Check()
        })
        .alert(isPresented: $camera.alert) {
            Alert(title: Text("Please Enable Camera Access"))
        }
    }
}

// ImageObject

class ImageObject: Object {
    @objc dynamic var imageData: Data = Data()
}

// Camera Model...

class CameraModel: NSObject,ObservableObject,AVCapturePhotoCaptureDelegate {
    
    
    //@State var myImage: UIImage?
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    // since were going to read pic data....
    @Published var output = AVCapturePhotoOutput()
    
    // preview....
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    // Pic Data...
    
    @Published var isSaved = false
    
    @Published var res = ""
    
    @Published var confidence = 100.0
    
    @Published var picData = Data(count: 0)
    
    //@State var res: ParkinsonDetectorOutput
    
    func Check(){
        
        // first checking camerahas got permission...
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
            // Setting Up Session
        case .notDetermined:
            // retusting for permission....
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                
                if status{
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
            
        default:
            return
        }
    }
    
    func setUp(){
        
        // setting up camera...
        
        do{
            
            // setting configs...
            self.session.beginConfiguration()
            
            // change for your own...
            
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            // checking and adding to session...
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            // same for output....
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    // take and retake functions...
    
    func takePic(){
        
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        
        DispatchQueue.global(qos: .background).async {
            
            self.session.stopRunning()
            
            DispatchQueue.main.async {
                
                withAnimation{self.isTaken.toggle()}
            }
        }
    }
    
    func reTake(){
        
        DispatchQueue.global(qos: .background).async {
            
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
                //clearing ...
                self.isSaved = false
                self.picData = Data(count: 0)
            }
        }
    }
    
    func getOutput()->(Double,String){
        return (confidence,res)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if error != nil{
            return
        }
        
        print("pic taken...")
        
        guard let imageData = photo.fileDataRepresentation() else{return}
        
        self.picData = imageData
    }
    
    
    func savePic(){
        
        guard let image = UIImage(data: self.picData) else{return}
        print("savepic")
       // myImage = image
        do{
            let editedimage = image.resizeImageTo(size: CGSize(width: 300.0, height: 300.0))
            let config = MLModelConfiguration()
            let model = try ParkinsonDetector(configuration: config)
            let prediction = try model.prediction(image: (editedimage?.toCVPixelBuffer())!)
            print("Entered ML Stage\n\n")
            print(prediction.classLabel)
            res = prediction.classLabel
            confidence = max((prediction.classLabelProbs["healthy"])!, (prediction.classLabelProbs["parkinsons"])!)
            
        }catch{
            print("Something went wrong")
        }
        
        let storageRef = Storage.storage().reference()
        let jpegData = image.jpegData(compressionQuality: 0.8)!
        
        guard jpegData != nil else{
            return
        }
        
        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        let uploadTask = fileRef.putData(jpegData, metadata: nil) {
            metadata, error in
            
            if error == nil && metadata != nil{
                print("database entry")
                let db = Firestore.firestore()
                //print(db.collection("images") != nil)
                db.collection("images").document(UUID().uuidString).setData(["url":path]) 
                
            }
            
        }
        
        
        
        
        

        /*let realm = try! Realm()
        
        let pngData = image.pngData()!
        
        let imageObj = ImageObject()
        
        imageObj.imageData = pngData
        
        try! realm.write{
            realm.add(imageObj)
        }
         */
        
        
        // saving Image...
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
      
        
        self.isSaved = true
        
        print("saved Successfully....")
    }
    func returnPic(_ image: UIImage) -> UIImage?{
        return image
    }
}

// setting view for preview...

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) ->  UIView {
        //let rsize = CGSize(width: screenSize.width, height: screenSize.height)
       // let view = UIView(frame: CGRect(origin: CGPoint(x:0, y:0), size: CGSize())
        let view = UIView(frame: UIScreen.main.bounds)
        //let screenSize = UIScreen.main.bounds.size
        //let centerX = screenSize.width/2
        //let centerY = screenSize.height/2
        //view.center = CGPoint(x: centerX, y: centerY)
        
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        // Your Own Properties...
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        // starting session
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}


