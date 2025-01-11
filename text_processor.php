<?php
// text_processor.php

class TextProcessor {
    public static function cleanText($text) {
        // Remove HTML tags
        $text = strip_tags($text);
        // Remove extra whitespace
        $text = preg_replace('/\s+/', ' ', $text);
        // Remove special characters
        $text = preg_replace('/[^\p{L}\p{N}\s\.\,\!\?\-\'\"]/u', '', $text);
        return trim($text);
    }

    public static function extractKeySentences($text, $numSentences = 5) {
        // Split text into sentences
        $sentences = preg_split('/(?<=[.!?])\s+/', $text);
        
        // Score sentences based on length and word complexity
        $scoredSentences = [];
        foreach ($sentences as $sentence) {
            $score = self::calculateSentenceScore($sentence);
            $scoredSentences[$sentence] = $score;
        }
        
        // Sort by score and return top N sentences
        arsort($scoredSentences);
        return array_slice(array_keys($scoredSentences), 0, $numSentences);
    }

    public static function generateSummary($text, $maxLength = 300) {
        $cleanText = self::cleanText($text);
        $keySentences = self::extractKeySentences($cleanText, 3);
        
        $summary = implode(' ', $keySentences);
        if (strlen($summary) > $maxLength) {
            $summary = substr($summary, 0, $maxLength - 3) . '...';
        }
        
        return $summary;
    }

    private static function calculateSentenceScore($sentence) {
        $wordCount = str_word_count($sentence);
        $avgWordLength = strlen($sentence) / ($wordCount ?: 1);
        
        // Prefer sentences between 10-20 words with average word length 5-8 characters
        $lengthScore = min(1, $wordCount / 20) * max(0, 1 - abs($avgWordLength - 6.5) / 6.5);
        
        return $lengthScore;
    }

    public static function analyzeTextComplexity($text) {
        $words = str_word_count($text, 1);
        $sentences = preg_split('/(?<=[.!?])\s+/', $text);
        $syllables = self::countSyllables($text);
        
        // Calculate Flesch-Kincaid Grade Level
        $avgSentenceLength = count($words) / (count($sentences) ?: 1);
        $avgSyllablesPerWord = $syllables / (count($words) ?: 1);
        $gradeLevel = 0.39 * $avgSentenceLength + 11.8 * $avgSyllablesPerWord - 15.59;
        
        return [
            'grade_level' => round($gradeLevel, 1),
            'complexity_level' => self::mapGradeLevelToComplexity($gradeLevel)
        ];
    }

    private static function countSyllables($text) {
        $words = str_word_count($text, 1);
        $syllableCount = 0;
        
        foreach ($words as $word) {
            $word = strtolower($word);
            $word = preg_replace('/(?:[^laeiouy]es|ed|[^laeiouy]e)$/', '', $word);
            $word = preg_replace('/^y/', '', $word);
            $syllableCount += max(1, preg_match_all('/[aeiouy]{1,2}/', $word));
        }
        
        return $syllableCount;
    }

    private static function mapGradeLevelToComplexity($gradeLevel) {
        if ($gradeLevel < 6) return 'very_easy';
        if ($gradeLevel < 8) return 'easy';
        if ($gradeLevel < 12) return 'medium';
        if ($gradeLevel < 14) return 'difficult';
        return 'very_difficult';
    }
}