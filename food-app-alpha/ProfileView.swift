//
//  ProfileView.swift
//  food-app-alpha
//
//

import SwiftUI
import Parse

struct ProfileView: View
{
    
    let posts = ["IMG1", "IMG2", "IMG3", "IMG4", "IMG5", "IMG6", "IMG7", "IMG8", "IMG9", "IMG10", "IMG11", "IMG12", "IMG13", "IMG14", "IMG15", "IMG10-1", "IMG11-1", "IMG12-1", "IMG13-1", "IMG14-1", "IMG15-1"]

    @State var profilePicture = "profile-photo-1"
    @State var profileImage: Image?
    @State var isShowingImagePicker = false
    @State var imageData = Data.init()
    @State var userName = "username5492"
    @State var name = "no name"
    @State var website = "mathly.io"
    @State var postCount = 0
    @State var bio = "Bio"
    @State var followers = 1742
    @State var following = 1
    @State var postsInCloud = []
    
    @State var isLinkActive = false
    
    @State private var editingProfile = false


    var body: some View
    {
        NavigationView {
            ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, content:
            {
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10, content: {
                    Spacer().frame(width: UIScreen.main.bounds.width, height: 10)
                    // Profile Header
                    HStack(alignment: .center, spacing: 49.0, content:
                        {
                            // Profile picture
                            VStack
                            {
                                profileImage?
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 110.0, height:110.0)
                                    .onTapGesture {
                                        self.isShowingImagePicker.toggle()

                                    }
                                
                                
                                Text(name).bold()


                            }
                            
//                             Profile info
                            HStack(alignment: .center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/15.0, content:
                                    {
                                        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                                            Text(String(postCount))
                                                .font(.system(size: 18))
                                                .fontWeight(.bold)
                                            Text("Posts")
                                                .font(.system(size:15))
                                        })
                                        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content:
                                        {
                                            Text(String(followers))
                                                .font(.system(size: 18))
                                                .fontWeight(.bold)
                                            Text("Followers")
                                                .font(.system(size:15))
                                        })
                                        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content:
                                        {
                                            Text(String(following))
                                                .font(.system(size: 18))
                                                .fontWeight(.bold)
                                            Text("Following")
                                                .font(.system(size:15))
                                        })
                                        
                                        
                                    })
                            
                        })
        
                    
                        
                    
                        
                    
                    // Bio Here
                    
                    HStack{
                        Text(bio)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .frame(width: UIScreen.main.bounds.width * 0.80)
                            .padding(2)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }
                    NavigationLink(destination: EditProfile(currentProfilePhoto: $profileImage, nameFieldText: $name, usernameFieldText: $userName, websiteFieldText: $website, bioFieldText: $bio)){
                        Text("Edit Profile").foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))).frame(width: (UIScreen.main.bounds.width/1.1), height: 35).border(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)),width: 1).cornerRadius(3)
                    }

                // Photo content


                    LazyVGrid(
                        columns:
                        [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 3)
                    {
                        ForEach(posts, id: \.self)
                        {
                            post in Image(post)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
                                .clipShape(Rectangle())

                        }
                    }
                    
                })
                
            })
                .navigationBarTitle(userName, displayMode: .inline)
        }.onAppear(perform: {
            getProfileHeader()
//            loadImage()
        })
        
        
    }



    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView()
        }
    }
        
    func getProfileHeader() {
        let query = PFQuery(className:"ProfileHeader")
        query.getObjectInBackground(withId: "s2Hudf19ux") { (profileheader, error) in
            if error == nil {
                // Success!
                if let ph = profileheader {

                    // then we in fact have a profileheader object
                    let file = ph["profile_photo"] as! PFFileObject
                    file.getDataInBackground(block: { (data, e) -> Void in
                        if e == nil {
                            
                            if let imagedata = data {
                                imageData = imagedata
                                guard let uiImage = UIImage(data: imageData) else {
                                    return
                                }
                                
                                profileImage = Image(uiImage: uiImage)
                            }
                        }

                })
                
                
                name = profileheader?.object(forKey: "name") as! String
                userName = profileheader?.object(forKey: "username") as! String
                website = profileheader?.object(forKey: "website") as! String
                bio = profileheader?.object(forKey: "bio") as! String
                postCount = profileheader?.object(forKey: "post_count") as! Int
            } else {
                // Fail!
            }
        }
    }
    
    }
    
    func loadImage() {
        
        
        
        
    }
    
    
}
