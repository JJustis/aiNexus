<?php
function getDbConnection() {
    $host = 'localhost';
    $dbname = 'reservesphp2';
    $username = 'root';
    $password = '';

    try {
        $db = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
        $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $db;
    } catch (PDOException $e) {
        error_log('Database Connection Error: ' . $e->getMessage());
        throw $e;
    }
}
// submit_article.php
class ArticleSubmission {
    private $db;
    private $currentUser;

    public function __construct(PDO $db, $currentUser = null) {
        $this->db = $db;
        $this->currentUser = $currentUser ?? $this->getCurrentUser();
    }

    /**
     * Submit a new article
     */
    public function submitArticle($articleData) {
        try {
            // Validate input
            $this->validateArticleData($articleData);

            // Prepare article data for database
            $stmt = $this->db->prepare("
                INSERT INTO articles 
                (title, summary, content, topic, user_id, tags, confidence, ai_thoughts, created_at) 
                VALUES 
                (:title, :summary, :content, :topic, :user_id, :tags, :confidence, :ai_thoughts, NOW())
            ");

            // Generate AI thoughts if not provided
            $aiThoughts = $articleData['ai_thoughts'] ?? $this->generateAIThoughts($articleData);

           $stmt->execute([
    'title' => $articleData['title'],
    'summary' => $articleData['summary'] ?? $this->generateSummary($articleData['content']),
    'content' => $articleData['content'],
    'topic' => $articleData['topic'],
    'user_id' => $this->currentUser['user_id'] ?? null,
    'tags' => json_encode($articleData['tags'] ?? []),
    'confidence' => $this->calculateArticleConfidence($articleData),
    'ai_thoughts' => json_encode($aiThoughts)
]);

            // Get the ID of the newly inserted article
            $articleId = $this->db->lastInsertId();

            // Award experience points
            $this->awardExperiencePoints($articleId);

            return $articleId;
        } catch (Exception $e) {
            error_log('Article Submission Error: ' . $e->getMessage());
            throw $e;
        }
    }

    /**
     * Validate article submission data
     */
    private function validateArticleData($articleData) {
        if (empty($articleData['title'])) {
            throw new Exception("Article title is required");
        }

        if (empty($articleData['content'])) {
            throw new Exception("Article content cannot be empty");
        }

        if (strlen($articleData['content']) < 100) {
            throw new Exception("Article is too short. Minimum 100 characters required.");
        }
    }

    /**
     * Generate summary if not provided
     */
    private function generateSummary($content) {
        // Simple summary generation
        $sentences = preg_split('/(?<=[.!?])\s+/', $content, 3, PREG_SPLIT_NO_EMPTY);
        return implode(' ', array_slice($sentences, 0, 2));
    }

    /**
     * Generate AI thoughts about the article
     */
    private function generateAIThoughts($articleData) {
        $thoughts = [
            "Identified key themes and perspectives",
            "Analyzed potential impact of the article's content",
            "Recognized innovative insights"
        ];

        return $thoughts;
    }

    /**
     * Calculate article confidence
     */
private function calculateArticleConfidence($articleData) {
        // Basic confidence calculation
        $baseConfidence = 0.6; // Start with 60% base confidence

        // Increase confidence for longer content
        $contentLengthFactor = min(strlen($articleData['content']) / 1000, 0.2);

        // Increase confidence for articles with tags
        $tagsFactor = !empty($articleData['tags']) ? 0.1 : 0;

        return min($baseConfidence + $contentLengthFactor + $tagsFactor, 1.0);
    }

    /**
/**
 * Award experience points for article submission
 */
private function awardExperiencePoints($articleId) {
    if (!$this->currentUser) return;

    try {
        // Different XP for different article lengths
        $xpPoints = 50; // Default
        if (strlen($this->currentUser['content'] ?? '') < 500) {
            $xpPoints = 10;
        } elseif (strlen($this->currentUser['content'] ?? '') < 1000) {
            $xpPoints = 25;
        }

        $stmt = $this->db->prepare("
            UPDATE users 
            SET exp_points = exp_points + :xp_points 
            WHERE user_id = :user_id
        ");

        $stmt->execute([
            'xp_points' => $xpPoints,
            'user_id' => $this->currentUser['user_id']
        ]);

        // Log article contribution
        $this->logArticleContribution($articleId, $xpPoints);
    } catch (Exception $e) {
        error_log('XP Award Error: ' . $e->getMessage());
    }
}

    /**
     * Log article contribution for tracking
     */
    private function logArticleContribution($articleId, $xpPoints) {
        try {
            $stmt = $this->db->prepare("
                INSERT INTO user_contributions 
                (user_id, article_id, contribution_type, xp_earned, created_at) 
                VALUES 
                (:user_id, :article_id, 'article_submission', :xp_points, NOW())
            ");

            $stmt->execute([
                'user_id' => $this->currentUser['user_id'],
                'article_id' => $articleId,
                'xp_points' => $xpPoints
            ]);
        } catch (Exception $e) {
            error_log('Contribution Logging Error: ' . $e->getMessage());
        }
    }

    /**
     * Get current logged-in user
     */
    private function getCurrentUser() {
        // Implement session-based or token-based user retrieval
        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }

        if (isset($_SESSION['user_id'])) {
            try {
                $stmt = $this->db->prepare("
                    SELECT user_id, username, email 
                    FROM users 
                    WHERE user_id = :user_id
                ");
                $stmt->execute(['user_id' => $_SESSION['user_id']]);
                return $stmt->fetch(PDO::FETCH_ASSOC);
            } catch (Exception $e) {
                error_log('User Retrieval Error: ' . $e->getMessage());
                return null;
            }
        }

        return null;
    }
}

// Handle Article Submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    try {
        $db = getDbConnection();
        $articleSubmission = new ArticleSubmission($db);

        // Submit the article and get its ID
        $articleId = $articleSubmission->submitArticle($input);

        // Respond with success and article ID
        echo json_encode([
            'success' => true,
            'articleId' => $articleId,
            'message' => 'Article submitted successfully!'
        ]);
    } catch (Exception $e) {
        // Handle submission errors
        http_response_code(400);
        echo json_encode([
            'success' => false,
            'message' => $e->getMessage()
        ]);
    }
    exit;
}
?>