import SwiftUI

struct FavoritesView: View {
    var body: some View {
        NavigationView {
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
            .navigationTitle("즐겨찾기")
        }
    }
}
