<?php
session_start();
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Database connection
try {
    $db = new PDO('mysql:host=localhost;dbname=reservesphp2', 'root', '', [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);
} catch(PDOException $e) {
    die("Database connection failed: " . $e->getMessage());
}
// Database connection
try {
    $db2 = new PDO('mysql:host=localhost;dbname=reservesphp', 'root', '', [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);
} catch(PDOException $e) {
    die("Database connection failed: " . $e->getMessage());
}
// Authentication (simple session-based)
$is_authenticated = isset($_SESSION['user_id']);

// Handle actions
$response = ['status' => 'idle', 'message' => ''];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        if (isset($_POST['action'])) {
            switch($_POST['action']) {
                case 'login':
                    $username = $_POST['username'] ?? '';
                    $password = $_POST['password'] ?? '';
                    
                    $stmt = $db->prepare("SELECT user_id, password_hash FROM users WHERE username = ?");
                    $stmt->execute([$username]);
                    $user = $stmt->fetch(PDO::FETCH_ASSOC);
                    
                    if ($user && password_verify($password, $user['password_hash'])) {
                        $_SESSION['user_id'] = $user['user_id'];
                        $response = ['status' => 'success', 'message' => 'Login successful'];
                    } else {
                        $response = ['status' => 'error', 'message' => 'Invalid credentials'];
                    }
                    break;
                
                case 'register':
                    $username = $_POST['username'] ?? '';
                    $password = $_POST['password'] ?? '';
                    $email = $_POST['email'] ?? '';
                    
                    // Basic validation
                    if (empty($username) || empty($password) || empty($email)) {
                        $response = ['status' => 'error', 'message' => 'All fields are required'];
                        break;
                    }
                    
                    // Check if username or email exists
                    $stmt = $db->prepare("SELECT * FROM users WHERE username = ? OR email = ?");
                    $stmt->execute([$username, $email]);
                    if ($stmt->rowCount() > 0) {
                        $response = ['status' => 'error', 'message' => 'Username or email already exists'];
                        break;
                    }
                    
                    // Hash password
                    $password_hash = password_hash($password, PASSWORD_BCRYPT);
                    
                    // Insert new user
                    $stmt = $db->prepare("INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)");
                    $stmt->execute([$username, $email, $password_hash]);
                    
                    $response = ['status' => 'success', 'message' => 'Registration successful'];
                    break;
                
                case 'generate_training_data':
                    if (!$is_authenticated) {
                        $response = ['status' => 'error', 'message' => 'Authentication required'];
                        break;
                    }
                    
                    // Training data generation logic
                    $stmt = $db2->query("SELECT word FROM word ORDER BY RAND() LIMIT 50");
                    $words = $stmt->fetchAll(PDO::FETCH_COLUMN);
                    
                    $trainingDataFile = 'training_data.txt';
                    $generatedData = [];
                    $processedWords = [];
                    
                    foreach ($words as $word) {
                        if (in_array($word, $processedWords)) continue;
                        
                        // Fetch word details
                        $stmt = $db2->prepare("SELECT definition, wiki, type FROM word WHERE word = ?");
                        $stmt->execute([$word]);
                        $details = $stmt->fetch(PDO::FETCH_ASSOC);
                        
                        if (!$details || empty($details['definition']) || empty($details['wiki'])) continue;
                        
                        // Sanitize data
                        $description = htmlspecialchars($details['definition'], ENT_QUOTES, 'UTF-8');
                        $wiki = htmlspecialchars($details['wiki'], ENT_QUOTES, 'UTF-8');
                        $type = htmlspecialchars($details['type'] ?? 'unknown', ENT_QUOTES, 'UTF-8');
                        
                        // Primary entry
                        $primaryEntry = "The word '{$word}' ({$type}) is defined as: {$description}. Additional context from {$wiki}. More info at: http://localhost/wordpedia/pages/{$word}";
                        $generatedData[] = $primaryEntry;
                        $processedWords[] = $word;
                        
                        // Similar words
                        $stmt = $db2->prepare("SELECT word FROM word WHERE definition LIKE ? LIMIT 5");
                        $stmt->execute(['%' . $description . '%']);
                        $similarWords = $stmt->fetchAll(PDO::FETCH_COLUMN);
                        
                        foreach ($similarWords as $similarWord) {
                            if ($similarWord === $word || in_array($similarWord, $processedWords)) continue;
                            
                            $stmt = $db2->prepare("SELECT definition, wiki, type FROM word WHERE word = ?");
                            $stmt->execute([$similarWord]);
                            $similarDetails = $stmt->fetch(PDO::FETCH_ASSOC);
                            
                            if (!$similarDetails) continue;
                            
                            $similarDescription = htmlspecialchars($similarDetails['definition'], ENT_QUOTES, 'UTF-8');
                            $similarWiki = htmlspecialchars($similarDetails['wiki'], ENT_QUOTES, 'UTF-8');
                            $similarType = htmlspecialchars($similarDetails['type'] ?? 'unknown', ENT_QUOTES, 'UTF-8');
                            
                            $similarEntry = "Related word '{$similarWord}' ({$similarType}) provides context: {$similarDescription}. Sourced from {$similarWiki}. Additional details at: http://localhost/wordpedia/pages/{$similarWord}";
                            $generatedData[] = $similarEntry;
                            $processedWords[] = $similarWord;
                        }
                    }
                    
                    // Unique entries and write to file
                    $generatedData = array_unique($generatedData);
                    file_put_contents($trainingDataFile, implode("\n", $generatedData) . "\n", FILE_APPEND);
                    
                    $response = [
                        'status' => 'success', 
                        'message' => "Generated training data for " . count($generatedData) . " unique entries.",
                        'wordCount' => count($generatedData)
                    ];
                    break;
                
                case 'logout':
                    session_destroy();
                    $response = ['status' => 'success', 'message' => 'Logged out successfully'];
                    break;
            }
        }
    } catch(Exception $e) {
        $response = [
            'status' => 'error', 
            'message' => "An error occurred: " . $e->getMessage()
        ];
    }
    
    // Send JSON response for AJAX requests
    if (isset($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
        header('Content-Type: application/json');
        echo json_encode($response);
        exit;
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Training Data Generator</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { 
            background-color: #f4f6f9; 
            
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            padding: 30px;
            max-width: 500px;
            width: 100%;
        }
        #authForms .form-section { display: none; }
        #trainingDataSection { display: none; }
    </style>
</head>
<body>
    <div class="container">
        <!-- Authentication Forms -->
        <div id="authForms">
            <!-- Login Form -->
            <div id="loginForm" class="form-section">
                <h2 class="text-center mb-4">Login</h2>
                <form id="loginFormData">
                    <input type="text" name="username" class="form-control mb-3" placeholder="Username" required>
                    <input type="password" name="password" class="form-control mb-3" placeholder="Password" required>
                    <button type="submit" class="btn btn-primary w-100">Login</button>
                </form>
                <p class="text-center mt-3">
                    Don't have an account? 
                    <a href="#" id="showRegister" class="text-primary">Register</a>
                </p>
            </div>

            <!-- Registration Form -->
            <div id="registerForm" class="form-section">
                <h2 class="text-center mb-4">Register</h2>
                <form id="registerFormData">
                    <input type="text" name="username" class="form-control mb-3" placeholder="Username" required>
                    <input type="email" name="email" class="form-control mb-3" placeholder="Email" required>
                    <input type="password" name="password" class="form-control mb-3" placeholder="Password" required>
                    <button type="submit" class="btn btn-success w-100">Register</button>
                </form>
                <p class="text-center mt-3">
                    Already have an account? 
                    <a href="#" id="showLogin" class="text-primary">Login</a>
                </p>
            </div>
        </div>

        <!-- Training Data Section -->
        <div id="trainingDataSection">
            <h2 class="text-center mb-4">Training Data Generator</h2>
            <div class="alert alert-info" id="userInfo"></div>
            <button id="generateTrainingData" class="btn btn-primary w-100 mb-3">Generate Training Data</button>
            <button id="logoutBtn" class="btn btn-danger w-100">Logout</button>
            <div id="trainingDataOutput" class="mt-3"></div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const authForms = document.getElementById('authForms');
            const loginForm = document.getElementById('loginForm');
            const registerForm = document.getElementById('registerForm');
            const trainingDataSection = document.getElementById('trainingDataSection');
            const userInfo = document.getElementById('userInfo');
            const trainingDataOutput = document.getElementById('trainingDataOutput');

            // Initial state
            <?php if ($is_authenticated): ?>
                authForms.style.display = 'none';
                trainingDataSection.style.display = 'block';
                userInfo.textContent = 'Welcome, User!';
            <?php else: ?>
                loginForm.style.display = 'block';
            <?php endif; ?>

            // Form toggle
            document.getElementById('showRegister').addEventListener('click', (e) => {
                e.preventDefault();
                loginForm.style.display = 'none';
                registerForm.style.display = 'block';
            });

            document.getElementById('showLogin').addEventListener('click', (e) => {
                e.preventDefault();
                registerForm.style.display = 'none';
                loginForm.style.display = 'block';
            });

            // Form submission handlers
            document.getElementById('loginFormData').addEventListener('submit', (e) => {
                e.preventDefault();
                submitForm(e.target, 'login');
            });

            document.getElementById('registerFormData').addEventListener('submit', (e) => {
                e.preventDefault();
                submitForm(e.target, 'register');
            });

            // Generate Training Data
            document.getElementById('generateTrainingData').addEventListener('click', () => {
                fetch('', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: 'action=generate_training_data'
                })
                .then(response => response.json())
                .then(data => {
                    const outputElement = document.createElement('div');
                    outputElement.className = `alert alert-${data.status === 'success' ? 'success' : 'danger'}`;
                    outputElement.textContent = data.message;
                    trainingDataOutput.prepend(outputElement);
                });
            });

            // Logout
            document.getElementById('logoutBtn').addEventListener('click', () => {
                fetch('', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: 'action=logout'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        location.reload();
                    }
                });
            });

            // Generic form submission
            function submitForm(form, action) {
                const formData = new FormData(form);
                formData.append('action', action);

                fetch('', {
                    method: 'POST',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        if (action === 'login' || action === 'register') {
                            location.reload();
                        }
                    } else {
                        alert(data.message);
                    }
                });
            }
        });
    </script>
</body>
</html>