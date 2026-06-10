import SwiftUI
import CoreData

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteRecipe.createdAt, ascending: false)],
        animation: .default
    )
    private var favorites: FetchedResults<FavoriteRecipe>

    var body: some View {
        NavigationView {
            Group {
                if favorites.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()

                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.pink)

                        Text("저장된 레시피가 없어요")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text("마음에 드는 레시피를 저장해보세요.")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Spacer()
                    }
                    .padding()
                } else {
                    List {
                        ForEach(favorites) { favorite in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(favorite.title ?? "이름 없음")
                                    .font(.headline)

                                if let createdAt = favorite.createdAt {
                                    Text(createdAt.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteFavorites)
                    }
                }
            }
            .navigationTitle("즐겨찾기")
        }
    }
    
    private func deleteFavorites(offsets: IndexSet) {
        withAnimation {
            offsets.map { favorites[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                print("즐겨찾기 삭제 실패: \(error.localizedDescription)")
            }
        }
    }
}
