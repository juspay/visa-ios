
import SwiftUI
import SUINavigation

struct LaunchPageView: View {
    @State private var navigateToHome = false
    @State private var isHomeActive = true
    
    var body: some View {
        NavigationStorageView {
            VStack {
                NavigationLink(
                    destination: ExperienceHomeView(
                        encryptPayLoadMainapp: encryptedPayload,
                        isActive: $isHomeActive,
                        onFinish: {
                            print("🔵 LaunchPageView - Home Finished callback triggered")
                            print("Home Finished")
                            // Handle main app exit logic here
                            handleAppExit()
                        }
                    ),
                    isActive: $navigateToHome
                ){
                    Text("Start Experience")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("MainAppHomeFinished"))) { _ in
                print("🔵 LaunchPageView received HomeFinished notification from wrapper")
                print("Home Finished")
                handleAppExit()
            }
        }
    }
    
    private func handleAppExit() {
        print("🔵 LaunchPageView handling app exit")
        // Post notification to parent app or handle exit logic
        NotificationCenter.default.post(name: NSNotification.Name("VisaActivityFlowExit"), object: nil)
    }
}
