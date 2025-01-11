<?php
// rss_processor.php

class RSSProcessor {
    private $feeds;
    private $lastError;

    public function __construct($feeds = []) {
        $this->feeds = $feeds ?: [
            'technology' => [
                'https://techcrunch.com/feed/',
                'https://www.wired.com/feed/',
                'https://www.theverge.com/rss/index.xml'
            ],
            'science' => [
                'https://www.scientificamerican.com/rss/blog/60-second-science/',
                'https://www.nasa.gov/rss/dyn/breaking_news.rss'
            ],
            'business' => [
                'https://www.forbes.com/innovation/feed2/'
            ]
        ];
    }

    public function fetchContent($category) {
        if (!isset($this->feeds[$category])) {
            throw new Exception("Invalid RSS category: {$category}");
        }

        $allContent = '';
        $successCount = 0;

        foreach ($this->feeds[$category] as $feedUrl) {
            try {
                $content = $this->fetchUrl($feedUrl);
                if ($content) {
                    $parsed = $this->parseRSS($content);
                    if ($parsed) {
                        $allContent .= $parsed . ' ';
                        $successCount++;
                    }
                }
            } catch (Exception $e) {
                $this->lastError = "Error fetching {$feedUrl}: " . $e->getMessage();
                error_log($this->lastError);
                continue;
            }
        }

        if ($successCount === 0) {
            throw new Exception("Failed to fetch content from any RSS feeds in category: {$category}");
        }

        return $this->processContent($allContent);
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
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($error) {
            throw new Exception("CURL Error: {$error}");
        }

        if ($httpCode !== 200) {
            throw new Exception("HTTP Error {$httpCode}");
        }

        return $content;
    }

    private function parseRSS($content) {
        libxml_use_internal_errors(true);
        $xml = simplexml_load_string($content);
        
        if ($xml === false) {
            $errors = libxml_get_errors();
            libxml_clear_errors();
            throw new Exception("XML Parse Error: " . implode(', ', array_map(function($error) {
                return $error->message;
            }, $errors)));
        }

        $items = [];

        // Handle standard RSS
        if (isset($xml->channel)) {
            foreach ($xml->channel->item as $item) {
                $items[] = [
                    'title' => (string)$item->title,
                    'description' => strip_tags((string)$item->description)
                ];
            }
        }
        // Handle Atom
        elseif (isset($xml->entry)) {
            foreach ($xml->entry as $entry) {
                $items[] = [
                    'title' => (string)$entry->title,
                    'description' => strip_tags((string)($entry->content ?? $entry->summary))
                ];
            }
        }

        return implode(' ', array_map(function($item) {
            return $item['title'] . '. ' . $item['description'];
        }, $items));
    }

    private function processContent($content) {
        // Clean the content
        $content = preg_replace('/\s+/', ' ', $content);
        $content = strip_tags($content);
        $content = trim($content);

        // Extract sentences
        $sentences = preg_split('/(?<=[.!?])\s+/', $content);
        
        // Get unique sentences and limit to a reasonable number
        $sentences = array_unique($sentences);
        $sentences = array_slice($sentences, 0, 10);

        return implode(' ', $sentences);
    }

    public function getLastError() {
        return $this->lastError;
    }
}