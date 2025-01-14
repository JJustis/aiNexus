<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI News Nexus</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
	<style>


    .xp-display {
        transition: all 0.3s ease;
    }

    .xp-display:hover {
        transform: scale(1.05);
    }

    .exp-points {
        text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
    }

    .dropdown-menu {
        border: none;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
    }

    .dropdown-item:hover {
        background-color: #f8f9fa;
    }

        .gradient-header {
            background: linear-gradient(to right, #0061ff, #6b3aff);
            color: white;
            padding: 2rem 0;
        }
        
        .ai-status-banner {
            background-color: #f3f0ff;
            border-bottom: 1px solid #e9d8fd;
            padding: 0.75rem 0;
        }
        
        .topic-button {
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 9999px;
            margin-right: 0.5rem;
            transition: all 0.3s;
        }
        
        .topic-button.active {
            background-color: #3b82f6;
            color: white;
        }
        .sensory-module {
    background: #1a1a2e;
    border-radius: 10px;
    padding: 15px;
    margin-bottom: 20px;
}

.sensory-module h4 {
    color: #e2e8f0;
    font-size: 1rem;
    margin-bottom: 15px;
}

.audio-levels {
    display: flex;
    height: 100px;
    gap: 2px;
    align-items: flex-end;
}

.audio-bar {
    flex: 1;
    background: #4a90e2;
    min-height: 2px;
    transition: height 0.1s ease;
}

.motion-data {
    color: #e2e8f0;
    font-family: monospace;
    font-size: 0.9rem;
    line-height: 1.5;
}

#videoFeedback {
    width: 100%;
    height: auto;
    border-radius: 5px;
    background: #0f0f1a;
}
        .topic-button:not(.active) {
            background-color: #e5e7eb;
            color: #374151;
        }
        
        .article-card {
            background: white;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 1.5rem;
        }
        
        .ai-thoughts {
            background-color: #f3f0ff;
            border-radius: 0.5rem;
            padding: 1rem;
            margin: 1rem 0;
        }
        
        .feedback-section {
            border-top: 1px solid #e5e7eb;
            padding-top: 1rem;
            margin-top: 1rem;
        }
        
        .status-indicator {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background-color: #34d399;
            display: inline-block;
            margin-right: 0.5rem;
        }
        
        .dark-footer {
            background-color: #1f2937;
            color: white;
            padding: 2rem 0;
            margin-top: 3rem;
        }

        .canvas-container {
            background: #1a1a2e;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }

        #aiCanvas {
            border: 1px solid #2d3748;
            background: #0f0f1a;
            width: 100%;
        }

        .thought-stream {
            color: #e2e8f0;
            font-family: monospace;
            height: 100px;
            overflow-y: auto;
            padding: 10px;
            background: #2d3748;
            border-radius: 5px;
            margin-top: 10px;
        }

        .training-feedback {
            margin-bottom: 20px;
        }

        .feedback-form {
            display: none;
            margin-top: 15px;
        }
    </style>
