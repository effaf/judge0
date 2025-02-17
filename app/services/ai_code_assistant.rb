class AiCodeAssistant
    def initialize
      @client = OpenAI::Client.new(
        access_token: ENV['OPENAI_API_KEY'],
        request_timeout: 240
      )
    end
  
    def analyze_code(submission)
      prompt = generate_prompt(submission)
      
      response = @client.chat(
        parameters: {
          model: "gpt-4",  # or "gpt-3.5-turbo" for a more economical option
          messages: [
            { role: "system", content: "You are a helpful programming assistant. Analyze the code and provide feedback on improvements, potential bugs, and best practices." },
            { role: "user", content: prompt }
          ],
          temperature: 0.7
        }
      )
  
      response.dig("choices", 0, "message", "content")
    end
  
    private
  
    def generate_prompt(submission)
      <<~PROMPT
        Please analyze the following code submission:
  
        Language: #{submission.language}
        Code:
        #{submission.source_code}
  
        Please provide:
        1. Code quality analysis
        2. Potential improvements
        3. Any security concerns
        4. Best practices recommendations
      PROMPT
    end
  end