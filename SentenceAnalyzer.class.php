<?php
class SentenceAnalyzer {
    private $db;
    
    public function __construct($db) {
        $this->db = $db;
    }
    
    public function analyzeSentence($sentence) {
        // Clean and split the sentence
        $words = $this->tokenizeSentence($sentence);
        
        // Store word pairs and their relationships
        $this->processWordPairs($words);
        
        // Identify common patterns
        $pattern = $this->identifyPattern($words);
        
        // Store sentence structure
        $this->storeSentenceStructure($pattern);
        
        return [
            'words' => $words,
            'pattern' => $pattern
        ];
    }
    
    private function tokenizeSentence($sentence) {
        // Clean the sentence
        $sentence = strtolower(trim($sentence));
        
        // Split into words
        return array_filter(
            explode(' ', 
                preg_replace('/[^a-z0-9\s]/i', '', $sentence)
            )
        );
    }
    
    private function processWordPairs($words) {
        for ($i = 0; $i < count($words) - 1; $i++) {
            $currentWord = $words[$i];
            $nextWord = $words[$i + 1];
            
            // Update word relationship in database
            $stmt = $this->db->prepare("
                INSERT INTO word (word, related_words, frequency)
                VALUES (?, JSON_ARRAY(?), 1)
                ON DUPLICATE KEY UPDATE
                related_words = JSON_ARRAY_APPEND(
                    COALESCE(related_words, JSON_ARRAY()),
                    '$',
                    ?
                ),
                frequency = frequency + 1
            ");
            
            $stmt->execute([$currentWord, $nextWord, $nextWord]);
        }
    }
    
    private function identifyPattern($words) {
        $pattern = [];
        
        foreach ($words as $word) {
            // Check if word is a common connector
            $stmt = $this->db->prepare("
                SELECT is_connector 
                FROM word 
                WHERE word = ? AND frequency > 5
            ");
            $stmt->execute([$word]);
            $isConnector = $stmt->fetchColumn();
            
            $pattern[] = [
                'word' => $word,
                'is_connector' => $isConnector
            ];
        }
        
        return $pattern;
    }
    
    private function storeSentenceStructure($pattern) {
        // Convert pattern to string representation
        $patternStr = json_encode($pattern);
        
        // Store in sentence_structures table
        $stmt = $this->db->prepare("
            INSERT INTO sentence_structures 
            (pattern, pattern_type) 
            VALUES (?, 'statement')
            ON DUPLICATE KEY UPDATE
            frequency = frequency + 1
        ");
        
        $stmt->execute([$patternStr]);
    }
    
    public function findCommonPatterns() {
        // Get most frequent patterns
        $stmt = $this->db->query("
            SELECT pattern, frequency 
            FROM sentence_structures 
            WHERE frequency > 3 
            ORDER BY frequency DESC 
            LIMIT 10
        ");
        
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    
    public function getWordConnections($word) {
        // Get related words for a given word
        $stmt = $this->db->prepare("
            SELECT related_words, frequency 
            FROM word 
            WHERE word = ?
        ");
        
        $stmt->execute([$word]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
}
?>