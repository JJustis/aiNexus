<?php
require_once 'advanced_article_generator.php';
session_start();

define('ADMIN_PASSWORD', '12345');

function getWordsDb() {
    try {
        return new PDO('mysql:host=localhost;dbname=reservesphp', 'root', '', [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
        ]);
    } catch (PDOException $e) {
        die("Words database connection failed: " . $e->getMessage());
    }
}

function getArticlesDb() {
    try {
        return new PDO('mysql:host=localhost;dbname=reservesphp2', 'root', '', [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
        ]);
    } catch (PDOException $e) {
        die("Articles database connection failed: " . $e->getMessage());
    }
}

if (isset($_SESSION['admin_logged_in']) && $_SESSION['admin_logged_in'] === true) {
    $showAdminContent = true;
} else {
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'login') {
        if ($_POST['password'] === ADMIN_PASSWORD) {
            $_SESSION['admin_logged_in'] = true;
            $showAdminContent = true;
        } else {
            $loginError = "Invalid password";
            $showAdminContent = false;
        }
    } else {
        $showAdminContent = false;
    }
}

try {
    $wordsDb = getWordsDb();
    $articlesDb = getArticlesDb();
} catch (PDOException $e) {
    die("Database connection failed: " . $e->getMessage());
}

function generateArticle($articlesDb, $wordsDb) {
    try {
        $stmt = $wordsDb->query("
            SELECT * FROM word 
            WHERE definition IS NOT NULL 
            ORDER BY RAND() LIMIT 1
        ");
        $wordData = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if (!$wordData) {
            throw new Exception("No suitable words found in database");
        }

        $dictionaryDef = [
            'word' => $wordData['word'],
            'type' => $wordData['type'] ?? $wordData['part_of_speech'],
            'definition' => $wordData['definition'],
            'usage_example' => $wordData['usage_example'],
            'etymology' => $wordData['etymology'],
            'synonyms' => $wordData['synonyms'],
            'antonyms' => $wordData['antonyms']
        ];

        $wikiContent = $wordData['wiki'] ? [
            'Overview' => $wordData['definition'],
            'Etymology' => $wordData['etymology'],
            'Usage' => $wordData['usage_example'],
            'Related Concepts' => $wordData['related_word'],
            'Additional Information' => $wordData['wiki']
        ] : generateWikipediaContent($wordData['word'], $wordData['related_word']);

        $content = generateMainContent($wordData);
        $title = "Understanding " . ucfirst($wordData['word']) . ": A " . ucfirst($wordData['type'] ?? 'Comprehensive') . " Analysis";
        $summary = substr(strip_tags($wordData['definition']), 0, 200) . "...";
        $tags = generateTags($wordData);
        $thoughts = [
            "Analyzing " . $wordData['word'] . " (" . ($wordData['part_of_speech'] ?? $wordData['type']) . ")",
            "Difficulty level: " . $wordData['difficulty_level'],
            "Found related words: " . $wordData['related_word'],
            "Identified topic: " . $wordData['related_topic'],
            "Analyzed etymology and history",
            "Evaluating usage frequency: " . $wordData['frequency']
        ];

        $stmt = $articlesDb->prepare("
            INSERT INTO articles (
                title, content, dictionary_definition, wikipedia_excerpt,
                encyclopedia_link, summary, topic, tags, created_at,
                ai_thoughts, confidence
            ) VALUES (
                :title, :content, :dict_def, :wiki_excerpt,
                :enc_link, :summary, :topic, :tags, NOW(),
                :thoughts, :confidence
            )
        ");

        $stmt->execute([
            'title' => $title,
            'content' => $content,
            'dict_def' => json_encode($dictionaryDef),
            'wiki_excerpt' => json_encode($wikiContent),
            'enc_link' => "https://www.britannica.com/search?query=" . urlencode($wordData['word']),
            'summary' => $summary,
            'topic' => $wordData['related_topic'] ?? determineTopicFromWord($wordData['word']),
            'tags' => json_encode($tags),
            'thoughts' => json_encode($thoughts),
            'confidence' => calculateConfidence($wordData['difficulty_level'])
        ]);

        return "Article generated successfully for '{$wordData['word']}'!";
    } catch (Exception $e) {
        return "Error generating article: " . $e->getMessage();
    }
}

function generateMainContent($wordData) {
    $content = "# " . ucfirst($wordData['word']) . "\n\n";
    $content .= "## Introduction\n";
    $content .= $wordData['definition'] . "\n\n";
    
    if ($wordData['etymology']) {
        $content .= "## Etymology\n";
        $content .= $wordData['etymology'] . "\n\n";
    }
    
    if ($wordData['usage_example']) {
        $content .= "## Usage Examples\n";
        $content .= $wordData['usage_example'] . "\n\n";
    }
    
    if ($wordData['synonyms'] || $wordData['antonyms'] || $wordData['opposite']) {
        $content .= "## Related Words\n";
        if ($wordData['synonyms']) $content .= "### Synonyms\n" . $wordData['synonyms'] . "\n\n";
        if ($wordData['antonyms']) $content .= "### Antonyms\n" . $wordData['antonyms'] . "\n\n";
        if ($wordData['opposite']) $content .= "### Opposites\n" . $wordData['opposite'] . "\n\n";
    }
    
    if ($wordData['wiki']) {
        $content .= "## Additional Information\n";
        $content .= $wordData['wiki'] . "\n\n";
    }
    
    return $content;
}

function generateWikipediaContent($word, $relatedWords) {
    return [
        'Overview' => "An exploration of $word and its significance.",
        'Related Concepts' => "Related terms include: $relatedWords",
        'Applications' => "Various applications and uses of $word in different contexts."
    ];
}

function generateTags($wordData) {
    $tags = [$wordData['word']];
    
    if ($wordData['related_word']) {
        $relatedWords = explode(',', $wordData['related_word']);
        $tags = array_merge($tags, array_slice($relatedWords, 0, 3));
    }
    
    if ($wordData['type']) $tags[] = $wordData['type'];
    if ($wordData['related_topic']) $tags[] = $wordData['related_topic'];
    
    return array_unique(array_map('trim', $tags));
}

function determineTopicFromWord($word) {
    $topics = ['technology', 'science', 'economics', 'business', 'culture', 'history'];
    return $topics[array_rand($topics)];
}

function calculateConfidence($difficulty) {
    switch ($difficulty) {
        case 'basic': return rand(85, 95) / 100;
        case 'intermediate': return rand(75, 85) / 100;
        case 'advanced': return rand(65, 75) / 100;
        default: return rand(70, 90) / 100;
    }
}

if ($showAdminContent && $_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['action'])) {
        switch ($_POST['action']) {
            case 'generate_article':
                $message = generateArticle($articlesDb, $wordsDb);
                break;
            case 'logout':
                session_destroy();
                header('Location: admin.php');
                exit;
                break;
        }
    }
}
function generateAdvancedArticle($articlesDb, $wordsDb, $type, $options = []) {
    $generator = new AdvancedArticleGenerator($wordsDb, $articlesDb);
    return $generator->generateArticle($type, $options);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI News Nexus - Admin</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .admin-header {
            background: linear-gradient(to right, #1a237e, #311b92);
            color: white;
            padding: 2rem 0;
        }
        .stats-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .ai-status {
            background: #f3f0ff;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        .dark-footer {
            background-color: #1f2937;
            color: white;
            padding: 2rem 0;
            margin-top: 3rem;
        }
        .status-indicator {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background-color: #34d399;
            display: inline-block;
            margin-right: 0.5rem;
        }
    </style>
</head>
<body class="bg-light">
    <?php if (!$showAdminContent): ?>
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0 text-center">Admin Access</h4>
                        </div>
                        <div class="card-body">
                            <?php if (isset($loginError)): ?>
                                <div class="alert alert-danger"><?php echo $loginError; ?></div>
                            <?php endif; ?>
                            <form method="POST">
                                <input type="hidden" name="action" value="login">
                                <div class="mb-3">
                                    <input type="password" class="form-control" name="password" placeholder="Enter Password" required>
                                </div>
                                <button type="submit" class="btn btn-primary w-100">Login</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <?php else: ?>
        <header class="admin-header">
            <div class="container">
                <div class="d-flex justify-content-between align-items-center">
                    <h1><i class="bi bi-gear"></i> AI News Nexus Admin</h1>
                    <form method="POST" class="d-inline">
                        <input type="hidden" name="action" value="logout">
                        <button type="submit" class="btn btn-light">Logout</button>
                    </form>
                </div>
            </div>
        </header>

        <main class="container py-4">
            <?php if (isset($message)): ?>
                <div class="alert alert-info"><?php echo $message; ?></div>
            <?php endif; ?>

            <div class="row">
                <div class="col-md-8">
                    <div class="card mb-4">
                        <div class="card-header">
                            <h4 class="mb-0">Article Generation</h4>
                        </div>
                        <div class="card mb-4">
    <div class="card-header">
        <h4 class="mb-0">Advanced Article Generation</h4>
    </div>
    <div class="card-body">
        <form method="POST" id="advanced-article-form">
            <input type="hidden" name="action" value="generate_advanced_article">
            
            <div class="mb-3">
                <label class="form-label">Article Type</label>
                <select name="article_type" class="form-control" id="article-type-selector">
                    <option value="term_article">Term Article</option>
                    <option value="trending_article">Trending Article</option>
                    <option value="rss_synthesized_article">RSS Synthesized Article</option>
                </select>
            </div>

            <div id="term-article-options" class="article-options">
                <div class="mb-3">
                    <label class="form-label">Specific Word (Optional)</label>
                    <input type="text" name="word" class="form-control" placeholder="Leave blank for random word">
                </div>
            </div>

            <div id="trending-article-options" class="article-options" style="display:none;">
                <p class="text-muted">Automatically selects trending words from RSS feeds</p>
            </div>


                <div id="rss-article-options" class="article-options" style="display:none;">
    <div class="mb-3">
        <label class="form-label">RSS Category</label>
        <select name="rss_category" class="form-control">
            <option value="technology">Technology</option>
            <option value="science">Science</option>
            <option value="business">Business</option>
            <option value="world_news">World News</option>
            <option value="entertainment">Entertainment</option>
            <option value="sports">Sports</option>
            <option value="health">Health</option>
            <option value="technology_reviews">Technology Reviews</option>
            <option value="environment">Environment</option>
            <option value="finance">Finance</option>
        </select>
    </div>
            </div>

            <button type="submit" class="btn btn-primary">
                <i class="bi bi-magic"></i> Generate Advanced Article
            </button>
        </form>
    </div>
</div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h4 class="mb-0">Recent Articles</h4>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                            <th>Topic</th>
                                            <th>Created</th>
                                            <th>Confidence</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php
                                        $articles = $articlesDb->query("SELECT * FROM articles ORDER BY created_at DESC LIMIT 10")->fetchAll();
                                        foreach ($articles as $article):
                                        ?>
                                        <tr>
                                            <td><?php echo htmlspecialchars($article['title']); ?></td>
                                            <td><?php echo htmlspecialchars($article['topic']); ?></td>
                                            <td><?php echo date('Y-m-d', strtotime($article['created_at'])); ?></td>
                                            <td><?php echo number_format($article['confidence'] * 100, 1); ?>%</td>
                                            <!-- Update the table buttons -->
<td>
    <button class="btn btn-sm btn-outline-primary" onclick="showEditModal(<?php echo htmlspecialchars(json_encode($article)); ?>)">
        <i class="bi bi-pencil"></i> Edit
    </button>
    <button class="btn btn-sm btn-outline-danger" onclick="confirmDelete(<?php echo $article['article_id']; ?>)">
        <i class="bi bi-trash"></i> Delete
    </button>
</td>

<!-- Add this modal HTML after the table -->
<div class="modal fade" id="editArticleModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Article</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="editArticleForm">
                    <input type="hidden" id="editArticleId">
                    <div class="mb-3">
                        <label class="form-label">Title</label>
                        <input type="text" class="form-control" id="editTitle" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Topic</label>
                        <select class="form-control" id="editTopic" required>
                            <option value="technology">Technology</option>
                            <option value="science">Science</option>
                            <option value="economics">Economics</option>
                            <option value="business">Business</option>
                            <option value="culture">Culture</option>
                            <option value="history">History</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Summary</label>
                        <textarea class="form-control" id="editSummary" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Content</label>
                        <textarea class="form-control" id="editContent" rows="10" required></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="saveArticle()">Save Changes</button>
            </div>
        </div>
    </div>
</div>
                                        </tr>
                                        <?php endforeach; ?>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="ai-status">
                        <h5><i class="bi bi-cpu"></i> AI System Status</h5>
                        <div class="mb-2">
                            <small class="text-muted">Learning Rate:</small>
                            <div class="progress">
                                <div class="progress-bar bg-success" style="width: 85%">85%</div>
                            </div>
                        </div>
                        <div class="mb-2">
                            <small class="text-muted">Training Data:</small>
                            <div class="progress">
                                <div class="progress-bar bg-info" style="width: 70%">70%</div>
								</div>
                        </div>
                    </div>

                    <div class="stats-card">
                        <h5>Quick Stats</h5>
                        <?php
                        $stats = [
                            'Total Articles' => $articlesDb->query("SELECT COUNT(*) FROM articles")->fetchColumn(),
                            'Total Words' => $wordsDb->query("SELECT COUNT(*) FROM word")->fetchColumn(),
                            'User Feedback' => $articlesDb->query("SELECT COUNT(*) FROM comments")->fetchColumn()
                        ];
                        foreach ($stats as $label => $value):
                        ?>
                        <div class="d-flex justify-content-between mb-2">
                            <span><?php echo $label; ?>:</span>
                            <strong><?php echo number_format($value); ?></strong>
                        </div>
                        <?php endforeach; ?>
                    </div>
                </div>
            </div>
        </main>

        <footer class="dark-footer">
            <div class="container">
                <div class="row">
                    <div class="col-md-4">
                        <h3 class="h5 mb-3">AI Learning Stats</h3>
                        <ul class="list-unstyled">
                            <li class="mb-2">
                                <i class="bi bi-book me-2"></i>
                                Articles Generated: <?php echo $articlesDb->query("SELECT COUNT(*) FROM articles")->fetchColumn(); ?>
                            </li>
                            <li class="mb-2">
                                <i class="bi bi-brain me-2"></i>
                                Language Patterns Learned: <?php echo $articlesDb->query("SELECT COUNT(*) FROM training_patterns")->fetchColumn(); ?>
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-4">
                        <h3 class="h5 mb-3">Top Contributors</h3>
                        <ul class="list-unstyled">
                            <?php 
                            $userQuery = $articlesDb->query("SELECT username, exp_points as exp FROM users ORDER BY exp_points DESC LIMIT 3");
                            $topUsers = $userQuery->fetchAll(PDO::FETCH_ASSOC);
                            if (!empty($topUsers)): 
                                foreach ($topUsers as $user): ?>
                                    <li class="mb-2"><?php echo htmlspecialchars($user['username']); ?> - <?php echo $user['exp']; ?> XP</li>
                                <?php endforeach;
                            else: ?>
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
    <?php endif; ?>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
// Article editing and deletion functions
// Usage in admin.php

function showEditModal(article) {
    document.getElementById('editArticleId').value = article.article_id;
    document.getElementById('editTitle').value = article.title;
    document.getElementById('editTopic').value = article.topic;
    document.getElementById('editSummary').value = article.summary;
    document.getElementById('editContent').value = article.content;
    
    new bootstrap.Modal(document.getElementById('editArticleModal')).show();
}

function saveArticle() {
    const articleData = {
        articleId: document.getElementById('editArticleId').value,
        title: document.getElementById('editTitle').value,
        topic: document.getElementById('editTopic').value,
        summary: document.getElementById('editSummary').value,
        content: document.getElementById('editContent').value
    };

    fetch('edit_article.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(articleData)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('Article updated successfully!');
            location.reload();
        } else {
            alert('Error updating article: ' + data.message);
        }
    })
    .catch(error => {
        alert('Error updating article');
        console.error('Error:', error);
    });
}

