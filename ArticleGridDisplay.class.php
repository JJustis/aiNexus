<?php
// ArticleGridDisplay.class.php
class ArticleGridDisplay {
    private $db;
    private $languageProcessor;

    public function __construct($db, $languageProcessor) {
        $this->db = $db;
        $this->languageProcessor = $languageProcessor;
    }

    public function generateGrid($page = 0) {
        $articles = $this->fetchArticleBatch($page);
        return $this->formatGridLayout($articles);
    }

    private function fetchArticleBatch($page) {
        $limit = 12; // 4x3 grid
        $offset = $page * $limit;
        
        $stmt = $this->db->prepare("
            SELECT * FROM articles 
            ORDER BY created_at DESC 
            LIMIT ? OFFSET ?
        ");
        $stmt->execute([$limit, $offset]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    private function formatGridLayout($articles) {
        $html = '<div class="article-grid" data-page="' . $page . '">';
        foreach (array_chunk($articles, 4) as $row) {
            $html .= $this->generateGridRow($row);
        }
        $html .= '</div>';
        return $html;
    }

    private function generateGridRow($articles) {
        $html = '<div class="grid-row">';
        foreach ($articles as $article) {
            $html .= $this->generateArticleCard($article);
        }
        $html .= '</div>';
        return $html;
    }

    private function generateArticleCard($article) {
        return '
        <div class="article-card" data-id="' . $article['id'] . '">
            <div class="card-img-top">
                <img src="' . $article['image_url'] . '" alt="Article image">
            </div>
            <div class="card-body">
                <h5 class="card-title">' . htmlspecialchars($article['title']) . '</h5>
                <p class="card-summary">' . htmlspecialchars($article['summary']) . '</p>
                <div class="word-relationships">
                    ' . $this->generateWordConnections($article) . '
                </div>
                <div class="learning-controls">
                    <button class="btn-train" onclick="trainOnArticle(' . $article['id'] . ')">Train AI</button>
                    <button class="btn-correct" onclick="showCorrection(' . $article['id'] . ')">Correct</button>
                </div>
            </div>
        </div>';
    }

    private function generateWordConnections($article) {
        $connections = $this->languageProcessor->analyzeSentence($article['title']);
        $html = '<div class="word-web">';
        foreach ($connections as $word => $related) {
            $html .= $this->visualizeWordConnection($word, $related);
        }
        $html .= '</div>';
        return $html;
    }
}