
<?php
trait RSSProcessingTrait {
       /**
     * Advanced RSS feed fetching with multiple error handling mechanisms
     */
    private function fetchFeedTitles($feedUrl) {
        // Validate URL
        if (!filter_var($feedUrl, FILTER_VALIDATE_URL)) {
            error_log("Invalid RSS feed URL: {$feedUrl}");
            return [];
        }

        try {
            // Attempt to fetch content
            $rawXml = $this->fetchUrlContent($feedUrl);
            
            // Validate XML content
            if (empty($rawXml)) {
                error_log("Empty content received from RSS feed: {$feedUrl}");
                return [];
            }

            // Suppress XML parsing warnings
            libxml_use_internal_errors(true);
            $xml = simplexml_load_string($rawXml);
            
            // Check for XML parsing errors
            if ($xml === false) {
                $xmlErrors = libxml_get_errors();
                error_log("XML Parsing Errors for {$feedUrl}: " . 
                    implode(', ', array_map(function($error) {
                        return $error->message;
                    }, $xmlErrors))
                );
                libxml_clear_errors();
                return [];
            }
            
            $titles = [];
            
            // Support different RSS/Atom feed structures with enhanced detection
            if (isset($xml->channel->item)) {
                // Standard RSS
                foreach ($xml->channel->item as $item) {
                    $title = trim((string)$item->title);
                    if (!empty($title)) {
                        $titles[] = $title;
                    }
                }
            } elseif (isset($xml->entry)) {
                // Atom feed
                foreach ($xml->entry as $entry) {
                    $title = trim((string)$entry->title);
                    if (!empty($title)) {
                        $titles[] = $title;
                    }
                }
            } else {
                error_log("Unrecognized feed structure for URL: {$feedUrl}");
            }
            
            return $titles;
        } catch (Exception $e) {
            error_log("Comprehensive RSS feed fetch error for {$feedUrl}: " . $e->getMessage());
            return [];
        }
    }

    /**
     * Enhanced URL content fetching with additional security and error handling
     */
    private function fetchUrlContent($url) {
        // Validate URL
        if (!filter_var($url, FILTER_VALIDATE_URL)) {
            error_log("Invalid URL: {$url}");
            return '';
        }

        // Initialize cURL with enhanced security
        $ch = curl_init();
        
        // Set comprehensive cURL options
        $curlOptions = [
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_MAXREDIRS => 5,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_CONNECTTIMEOUT => 15,
            CURLOPT_SSL_VERIFYPEER => true,
            CURLOPT_SSL_VERIFYHOST => 2,
            CURLOPT_USERAGENT => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            CURLOPT_HTTPHEADER => [
                'Accept: application/rss+xml, application/atom+xml, text/xml',
                'Cache-Control: no-cache'
            ]
        ];

        curl_setopt_array($ch, $curlOptions);
        
        // Execute request
        $content = curl_exec($ch);
        
        // Comprehensive error handling
        if (curl_errno($ch)) {
            $errorMessage = curl_error($ch);
            $errorCode = curl_errno($ch);
            
            error_log("cURL Error [{$errorCode}]: {$errorMessage} for URL: {$url}");
            
            // Additional error categorization
            switch ($errorCode) {
                case CURLE_COULDNT_RESOLVE_HOST:
                    error_log("DNS resolution failed for {$url}");
                    break;
                case CURLE_OPERATION_TIMEOUTED:
                    error_log("Connection timeout for {$url}");
                    break;
                case CURLE_SSL_CONNECT_ERROR:
                    error_log("SSL connection error for {$url}");
                    break;
            }
            
            $content = '';
        }
        
        // Close cURL resource
        curl_close($ch);
        
        return $content;
    }

