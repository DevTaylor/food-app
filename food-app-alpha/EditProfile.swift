//
//  EditProfile.swift
//  food-app-alpha
//
//  Created by Rainier Dirawatun on 9/3/21.
//

import SwiftUI
import Parse
import MobileCoreServices

struct EditProfile: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var isShowingImageSelector = false
    @Binding var currentProfilePhoto: Image?
    @State var selectedUIImage = UIImage()
    @Binding var nameFieldText: String
    @Binding var usernameFieldText: String
    @Binding var websiteFieldText: String
    @Binding var bioFieldText: String
    
    var body: some View {
        
        
        // Container
        VStack {
        
            nav
            Divider()
            // Profile Picture & Change Btn
            currentProfilePhoto?
                .resizable()
                .scaledToFill()
//                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 110.0, height:110.0)
            
//            Image(uiImage: selectedUIImage)
            Button(action: {
                self.isShowingImageSelector.toggle()
            }, label: {
                Text("Change Profile Photo").bold().foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            })
            .sheet(isPresented: $isShowingImageSelector, content: {
                ImageSelectorView(isPresented: self.$isShowingImageSelector, selectedUIImage: self.$selectedUIImage, profilePhoto: self.$currentProfilePhoto)
            })
            
            Divider()
            
            // Inputs //////
            HStack {
                VStack(spacing: 29){
                    Text("Name").frame(maxWidth: 130, alignment: .leading)
                    Text("Username").frame(maxWidth: 130, alignment: .leading)
                    Text("Website").frame(maxWidth: 130, alignment: .leading)
                    Text("Bio").frame(maxWidth: 130, alignment: .leading)
                    
                }
                Spacer()
                VStack(alignment: .leading, spacing: 9, content: {
                    
                        TextField(nameFieldText, text: $nameFieldText)
                            .frame(width: 270, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Divider()
                        TextField(usernameFieldText, text: $usernameFieldText)
                            .frame(width: 270, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).textCase(.lowercase)
                        Divider()
                        TextField(websiteFieldText, text: $websiteFieldText)
                            .frame(width: 270, height: 30, alignment: .center)
                        Divider()
                        TextField(bioFieldText, text: $bioFieldText)
                                       .frame(width: 270, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                }).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: 170, alignment: .leading)
            }.padding(16)
            Divider()
            Button("Save"){
                updateProfileHeader(uiImage: selectedUIImage, name: nameFieldText, username: usernameFieldText, website: websiteFieldText, bio: bioFieldText)
                
                if self.presentationMode.wrappedValue.isPresented{
                    currentProfilePhoto = Image(uiImage: selectedUIImage)
                    self.presentationMode.wrappedValue.dismiss()
                }
                
                print("saved!")
            }
            
            // press back button here
            Spacer()
        }
        
        
    }
    
    var nav: some View{
                    // Nav
                    HStack {
                        Text("Cancel").onTapGesture {
                            print("Cancel")
                        }
                        Spacer()
                        Text("Edit Profile")
                            .bold()
                        Spacer()
                        Text("Done")
                            .bold()
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
        
                    }.padding(12)
    }
}

func UIImageToDataIO(image: UIImage, compressionRatio: CGFloat, orientation: Int = 1) -> Data? {
    return autoreleasepool(invoking: { () -> Data in
        let data = NSMutableData()
        let options: NSDictionary = [
            kCGImagePropertyOrientation: orientation,
            kCGImagePropertyHasAlpha: true,
            kCGImageDestinationLossyCompressionQuality: compressionRatio
        ]
        
        let imageDestinationRef = CGImageDestinationCreateWithData(data as CFMutableData, kUTTypeJPEG, 1, nil)!
        CGImageDestinationAddImage(imageDestinationRef, image.cgImage!, options)
        CGImageDestinationFinalize(imageDestinationRef)
        return data as Data
    })
}

func updateProfileHeader(uiImage: UIImage, name: String, username: String, website: String, bio: String){
    let query = PFQuery(className:"ProfileHeader")
    
    query.getObjectInBackground(withId: "s2Hudf19ux") { (profileHeader: PFObject?, error: Error?) in
        if let error = error {
            print(error.localizedDescription)
        } else if let profileHeader = profileHeader {
            
            
            // handle profile photo
            
            let image:UIImage? = uiImage
            
            // change photo in ui
            
            
            if let uiImageWithData = image {
                
                // Gets image DATA
//                let imagedata = uiImageWithData.pngData()
                let imagedata = UIImageToDataIO(image: uiImageWithData, compressionRatio: 1)
                
                
                // Need to grab the data from the uiImage
                // Now we need to set the image data to a key of the PFObject
                let file = PFFileObject(name: "veryimage2", data: imagedata!)
                
                profileHeader["profile_photo"] = file
                print("success")
            }
            
            profileHeader["name"] = name
            profileHeader["username"] = username
            profileHeader["website"] = website
            profileHeader["bio"] = bio
            profileHeader.saveInBackground()
        }
    }
    
}

struct ImageSelectorView: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    @Binding var selectedUIImage: UIImage
    @Binding var profilePhoto: Image?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageSelectorView>) ->
        UIViewController {
            let controller = UIImagePickerController()
            controller.delegate = context.coordinator
            return controller
    }
    
    // Creating the coordinator
    func makeCoordinator() -> ImageSelectorView.Coordinator {
        return Coordinator(parent: self)
    }
    
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate,
                       UINavigationControllerDelegate{
        
        let parent: ImageSelectorView
        init(parent: ImageSelectorView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImageFromSelector = info[.originalImage] as? UIImage {
                
                self.parent.selectedUIImage = selectedImageFromSelector
                self.parent.profilePhoto = Image(uiImage: selectedImageFromSelector)
            }
            self.parent.isPresented = false
        }
        
    }
    
    func updateUIViewController(_ uiViewController: ImageSelectorView.UIViewControllerType, context: UIViewControllerRepresentableContext<ImageSelectorView>) {
        
    }
}

struct DummyView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<DummyView>) -> UIButton {
        let button = UIButton()
        button.setTitle("DUMMY", for: .normal)
        button.backgroundColor = .red
        return button
    }
    
    func updateUIView(_ uiView: DummyView.UIViewType, context:
                        UIViewRepresentableContext<DummyView>) {
        
    }
}

struct EditProfile_Previews: PreviewProvider {
    
    @State static var cPP: Image?
    
    static var previews: some View {
        EditProfile(currentProfilePhoto: $cPP, nameFieldText: .constant(""), usernameFieldText:.constant(""), websiteFieldText: .constant(""), bioFieldText: .constant(""))
    }
}
