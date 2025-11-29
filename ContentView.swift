import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            SongView()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Songs")
                }
            TodofukenView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Todofuken")
                }
        }
    }
}





#Preview {
    ContentView()
}
