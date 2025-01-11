<?php
session_start();
require_once 'database_connection.php'; // Assuming you have a central DB connection file

class ArticleDisplay {
    private $db;

    public function __construct($db) {
        $this->db = $db;
    }

    public function getArticleDetails($articleId) {
        try {
            // Extract similarity score and clean article ID
            $parts = explode('-', $articleId);
            $similarityScore = intval($parts[0]);
            $cleanId = isset($parts[1]) ? intval($parts[1]) : 0;

            // Fetch article details
            $stmt = $this->db->prepare("
                SELECT a.*, 
                       u.username AS author_name, 
                       COUNT(c.comment_id) AS comment_count
                FROM articles a
                LEFT JOIN users u ON a.user_id = u.user_id
                LEFT JOIN comments c ON a.article_id = c.article_id
                WHERE a.article_id = :article_id
                GROUP BY a.article_id
            ");
            $stmt->execute(['article_id' => $cleanId]);
            $article = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$article) {
                throw new Exception("Article not found");
            }

            // Fetch related articles
            $relatedArticles = $this->fetchRelatedArticles($cleanId, $article['topic']);

            // Fetch AI thoughts
            $thoughts = json_decode($article['ai_thoughts'] ?? '[]', true);

            return [
                'article' => $article,
                'related_articles' => $relatedArticles,
                'ai_thoughts' => $thoughts,
                'similarity_score' => $similarityScore
            ];
        } catch (Exception $e) {
            error_log('Article Fetch Error: ' . $e->getMessage());
            return null;
        }
    }

