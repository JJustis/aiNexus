<?php
session_start();
require_once 'config.php';

// Ensure user is logged in
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit;
}

try {
    $db = new PDO("mysql:host=localhost;dbname=reservesphp2", 'root', '');
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Fetch user details
    $stmt = $db->prepare("SELECT * FROM users WHERE user_id = ?");
    $stmt->execute([$_SESSION['user_id']]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

} catch(PDOException $e) {
    die("Error: " . $e->getMessage());
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - AI News Nexus</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
        }
        .gradient-header {
            background: linear-gradient(to right, #0061ff, #6b3aff);
            color: white;
            padding: 2rem 0;
        }
        .dashboard-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <header class="gradient-header mb-4">
        <div class="container">
            <h1 class="display-4">AI News Nexus Dashboard</h1>
            <p class="lead">Welcome, <?php echo htmlspecialchars($user['username']); ?>!</p>
        </div>
    </header>

    <main class="container">
        <div class="row">
            <div class="col-md-6 mb-4">
                <div class="dashboard-card p-4">
                    <h2 class="h4 mb-3">Experience Points</h2>
                    <p class="display-4 fw-bold text-primary"><?php echo $user['exp_points']; ?> XP</p>
                </div>
            </div>
            <div class="col-md-6 mb-4">
                <div class="dashboard-card p-4">
                    <h2 class="h4 mb-3">Training Worker</h2>
                    <button class="btn btn-primary mb-3" onclick="startTrainingWorker()">
                        <i class="bi bi-play-circle me-2"></i>Start Training Worker
                    </button>
                    <div id="worker-status" class="alert alert-info" role="alert"></div>
                </div>
            </div>
        </div>
    </main>

    <footer class="mt-5 py-3 bg-light">
        <div class="container text-center">
            <a href="index.php" class="btn btn-outline-primary me-2">Home</a>
            <a href="logout.php" class="btn btn-outline-danger">Logout</a>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function startTrainingWorker() {
            fetch('training_worker.php')
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        document.getElementById('worker-status').textContent = 
                            `Generated ${data.wordCount} words. Earned ${data.exp_awarded} XP!`;
                    } else {
                        document.getElementById('worker-status').textContent = data.message;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                });
        }
    </script>
</body>
</html>