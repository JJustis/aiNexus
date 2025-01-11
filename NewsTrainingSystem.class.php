<?php
class NewsTrainingSystem {
    private $db;
    
    public function __construct($db_connection) {
        $this->db = $db_connection;
    }

    public function saveFeedback($articleId, $userId, $feedback, $correctionText = null) {
        try {
            // Start transaction
            $this->db->beginTransaction();
            
            // Save the feedback
            $stmt = $this->db->prepare("
                INSERT INTO feedback 
                (article_id, user_id, feedback_type, created_at) 
                VALUES (?, ?, ?, NOW())
            ");
            $stmt->execute([$articleId, $userId, $feedback]);
            
            // If correction provided, save it
            if ($correctionText) {
                $stmt = $this->db->prepare("
                    INSERT INTO corrections 
                    (article_id, user_id, correction_text, status) 
                    VALUES (?, ?, ?, 'pending')
                ");
                $stmt->execute([$articleId, $userId, $correctionText]);
            }

            // Extract and save word patterns from correction
            if ($correctionText) {
                $this->processWordPatterns($correctionText);
            }

            // Update user experience points
            $expPoints = $this->calculateExpPoints($feedback, $correctionText);
            $stmt = $this->db->prepare("
                UPDATE users 
                SET exp_points = exp_points + ? 
                WHERE user_id = ?
            ");
            $stmt->execute([$expPoints, $userId]);

            $this->db->commit();
            return true;

        } catch (Exception $e) {
            $this->db->rollBack();
            error_log("Error in saveFeedback: " . $e->getMessage());
            return false;
        }
    }

    private function processWordPatterns($text) {
        // Split text into words
        $words = str_word_count(strtolower($text), 1);
        
        // Process word pairs for pattern recognition
        for ($i = 0; $i < count($words) - 1; $i++) {
            $currentWord = $words[$i];
            $nextWord = $words[$i + 1];
            
            // Store word relationship
            $stmt = $this->db->prepare("
                INSERT INTO word_relationships (word, related_words, occurrence_count)
                VALUES (?, ?, 1)
                ON DUPLICATE KEY UPDATE 
                related_words = JSON_ARRAY_APPEND(
                    COALESCE(related_words, JSON_ARRAY()), 
                    '$', 
                    ?
                ),
                occurrence_count = occurrence_count + 1
            ");
            $stmt->execute([$currentWord, json_encode([$nextWord]), $nextWord]);
        }
    }

    private function calculateExpPoints($feedback, $correctionText) {
        $points = 0;
        
        // Base points for feedback
        switch($feedback) {
            case 'upvote':
                $points += 10;
                break;
            case 'downvote':
                $points += 5;
                break;
        }
        
        // Additional points for corrections
        if ($correctionText) {
            // Points based on correction length and quality
            $words = str_word_count($correctionText);
            $points += min(50, $words * 2); // Cap at 50 points
        }
        
        return $points;
    }

    public function getTrainingData() {
        $stmt = $this->db->query("
            SELECT 
                a.article_id,
                a.title,
                a.content,
                f.feedback_type,
                c.correction_text,
                wr.word,
                wr.related_words
            FROM articles a
            LEFT JOIN feedback f ON a.article_id = f.article_id
            LEFT JOIN corrections c ON a.article_id = c.article_id
            LEFT JOIN word_relationships wr ON 
                JSON_CONTAINS(a.content, wr.word, '$')
            ORDER BY a.created_at DESC
            LIMIT 100
        ");
        
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}

// Example usage in your main page:
/*
$trainingSystem = new NewsTrainingSystem($db);

// Save feedback
if ($_POST['action'] === 'feedback') {
    $trainingSystem->saveFeedback(
        $_POST['article_id'],
        $_SESSION['user_id'],
        $_POST['feedback_type'],
        $_POST['correction'] ?? null
    );
}

// Get training data for AI
$trainingData = $trainingSystem->getTrainingData();
*/
?>