    private function fetchRelatedArticles($currentArticleId, $topic) {
        $stmt = $this->db->prepare("
            SELECT article_id, title, summary 
            FROM articles 
            WHERE topic = :topic AND article_id != :current_id 
            LIMIT 3
        ");
        $stmt->execute([
            'topic' => $topic,
            'current_id' => $currentArticleId
        ]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}

// Database connection
try {
    $db = new PDO('mysql:host=localhost;dbname=reservesphp2', 'root', '', [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);

    $articleDisplay = new ArticleDisplay($db);
    
    // Get article ID from URL
    $articleId = isset($_GET['artid']) ? $_GET['artid'] : null;

    if (!$articleId) {
        throw new Exception("No article ID provided");
    }

    $articleData = $articleDisplay->getArticleDetails($articleId);

    if (!$articleData) {
        throw new Exception("Could not retrieve article details");
    }
} catch (Exception $e) {
    error_log('Article Page Error: ' . $e->getMessage());
    // Redirect to error page or show error message
    header("Location: index2.php?error=" . urlencode($e->getMessage()));
    exit();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($articleData['article']['title']); ?> - AI News Nexus</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        /* Inherit styles from index2.php */
        <?php include 'article_styles.css'; ?>
    </style>
</head>
<body class="bg-light">
    <header class="gradient-header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="display-4 fw-bold">AI News Nexus</h1>
                    <p class="text-blue-100">News generated and curated by artificial intelligence</p>
                </div>
                <div class="bg-white bg-opacity-25 rounded p-3">
                    <span class="d-block">Experience Points</span>
                    <div class="fs-4 fw-bold exp-points">
                        <?php echo isset($_SESSION['exp']) ? $_SESSION['exp'] : 0; ?> XP
                    </div>
                </div>
            </div>
        </div>
    </header>

    <main class="container py-4">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="article-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h1 class="h2 mb-0"><?php echo htmlspecialchars($articleData['article']['title']); ?></h1>
                        <div class="text-muted d-flex flex-column align-items-end">
                            <span>Confidence: <?php echo number_format($articleData['article']['confidence'] * 100, 1); ?>%</span>
                            <small class="text-info">Similarity: <?php echo $articleData['similarity_score']; ?>%</small>
                        </div>
                    </div>
                    
                    <p class="lead text-muted mb-4">
                        <?php echo htmlspecialchars($articleData['article']['summary']); ?>
                    </p>

                    <div class="article-content mb-4">
                        <?php echo nl2br(htmlspecialchars($articleData['article']['content'])); ?>
                    </div>

                    <div class="ai-thoughts">
                        <h3 class="h6 text-purple-700 mb-2">AI Thought Process</h3>
                        <?php foreach ($articleData['ai_thoughts'] as $thought): ?>
                            <div class="d-flex align-items-center mb-2">
                                <i class="bi bi-brain me-2"></i>
                                <span class="text-purple-600">
                                    <?php echo htmlspecialchars($thought); ?>
                                </span>
                            </div>
                        <?php endforeach; ?>
                    </div>

                    <div class="article-metadata mt-4">
                        <div class="row">
                            <div class="col-md-6">
                                <p class="text-muted mb-1">
                                    <i class="bi bi-person me-2"></i>
                                    Author: <?php echo htmlspecialchars($articleData['article']['author_name'] ?? 'AI Generated'); ?>
                                </p>
                                <p class="text-muted">
                                    <i class="bi bi-calendar me-2"></i>
                                    Published: <?php echo date('F j, Y', strtotime($articleData['article']['created_at'])); ?>
                                </p>
                            </div>
                            <div class="col-md-6 text-md-end">
                                <p class="text-muted mb-1">
                                    <i class="bi bi-chat me-2"></i>
                                    Comments: <?php echo intval($articleData['article']['comment_count']); ?>
                                </p>
                                <p class="text-muted">
                                    <i class="bi bi-tag me-2"></i>
                                    Topic: <?php echo htmlspecialchars($articleData['article']['topic']); ?>
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="feedback-section mt-4">
                        <h4 class="mb-3">Article Feedback</h4>
                        <div class="btn-group">
                            <button class="btn btn-outline-success btn-sm" 
                                onclick="provideFeedback('accurate', <?php echo $articleData['article']['article_id']; ?>)">
                                <i class="bi bi-check-circle"></i> Accurate
                            </button>
                            <button class="btn btn-outline-danger btn-sm" 
                                onclick="provideFeedback('inaccurate', <?php echo $articleData['article']['article_id']; ?>)">
                                <i class="bi bi-x-circle"></i> Inaccurate
                            </button>
                            <button class="btn btn-outline-primary btn-sm" 
                                onclick="showEditForm(<?php echo $articleData['article']['article_id']; ?>)">
                                <i class="bi bi-pencil"></i> Edit
                            </button>
                        </div>
                    </div>
                </div>

                <?php if (!empty($articleData['related_articles'])): ?>
                    <div class="related-articles mt-4">
                        <h3 class="mb-3">Related Articles</h3>
                        <div class="row">
                            <?php foreach ($articleData['related_articles'] as $relatedArticle): ?>
                                <div class="col-md-4">
                                    <div class="card mb-3">
                                        <div class="card-body">
                                            <h5 class="card-title"><?php echo htmlspecialchars($relatedArticle['title']); ?></h5>
                                            <p class="card-text"><?php echo htmlspecialchars($relatedArticle['summary']); ?></p>
                                            <a href="article.php?artid=50-<?php echo strtolower(preg_replace(['/[^a-zA-Z0-9\s]/', '/\s+/'], ['', '-'], $relatedArticle['title'])); ?>" 
                                               class="btn btn-sm btn-outline-primary">
                                                Read More
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            <?php endforeach; ?>
                        </div>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </main>

    <footer class="dark-footer">
        <div class="container">
            <div class="text-center">
                <p>&copy; 2024 AI News Nexus. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        function provideFeedback(type, articleId) {
            fetch('handle_feedback.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    articleId: articleId,
                    feedbackType: type
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.querySelector('.exp-points').textContent = data.newExp + ' XP';
                    alert(`Feedback submitted successfully! Earned ${data.expGained} XP`);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred while submitting feedback');
            });
        }

        function showEditForm(articleId) {
            // Implement edit form logic similar to index2.php
            alert('Edit functionality to be implemented');
        }
    </script>
</body>
</html>