function confirmDelete(articleId) {
    if (confirm('Are you sure you want to delete this article?')) {
        fetch('delete_article.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ articleId: articleId })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Article deleted successfully!');
                location.reload();
            } else {
                alert('Error deleting article: ' + data.message);
            }
        })
        .catch(error => {
            alert('Error deleting article');
            console.error('Error:', error);
        });
    }
}

// Add this script inside the <script> tag at the bottom of the page
document.getElementById('advanced-article-form').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    const submitButton = this.querySelector('button[type="submit"]');
    const originalText = submitButton.innerHTML;
    submitButton.disabled = true;
    submitButton.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Generating...';

    try {
        const formData = new FormData(this);
        
        const response = await fetch('generate_advanced_article.php', {
            method: 'POST',
            body: formData
        });

        let data;
        const contentType = response.headers.get('content-type');
        if (contentType && contentType.includes('application/json')) {
            data = await response.json();
        } else {
            // Log the actual response for debugging
            const text = await response.text();
            console.error('Unexpected response:', text);
            throw new Error('Server returned invalid response format');
        }

        if (data.success) {
            const alert = document.createElement('div');
            alert.className = 'alert alert-success alert-dismissible fade show mt-3';
            alert.innerHTML = `
                <strong>Success!</strong> Article generated successfully (ID: ${data.articleId})
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            this.insertAdjacentElement('beforebegin', alert);

            // Reset form
            this.reset();

            // Reload after delay
            setTimeout(() => location.reload(), 2000);
        } else {
            throw new Error(data.message || 'Failed to generate article');
        }
    } catch (error) {
        console.error('Generation error:', error);
        
        const alert = document.createElement('div');
        alert.className = 'alert alert-danger alert-dismissible fade show mt-3';
        alert.innerHTML = `
            <strong>Error!</strong> ${error.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        this.insertAdjacentElement('beforebegin', alert);
    } finally {
        submitButton.disabled = false;
        submitButton.innerHTML = originalText;
    }
});

