import Testing
@testable import LumoKit

@Test func coreVersionComesFromRust() {
    #expect(CoreInfo.version == "0.1.0")
}
