
import SDWebImageSwiftUI
import SwiftUI

struct ContentView: View {

    @State var useWebImage = false
    @State var isSheetShowing = false
    @State var selectedIndex = 0

    private let images = [
        "https://images.unsplash.com/photo-1478368499690-1316c519df07?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2706&q=80",
        "https://images.unsplash.com/photo-1507154258-c81e5cca5931?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2600&q=80",
        "https://images.unsplash.com/photo-1513310719763-d43889d6fc95?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2734&q=80",
        "https://images.unsplash.com/photo-1585766765962-28aa4c7d719c?ixlib=rb-1.2.1&auto=format&fit=crop&w=2734&q=80",
        "https://images.unsplash.com/photo-1485970671356-ff9156bd4a98?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2734&q=80",
        "https://images.unsplash.com/photo-1585607666104-4d5b201d6d8c?ixlib=rb-1.2.1&auto=format&fit=crop&w=2700&q=80",
        "https://images.unsplash.com/photo-1577702066866-6c8897d06443?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2177&q=80",
        "https://images.unsplash.com/photo-1513809491260-0e192158ae44?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2736&q=80",
        "https://images.unsplash.com/photo-1582092723055-ad941d1db0d4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2700&q=80",
        "https://images.unsplash.com/photo-1478264635837-66efba4b74ba?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjF9&auto=format&fit=crop&w=2682&q=80"
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 40) {

                    Text(useWebImage ? "WebImage is used." : "SwiftUI Image is used")
                        .font(.system(size: 18))
                        .bold()
                        .kerning(0.5)
                        .padding(.top, 20)

                    Toggle(isOn: $useWebImage) {
                        Text("Use WebImage")
                            .font(.system(size: 18))
                            .bold()
                            .kerning(0.5)
                            .padding(.top, 20)
                    }

                    ForEach(0..<images.count) { index in
                        Button(action: {
                            self.selectedIndex = index
                            self.isSheetShowing.toggle()
                        }) {
                            Card(imageUrl: self.images[index], index: index, useWebImage: self.$useWebImage)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                .sheet(isPresented: self.$isSheetShowing) {
                    DestinationView(imageUrl: self.images[self.selectedIndex], index: self.selectedIndex, useWebImage: self.$useWebImage)
                }
            }
            .navigationBarTitle("Images")
        }
    }
}

struct Card: View {

    let imageUrl: String
    let index: Int
    @Binding var useWebImage: Bool

    var body: some View {
        VStack {
            if useWebImage {
                WebImage(url: URL(string: imageUrl))
                    .resizable()
                    .indicator(.activity)
                    .animation(.easeInOut(duration: 0.5))
                    .transition(.fade)
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 250, maxHeight: 250, alignment: .center)
                    .cornerRadius(12)
                    .clipped()
            } else {
                Image("image\(index)")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 250, maxHeight: 250, alignment: .center)
                    .cornerRadius(12)
                    .clipped()
            }

            HStack {
                Text("Image #\(index + 1) (\(useWebImage ? "WebImage" : "SwiftUI Image"))")
                    .font(.system(size: 18))
                    .bold()
                    .kerning(0.5)

                Spacer()
            }
        }
        .padding(2)
        .border(Color(.systemRed), width: 2)
    }
}

struct DestinationView: View {

    @Environment(\.presentationMode) var presentationMode

    let imageUrl: String
    let index: Int
    @Binding var useWebImage: Bool

    var body: some View {
        NavigationView {
            VStack {
                if useWebImage {
                    WebImage(url: URL(string: imageUrl))
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade)
                        .scaledToFit()
                } else {
                    Image("image\(index)")
                        .resizable()
                        .scaledToFit()
                }
            }
            .navigationBarTitle(Text("Image #\(index + 1)"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11 Pro")
    }
}
