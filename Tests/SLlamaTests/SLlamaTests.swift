import XCTest
@testable import SLlama

final class SLlamaTests: XCTestCase {
    
    let template: String = """
    <|system|>
    \(PromptProcessor.SYSTEM_MESSAGE_INSERT)
    </s>
    <|user|>
    \(PromptProcessor.USER_MESSAGE_INSERT)
    </s>
    <|assistant|>

    """
    
    func testCompletionEndpoint() async throws {
        let client = Client(baseURLString: "http://127.0.0.1:8080")

        let preparedPrompt = PromptProcessor.prepareTemplate(template: template, systemPrompt: "A chat between a curious human and an artificial intelligence assistant. The assistant gives helpful, detailed, and polite answers to the human's questions.", userPrompt: "Hello Assistant")
        let settings: CompletionSettings = .init(prompt: preparedPrompt, temperature: 0.7, n_predict: 256)

        let request = LlamaRequests.completion(settings)

        let response = try await client.run(request)

        print(response.content)
    }
    
    func testCompletionStreaming() async throws {
        let client = Client(baseURLString: "http://127.0.0.1:8080")
        
        let preparedPrompt = PromptProcessor.prepareTemplate(template: template, systemPrompt: "A chat between a curious human and an artificial intelligence assistant. The assistant gives helpful, detailed, and polite answers to the human's questions.", userPrompt: "Hello Assistant")
        let settings: CompletionSettings = .init(prompt: preparedPrompt, temperature: 0.7, n_predict: 256, stream: true)
        
        let request = LlamaRequests.completion(settings)
        
        let clientStream = try client.stream(request)
        
        clientStream.delegate = self
        
        clientStream.resumeStream()
        
        while clientStream.status != .finished {

        }
    }
}

extension SLlamaTests: ClientStreamDelegate {
    func didReceiveModel<Model>(model: Model) where Model : Codable {
        guard let model = model as? CompletionResult else { return }
        print(model.content)
    }
    
    func didFinish(error: Error?) {
        if let error {
            print("Finished with error: \(error)")
        } else {
            print("Finished with no error")
        }
    }
}
