import SwiftUI
import CoreData

struct NotificationLogView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \NotificationLog.createdAt, ascending: false)],
        animation: .default
    )
    private var logs: FetchedResults<NotificationLog>

    var body: some View {
        NavigationView {
            Group {
                if logs.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()

                        Image(systemName: "bell.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.orange)

                        Text("알림 기록이 없어요")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text("유통기한 임박 재료가 생기면 여기에 기록돼요.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)

                        Spacer()
                    }
                    .padding()
                } else {
                    List {
                        ForEach(logs) { log in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(log.message ?? "알림 내용 없음")
                                    .font(.headline)

                                if let createdAt = log.createdAt {
                                    Text(createdAt.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteLogs)
                    }
                }
            }
            .navigationTitle("알림 기록")
        }
    }
    
    private func deleteLogs(offsets: IndexSet) {
        withAnimation {
            offsets.map { logs[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                print("알림 기록 삭제 실패: \(error.localizedDescription)")
            }
        }
    }
}
