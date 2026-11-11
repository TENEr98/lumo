import LumoKit
import SwiftUI

@main
struct LumoMacApp: App {
    var body: some Scene {
        WindowGroup {
            Text("Lumo · ядро \(CoreInfo.version)")
                .padding(32)
        }
    }
}
