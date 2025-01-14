
<?php
// advanced_article_generator.php
require_once __DIR__ . '/rss_processing_trait.php';
require_once __DIR__ . '/rss_processor.php';
require_once __DIR__ . '/WikiImageGalleryGenerator.class.php'; 

class WikipediaLiveScraper {
    private $userAgent = 'TrendingWordsBot/4.0 (research@example.com)';

    public function fetchWikipediaSummary($word) {
        // Normalize the word
        $normalizedWord = ucwords(trim($word));

        try {
            // Construct Wikipedia URL
            $encodedWord = str_replace(' ', '_', $normalizedWord);
            $url = "https://en.wikipedia.org/wiki/" . urlencode($encodedWord);

            // Initialize cURL
            $ch = curl_init();
            curl_setopt_array($ch, [
                CURLOPT_URL => $url,
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_USERAGENT => $this->userAgent,
                CURLOPT_TIMEOUT => 10,
                CURLOPT_FOLLOWLOCATION => true,
                CURLOPT_MAXREDIRS => 3,
                CURLOPT_SSL_VERIFYPEER => false
            ]);

            $html = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $error = curl_error($ch);
            curl_close($ch);

            // Check if page exists (not a 404)
            if ($httpCode === 404 || $error) {
                return $this->getGenericSummary($normalizedWord, false);
            }

            // Use DOMDocument to parse HTML
            $dom = new DOMDocument();
            @$dom->loadHTML(mb_convert_encoding($html, 'HTML-ENTITIES', 'UTF-8'));
            
            // Try to extract summary
            $summary = $this->extractSummary($dom);
            
            // If no summary found or page is a disambiguation page
            if (empty(trim($summary)) || $this->isDisambiguationPage($dom)) {
                return $this->getGenericSummary($normalizedWord, false);
            }

            // Truncate summary if too long
            $summary = $this->truncateSummary($summary);

            // Prepare summary data
            return [
                'summary' => $summary,
                'link' => $url,
                'key_points' => $this->extractKeyPoints($summary)
            ];

        } catch (Exception $e) {
            error_log("Wikipedia Scrape Error for {$word}: " . $e->getMessage());
            return $this->getGenericSummary($normalizedWord, false);
        }
    }

    private function extractSummary(DOMDocument $dom) {
        $xpath = new DOMXPath($dom);

        // Try different methods to extract summary
        $summarySelectors = [
            "//div[@class='mw-parser-output']/p[1]", // First paragraph
            "//div[@id='mw-content-text']/div[@class='mw-parser-output']/p[1]",
            "//div[@class='mw-parser-output']/p[normalize-space()][1]"
        ];

        foreach ($summarySelectors as $selector) {
            $paragraphs = $xpath->query($selector);
            
            if ($paragraphs && $paragraphs->length > 0) {
                $summary = trim($paragraphs->item(0)->textContent);
                
                // Validate summary length and content
                if (strlen($summary) > 50 && !preg_match('/\d{4} (birth|death)/i', $summary)) {
                    return $summary;
                }
            }
        }

        return '';
    }

    private function isDisambiguationPage(DOMDocument $dom) {
        $xpath = new DOMXPath($dom);
        
        // Check for common disambiguation page indicators
        $disambigSelectors = [
            "//div[contains(@class, 'hatnote')]",
            "//div[contains(text(), 'disambiguation')]",
            "//div[contains(@class, 'mw-disambig')]"
        ];

        foreach ($disambigSelectors as $selector) {
            $disambigElements = $xpath->query($selector);
            if ($disambigElements && $disambigElements->length > 0) {
                return true;
            }
        }

        return false;
    }

    private function truncateSummary($summary, $maxLength = 300) {
        // Truncate summary to max length, preserving whole words
        if (strlen($summary) <= $maxLength) {
            return $summary;
        }

        $truncated = substr($summary, 0, $maxLength);
        return substr($truncated, 0, strrpos($truncated, ' ')) . '...';
    }

    private function extractKeyPoints($summary) {
        // Split summary into sentences
        $sentences = preg_split('/(?<=[.!?])\s+/', $summary);
        
        // Select up to 3 most informative sentences
        $keyPoints = array_slice(
            array_filter($sentences, function($sentence) {
                return strlen($sentence) > 30;
            }),
            0,
            3
        );

        // If no good sentences found, create generic key points
        return $keyPoints ?: [
            "A significant term with broad implications.",
            "Represents an important concept in contemporary discourse.",
            "Requires deeper contextual understanding."
        ];
    }

