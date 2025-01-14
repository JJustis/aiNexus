<?php
session_start();
require_once 'config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';

    try {
        $db = new PDO("mysql:host=localhost;dbname=reservesphp2", 'root', '');
        $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        $stmt = $db->prepare("SELECT * FROM users WHERE username = ?");
        $stmt->execute([$username]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user && password_verify($password, $user['password_hash'])) {
            $_SESSION['user_id'] = $user['user_id'];
            $_SESSION['username'] = $user['username'];

            // Update last active
            $stmt = $db->prepare("UPDATE users SET last_active = NOW() WHERE user_id = ?");
            $stmt->execute([$user['user_id']]);

            header("Location: dashboard.php");
            exit;
        } else {
            $error = "Invalid username or password";
        }
    } catch(PDOException $e) {
        $error = "Login failed: " . $e->getMessage();
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - AI News Nexus</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .gradient-header {
            background: linear-gradient(to right, #0061ff, #6b3aff);
            color: white;
            padding: 2rem 0;
        }
        .auth-card {
            background: white;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            margin-top: -3rem;
            position: relative;
            z-index: 1;
        }
        .form-control:focus {
            border-color: #6b3aff;
            box-shadow: 0 0 0 0.2rem rgba(107, 58, 255, 0.25);
        }
        .btn-primary {
            background: linear-gradient(to right, #0061ff, #6b3aff);
            border: none;
        }
        .btn-primary:hover {
            background: linear-gradient(to right, #004cd6, #5a31d6);
        }
    </style>
</head>
<body class="bg-light">
    <header class="gradient-header">
        <div class="container">
            <h1 class="display-4 fw-bold">AI News Nexus</h1>
            <p class="text-blue-100">Welcome back to our AI-powered news platform</p>
        </div>
    </header>

    <main class="container py-4">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="auth-card">
                    <h2 class="text-center mb-4">Login</h2>
                    <?php if (isset($error)): ?>
                        <div class="alert alert-danger" role="alert">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            <?php echo htmlspecialchars($error); ?>
                        </div>
                    <?php endif; ?>
                    <form method="POST">
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <input type="text" name="username" class="form-control" required>
                            </div>
                        </div>
                        <div class="mb-4">
                            <label class="form-label">Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                <input type="password" name="password" class="form-control" required>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 mb-3">
                            <i class="bi bi-box-arrow-in-right me-2"></i>Login
                        </button>
                        <p class="text-center mb-0">
                            Don't have an account? 
                            <a href="register.php" class="text-primary">Register</a>
                        </p>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>