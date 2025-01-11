<?php
session_start();
require_once 'database_connection.php';
header('Content-Type: text/html; charset=UTF-8');
class ArticleDisplay {
    private $db;

    public function __construct($db) {
        $this->db = $db;
    }

    public function getArticleDetails($articleId) {
    try {
        // Log the full input
        error_log("Full Article ID Input: " . $articleId);

        // Split the input by the last hyphen to separate the ID
        $lastHyphenPos = strrpos($articleId, '-');
        
        if ($lastHyphenPos === false) {
            throw new Exception("Invalid article ID format: " . $articleId);
        }

        // Extract similarity score (everything before the last hyphen)
        $similarityScore = intval(substr($articleId, 0, $lastHyphenPos));
        
        // Extract URL-friendly title (everything after the last hyphen)
        $urlTitle = substr($articleId, $lastHyphenPos + 1);
        
        error_log("Parsed Details - Similarity Score: {$similarityScore}, URL Title: {$urlTitle}");

        // Find article by URL-friendly title
        $stmt = $this->db->prepare("
            SELECT a.*, 
                   u.username AS author_name, 
                   COALESCE((
                       SELECT COUNT(*) 
                       FROM comments c 
                       WHERE c.article_id = a.article_id
                   ), 0) AS comment_count
            FROM articles a
            LEFT JOIN users u ON a.user_id = u.user_id
            WHERE LOWER(REPLACE(REPLACE(a.title, ' ', '-'), '[^a-zA-Z0-9-]', '')) = :url_title
        ");
        
        $stmt->execute(['url_title' => strtolower($urlTitle)]);
        $article = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$article) {
            // Fallback: try partial match
            $stmt = $this->db->prepare("
                SELECT a.*, 
                       u.username AS author_name, 
                       COALESCE((
                           SELECT COUNT(*) 
                           FROM comments c 
                           WHERE c.article_id = a.article_id
                       ), 0) AS comment_count
                FROM articles a
                LEFT JOIN users u ON a.user_id = u.user_id
                WHERE a.title LIKE :title_like
            ");
            
            $stmt->execute(['title_like' => '%' . str_replace('-', ' ', $urlTitle) . '%']);
            $article = $stmt->fetch(PDO::FETCH_ASSOC);
        }

        if (!$article) {
            error_log("No article found for URL title: " . $urlTitle);
            throw new Exception("Article not found. URL Title: " . $urlTitle);
        }

        // Fetch related articles
        $relatedArticles = $this->fetchRelatedArticles($article['article_id'], $article['topic'] ?? 'general');

        // Safely decode AI thoughts
        $thoughts = json_decode($article['ai_thoughts'] ?? '[]', true);
        if (json_last_error() !== JSON_ERROR_NONE) {
            error_log("JSON decoding error for AI thoughts: " . json_last_error_msg());
            $thoughts = [];
        }

    $commentStmt = $this->db->prepare("
        SELECT c.*, u.username
        FROM comments c
        LEFT JOIN users u ON c.user_id = u.user_id
        WHERE c.article_id = :article_id
        ORDER BY c.created_at DESC
    ");
    $commentStmt->execute(['article_id' => $article['article_id']]);
    $comments = $commentStmt->fetchAll(PDO::FETCH_ASSOC);

    return [
        'article' => $article,
        'related_articles' => $relatedArticles,
        'ai_thoughts' => $thoughts,
        'similarity_score' => $similarityScore,
        'comments' => $comments // Add comments to the returned data
    ];
    } catch (Exception $e) {
        // Log the full error details
        error_log('Article Retrieval Error: ' . $e->getMessage());
        error_log('Full Error Trace: ' . $e->getTraceAsString());
        
        // Rethrow to be caught in the main script
        throw $e;
    }
}

    private function fetchRelatedArticles($currentArticleId, $topic) {
        try {
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
        } catch (Exception $e) {
            error_log('Related Articles Fetch Error: ' . $e->getMessage());
            return []; // Return empty array instead of throwing
        }
    }
}

// Database connection and article retrieval
try {
    // Establish database connection
    $db = new PDO('mysql:host=localhost;dbname=reservesphp2', 'root', '', [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);

    $articleDisplay = new ArticleDisplay($db);
    
    // Get article ID from URL
    $articleId = isset($_GET['artid']) ? $_GET['artid'] : null;

    // Extensive logging and validation
    error_log("Received Article ID: " . print_r($articleId, true));

    if (!$articleId) {
        // If no article ID, fetch the first article
        $stmt = $db->query("SELECT article_id FROM articles ORDER BY article_id LIMIT 1");
        $firstArticle = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($firstArticle) {
            $articleId = $firstArticle['article_id'];
            error_log("No article ID provided. Using first article ID: " . $articleId);
        } else {
            throw new Exception("No articles found in the database");
        }
    }

    $articleData = $articleDisplay->getArticleDetails($articleId);
    $comments = $articleData['comments']; // Add this line here

    // If we reach here, article was successfully retrieved
} catch (Exception $e) {
    // Log the full error details
    error_log('Article Page Critical Error: ' . $e->getMessage());
    error_log('Full Error Trace: ' . $e->getTraceAsString());

    // Redirect to error page with detailed message
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
				<div class="article-tags mb-4">
    <?php
    $tags = json_decode($articleData['article']['tags'], true);
    foreach ($tags as $tag) {
        echo '<span class="badge bg-primary me-2">' . htmlspecialchars($tag) . '</span>';
    }
    ?>
</div>
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
							<div class="comments-section mt-5">
    <h4 class="mb-4">Comments</h4>
    <?php foreach ($comments as $comment): ?>
        <div class="comment mb-4">
            <div class="d-flex align-items-center mb-2">
                <strong><?php echo htmlspecialchars($comment['username']); ?></strong>
                <span class="text-muted ms-2"><?php echo date('F j, Y', strtotime($comment['created_at'])); ?></span>
            </div>
            <p><?php echo htmlspecialchars($comment['content']); ?></p>
            <div class="d-flex align-items-center">
                <button class="btn btn-sm btn-outline-primary me-2" onclick="voteComment(<?php echo $comment['comment_id']; ?>, 'up')">
                    <i class="bi bi-arrow-up"></i> Upvote
                </button>
                <button class="btn btn-sm btn-outline-secondary me-2" onclick="voteComment(<?php echo $comment['comment_id']; ?>, 'down')">
                    <i class="bi bi-arrow-down"></i> Downvote
                </button>
                <span class="text-muted"><?php echo $comment['votes']; ?> votes</span>
            </div>
        </div>
    <?php endforeach; ?>

    <h5 class="mt-5 mb-3">Leave a Comment</h5>
    <form id="commentForm" onsubmit="submitComment(event)">
        <div class="mb-3">
            <label for="commentName" class="form-label">Name</label>
            <input type="text" class="form-control" id="commentName" required>
        </div>
        <div class="mb-3">
            <label for="commentEmail" class="form-label">Email</label>
            <input type="email" class="form-control" id="commentEmail" required>
        </div>
        <div class="mb-3">
            <label for="commentContent" class="form-label">Comment</label>
            <textarea class="form-control" id="commentContent" rows="4" required></textarea>
        </div>
        <button type="submit" class="btn btn-primary">Submit Comment</button>
    </form>
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

      <?php
    $articleCount = 0;
    $patternCount = 0;
    $topUsers = [];

    try {
        $tableCheck = $db->query("SHOW TABLES LIKE 'articles'");
        if ($tableCheck->rowCount() > 0) {
            $articleQuery = $db->query("SELECT COUNT(*) FROM articles");
            if ($articleQuery) {
                $articleCount = $articleQuery->fetchColumn();
            }
        }

        $tableCheck = $db->query("SHOW TABLES LIKE 'training_patterns'");
        if ($tableCheck->rowCount() > 0) {
            $patternQuery = $db->query("SELECT COUNT(*) FROM training_patterns");
            if ($patternQuery) {
                $patternCount = $patternQuery->fetchColumn();
            }
        }

        $tableCheck = $db->query("SHOW TABLES LIKE 'users'");
        if ($tableCheck->rowCount() > 0) {
            $userQuery = $db->query("SELECT username, exp_points as exp FROM users ORDER BY exp_points DESC LIMIT 3");
            if ($userQuery) {
                $topUsers = $userQuery->fetchAll(PDO::FETCH_ASSOC);
            }
        }
    } catch (PDOException $e) {
        error_log($e->getMessage());
    }
    ?>

    <footer class="dark-footer">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h3 class="h5 mb-3">AI Learning Stats</h3>
                    <ul class="list-unstyled">
                        <li class="mb-2">
                            <i class="bi bi-book me-2"></i>
                            Articles Generated: <?php echo $articleCount; ?>
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-brain me-2"></i>
                            Language Patterns Learned: <?php echo $patternCount; ?>
                        </li>
                    </ul>
                </div>
                <div class="col-md-4">
                    <h3 class="h5 mb-3">Top Contributors</h3>
                    <ul class="list-unstyled">
                        <?php if (!empty($topUsers)): ?>
                            <?php foreach ($topUsers as $user): ?>
                                <li class="mb-2"><?php echo htmlspecialchars($user['username']); ?> - <?php echo $user['exp']; ?> XP</li>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <li class="mb-2">No users yet</li>
                        <?php endif; ?>
                    </ul>
                </div>
                <div class="col-md-4">
                    <h3 class="h5 mb-3">System Status</h3>
                    <div>
                        <p class="mb-2">
                            <span class="status-indicator"></span>
                            AI Learning System: Active
                        </p>
                        <p class="mb-2">
                            <span class="status-indicator"></span>
                            News Generation: Running
                        </p>
                    </div>
                </div>
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