<?php
class WikiImageGalleryGenerator {
    private $userAgent = 'ImageBot/1.0 (educational research project)';
    
    public function generateGallery($term) {
        try {
            $images = $this->getWikipediaImages($term);
            if (empty($images)) {
                return $this->generatePlaceholderGallery();
            }
            return $this->formatGalleryHTML($images);
        } catch (Exception $e) {
            error_log("Wiki Gallery generation error: " . $e->getMessage());
            return $this->generatePlaceholderGallery();
        }
    }
    
    private function getWikipediaImages($term) {
        $term = ucwords(trim($term));
        $encodedTerm = str_replace(' ', '_', $term);
        
        // First try exact match
        $images = $this->scrapeWikiImages("https://en.wikipedia.org/wiki/" . urlencode($encodedTerm));
        
        // If no images found, try search
        if (empty($images)) {
            $searchUrl = "https://en.wikipedia.org/w/api.php?action=opensearch&search=" . 
                        urlencode($term) . "&limit=5&namespace=0&format=json";
            $searchResults = $this->makeRequest($searchUrl);
            
            if ($searchResults) {
                $data = json_decode($searchResults, true);
                if (!empty($data[3])) {
                    foreach ($data[3] as $articleUrl) {
                        $newImages = $this->scrapeWikiImages($articleUrl);
                        $images = array_merge($images, $newImages);
                        if (count($images) >= 5) break;
                    }
                }
            }
        }
        
        return array_slice($images, 0, 5);
    }
    
    private function scrapeWikiImages($url) {
        $html = $this->makeRequest($url);
        if (!$html) return [];
        
        libxml_use_internal_errors(true);
        $images = [];
        $dom = new DOMDocument();
        @$dom->loadHTML($html);
        $xpath = new DOMXPath($dom);
        
        // First try infobox images
        $infoboxImages = $xpath->query("//table[contains(@class, 'infobox')]//img");
        foreach ($infoboxImages as $img) {
            $imageData = $this->processWikiImage($img);
            if ($imageData) {
                $images[] = $imageData;
            }
        }
        
        // Then try content images
        if (count($images) < 5) {
            $contentImages = $xpath->query("//div[@class='mw-parser-output']//img[contains(@class, 'thumbimage')]");
            foreach ($contentImages as $img) {
                $imageData = $this->processWikiImage($img);
                if ($imageData && !$this->isDuplicateImage($images, $imageData)) {
                    $images[] = $imageData;
                }
            }
        }
        
        libxml_clear_errors();
        return array_slice(array_values($images), 0, 5);
    }
    
private function processWikiImage($img) {
        $src = $img->getAttribute('src');
        if (!$src) return null;
        
        // Fix protocol
        if (strpos($src, '//') === 0) {
            $src = 'https:' . $src;
        }

        // Clean up the URL
        $src = str_replace('/thumb/', '/', $src);

        // Extract the real filename
        if (preg_match('~/([^/]+\.[a-zA-Z]{3,4})/[^/]*$~', $src, $matches)) {
            // Remove everything after the actual file
            $src = preg_replace('~/' . preg_quote($matches[1]) . '/.*$~', '/' . $matches[1], $src);
        }

        // Remove any remaining size prefix
        $src = preg_replace('~/\d+px-~', '/', $src);
        
        // Skip SVG files and small images
        if (stripos($src, '.svg') !== false) {
            return null;
        }
        
        $width = $img->getAttribute('width');
        if ($width && intval($width) < 100) {
            return null;
        }
        
        // Final cleanup of any double slashes
        $src = preg_replace('~([^:])//+~', '$1/', $src);
        
        return [
            'url' => $src,
            'alt' => $img->getAttribute('alt') ?: 'Wikipedia image',
            'title' => $img->getAttribute('title') ?: ''
        ];
    }
    
    private function makeRequest($url) {
        $ch = curl_init();
        curl_setopt_array($ch, [
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_USERAGENT => $this->userAgent,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_MAXREDIRS => 3,
            CURLOPT_TIMEOUT => 10,
            CURLOPT_SSL_VERIFYPEER => false
        ]);
        
        $content = curl_exec($ch);
        $error = curl_error($ch);
        curl_close($ch);
        
        if ($error) {
            error_log("Wikipedia request error: " . $error);
            return false;
        }
        
        return $content;
    }
    
    private function isDuplicateImage($images, $newImage) {
        foreach ($images as $image) {
            if ($image['url'] === $newImage['url']) {
                return true;
            }
        }
        return false;
    }
    
    private function formatGalleryHTML($images) {
        $html = '<div class="card mb-4">';
        $html .= '<div class="card-body">';
        $html .= '<h5 class="card-title mb-3">Visual References from Wikipedia</h5>';
        $html .= '<div class="row g-2">';
        
        foreach ($images as $image) {
            $html .= '<div class="col">';
            $html .= '<div class="position-relative">';
            $html .= sprintf(
                '<img src="%s" class="img-fluid rounded" alt="%s" title="%s" style="height: 200px; width: 100%%; object-fit: cover;">',
                htmlspecialchars($image['url']),
                htmlspecialchars($image['alt']),
                htmlspecialchars($image['title'])
            );
            
            if ($image['title']) {
                $html .= '<div class="position-absolute bottom-0 start-0 w-100 p-2" style="background: rgba(0,0,0,0.5);">';
                $html .= sprintf('<small class="text-white">%s</small>', htmlspecialchars($image['title']));
                $html .= '</div>';
            }
            
            $html .= '</div>';
            $html .= '</div>';
        }
        
        $html .= '</div>';
        $html .= '<div class="mt-2 text-muted small">Images sourced from Wikipedia</div>';
        $html .= '</div>';
        $html .= '</div>';
        
        return $html;
    }
    
    private function generatePlaceholderGallery() {
        $html = '<div class="card mb-4">';
        $html .= '<div class="card-body">';
        $html .= '<h5 class="card-title mb-3">Visual References</h5>';
        $html .= '<div class="row g-2">';
        
        for ($i = 0; $i < 5; $i++) {
            $html .= '<div class="col">';
            $html .= sprintf(
                '<img src="/api/placeholder/400/320" class="img-fluid rounded" alt="placeholder" style="height: 200px; width: 100%%; object-fit: cover;">'
            );
            $html .= '</div>';
        }
        
        $html .= '</div>';
        $html .= '</div>';
        $html .= '</div>';
        
        return $html;
    }
}