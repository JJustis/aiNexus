<?php
// ai_assist.php
require_once 'database_connection.php';

class AIAssistant {
    private $db;
    private $openaiApiKey;

    public function __construct(PDO $db) {
        $this->db = $db;
        $this->openaiApiKey = getenv('OPENAI_API_KEY') ?: null;
    }

    /**
     * Generate summary using AI
     */
    public function generateSummary($content) {
        $prompt = "Generate a concise summary of the following text, capturing its main points and key insights:\n\n" . $content;
        return $this->callOpenAI($prompt);
    }

    /**
     * Extract keywords from content
     */
    public function extractKeywords($content) {
        $prompt = "Extract the 5-7 most important keywords or key phrases from the following text:\n\n" . $content;
        $keywords = $this->callOpenAI($prompt);
        return explode(',', $keywords);
    }

    /**
     * Generate editorial suggestions
     */
    public function generateEditorialSuggestions($content) {
        $prompt = "Provide 3-4 editorial suggestions to improve the following text, focusing on clarity, structure, and engagement:\n\n" . $content;
        $suggestions = $this->callOpenAI($prompt);
        return explode("\n", $suggestions);
    }

    /**
     * Call OpenAI API (simplified mock implementation)
     */
    private function callOpenAI($prompt) {
        // In a real scenario, you'd make an actual API call to OpenAI
        if (!$this->openaiApiKey) {
            return $this->localAIGeneration($prompt);
        }

        try {
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, 'https://api.openai.com/v1/chat/completions');
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                'Content-Type: application/json',
                'Authorization: Bearer ' . $this->openaiApiKey
            ]);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
                'model' => 'gpt-3.5-turbo',
                'messages' => [
                    ['role' => 'system', 'content' => 'You are a helpful AI assistant.'],
                    ['role' => 'user', 'content' => $prompt]
                ]
            ]));

            $response = curl_exec($ch);
            curl_close($ch);

            $responseData = json_decode($response, true);
            return $responseData['choices'][0]['message']['content'] ?? '';
        } catch (Exception $e) {
            error_log('OpenAI API Error: ' . $e->getMessage());
            return $this->localAIGeneration($prompt);
        }
    }

    /**
     * Local fallback AI generation
     */
    private function localAIGeneration($prompt) {
        // Basic AI-like generation
        $templates = [
            'summary' => [
                "In this article, the key points revolve around {key_theme}.",
                "The text explores {key_theme} with insights into its broader implications."
            ],
            'keywords' => ['technology', 'innovation', 'trends', 'impact', 'future'],
            'suggestions' => [
                "Consider adding more specific examples to support your arguments.",
                "The structure could benefit from a clearer progression of ideas.",
                "Elaborate on the potential implications of the main points."
            ]
        ];

        // Simulate different AI responses based on prompt type
        if (stripos($prompt, 'summary') !== false) {
            $keyTheme = $templates['keywords'][array_rand($templates['keywords'])];
            return sprintf(
                $templates['summary'][array_rand($templates['summary'])], 
                $key_theme = $keyTheme
            );
        } elseif (stripos($prompt, 'keywords') !== false) {
            return implode(', ', array_slice($templates['keywords'], 0, 5));
        } elseif (stripos($prompt, 'suggestions') !== false) {
            return implode("\n", array_slice($templates['suggestions'], 0, 3));
        }

        return "AI assistance unavailable.";
    }
}

// Handle AI Assistance Requests
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    try {
        $db = getDbConnection();
        $aiAssistant = new AIAssistant($db);

        $response = [];
        switch ($input['action']) {
            case 'generate_summary':
                $response['summary'] = $aiAssistant->generateSummary($input['content']);
                break;
            case 'extract_keywords':
                $response['keywords'] = $aiAssistant->extractKeywords($input['content']);
                break;
            case 'editorial_suggestions':
                $response['suggestions'] = $aiAssistant->generateEditorialSuggestions($input['content']);
                break;
            default:
                throw new Exception("Invalid AI assistance action");
        }

        echo json_encode($response);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
    }
    exit;
}