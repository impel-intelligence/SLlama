import XCTest
@testable import SLlama

final class SLlamaTests: XCTestCase {
    
//    let template: String = """
//    <|system|>
//    \(PromptProcessor.SYSTEM_MESSAGE_INSERT)
//    </s>
//    <|user|>
//    \(PromptProcessor.USER_MESSAGE_INSERT)
//    </s>
//    <|assistant|>
//
//    """
    
    struct temp: Encodable {
        var embeddings: [Double]
    }
    
    func testEmbeddings() async throws {
        let output = URL(string: "/Users/taylorlineman/Developer/Impel/VectorDB/output/")!
        let url = URL(string: "/Users/taylorlineman/Developer/Impel/VectorDB/raw.txt")!
        let fileContents = try String(contentsOf: url)
        let articles = fileContents.split(separator: "\n")
        print("\(articles.count) Articles To Embed")
        
        let client = Client(baseURLString: "http://127.0.0.1:8080")

        for article in articles {
            let split = article.split(separator: " ||| ")
            let title = String(split[0])
            let content = String(split[1])
            print("Embedding \(title), length: \(content.count)")
            
            let settings: EmbeddingSettings = .init(content: content)
            let request = LlamaRequests.embedding(settings)
            
            let results = try await client.run(request)
            let tmp = temp(embeddings: results.embedding)
            let data = try JSONEncoder().encode(tmp)
            try data.write(to: output.appendingPathComponent(title, conformingTo: .folder))
        }
    }

//    func testCompletionEndpoint() async throws {
//        let client = Client(baseURLString: "http://127.0.0.1:8080")
//
//        let preparedPrompt = PromptProcessor.prepareTemplate(template: template, systemPrompt: "A chat between a curious human and an artificial intelligence assistant. The assistant gives helpful, detailed, and polite answers to the human's questions.", userPrompt: "Hello Assistant")
//        let settings: CompletionSettings = .init(prompt: preparedPrompt, temperature: 0.7, n_predict: 256)
//
//        let request = LlamaRequests.completion(settings)
//
//        _ = try await client.run(request)
//    }
//
//    func testCompletionStreaming() async throws {
//        let client = Client(baseURLString: "http://127.0.0.1:24445")
//        
//        let preparedPrompt = PromptProcessor.prepareTemplate(template: template, systemPrompt: "A chat between a curious human and an artificial intelligence assistant. The assistant gives helpful, detailed, and polite answers to the human's questions.", userPrompt: "Hello Assistant")
//        
//        let settings: CompletionSettings = .init(prompt: preparedPrompt, temperature: 0.7, n_predict: 256, stream: true)
//        
//        let request = LlamaRequests.completion(settings)
//        
//        let clientStream = try client.stream(request)
//        
//        clientStream.delegate = self
//        
//        clientStream.resumeStream()
//        
//        while clientStream.status != .finished {
//
//        }
//    }
}

extension SLlamaTests: ClientStreamDelegate {
    func didReceiveModel<Model>(model: Model) where Model : Codable {
        guard let model = model as? CompletionResult else { return }
        print(model.content, terminator: "")
    }
    
    func didFinish(error: Error?) {
        if let error {
            print("Finished with error: \(error)")
        } else {
            print("Finished with no error")
        }
    }
}
