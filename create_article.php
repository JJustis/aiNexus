<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Article - AI News Nexus</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f5f7;
        }
        .gradient-header {
            background: linear-gradient(to right, #0061ff, #6b3aff);
            color: white;
            padding: 2rem 0;
        }
        .article-creation-card {
            background: white;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 1.5rem;
            padding: 2rem;
        }
        .ai-thoughts {
            background-color: #f3f0ff;
            border-radius: 0.5rem;
            padding: 1rem;
            margin: 1rem 0;
        }
        .ai-assistance-panel {
            background-color: #f3f0ff;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-top: 1rem;
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
        .topic-button:not(.active) {
            background-color: #e5e7eb;
            color: #374151;
        }
        .summernote-container .note-editor {
            border-radius: 0.5rem;
            border: 1px solid #ced4da;
        }
    </style>
</head>
<body>
    <header class="gradient-header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="display-4 fw-bold">AI News Nexus</h1>
                    <p class="text-blue-100">Create Your Own AI-Assisted Article</p>
                </div>
                <div class="bg-white bg-opacity-25 rounded p-3">
                    <span class="d-block">Experience Points</span>
                    <div class="fs-4 fw-bold exp-points">
                        <?php 
                        session_start();
                        echo isset($_SESSION['exp']) ? $_SESSION['exp'] : 0; 
                        ?> XP
                    </div>
                </div>
            </div>
        </div>
    </header>

    <main class="container py-4">
        <div class="article-creation-card">
            <h2 class="h3 mb-4 text-center">
                <i class="bi bi-pencil-square text-primary me-2"></i>
                Create New Article
            </h2>

            <form id="articleCreationForm">
                <div class="row">
                    <div class="col-md-8">
                        <div class="mb-3">
                            <label for="articleTitle" class="form-label">Article Title</label>
                            <input type="text" class="form-control" id="articleTitle" 
                                   placeholder="Enter your article title" required>
                        </div>

                        <div class="mb-3 summernote-container">
                            <label for="articleContent" class="form-label">Article Content</label>
                            <textarea id="articleContent"></textarea>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="mb-3">
                            <label for="articleTopic" class="form-label">Topic</label>
                            <select class="form-select" id="articleTopic" required>
                                <option value="">Select Topic</option>
                                <optgroup label="Technology">
                                    <option value="ai">Artificial Intelligence</option>
                                    <option value="tech_trends">Tech Trends</option>
                                    <option value="cybersecurity">Cybersecurity</option>
                                </optgroup>
                                <optgroup label="Science">
                                    <option value="space">Space Exploration</option>
                                    <option value="climate">Climate Change</option>
                                    <option value="biology">Biology</option>
                                </optgroup>
                                <optgroup label="Business">
                                    <option value="startups">Startups</option>
                                    <option value="economics">Economics</option>
                                    <option value="innovation">Innovation</option>
                                </optgroup>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="articleTags" class="form-label">Tags</label>
                            <input type="text" class="form-control" id="articleTags" 
                                   placeholder="Comma-separated tags">
                        </div>

                        <div class="ai-assistance-panel">
                            <h5 class="mb-3">
                                <i class="bi bi-robot text-primary me-2"></i>
                                AI Assistance
                            </h5>
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="checkbox" id="aiSummaryAssist">
                                <label class="form-check-label" for="aiSummaryAssist">
                                    Generate AI Summary
                                </label>
                            </div>
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="checkbox" id="aiKeywordExtract">
                                <label class="form-check-label" for="aiKeywordExtract">
                                    Extract Keywords
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="aiEditAssist">
                                <label class="form-check-label" for="aiEditAssist">
                                    Editorial Suggestions
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <button type="submit" class="btn btn-primary btn-lg">
                        <i class="bi bi-cloud-upload me-2"></i>
                        Publish Article
                    </button>
                </div>
            </form>
        </div>
    </main>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js"></script>
    <script>
$(document).ready(function() {
    // Initialize Summernote rich text editor
    $('#articleContent').summernote({
        placeholder: 'Write your article here...',
        tabsize: 2,
        height: 400,
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'underline', 'clear']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['table', ['table']],
            ['insert', ['link', 'picture']],
            ['view', ['fullscreen', 'codeview']]
        ]
    });

    // Form submission handler
    $('#articleCreationForm').on('submit', function(e) {
        e.preventDefault();

        // Collect form data
        const articleData = {
            title: $('#articleTitle').val(),
            content: $('#articleContent').summernote('code'),
            topic: $('#articleTopic').val(),
            tags: $('#articleTags').val() ? $('#articleTags').val().split(',').map(tag => tag.trim()) : []
        };

        // Submit article
fetch('submit_article.php', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
    },
    body: JSON.stringify(articleData)
})
.then(response => {
    console.log('Response Status:', response.status);
    console.log('Response Headers:', Object.fromEntries(response.headers.entries()));
    
    // Read response text for debugging
    return response.text().then(text => {
        console.log('Response Text:', text);
        
        // Try to parse the text as JSON
        try {
            return JSON.parse(text);
        } catch (parseError) {
            console.error('JSON Parsing Error:', parseError);
            throw new Error('Failed to parse JSON: ' + text);
        }
    });
})
.then(data => {
    if (data.success) {
        alert('Article published successfully!');
        window.location.href = `article.php?id=${data.articleId}`;
    } else {
        alert('Failed to publish article: ' + (data.message || 'Unknown error'));
    }
})
.catch(error => {
    console.error('Full Submission Error:', error);
    alert('An error occurred while publishing the article: ' + error.message);
});
	});

	});
 </script>
</body>
</html>