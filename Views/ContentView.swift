import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {

            HomeView()
                .tabItem {
                    Label("냉장고", systemImage: "refrigerator")
                }

            RecipeListView()
                .tabItem {
                    Label("레시피", systemImage: "fork.knife")
                }

            FavoritesView()
                .tabItem {
                    Label("즐겨찾기", systemImage: "heart")
                }

            NotificationLogView()
                .tabItem {
                    Label("알림", systemImage: "bell")
                }
        }
    }
}
