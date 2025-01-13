
<?php
// advanced_article_generator.php
require_once __DIR__ . '/rss_processing_trait.php';
require_once __DIR__ . '/rss_processor.php';
class AdvancedArticleGenerator {
    use RSSProcessingTrait;
    
    private $wordsDb;
    private $articlesDb;
    private $rssFeeds;

    public function __construct($wordsDb, $articlesDb) {
        $this->wordsDb = $wordsDb;
        $this->articlesDb = $articlesDb;
        $this->rssFeeds = $this->loadRSSFeeds();
    }

private function loadRSSFeeds() {
    return [
        'technology' => [
            'https://techcrunch.com/feed/',
            'https://www.wired.com/feed/',
            'https://www.theverge.com/rss/index.xml',
            'https://arstechnica.com/feed/',
            'https://www.cnet.com/rss/news/',
            'https://venturebeat.com/feed/',
            'https://techraptor.net/rss/articles'
        ],
        'science' => [
            'https://www.scientificamerican.com/article/feed/',
            'https://www.nasa.gov/rss/dyn/breaking_news.rss',
            'https://phys.org/rss-feed/',
            'https://www.newscientist.com/feed/home/',
            'https://www.nationalgeographic.com/science/article/rss',
            'https://www.sciencenews.org/feed'
        ],
        'business' => [
            'https://www.forbes.com/feeds/forbesfeeds.rss',
            'https://www.bloomberg.com/feeds/bbiz.rss',
            'https://www.wsj.com/news/business?mod=rsswn',
            'https://www.reuters.com/business/feed/',
            'https://www.entrepreneur.com/feed/'
        ],
        'world_news' => [
            'https://www.bbc.com/news/world/rss.xml',
            'https://www.aljazeera.com/xml/rss/all.xml',
            'https://www.npr.org/rss/rss.php?id=1004',
            'https://www.reuters.com/world/feed/'
        ],
        'entertainment' => [
            'https://www.hollywoodreporter.com/feed/',
            'https://variety.com/feed/',
            'https://ew.com/feed/',
            'https://www.billboard.com/feed/'
        ],
        'sports' => [
            'https://www.espn.com/espn/rss/news',
            'https://www.si.com/rss/si_topstories.rss',
            'https://bleacherreport.com/rss/index.html'
        ],
        'health' => [
            'https://www.health.com/feed',
            'https://www.medicalnewstoday.com/rss/main',
            'https://www.webmd.com/rss/featured_item.xml',
            'https://www.healthline.com/health/rss'
        ],
        'technology_reviews' => [
            'https://www.pcmag.com/rss/all',
            'https://www.gizmodo.com/rss',
            'https://www.engadget.com/rss.xml',
            'https://www.digitaltrends.com/rss.xml'
        ],
        'environment' => [
            'https://www.nationalgeographic.com/environment/article/rss',
            'https://www.eenews.net/rss/feed',
            'https://www.climatechangenews.com/feed/'
        ],
        'finance' => [
            'https://www.cnbc.com/id/100727362/device/rss/rss.html',
            'https://www.investors.com/feed/',
            'https://seekingalpha.com/feed.xml'
        ]
    ];
}