</head>
<body class="bg-light">
    <?php
    session_start();
    $db = new PDO('mysql:host=localhost;dbname=reservesphp2', 'root', '', [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    require_once 'SentenceAnalyzer.class.php';
$sentenceAnalyzer = new SentenceAnalyzer($db);
    function getArticles($topic = 'all') {
        global $db;
        $sql = "SELECT * FROM articles";
        if ($topic !== 'all') {
            $sql .= " WHERE topic = :topic";
        }
        $stmt = $db->prepare($sql);
        if ($topic !== 'all') {
            $stmt->bindParam(':topic', $topic);
        }
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    
    $selectedTopic = isset($_GET['topic']) ? $_GET['topic'] : 'all';
    $articles = getArticles($selectedTopic);
    ?>

<?php
$is_logged_in = isset($_SESSION['user_id']);
$username = $is_logged_in && isset($_SESSION['username']) ? $_SESSION['username'] : '';
?>
<header class="gradient-header">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1 class="display-4 fw-bold">AI News Nexus</h1>
                <p class="text-blue-100">News generated and curated by artificial intelligence</p>
            </div>
            <div class="d-flex align-items-center">
                <?php if (!$is_logged_in): ?>
                    <div class="bg-white bg-opacity-25 rounded p-3 me-3">
                        <a href="login.php" class="btn btn-light btn-sm mb-2 w-100">
                            <i class="bi bi-box-arrow-in-right me-2"></i>Login
                        </a>
                        <a href="register.php" class="btn btn-light btn-sm w-100">
                            <i class="bi bi-person-plus me-2"></i>Register
                        </a>
                    </div>
                <?php else: ?>
                    <div class="dropdown me-3">
                        <button class="btn btn-light dropdown-toggle" type="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-person-circle me-2"></i><?php echo htmlspecialchars($username); ?>
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="profile.php">
                                <i class="bi bi-person me-2"></i>Profile
                            </a></li>
                            <li><a class="dropdown-item" href="dashboard.php">
                                <i class="bi bi-speedometer2 me-2"></i>Dashboard
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="logout.php">
                                <i class="bi bi-box-arrow-right me-2"></i>Logout
                            </a></li>
                        </ul>
                    </div>
                <?php endif; ?>
                
                <div class="bg-white bg-opacity-25 rounded p-3">
                    <span class="d-block">Experience Points</span>
                    <div class="fs-4 fw-bold exp-points">
                        <?php echo isset($_SESSION['exp']) ? $_SESSION['exp'] : 0; ?> XP
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

    <div class="ai-status-banner">
        <div class="container">
            <div class="d-flex align-items-center">
                <i class="bi bi-brain me-2"></i>
                <span class="text-purple-700">AI is actively learning from user interactions</span>
            </div>
        </div>
    </div>

    <main class="container py-4">
        <div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="mb-4">
            <?php
            $topics = ['all', 'technology', 'science', 'economics', 'business'];
            foreach ($topics as $topic) {
                $activeClass = $selectedTopic === $topic ? 'active' : '';
                echo "<button class='topic-button $activeClass' onclick='changeTopic(\"$topic\")'>
                    " . ucfirst($topic) . "
                </button>";
            }
            ?>
        </div>
        
        <!-- New Create Article Button -->
        <div>
            <a href="create_article.php" class="btn btn-primary">
                <i class="bi bi-pencil-square me-2"></i>Create Article
            </a>
        </div>
    </div>
</div>

        <div class="container mt-4">
            <div class="row">
                <div class="col-12">
                    <h2 class="mb-3">AI Thought Process Visualization</h2>
					<div class="container mt-4">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Sensory Processing</h3>
                </div>
                <div class="card-body">
                    <div class="sensory-container">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="sensory-module" id="audioModule">
                                    <h4><i class="bi bi-volume-up"></i> Audio Processing</h4>
                                    <div class="progress mb-2" style="height: 5px;">
                                        <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                                    </div>
                                    <div class="audio-levels">
                                        <!-- Audio bars will be inserted here by JavaScript -->
                                    </div>
                                    <div class="mt-2 text-light">
                                        <small>Direction: <span id="audioDirection">0°</span></small><br>
                                        <small>Intensity: <span id="audioIntensity">0%</span></small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="sensory-module" id="videoModule">
                                    <h4><i class="bi bi-camera-video"></i> Video Processing</h4>
                                    <div class="progress mb-2" style="height: 5px;">
                                        <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                                    </div>
                                    <div class="video-container position-relative">
                                        <video id="videoFeedback" autoplay playsinline muted></video>
                                        <canvas id="motionCanvas" class="position-absolute top-0 start-0 w-100 h-100"></canvas>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="sensory-module" id="motionModule">
                                    <h4><i class="bi bi-arrow-repeat"></i> Motion Analysis</h4>
                                    <div class="progress mb-2" style="height: 5px;">
                                        <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                                    </div>
                                    <div class="motion-data">
                                        Movement detected: <span id="motionCoords">0, 0</span><br>
                                        Intensity: <span id="motionIntensity">0%</span><br>
                                        Sound Source: <span id="soundLocation">No sound detected</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
                    <?php include 'ai_visualization.html'; ?>
					<div class="ai-analysis-section" style="display:none;">
    <div class="card mt-3">
        <div class="card-header">
		
            <h5 class="mb-0">Sentence Analysis</h5>
        </div>
        <div class="card-body">
		
		
            <div id="analysisResults"></div>
        </div>
    </div>
</div>
                </div>
            </div>
        </div>

        <div class="row">
            <?php foreach ($articles as $article): ?>
            <div class="col-md-6">
                <div class="article-card p-4" data-article-id="<?php echo $article['article_id']; ?>">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h2 class="h4 mb-0"><?php echo htmlspecialchars($article['title']); ?></h2>
                        <div class="text-muted">
                            Confidence: <?php echo number_format($article['confidence'] * 100, 1); ?>%
                        </div>
                    </div>
                    
<p class="text-muted">
    <?php echo nl2br($article['summary']); ?>
    <a href="article.php?artid=<?php echo $article['article_id']; ?>" class="text-primary ms-2">
        Read Full Article
    </a>
</p>
                    <div class="ai-thoughts">
                        <h3 class="h6 text-purple-700 mb-2">AI Thought Process</h3>
                        <?php 
                        $thoughts = json_decode($article['ai_thoughts'], true) ?? [];
                        foreach ($thoughts as $thought): 
                        ?>
                        <div class="d-flex align-items-center mb-2">
                            <i class="bi bi-brain me-2"></i>
                            <span class="text-purple-600"><?php echo htmlspecialchars($thought); ?></span>
                        </div>
                        <?php endforeach; ?>
                    </div>

                    <div class="feedback-section">
                        <div class="d-flex justify-content-between mb-3">
                            <div class="btn-group">
                                <button class="btn btn-outline-success btn-sm" 
                                    onclick="provideFeedback('accurate', <?php echo $article['article_id']; ?>)">
                                    <i class="bi bi-check-circle"></i> Accurate
                                </button>
                                <button class="btn btn-outline-danger btn-sm" 
                                    onclick="provideFeedback('inaccurate', <?php echo $article['article_id']; ?>)">
                                    <i class="bi bi-x-circle"></i> Inaccurate
                                </button>
                                <button class="btn btn-outline-primary btn-sm" 
                                    onclick="showEditForm(<?php echo $article['article_id']; ?>)">
                                    <i class="bi bi-pencil"></i> Edit
                                </button>
                            </div>
                        </div>

                        <div class="edit-form" id="editForm_<?php echo $article['article_id']; ?>" style="display:none;">
                            <div class="mb-3">
                                <label class="form-label">Title</label>
                                <input type="text" class="form-control" 
                                       id="editTitle_<?php echo $article['article_id']; ?>"
                                       value="<?php echo htmlspecialchars($article['title']); ?>">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Summary</label>
                                <textarea class="form-control" rows="3" 
                                         id="editSummary_<?php echo $article['article_id']; ?>"><?php echo nl2br($article['summary']); ?></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Additional Notes</label>
                                <textarea class="form-control" rows="2" 
                                         id="editNotes_<?php echo $article['article_id']; ?>"
                                         placeholder="Explain your changes..."></textarea>
                            </div>
                            <div class="d-flex justify-content-end gap-2">
                                <button class="btn btn-secondary btn-sm" 
                                        onclick="hideEditForm(<?php echo $article['article_id']; ?>)">Cancel</button>
                                <button class="btn btn-primary btn-sm" 
                                        onclick="submitEdit(<?php echo $article['article_id']; ?>)">Submit Changes</button>
                            </div>
                        </div>

                        <div class="training-progress mt-3" id="progress_<?php echo $article['article_id']; ?>">
                            <small class="text-muted d-block mb-1">AI Learning Progress</small>
                            <div class="progress" style="height: 5px;">
                                <div class="progress-bar bg-success" role="progressbar" style="width: 0%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <?php endforeach; ?>
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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/tensorflow/4.7.0/tf.min.js"></script>
    <script src="brain.js"></script>

    <script>
    function changeTopic(topic) {
        window.location.href = `?topic=${topic}`;
    }

    function showEditForm(articleId) {
        document.getElementById(`editForm_${articleId}`).style.display = 'block';
    }

    function hideEditForm(articleId) {
        document.getElementById(`editForm_${articleId}`).style.display = 'none';
    }

    function updateArticleProgress(articleId, progress) {
        const progressBar = document.querySelector(`#progress_${articleId} .progress-bar`);
if (progressBar) {
            progressBar.style.width = `${progress}%`;
        }
    }

    function submitEdit(articleId) {
        const data = {
            articleId: articleId,
            title: document.getElementById(`editTitle_${articleId}`).value,
            summary: document.getElementById(`editSummary_${articleId}`).value,
            notes: document.getElementById(`editNotes_${articleId}`).value
        };

        fetch('handle_edit.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                document.querySelector('.exp-points').textContent = data.newExp + ' XP';
                hideEditForm(articleId);
                updateArticleProgress(articleId, data.trainingProgress);
                alert('Changes submitted successfully! Earned ' + data.expGained + ' XP');
                location.reload();
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('An error occurred while submitting changes');
        });
    }

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
                updateArticleProgress(articleId, data.trainingProgress);
                alert(`Feedback submitted successfully! Earned ${data.expGained} XP`);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('An error occurred while submitting feedback');
        });
    }

    window.addEventListener('load', function() {
        document.querySelectorAll('.training-progress').forEach(progress => {
            const articleId = progress.closest('.article-card').dataset.articleId;
            fetch(`get_progress.php?articleId=${articleId}`)
                .then(response => response.json())
                .then(data => {
                    if (data.progress) {
                        updateArticleProgress(articleId, data.progress);
                    }
                });
        });
    });
    </script>
	<script src="sensory.js"></script>
</body>
</html>