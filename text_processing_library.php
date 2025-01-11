<?php
class TextProcessor {
    /**
     * Clean and normalize text
     * @param string $text Input text
     * @return string Cleaned text
     */
    public static function cleanText($text) {
        // Remove excessive whitespace
        $text = preg_replace('/\s+/', ' ', $text);
        
        // Normalize punctuation
        $text = self::normalizePunctuation($text);
        
        // Remove invalid characters
        $text = preg_replace('/[^\p{L}\p{N}\p{P}\s]/u', '', $text);
        
        return trim($text);
    }

    /**
     * Normalize punctuation
     * @param string $text Input text
     * @return string Text with normalized punctuation
     */
    private static function normalizePunctuation($text) {
        // Replace multiple punctuation with single instance
        $text = preg_replace('/([.,!?])\1+/', '$1', $text);
        
        // Ensure space after punctuation
        $text = preg_replace('/([.,!?])(\S)/', '$1 $2', $text);
        
        return $text;
    }

    /**
     * Extract key sentences from text
     * @param string $text Input text
     * @param int $count Number of sentences to extract
     * @return array Key sentences
     */
    public static function extractKeySentences($text, $count = 3) {
        // Split into sentences
        $sentences = preg_split('/(?<=[.!?])\s+/', $text, -1, PREG_SPLIT_NO_EMPTY);
        
        // Score sentences based on various factors
        $scoredSentences = array_map(function($sentence) {
            return [
                'text' => $sentence,
                'score' => self::scoreSentence($sentence)
            ];
        }, $sentences);
        
        // Sort by score in descending order
        usort($scoredSentences, function($a, $b) {
            return $b['score'] <=> $a['score'];
        });
        
        // Return top N sentences
        return array_map(function($item) {
            return $item['text'];
        }, array_slice($scoredSentences, 0, $count));
    }

    /**
     * Score a sentence based on various linguistic features
     * @param string $sentence Input sentence
     * @return float Sentence score
     */
    private static function scoreSentence($sentence) {
        $score = 0;
        
        // Length consideration (prefer medium-length sentences)
        $wordCount = str_word_count($sentence);
        $score += min(1, abs(15 - $wordCount) / 10);
        
        // Presence of significant words
        $significantWords = [
            'new', 'important', 'significant', 'revolutionary', 
            'breakthrough', 'critical', 'emerging'
        ];
        
        foreach ($significantWords as $word) {
            if (stripos($sentence, $word) !== false) {
                $score += 0.5;
            }
        }
        
        // Capitalization of proper nouns
        preg_match_all('/\b[A-Z][a-z]+\b/', $sentence, $matches);
        $score += count($matches[0]) * 0.2;
        
        return $score;
    }

    /**
     * Generate a summary of text
     * @param string $text Input text
     * @param int $maxLength Maximum summary length
     * @return string Generated summary
     */
    public static function generateSummary($text, $maxLength = 250) {
        $sentences = self::extractKeySentences($text, 2);
        $summary = implode(' ', $sentences);
        
        // Truncate to max length
        return mb_substr($summary, 0, $maxLength) . 
               (mb_strlen($summary) > $maxLength ? '...' : '');
    }

    /**
     * Generate a human-like paragraph from extracted sentences
     * @param array $sentences Input sentences
     * @return string Generated paragraph
     */
    public static function generateHumanParagraph($sentences) {
        // Connective phrases to make text flow
        $connectivePhrases = [
            'Moreover, ', 'Furthermore, ', 'In addition, ', 
            'Notably, ', 'Importantly, ', 'Consequently, '
        ];
        
        $paragraph = '';
        foreach ($sentences as $index => $sentence) {
            // Add connective phrase for sentences after the first
            if ($index > 0) {
                $paragraph .= $connectivePhrases[array_rand($connectivePhrases)];
            }
            
            $paragraph .= $sentence . ' ';
        }
        
        return trim($paragraph);
    }
}

// Utility trait for more advanced text analysis
trait TextAnalysisTrait {
    /**
     * Analyze text complexity
     * @param string $text Input text
     * @return array Complexity metrics
     */
    protected function analyzeTextComplexity($text) {
        $wordCount = str_word_count($text);
        $sentenceCount = count(preg_split('/[.!?]/', $text));
        
        // Flesch-Kincaid readability
        $syllableCount = $this->countSyllables($text);
        $readabilityScore = 206.835 - (1.015 * ($wordCount / $sentenceCount)) - 
                            (84.6 * ($syllableCount / $wordCount));
        
        return [
            'word_count' => $wordCount,
            'sentence_count' => $sentenceCount,
            'readability_score' => $readabilityScore,
            'complexity_level' => $this->determineComplexityLevel($readabilityScore)
        ];
    }

    /**
     * Count syllables in text
     * @param string $text Input text
     * @return int Number of syllables
     */
    private function countSyllables($text) {
        $words = str_word_count(strtolower($text), 1);
        $syllableCount = 0;
        
        foreach ($words as $word) {
            $syllableCount += $this->countWordSyllables($word);
        }
        
        return $syllableCount;
    }

    /**
     * Count syllables in a word
     * @param string $word Input word
     * @return int Number of syllables
     */
    private function countWordSyllables($word) {
        // Basic syllable counting algorithm
        $word = preg_replace('/(?:[^laeiouy]es|[^laeiouy]ed|[^laeiouy]e)$/', '', $word);
        $word = preg_replace('/^y/', '', $word);
        
        return max(1, count(preg_replace('/[^aeiouy]+/', '', $word)));
    }

    /**
     * Determine text complexity level
     * @param float $readabilityScore Flesch-Kincaid score
     * @return string Complexity level
     */
    private function determineComplexityLevel($readabilityScore) {
        if ($readabilityScore > 90) return 'very_easy';
        if ($readabilityScore > 70) return 'easy';
        if ($readabilityScore > 50) return 'medium';
        if ($readabilityScore > 30) return 'difficult';
        return 'very_difficult';
    }
}