    public function generateArticle($type, $options = []) {
        switch ($type) {
            case 'term_article':
                return $this->generateTermArticle($options);
            
            case 'trending_article':
                return $this->generateTrendingArticle($options);
            
            case 'rss_synthesized_article':
                return $this->generateRSSSynthesizedArticle($options);
            
            default:
                throw new Exception("Invalid article type");
        }
    }
private function fetchRSSContent($sources) {
    $allContent = '';
    $successfulSources = 0;
    
    foreach ($sources as $source) {
        try {
            $content = $this->fetchUrl($source);
            if (!empty($content)) {
                $parsed = $this->parseRSSFeed($content);
                if (!empty($parsed)) {
                    $allContent .= $parsed . ' ';
                    $successfulSources++;
                }
            }
            
            // Limit to first 3 successful sources to prevent overload
            if ($successfulSources >= 3) break;
        } catch (Exception $e) {
            error_log("RSS Fetch Error for {$source}: " . $e->getMessage());
            continue;
        }
    }
    
    return trim($allContent);
}

private function fetchUrl($url) {
    $ch = curl_init();
    curl_setopt_array($ch, [
        CURLOPT_URL => $url,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_MAXREDIRS => 3,
        CURLOPT_TIMEOUT => 15,
        CURLOPT_SSL_VERIFYPEER => false,
        CURLOPT_USERAGENT => 'Mozilla/5.0 (compatible; RSS Reader/1.0;)'
    ]);

    $content = curl_exec($ch);
    $error = curl_error($ch);
    curl_close($ch);

    if ($error) {
        throw new Exception("CURL Error: {$error}");
    }

    return $content;
}

private function parseRSSFeed($content) {
    if (empty($content)) return '';

    libxml_use_internal_errors(true);
    $xml = simplexml_load_string($content);
    
    if ($xml === false) {
        $errors = libxml_get_errors();
        libxml_clear_errors();
        throw new Exception("XML Parse Error: " . $errors[0]->message);
    }

    $text = '';

    // Handle standard RSS format
    if (isset($xml->channel)) {
        foreach ($xml->channel->item as $item) {
            if (isset($item->title)) {
                $text .= strip_tags((string)$item->title) . '. ';
            }
            if (isset($item->description)) {
                $text .= strip_tags((string)$item->description) . ' ';
            }
        }
    }
    // Handle Atom format
    elseif (isset($xml->entry)) {
        foreach ($xml->entry as $entry) {
            if (isset($entry->title)) {
                $text .= strip_tags((string)$entry->title) . '. ';
            }
            if (isset($entry->summary)) {
                $text .= strip_tags((string)$entry->summary) . ' ';
            }
        }
    }

    // Clean up the text
    $text = preg_replace('/\s+/', ' ', $text);
    return trim($text);
}

private function processRSSContent($content) {
    // Clean the content
    $content = strip_tags($content);
    $content = preg_replace('/\s+/', ' ', $content);
    $content = trim($content);

    // Break into sentences
    $sentences = preg_split('/(?<=[.!?])\s+/', $content);
    
    // Select unique sentences
    $sentences = array_unique($sentences);
    
    // Get key sentences (first 10)
    $keySentences = array_slice($sentences, 0, 10);
    
    // Calculate word frequency for tags
    $words = str_word_count(strtolower($content), 1);
    $wordFrequency = array_count_values($words);
    arsort($wordFrequency);

    return [
        'raw_text' => $content,
        'key_sentences' => $keySentences,
        'word_frequency' => $wordFrequency
    ];
}

private function generateRSSSynthesizedArticle($options) {
    $category = $options['category'] ?? 'technology';
    $rssSources = $this->rssFeeds[$category] ?? [];
    
    if (empty($rssSources)) {
        throw new Exception("No RSS sources found for category: {$category}");
    }

    $rawContent = $this->fetchRSSContent($rssSources);
    if (empty($rawContent)) {
        throw new Exception("Failed to fetch RSS content");
    }

    $processedContent = $this->processRSSContent($rawContent);
    
    $article = [
        'title' => "Latest Insights: " . ucfirst($category),
        'type' => 'rss_synthesis',
        'content' => implode(' ', $processedContent['key_sentences']),
        'summary' => implode(' ', array_slice($processedContent['key_sentences'], 0, 2)),
        'topic' => $category,
        'tags' => array_slice(array_keys($processedContent['word_frequency']), 0, 5),
        'ai_thoughts' => "Analyzed RSS feeds from {$category}; Generated synthesis from multiple sources"
    ];

    return $this->saveArticle($article);
}

private function generateTermArticle($options) {
    $word = $options['word'] ?? $this->getRandomWord();
    $article = [
        'title' => ucfirst($word),
        'type' => 'term',
        'content' => '<iframe height="600px" width="100%" src="http://localhost/wordpedia/pages/' . $word . '"></iframe>'
    ];
        
    return $this->saveArticle($article);
}

