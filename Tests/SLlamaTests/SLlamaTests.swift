import XCTest
@testable import SLlama

final class SLlamaTests: XCTestCase {
    
    func testCompletionEndpoint() async throws {
        let client = Client(baseURLString: "http://127.0.0.1:8080")
        
        let settings: CompletionSettings = .init(prompt: "Hi")
        
        let request = LlamaRequests.completion(settings)
        
        let response = try await client.run(request)
    }
}