    /**
     * Advanced word frequency analysis with enhanced filtering
     */
    private function analyzeWordFrequency($titles) {
        // Extended list of stop words
        $stopWords = array_merge([
            'the', 'and', 'or', 'but', 'in', 'on', 
            'at', 'to', 'for', 'of', 'a', 'an'
        ], [
            'is', 'are', 'was', 'were', 'will', 'be', 'been',
            'has', 'have', 'had', 'do', 'does', 'did',
            'this', 'that', 'these', 'those', 'it', 'its'
        ]);
        
        $allWords = [];
        
        foreach ($titles as $title) {
            // More comprehensive text cleaning
            $cleanTitle = preg_replace([
                '/[^\p{L}\s]/u',  // Remove non-letter characters
                '/\s+/'           // Reduce multiple spaces
            ], [
                '', 
                ' '
            ], strtolower($title));
            
            $words = array_filter(explode(' ', $cleanTitle), function($word) use ($stopWords) {
                // More sophisticated word filtering
                return strlen($word) > 2 && 
                    !in_array($word, $stopWords) &&
                    !is_numeric($word);
            });
            
            foreach ($words as $word) {
                $allWords[$word] = ($allWords[$word] ?? 0) + 1;
            }
        }
        
        // Sort by frequency, descending
        arsort($allWords);
        
        // Return top 20 words
        return array_slice($allWords, 0, 20, true);
    }

    /**
     * Enhanced RSS content processing with more detailed analysis
     */
    private function processRSSContent($rawContent) {
        // More comprehensive text cleaning
        $cleanedContent = preg_replace([
            '/[^\w\s\.\,\!\?\-]/',  // Remove special characters
            '/\s+/'                  // Reduce multiple spaces
        ], [
            '', 
            ' '
        ], $rawContent);
        
        // Advanced sentence splitting
        $sentences = preg_split(
            '/(?<=[.!?])\s+/', 
            $cleanedContent, 
            -1, 
            PREG_SPLIT_NO_EMPTY
        );
        
        // Comprehensive content processing
        $processedContent = [
            'raw_text' => $cleanedContent,
            'sentences' => $sentences,
            'word_frequency' => $this->analyzeWordFrequency($sentences),
            'key_concepts' => $this->extractKeyConcepts($sentences),
            'sentence_count' => count($sentences),
            'word_count' => str_word_count($cleanedContent)
        ];
        
        return $processedContent;
    }
private function extractTextFromRSS($rawXml) {
    // Suppress XML parsing warnings
    libxml_use_internal_errors(true);
    
    // Attempt to parse XML
    $xml = simplexml_load_string($rawXml);
    
    // Check for XML parsing errors
    if ($xml === false) {
        $errors = libxml_get_errors();
        libxml_clear_errors();
        
        error_log("XML Parsing Errors: " . implode(', ', array_map(function($error) {
            return $error->message;
        }, $errors)));
        
        return '';
    }
    
    $content = [];
    
    // Handle different RSS/Atom feed structures
    if (isset($xml->channel->item)) {
        // Standard RSS
        foreach ($xml->channel->item as $item) {
            $itemContent = [];
            
            // Extract various text fields
            if (!empty($item->title)) {
                $itemContent[] = (string)$item->title;
            }
            if (!empty($item->description)) {
                $itemContent[] = (string)$item->description;
            }
            if (!empty($item->{'content:encoded'})) {
                $itemContent[] = (string)$item->{'content:encoded'};
            }
            
            $content[] = implode(' ', $itemContent);
        }
    } elseif (isset($xml->entry)) {
        // Atom feed
        foreach ($xml->entry as $entry) {
            $entryContent = [];
            
            // Extract various text fields
            if (!empty($entry->title)) {
                $entryContent[] = (string)$entry->title;
            }
            if (!empty($entry->content)) {
                $entryContent[] = (string)$entry->content;
            }
            if (!empty($entry->summary)) {
                $entryContent[] = (string)$entry->summary;
            }
            
            $content[] = implode(' ', $entryContent);
        }
    } else {
        error_log("Unrecognized feed structure in XML");
        return '';
    }
    
    // Combine all content and clean it up
    $combinedContent = implode(' ', $content);
    
    // Remove excessive whitespace
    $cleanedContent = preg_replace('/\s+/', ' ', $combinedContent);
    
    return trim($cleanedContent);
}

}



