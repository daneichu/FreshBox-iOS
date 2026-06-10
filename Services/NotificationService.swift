import Foundation
import UserNotifications

struct NotificationService {
    
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("알림 권한 요청 실패: \(error.localizedDescription)")
                return
            }
            
            print(granted ? "알림 권한 허용됨" : "알림 권한 거부됨")
        }
    }
    
    static func scheduleExpiryNotification(for ingredientName: String, dDay: Int) {
        let content = UNMutableNotificationContent()
        content.title = "유통기한 임박 재료가 있어요"
        content.body = "\(ingredientName)이(가) D-\(dDay)입니다. 오늘 레시피로 활용해보세요."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 등록 실패: \(error.localizedDescription)")
            } else {
                print("알림 등록 완료")
            }
        }
    }
}
