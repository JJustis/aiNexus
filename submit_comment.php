<?php
require_once 'database_connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $articleId = $_POST['articleId'];
    $userId = $_POST['userId'] ?? null; // Assuming you have user authentication
    $content = $_POST['content'];
    $name = $_POST['name'];
    $email = $_POST['email'];

    try {
        $db = getDbConnection();
        
        // If user is not logged in, create a new user with the provided name and email
        if (!$userId) {
            $userStmt = $db->prepare("INSERT INTO users (username, email) VALUES (:name, :email)");
            $userStmt->execute(['name' => $name, 'email' => $email]);
            $userId = $db->lastInsertId();
        }

        $commentStmt = $db->prepare("
            INSERT INTO comments (article_id, user_id, content, created_at)
            VALUES (:article_id, :user_id, :content, NOW())
        ");
        $commentStmt->execute(['article_id' => $articleId, 'user_id' => $userId, 'content' => $content]);

        echo json_encode(['success' => true]);
    } catch (PDOException $e) {
        error_log($e->getMessage());
        echo json_encode(['success' => false, 'message' => 'An error occurred while submitting the comment.']);
    }
}