    private function generateTrendingArticle($options) {
        $trendingWords = $this->extractTrendingWordsFromFeeds();
        $mainWord = reset($trendingWords);
        $wordDetails = $this->fetchWordDetails($mainWord);
        $aiGeneratedContent = $this->generateAIContent($trendingWords);
        
        $article = [
            'title' => "Breaking News: " . ucfirst($mainWord) . " Explained",
            'type' => 'trending',
            'trending_words' => $trendingWords,
            'main_word' => $mainWord,
            'wordpedia_url' => "http://localhost/wordpedia/pages/{$mainWord}",
            'ai_generated_content' => $aiGeneratedContent,
            'definition' => $wordDetails['definition'] ?? ''
        ];

        return $this->saveArticle($article);
    }

private function analyzeTrendsFromDatabase() {
    // Get tags from articles in the past 24 hours
    $stmt = $this->articlesDb->prepare("
        SELECT 
            tags,
            title,
            content,
            topic
        FROM articles 
        WHERE created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
        ORDER BY created_at DESC
    ");
    $stmt->execute();
    $recentArticles = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $wordFrequency = [];
    
    foreach ($recentArticles as $article) {
        // Process tags
        $tags = is_string($article['tags']) ? explode(',', $article['tags']) : [];
        foreach ($tags as $tag) {
            $tag = trim($tag);
            if (!empty($tag)) {
                $wordFrequency[$tag] = ($wordFrequency[$tag] ?? 0) + 3; // Tags have higher weight
            }
        }

        // Process title words
        $titleWords = str_word_count($article['title'], 1);
        foreach ($titleWords as $word) {
            $word = strtolower($word);
            if (strlen($word) > 3) { // Skip short words
                $wordFrequency[$word] = ($wordFrequency[$word] ?? 0) + 2; // Title words have medium weight
            }
        }

        // Process topic
        if (!empty($article['topic'])) {
            $wordFrequency[$article['topic']] = ($wordFrequency[$article['topic']] ?? 0) + 2;
        }

        // Process content words
        $contentWords = str_word_count(strip_tags($article['content']), 1);
        foreach ($contentWords as $word) {
            $word = strtolower($word);
            if (strlen($word) > 3) {
                $wordFrequency[$word] = ($wordFrequency[$word] ?? 0) + 1; // Content words have normal weight
            }
        }
    }

    // Filter out common words
    $commonWords = ['the', 'and', 'for', 'that', 'this', 'with', 'from'];
    foreach ($commonWords as $word) {
        unset($wordFrequency[$word]);
    }

    // Sort by frequency
    arsort($wordFrequency);

    // Return top 10 trends
    return array_slice($wordFrequency, 0, 10, true);
}

private function generateTrendingContent($trendingWords) {
    $content = "Current Trending Topics Analysis\n\n";
    
    // Main trend analysis
    $mainTrend = array_key_first($trendingWords);
    $content .= "Primary Trend: " . ucfirst($mainTrend) . "\n";
    $content .= "This topic has shown significant activity in recent discussions ";
    $content .= "with " . $trendingWords[$mainTrend] . " relevant mentions.\n\n";

    // Related trends
    $content .= "Related Trending Topics:\n";
    $relatedTrends = array_slice($trendingWords, 1, 4, true);
    foreach ($relatedTrends as $trend => $frequency) {
        $content .= "- " . ucfirst($trend) . " (" . $frequency . " mentions)\n";
    }
    
    $content .= "\nTrend Analysis:\n";
    $content .= "The emergence of these trends suggests growing interest in ";
    $content .= implode(", ", array_keys($relatedTrends)) . ". ";
    $content .= "This pattern indicates evolving discussions in these areas, ";
    $content .= "with potential implications for future developments.\n";

    return $content;
}

private function generateTrendingSummary($trendingWords) {
    $topTrends = array_slice(array_keys($trendingWords), 0, 3);
    return "Analysis of recent trending topics reveals significant interest in " . 
           implode(", ", $topTrends) . 
           ". This report examines these trends and their implications.";
}


    private function extractTrendingWordsFromFeeds() {
        $allTitles = [];
        foreach ($this->rssFeeds as $category => $feeds) {
            foreach ($feeds as $feedUrl) {
                $titles = $this->fetchFeedTitles($feedUrl);
                $allTitles = array_merge($allTitles, $titles);
            }
        }
        
        $wordCounts = $this->analyzeWordFrequency($allTitles);
        arsort($wordCounts);
        return array_keys(array_slice($wordCounts, 0, 10));
    }

    private function generateAIContent($trendingWords) {
        $content = "In the rapidly evolving landscape of ";
        $content .= implode(", ", array_slice($trendingWords, 0, 3));
        $content .= ", we are witnessing unprecedented developments.\n\n";
        
        return $content;
    }

    private function saveArticle($articleData) {
        $stmt = $this->articlesDb->prepare("
            INSERT INTO articles 
            (title, type, content, summary, created_at, tags, confidence) 
            VALUES 
            (:title, :type, :content, :summary, NOW(), :tags, :confidence)
        ");

        $stmt->execute([
            'title' => $articleData['title'],
            'type' => $articleData['type'],
            'content' => $articleData['content'],
            'summary' => $articleData['title'],
            'tags' => json_encode($articleData['trending_words'] ?? []),
            'confidence' => $this->calculateConfidence($articleData)
        ]);

        return $this->articlesDb->lastInsertId();
    }

    private function getRandomWord() {
        $stmt = $this->wordsDb->query("
            SELECT word FROM word 
            WHERE 
                definition IS NOT NULL AND 
                LENGTH(definition) > 50 AND 
                (usage_example IS NOT NULL OR etymology IS NOT NULL)
            ORDER BY RAND() 
            LIMIT 1
        ");
        $word = $stmt->fetchColumn();
        
        if (!$word) {
            $stmt = $this->wordsDb->query("SELECT word FROM word ORDER BY RAND() LIMIT 1");
            $word = $stmt->fetchColumn();
        }
        
        return $word;
    }

    private function fetchWordDetails($word) {
        $stmt = $this->wordsDb->prepare("
            SELECT 
                word, 
                definition, 
                type, 
                part_of_speech, 
                etymology, 
                usage_example, 
                synonyms, 
                antonyms, 
                related_word, 
                wiki, 
                related_topic, 
                difficulty_level, 
                frequency
            FROM word 
            WHERE LOWER(word) = LOWER(:word)
        ");
        $stmt->execute(['word' => $word]);
        $details = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if (!$details) {
            $stmt = $this->wordsDb->prepare("
                SELECT * FROM word 
                WHERE LOWER(word) LIKE LOWER(:word_pattern) 
                ORDER BY 
                    CASE 
                        WHEN word = :exact_word THEN 1 
                        WHEN word LIKE :word_start THEN 2 
                        ELSE 3 
                    END 
                LIMIT 1
            ");
            $stmt->execute([
                'word_pattern' => "%{$word}%",
                'exact_word' => $word,
                'word_start' => $word . "%"
            ]);
            $details = $stmt->fetch(PDO::FETCH_ASSOC);
        }
        
        if (!$details || !$this->isDetailRich($details)) {
            $details = $this->enrichWordDetailsFromExternal($word, $details);
        }
        
        return $details ?: [
            'word' => $word,
            'definition' => "A term that requires further exploration.",
            'type' => 'unknown'
        ];
    }

    private function isDetailRich($details) {
        return 
            !empty($details['definition']) && 
            strlen($details['definition']) > 50 && 
            (!empty($details['usage_example']) || !empty($details['etymology']));
    }

    private function generateSummary($articleData) {
        $summaryText = json_encode($articleData);
        return TextProcessor::generateSummary($summaryText, 300);
    }

    private function calculateConfidence($articleData) {
        $baseConfidence = 0.7;
        
        $confidenceModifiers = [
            'content_richness' => $this->calculateContentRichness($articleData),
            'source_reliability' => $this->determineSourceReliability($articleData),
            'complexity' => $this->assessComplexity($articleData)
        ];
        
        foreach ($confidenceModifiers as $modifier => $value) {
            $baseConfidence += ($value - 0.5) * 0.2;
        }
        
        return max(0.5, min(0.95, $baseConfidence));
    }

    private function calculateContentRichness($articleData) {
        $contentLength = strlen(json_encode($articleData));
        $wordCount = str_word_count(json_encode($articleData));
        return min(1, $wordCount / 500);
    }

    private function determineSourceReliability($articleData) {
        $sourceReliabilityMap = [
            'term' => 0.8,
            'trending' => 0.7,
            'rss_synthesis' => 0.6
        ];
        
        return $sourceReliabilityMap[$articleData['type'] ?? 'term'] ?? 0.7;
    }

    private function assessComplexity($articleData) {
        $complexity = $this->analyzeTextComplexity(json_encode($articleData));
        
        $complexityConfidence = [
            'very_easy' => 0.6,
            'easy' => 0.7,
            'medium' => 0.8,
            'difficult' => 0.7,
            'very_difficult' => 0.6
        ];
        
        return $complexityConfidence[$complexity['complexity_level']] ?? 0.7;
    }

    private function enrichWordDetailsFromExternal($word, $existingDetails = []) {
        return $existingDetails;
    }

    private function generateHumanSentence($processedContent) {
        $wordFrequency = $processedContent['word_frequency'];
        arsort($wordFrequency);
        $topWords = array_slice(array_keys($wordFrequency), 0, 3);
        
        $templates = [
            "Breaking developments in {fields} are reshaping our understanding.",
            "Emerging insights from {fields} point to significant transformations.",
            "The convergence of {fields} reveals unprecedented potential.",
            "Critical advances in {fields} are challenging existing paradigms."
        ];
        
        $template = $templates[array_rand($templates)];
        return str_replace('{fields}', implode(', ', $topWords), $template);
    }

    private function analyzeTextComplexity($text) {
        return TextProcessor::analyzeTextComplexity($text);
    }
}