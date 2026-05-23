import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "refrigerator")
                    Text("냉장고")
                }

            RecipeListView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("레시피")
                }

            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("즐겨찾기")
                }
        }
    }
}