    private function getGenericSummary($word, $includeLink = true) {
        return [
            'summary' => "A comprehensive exploration of the term '{$word}' and its significance in modern context.",
            'link' => $includeLink ? "https://en.wikipedia.org/wiki/" . urlencode($word) : '',
            'key_points' => [
                "Represents an important concept in contemporary discourse",
                "Potentially significant across multiple domains",
                "Requires further contextual analysis"
            ]
        ];
    }
}
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
            // Academic and Professional Technology Sources
            'https://cacm.acm.org/feed/',
            'https://www.technologyreview.com/feed/',
            'https://spectrum.ieee.org/rss/topic/robotics',
            'https://www.scientificamerican.com/tech/feed/',
            'https://arxiv.org/rss/cs.AI',
            'https://techcrunch.com/feed/',
            'https://feeds.feedburner.com/venturebeat/SZYF',
            'https://www.zdnet.com/news/rss.xml',
            'https://www.computerworld.com/index.rss',
            'https://www.theverge.com/rss/index.xml',
            'https://www.engadget.com/rss.xml',
            'https://www.wired.com/feed/rss',
            'https://rss.slashdot.org/Slashdot/slashdotMain',
            'https://www.cnet.com/rss/news/',
            'https://arstechnica.com/feed/'
        ],
        'artificial_intelligence' => [
            // AI-Specific Sources
            'https://arxiv.org/rss/cs.AI',
            'https://machinelearning.apple.com/rss.xml',
            'https://blog.google/technology/ai/rss/',
            'https://openai.com/blog/rss/',
            'https://feeds.feedburner.com/artificial-intelligence',
            'https://www.deepmind.com/blog/rss.xml',
            'https://distill.pub/rss.xml',
            'https://www.fast.ai/index.xml',
            'https://blogs.nvidia.com/blog/category/deep-learning/feed/',
            'https://aws.amazon.com/blogs/machine-learning/feed/'
        ],
        'science' => [
            'https://rss.sciencedaily.com/all.xml',
            'https://www.sciencenews.org/feed',
            'https://www.livescience.com/feeds/all',
            'https://phys.org/rss-feed/breaking/science-news/earth/',
            'https://www.newscientist.com/feed/home/',
            'https://www.sciencealert.com/feed',
            'https://www.eurekalert.org/rss/science.xml',
            'https://feeds.feedburner.com/scienceblog',
            'https://www.nasa.gov/rss/dyn/breaking_news.rss',
            'https://www.space.com/feeds/all',
            'https://api.quantamagazine.org/feed/',
            'https://www.scientificamerican.com/rss/sciam/basic-science/',
            'https://www.popsci.com/feed',
            'https://physicsworld.com/feed/',
            'https://www.chemistryworld.com/feed'
        ],
        'business' => [
            'https://hbr.org/feeds/webfeed',
            'https://sloanreview.mit.edu/feed/',
            'https://knowledge.insead.edu/rss',
            'https://www.economist.com/rss/business_and_finance_rss.xml',
            'https://www.mckinsey.com/featured-insights/rss',
            'https://knowledge.wharton.upenn.edu/feed/',
            'https://www.strategy-business.com/rss',
            'https://www.businesswire.com/rss/home',
            'https://www.businessinsider.com/rss',
            'https://www.forbes.com/leadership/feed/',
            'https://feeds.feedburner.com/entrepreneur/latest',
            'https://www.inc.com/rss/',
            'https://www.fastcompany.com/rss',
            'https://www.fool.com/feed/',
            'https://www.marketwatch.com/rss/topstories'
        ],
        'money' => [
            // Personal Finance and Investment Sources
            'https://www.fool.com/feeds/index.aspx',
            'https://www.kiplinger.com/feed',
            'https://feeds.feedburner.com/FreeMoneyFinance',
            'https://www.getrichslowly.org/feed/',
            'https://www.mrmoneymustache.com/feed/',
            'https://feeds.feedburner.com/moneyunder30',
            'https://feeds.feedburner.com/wisebread',
            'https://www.budgetsaresexy.com/feed/',
            'https://www.financialsamurai.com/feed/',
            'https://www.investopedia.com/rss/news.rss',
            'https://www.moneysavingexpert.com/news/feeds/news.rss',
            'https://clark.com/feed/',
            'https://www.nerdwallet.com/blog/feed/',
            'https://www.thebalance.com/rss',
            'https://feeds.feedburner.com/RetirementTheory'
        ],
        'world_news' => [
            'https://www.reuters.com/world/feed/',
            'https://www.ft.com/rss/home',
            'https://www.economist.com/rss/international_rss.xml',
            'https://www.aljazeera.com/xml/rss/all.xml',
            'https://foreignpolicy.com/feed/',
            'https://www.cfr.org/feed/rss.xml',
            'https://thediplomat.com/feed/',
            'https://www.politico.com/rss/world.xml',
            'https://feeds.bbci.co.uk/news/world/rss.xml',
            'https://feeds.npr.org/1004/rss.xml',
            'https://www.dw.com/en/top-stories/rss',
            'https://www.france24.com/en/rss',
            'https://english.kyodonews.net/rss/all.xml',
            'https://www3.nhk.or.jp/nhkworld/en/feed/rss/',
            'https://www.straitstimes.com/news/world/rss.xml'
        ],
        'environment' => [
            'https://www.nature.com/articles.rss?subject=environmental-sciences',
            'https://www.scientificamerican.com/article/environment/feed/',
            'https://www.ipcc.ch/feed/',
            'https://www.unep.org/news-and-stories/rss.xml',
            'https://www.globalchange.gov/rss.xml',
            'https://www.carbonbrief.org/feed',
            'https://www.worldwildlife.org/publications/feed',
            'https://www.iucn.org/news/feed',
            'https://www.nature.org/en-us/about-us/who-we-are/media-center/rss/',
            'https://e360.yale.edu/feed.xml',
            'https://www.greenbiz.com/rss.xml',
            'https://grist.org/feed/',
            'https://theecologist.org/rss.xml',
            'https://www.treehugger.com/feed',
            'https://www.ecowatch.com/feed'
        ],
        'health' => [
            'https://www.thelancet.com/rss/current',
            'https://jamanetwork.com/rss/site_wide.xml',
            'https://www.bmj.com/rss/current',
            'https://www.who.int/feeds/entity/mediacentre/news/rss.xml',
            'https://academic.oup.com/emph/rss/current',
            'https://www.healthline.com/rss/all',
            'https://www.medicalnewstoday.com/rss.xml',
            'https://www.webmd.com/rss/all.xml',
            'https://www.everydayhealth.com/rss',
            'https://feeds.feedburner.com/health-news',
            'https://www.nih.gov/feed/rss.xml',
            'https://www.cdc.gov/feed.xml',
            'https://www.mayoclinic.org/rss/all-updates.xml',
            'https://www.sciencedaily.com/rss/health_medicine.xml',
            'https://www.medscape.com/rss'
        ],
        'finance' => [
            'https://www.bis.org/rssfeed/index.htm',
            'https://www.imf.org/en/rss',
            'https://www.worldbank.org/en/rss',
            'https://www.brookings.edu/feed/',
            'https://www.ft.com/rss/home/us',
            'https://www.economist.com/finance-and-economics/rss.xml',
            'https://www.project-syndicate.org/rss',
            'https://feeds.bloomberg.com/markets/news.rss',
            'https://www.cnbc.com/id/10000664/device/rss/rss.html',
            'https://www.marketwatch.com/rss/topstories',
            'https://seekingalpha.com/feed.xml',
            'https://www.barrons.com/feed/rssheadlines',
            'https://www.investing.com/rss/news.rss',
            'https://www.zerohedge.com/feed',
            'https://finviz.com/rss.ashx'
        ],
        'cryptocurrency' => [
            // Crypto-Specific News
            'https://cointelegraph.com/rss',
            'https://coindesk.com/arc/outboundfeeds/rss/',
            'https://news.bitcoin.com/feed/',
            'https://bitcoinmagazine.com/.rss/full/',
            'https://cryptonews.com/news/feed',
            'https://decrypt.co/feed',
            'https://feed.cryptobriefing.com/',
            'https://cryptopotato.com/feed/',
            'https://ambcrypto.com/feed/',
            'https://newsbtc.com/feed/'
        ],
        'startups' => [
            // Startup and Innovation News
            'https://feeds.feedburner.com/venturebeat/SZYF',
            'https://techcrunch.com/startups/feed/',
            'https://www.eu-startups.com/feed/',
            'https://startupnation.com/feed/',
            'https://bothsidesofthetable.com/feed',
            'https://feeds.feedburner.com/onstartups',
            'https://www.startupgrind.com/feed/',
            'https://feeds.feedburner.com/youngentrepreneur',
            'https://www.startupdaily.net/feed/',
            'https://startupbeat.com/feed/'
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
private function isLikelyCompanyName($word) {
    // Common company suffixes
    $companySuffixes = [
        'Inc', 'Corp', 'Ltd', 'LLC', 'Co', 'Company', 'Group', 'Holdings',
        'Technologies', 'Tech', 'Systems', 'Solutions', 'Industries', 'International'
    ];
    
    // Check if the word contains any company suffix
    foreach ($companySuffixes as $suffix) {
        if (strpos($word, $suffix) !== false) {
            return true;
        }
    }
    
    // Additional checks for company names
    return (
        strlen($word) >= 4 && // Minimum length
        preg_match('/^[A-Z]/', $word) && // Starts with capital letter
        !preg_match('/^(The|A|An|And|Or|But|In|On|At|To|For|Of|With|By)$/', $word) // Not a common article/preposition
    );
}

private function extractProperNouns($content) {
    // Convert content to lowercase for comparison but keep original for extraction
    $originalWords = preg_split('/\s+/', $content);
    $words = [];
    
    foreach ($originalWords as $word) {
        // Check if word starts with capital letter and is at least 2 characters long
        if (preg_match('/^[A-Z][A-Za-z0-9\-]{1,}$/', $word)) {
            $words[] = $word;
        }
    }
    
    return $words;
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
    
    // Initialize gallery generator
    $galleryGenerator = new WikiImageGalleryGenerator();
    $gallery = $galleryGenerator->generateGallery($word);
    
    // Combine gallery and iframe
    $content = $gallery . "\n" . 
               '<iframe height="800px" width="100%" src="http://localhost/wordpedia/pages/' . $word . '"></iframe>';
    
    $article = [
        'title' => ucfirst($word),
        'type' => 'term',
        'content' => $content
    ];
        
    return $this->saveArticle($article);
}
private function formatTrendingArticleContent($mainWord, $wordDetails, $aiGeneratedContent, $trendingWords) {
    // Create live Wikipedia Scraper
    $summaryFetcher = new WikipediaLiveScraper();

    $content = "<h1>Trending Now: " . ucfirst($mainWord) . " and Related Topics</h1>";
    $content .= "<p><strong>Key Trend:</strong> " . ucfirst($mainWord) . " (Mentioned " . $trendingWords[$mainWord] . " times)</p>";
    
    if (!empty($wordDetails['definition'])) {
        $content .= "<p><strong>Definition:</strong> " . $wordDetails['definition'] . "</p>";
    }
    
    $content .= "<h2>Current Trends Analysis</h2>";
    $content .= "<p>" . $aiGeneratedContent . "</p>";
    
    $content .= "<h2>Related Trending Topics (Names, Places, Ideas, or Things)</h2>";
    $content .= "<ul>";
    $count = 0;
    foreach ($trendingWords as $word => $frequency) {
        if ($word !== $mainWord && $count < 5) {
            // Fetch Wikipedia summary with live scraping
            $summary = $summaryFetcher->fetchWikipediaSummary($word);
            
            $content .= "<li>" . 
                ucfirst($word) . 
                " (Mentioned " . $frequency . " times) ";
            
            // Only add link if it exists
            if (!empty($summary['link'])) {
                $content .= "<a href='" . htmlspecialchars($summary['link']) . "' target='_blank'>📖</a> ";
            }
            
            $content .= "<br><small>" . htmlspecialchars($summary['summary']) . "</small>" .
            "</li>";
            $count++;
        }
    }
    $content .= "</ul>";
    
    $content .= "<p>This trend analysis is based on recent RSS feeds from various news sources, focusing on names, places, ideas, or things with 5 or more letters.</p>";
    
    return $content;
}
private function isNoun($word) {
    // Use PHP's built-in parts of speech tagger if available
    if (function_exists('pos_tag')) {
        $tags = pos_tag([$word]);
        $pos = $tags[0][1];
        return strpos($pos, 'NN') === 0; // Check if it's any type of noun
    }
    
    // If pos_tag is not available, we'll use a simple heuristic
    // This is not perfect but can serve as a basic filter for nouns
    $lastChar = substr($word, -1);
    return !in_array($lastChar, ['a', 'e', 'i', 'o', 'u', 'y']);
}
private function generateTrendingArticle($options) {
    $trendingWords = $this->extractTrendingWordsFromFeeds();
    if (empty($trendingWords)) {
        throw new Exception("No trending names, places, ideas, or things found with 5 or more letters.");
    }
    $mainWord = key($trendingWords);
    $wordDetails = $this->fetchWordDetails($mainWord);
    $aiGeneratedContent = $this->generateAIContent($trendingWords);
    
    $article = [
        'title' => "Trending Now: " . ucfirst($mainWord) . " and Related Topics",
        'type' => 'trending',
        'trending_words' => $trendingWords,
        'main_word' => $mainWord,
        'ai_generated_content' => $aiGeneratedContent,
        'definition' => $wordDetails['definition'] ?? '',
        'content' => $this->formatTrendingArticleContent($mainWord, $wordDetails, $aiGeneratedContent, $trendingWords)
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
    $allWords = [];
$categories = [
    'science', 
    'technology', 
    'artificial_intelligence',
    'world_news', 
    'business', 
    'money',
    'environment', 
    'health', 
    'finance',
    'cryptocurrency',
    'startups'
];    
    // Get all words from the database to exclude
    $dictionaryWords = $this->getDictionaryWords();
    
    foreach ($categories as $category) {
        $feeds = $this->rssFeeds[$category] ?? [];
        foreach ($feeds as $feedUrl) {
            try {
                $content = $this->fetchRSSContent([$feedUrl]);
                $words = $this->extractProperNouns($content);
                
                // Filter out dictionary words
                $words = array_diff($words, $dictionaryWords);
                
                $allWords = array_merge($allWords, $words);
            } catch (Exception $e) {
                error_log("Error fetching feed $feedUrl: " . $e->getMessage());
                continue;
            }
        }
    }
    
    $wordCounts = array_count_values($allWords);
    arsort($wordCounts);
    
    // Filter to keep only words that appear multiple times and are likely company names
    $trendingWords = array_filter($wordCounts, function($count, $word) {
        return $count >= 2 && $this->isLikelyCompanyName($word);
    }, ARRAY_FILTER_USE_BOTH);
    
    // Return top 20 trending words
    return array_slice($trendingWords, 0, 20, true);
}
private function getDictionaryWords() {
    $words = [];
    $stmt = $this->wordsDb->query("SELECT LOWER(word) as word FROM word");
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $words[] = strtolower($row['word']);
    }
    return $words;
}
private function extractKeywords($content) {
    $content = strtolower($content);
    $words = str_word_count($content, 1);
    $words = array_diff($words, $this->filterWords);
    return array_filter($words, function($word) {
        return strlen($word) >= 5 && $this->isNamePlaceIdeaOrThing($word);
    });
}
private $filterWords = [
'originally', 'initially', 'primarily', 'essentially', 'basically', 'virtually',     
    'appeared', 'seemingly', 'reportedly', 'purportedly', 'allegedly', 'ostensibly',
    'hypothetically', 'theoretically', 'conceptually', 'potentially', 'possibly',
    'arguably', 'comparatively', 'relatively', 'nominally', 'tentatively',
    
    // Extended Narrative and Reporting Qualifiers
    'reportedly', 'seemingly', 'apparently', 'supposedly', 'allegedly', 'ostensibly',
    'purportedly', 'technically', 'theoretically', 'hypothetically', 'potentially',
    'arguably', 'comparatively', 'relatively', 'nominally', 'tentatively',

    // Additional Vague Descriptive Terms
    'somewhat', 'kind', 'sort', 'type', 'kind', 'sort', 'manner', 'way', 'form',
    'style', 'fashion', 'mode', 'method', 'approach', 'perspective', 'angle',

    // Extended Generic Existence and State Words
    'exist', 'exists', 'existed', 'present', 'presents', 'presented', 
    'survive', 'survives', 'survived', 'continue', 'continues', 'continued',
    'remain', 'remains', 'remained', 'persist', 'persists', 'persisted',

    // More Contextual and Comparative Qualifiers
    'roughly', 'about', 'around', 'approximately', 'generally', 'broadly',
    'practically', 'virtually', 'nearly', 'almost', 'somewhat', 'kind', 'sort',
    'relatively', 'comparatively', 'marginally', 'slightly', 'partially',

    // Extended Abstract Interaction and Existence Terms
    'involve', 'involves', 'involved', 'include', 'includes', 'included',
    'encompass', 'encompasses', 'encompassed', 'contain', 'contains', 'contained',
    'comprise', 'comprises', 'comprised', 'constitute', 'constitutes', 'constituted',

    // Extremely Vague Communication and Conceptual Terms
    'mean', 'means', 'meant', 'signify', 'signifies', 'signified',
    'indicate', 'indicates', 'indicated', 'suggest', 'suggests', 'suggested',
    'imply', 'implies', 'implied', 'connote', 'connotes', 'connoted',

    // Additional Generalized Perception and Interpretation Words
    'seem', 'seems', 'seemed', 'appear', 'appears', 'appeared',
    'look', 'looks', 'looked', 'sound', 'sounds', 'sounded',
    'feel', 'feels', 'felt', 'understand', 'understands', 'understood',

    // Extended Generic Development and Change Terms
    'develop', 'develops', 'developed', 'evolve', 'evolves', 'evolved',
    'transform', 'transforms', 'transformed', 'convert', 'converts', 'converted',
    'modify', 'modifies', 'modified', 'alter', 'alters', 'altered',

    // More Extremely Generic Action and State Words
    'happen', 'happens', 'happened', 'occur', 'occurs', 'occurred',
    'emerge', 'emerges', 'emerged', 'arise', 'arises', 'arose',
    'come', 'comes', 'came', 'go', 'goes', 'went',

    // Additional Extremely Vague Qualifier Words
    'particular', 'specific', 'general', 'overall', 'entire', 'complete',
    'partial', 'some', 'any', 'certain', 'various', 'multiple', 'several',

    // Extended Meta-Descriptive and Contextual Terms
    'clearly', 'simply', 'just', 'really', 'actually', 'kind', 'basically',
    'essentially', 'fundamentally', 'primarily', 'mainly', 'mostly', 'largely',

    // More Generic Intellectual and Conceptual Terms
    'consider', 'considers', 'considered', 'regard', 'regards', 'regarded',
    'view', 'views', 'viewed', 'perceive', 'perceives', 'perceived',

    // Additional Extremely Generic Narrative and Reporting Words
    'recently', 'currently', 'presently', 'moment', 'now', 'today',
    'recently', 'lately', 'soon', 'eventually', 'ultimately', 'finally',

    // Extended Extremely Vague Interaction Terms
    'deal', 'deals', 'dealt', 'handle', 'handles', 'handled',
    'manage', 'manages', 'managed', 'work', 'works', 'worked',

    // More Abstract Existence and State Terms
    'exist', 'exists', 'existed', 'live', 'lives', 'lived',
    'stand', 'stands', 'stood', 'sit', 'sits', 'sat','investor','others','other',

    // Additional Extremely Generic Perception Words
    'notice', 'notices', 'noticed', 'observe', 'observes', 'observed',
    'recognize', 'recognizes', 'recognized', 'realize', 'realizes', 'realized',

    // Extended Extremely Vague Comparative Terms
    'compare', 'compares', 'compared', 'contrast', 'contrasts', 'contrasted',
    'match', 'matches', 'matched', 'differ', 'differs', 'differed',

    // More Abstract Developmental and Change Terms
    'progress', 'progresses', 'progressed', 'advance', 'advances', 'advanced',
    'improve', 'improves', 'improved', 'change', 'changes', 'changed',

    // Additional Extremely Vague Interaction and Communication Terms
    'communicate', 'communicates', 'communicated', 
    'interact', 'interacts', 'interacted',
    'connect', 'connects', 'connected', 
    'relate', 'relates', 'related',
'make', 'made', 'doing', 'done', 'create', 'created', 'build', 'built', 
    'use', 'used', 'work', 'works', 'worked', 'try', 'tried', 
    'move', 'moved', 'change', 'changed', 'turn', 'turned',
    'start', 'started', 'stop', 'stopped', 'begin', 'began', 'end', 'ended',
    'happen', 'happened', 'occur', 'occurred', 'take', 'took', 'give', 'gave',

    // Emotional and Subjective Terms
    'like', 'likes', 'loved', 'hated', 'enjoyed', 'disliked', 'preferred',
    'interesting', 'boring', 'exciting', 'amazing', 'wonderful', 'terrible',
    'great', 'awesome', 'fantastic', 'horrible', 'nice', 'okay', 'fine',

    // Additional Pronouns and Generic References
    'something', 'anything', 'everything', 'nothing', 'whatever', 'whoever',
    'whomever', 'anywhere', 'everywhere', 'nowhere', 'somehow', 'anyhow',

    // More Prepositions and Connectors
    'amid', 'per', 'via', 'versus', 'vs', 'contra', 'unlike', 'save', 'except',
    'minus', 'plus', 'times', 'versus', 'opposite', 'alongside',

    // Extended Time and Temporal Expressions
    'ages', 'moment', 'instant', 'period', 'span', 'era', 'epoch', 'age',
    'lifecycle', 'timeframe', 'duration', 'interval', 'phase', 'stage',
    'millisecond', 'second', 'minute', 'hour', 'day', 'nights', 'quarters',

    // Communication and Abstract Concepts
    'idea', 'concept', 'notion', 'theory', 'approach', 'method', 'system',
    'process', 'procedure', 'technique', 'strategy', 'tactic', 'framework',
    'model', 'paradigm', 'structure', 'design', 'pattern', 'principle',

    // Extremely Generic Qualitative Descriptors
    'possible', 'impossible', 'potential', 'probable', 'improbable', 
    'likely', 'unlikely', 'certain', 'uncertain', 'definite', 'indefinite',
    'complete', 'incomplete', 'total', 'partial', 'whole', 'entire',

    // Extended Sensory and Perceptual Terms
    'feel', 'feels', 'felt', 'seem', 'seems', 'seemed', 'appear', 'appears', 'appeared',
    'look', 'looks', 'looked', 'sound', 'sounds', 'sounded', 'smell', 'smells', 'smelled',

    // Additional Generic Technology and Digital Terms
    'app', 'platform', 'system', 'network', 'interface', 'software', 'hardware',
    'program', 'programming', 'coded', 'coding', 'develop', 'developed', 'developing',

    // More Generic Measurement and Comparative Terms
    'amount', 'quantity', 'number', 'total', 'average', 'median', 'typical',
    'standard', 'normal', 'usual', 'common', 'rare', 'unique', 'similar', 'different',

    // Extended Abstract Location and Direction
    'place', 'spot', 'location', 'site', 'area', 'zone', 'region', 'sector',
    'here', 'there', 'everywhere', 'somewhere', 'anywhere', 'nowhere',

    // More Generic Action and Progress Terms
    'achieve', 'achieved', 'accomplish', 'accomplished', 'complete', 'completed',
    'resolve', 'resolved', 'solve', 'solved', 'fix', 'fixed', 'improve', 'improved',

    // Extended Intellectual and Knowledge Terms
    'know', 'knew', 'known', 'understand', 'understood', 'learn', 'learned', 
    'research', 'studied', 'investigate', 'investigated', 'explore', 'explored',

    // Additional Generic Descriptive Comparative Terms
    'better', 'worse', 'more', 'less', 'larger', 'smaller', 'faster', 'slower',
    'earlier', 'later', 'superior', 'inferior', 'equal', 'unequal', 'comparable',

    // Extended Modal and Hypothetical Terms
    'maybe', 'perhaps', 'possibly', 'potentially', 'seemingly', 'apparently',
    'hypothetically', 'theoretically', 'generally', 'broadly', 'typically',

    // More Generic Organizational and Structural Terms
    'unit', 'division', 'section', 'branch', 'department', 'group', 'team',
    'organization', 'entity', 'body', 'institution', 'association', 'alliance',

    // Extended Communication and Interaction Terms
    'communicate', 'communicated', 'interact', 'interacted', 'connect', 'connected',
    'relate', 'related', 'link', 'linked', 'associate', 'associated',

    // Additional Generic Performance and Evaluation Terms
    'perform', 'performed', 'execute', 'executed', 'conduct', 'conducted',
    'manage', 'managed', 'handle', 'handled', 'process', 'processed',

    // Extended Meta-Language and Discussion Terms
    'discuss', 'discussed', 'debate', 'debated', 'argue', 'argued', 'contend', 'contended',
    'propose', 'proposed', 'suggest', 'suggested', 'imply', 'implied',

    // More Filler Words and Generic Placeholders
    'thing', 'things', 'stuff', 'matter', 'element', 'aspect', 'factor', 
    'component', 'part', 'portion', 'segment', 'fragment',

    // Generic Online and Digital Content Terms
    'content', 'information', 'data', 'details', 'specifics', 'particulars',
    'overview', 'summary', 'breakdown', 'snapshot', 'glimpse', 'insight',
 'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for', 'of', 'with', 'by',
    'from', 'up', 'about', 'into', 'over', 'after', 'beneath', 'under', 'above',

    // Pronouns
    'he', 'she', 'it', 'they', 'we', 'you', 'who', 'whom', 'whose', 'which', 'that',
    'i', 'me', 'my', 'mine', 'your', 'yours', 'his', 'her', 'hers', 'its', 'our', 'ours',
    'their', 'theirs', 'them', 'themselves', 'ourselves', 'yourself', 'myself',

    // Verbs and auxiliaries
    'is', 'are', 'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had', 'do',
    'does', 'did', 'will', 'would', 'shall', 'should', 'can', 'could', 'may', 'might',
    'must', 'ought', 'go', 'going', 'gone', 'went', 'come', 'coming', 'came',

    // Time-related words
    'now', 'then', 'always', 'never', 'sometimes', 'often', 'occasionally', 'rarely',
    'today', 'tomorrow', 'yesterday', 'week', 'month', 'year', 'decade', 'century',
    'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday',
    'january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december',

    // Business and news-related terms
    'company', 'business', 'industry', 'market', 'economy', 'stock', 'shares', 'investors',
    'profit', 'revenue', 'sales', 'growth', 'decline', 'increase', 'decrease', 'rise', 'fall',
    'report', 'earnings', 'quarter', 'fiscal', 'financial', 'economic', 'corporate',
    'ceo', 'cfo', 'cto', 'executive', 'management', 'board', 'directors', 'shareholders',
    'employees', 'workers', 'staff', 'team', 'department', 'division', 'subsidiary',
    'merger', 'acquisition', 'partnership', 'collaboration', 'deal', 'agreement',
    'strategy', 'plan', 'goal', 'objective', 'mission', 'vision', 'value', 'principle',
    'product', 'service', 'solution', 'innovation', 'technology', 'development',
    'launch', 'release', 'update', 'version', 'edition', 'model', 'series',
    'customer', 'client', 'consumer', 'user', 'audience', 'target', 'demographic',
    'market', 'industry', 'sector', 'niche', 'segment', 'vertical', 'horizontal',
    'competitor', 'rival', 'competition', 'benchmark', 'leader', 'pioneer',
    'trend', 'pattern', 'shift', 'change', 'transformation', 'disruption',
    'challenge', 'opportunity', 'threat', 'risk', 'issue', 'problem', 'solution',
    'analysis', 'research', 'study', 'survey', 'report', 'whitepaper', 'case study',
    'forecast', 'prediction', 'projection', 'estimate', 'speculation',
    'investment', 'funding', 'financing', 'capital', 'assets', 'liabilities',
    'debt', 'equity', 'valuation', 'worth', 'value', 'price', 'cost',
    'budget', 'expense', 'spending', 'saving', 'profit', 'loss', 'margin',
    'efficiency', 'productivity', 'performance', 'output', 'input', 'throughput',
    'quality', 'quantity', 'volume', 'capacity', 'scale', 'scope',
    'global', 'local', 'regional', 'national', 'international', 'worldwide',
    'domestic', 'foreign', 'offshore', 'onshore', 'outsource', 'insource',
    'brand', 'branding', 'marketing', 'advertising', 'promotion', 'campaign',
    'media', 'press', 'publication', 'news', 'article', 'story', 'feature',
    'interview', 'statement', 'announcement', 'press release', 'conference',
    'event', 'webinar', 'seminar', 'workshop', 'meeting', 'conference',
    'regulation', 'compliance', 'legal', 'law', 'policy', 'guideline', 'standard',
    'sustainability', 'responsibility', 'ethics', 'governance', 'transparency',
    'diversity', 'inclusion', 'equality', 'equity', 'fairness',
    'innovation', 'creativity', 'invention', 'discovery', 'breakthrough',
    'success', 'failure', 'achievement', 'milestone', 'progress', 'setback',
    'crisis', 'emergency', 'disaster', 'scandal', 'controversy',
    'reform', 'restructure', 'reorganize', 'revamp', 'overhaul',
    'initiative', 'program', 'project', 'campaign', 'drive', 'effort',

    // Action words and general terms
    'appeared', 'watch', 'watched', 'latest', 'recent', 'new', 'update', 'updated',
    'released', 'launched', 'announced', 'revealed', 'introduced', 'premiered',
    'debuted', 'unveiled', 'showcased', 'demonstrated', 'presented', 'exhibited',
    'featured', 'highlighted', 'spotlighted', 'showcased', 'current', 'ongoing',
    'upcoming', 'forthcoming', 'future', 'past', 'previous', 'former', 'earlier',
    'later', 'soon', 'recently', 'lately', 'season', 'episode', 'series',
    'according', 'reported', 'said', 'says', 'told', 'stated', 'claims', 'believes',
    'thinks', 'suggests', 'indicates', 'shows', 'reveals', 'confirms', 'denies',
    'argues', 'explains', 'describes', 'discusses', 'highlights', 'emphasizes',
    'focuses', 'points', 'notes', 'adds', 'continues', 'concludes', 'summarizes',
    'details', 'outlines', 'presents', 'introduces', 'examines', 'explores',
    'investigates', 'analyzes', 'evaluates', 'assesses', 'reviews', 'considers',
    'addresses', 'tackles', 'deals', 'handles', 'covers', 'features',
    // Original list
    'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for', 'of', 'with', 'by',
    'from', 'up', 'about', 'into', 'over', 'after', 'beneath', 'under', 'above',
    'he', 'she', 'it', 'they', 'we', 'you', 'who', 'whom', 'whose', 'which', 'that',
    'i', 'me', 'my', 'mine', 'your', 'yours', 'his', 'her', 'hers', 'its', 'our', 'ours',
    'their', 'theirs', 'them', 'there', 'here', 'where', 'when', 'why', 'how',
    'is', 'are', 'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had', 'do',
    'does', 'did', 'will', 'would', 'shall', 'should', 'can', 'could', 'may', 'might',
    'must', 'ought', 'this', 'these', 'those', 'then', 'than', 'so',

    // Additional words to filter out
    'first', 'second', 'third', 'fourth', 'fifth', 'last', 'next', 'previous',
    'red', 'blue', 'green', 'yellow', 'black', 'white', 'orange', 'purple', 'brown',
    'before', 'after', 'during', 'while', 'since', 'until', 'throughout', 'within',
    'without', 'through', 'across', 'along', 'around', 'behind', 'beside', 'between',
    'among', 'beyond', 'despite', 'except', 'inside', 'outside', 'near', 'off',
    'good', 'bad', 'big', 'small', 'large', 'little', 'high', 'low', 'long', 'short',
    'old', 'new', 'young', 'easy', 'hard', 'fast', 'slow', 'early', 'late', 'far',
    'close', 'deep', 'shallow', 'heavy', 'light', 'strong', 'weak', 'clean', 'dirty',
    'loud', 'quiet', 'rich', 'poor', 'thick', 'thin', 'wide', 'narrow',
    'however', 'therefore', 'meanwhile', 'nevertheless', 'furthermore', 'moreover',
    'although', 'though', 'even', 'still', 'yet', 'anyway', 'besides', 'certainly',
    'indeed', 'obviously', 'course', 'fact', 'generally', 'apparently', 'clearly',
    'actually', 'usually', 'often', 'sometimes', 'always', 'never', 'rarely',
	    'engadget', 'stock', 'company', 'daily', 'climate',
    'news', 'report', 'update', 'today', 'yesterday',
    'week', 'month', 'year', 'time', 'people',
    'world', 'country', 'city', 'state', 'government',
    'business', 'market', 'industry', 'technology', 'science',
    'health', 'sports', 'entertainment', 'media', 'social',
    'online', 'digital', 'global', 'local', 'national',
    'international', 'public', 'private', 'official', 'unofficial',
    'report', 'article', 'story', 'feature', 'analysis',
    'review', 'opinion', 'editorial', 'column', 'blog',
    'post', 'tweet', 'video', 'audio', 'photo',
    'image', 'gallery', 'slideshow', 'infographic', 'chart',
	'appeared', 'watch', 'watched', 'latest', 'recent', 'new',
    'update', 'updated', 'released', 'launched', 'announced',
    'revealed', 'introduced', 'premiered', 'debuted', 'unveiled',
    'showcased', 'demonstrated', 'presented', 'exhibited',
    'featured', 'highlighted', 'spotlighted', 'showcased',
    'current', 'ongoing', 'upcoming', 'forthcoming', 'future',
    'past', 'previous', 'former', 'earlier', 'later',
    'now', 'then', 'soon', 'recently', 'lately',
    'today', 'tomorrow', 'yesterday', 'week', 'month', 'year',
    'season', 'episode', 'series', 'edition', 'version'
];
private function isNamePlaceIdeaOrThing($word) {
    // Use PHP's built-in parts of speech tagger if available
    if (function_exists('pos_tag')) {
        $tags = pos_tag([$word]);
        $pos = $tags[0][1];
        // Check for nouns (NN), proper nouns (NNP), or adjectives (JJ) which might represent ideas
        return strpos($pos, 'NN') === 0;
    }
    
    // If pos_tag is not available, we'll use a simple heuristic
    // This is not perfect but can serve as a basic filter
    $firstChar = substr($word, 0, 1);
    $lastChar = substr($word, -1);
    // Check if the word starts with a capital letter (potential name or place)
    // or doesn't end with common verb endings
    return ctype_upper($firstChar) || !in_array($lastChar, ['s', 'ed', 'ing']);
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