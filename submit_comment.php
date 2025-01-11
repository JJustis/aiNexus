<?php
// submit_comment.php
header('Content-Type: application/json');

try {
    require_once 'database_connection.php';

    // Validate inputs
    if (empty($_POST['name']) || empty($_POST['content']) || empty($_POST['article_id'])) {
        throw new Exception('All fields are required');
    }

    // Get database connection
    $db = new PDO('mysql:host=localhost;dbname=reservesphp2', 'root', '', [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);

    // Insert comment
    $stmt = $db->prepare("
        INSERT INTO comments (article_id, username, content, created_at)
        VALUES (:article_id, :username, :content, NOW())
    ");

    $stmt->execute([
        'article_id' => filter_var($_POST['article_id'], FILTER_SANITIZE_NUMBER_INT),
        'username' => filter_var($_POST['name'], FILTER_SANITIZE_STRING),
        'content' => filter_var($_POST['content'], FILTER_SANITIZE_STRING)
    ]);

    $commentId = $db->lastInsertId();

    echo json_encode([
        'success' => true,
        'message' => 'Comment added successfully',
        'commentId' => $commentId
    ]);

} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}