// Type selector handler
const articleTypeSelector = document.getElementById('article-type-selector');
const optionSections = {
    'term_article': document.getElementById('term-article-options'),
    'trending_article': document.getElementById('trending-article-options'),
    'rss_synthesized_article': document.getElementById('rss-article-options')
};

articleTypeSelector.addEventListener('change', function() {
    Object.values(optionSections).forEach(section => {
        if (section) section.style.display = 'none';
    });
    
    const selectedSection = optionSections[this.value];
    if (selectedSection) {
        selectedSection.style.display = 'block';
    }
});

// Initialize with current selection
articleTypeSelector.dispatchEvent(new Event('change'));


// Show/hide article type-specific options
document.getElementById('article-type-selector').addEventListener('change', function() {
    // Hide all option sections
    ['term-article-options', 'trending-article-options', 'rss-article-options'].forEach(function(id) {
        document.getElementById(id).style.display = 'none';
    });

    // Show selected options
    const selectedType = this.value;
    switch(selectedType) {
        case 'term_article':
            document.getElementById('term-article-options').style.display = 'block';
            break;
        case 'trending_article':
            document.getElementById('trending-article-options').style.display = 'block';
            break;
        case 'rss_synthesized_article':
            document.getElementById('rss-article-options').style.display = 'block';
            break;
    }
});
</script>

</body>
</html>