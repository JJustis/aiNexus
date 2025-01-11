<?php
session_start();
header('Content-Type: application/json');

if (!isset($_SESSION['admin_logged_in']) || $_SESSION['admin_logged_in'] !== true) {
    http_response_code(403);
    echo json_encode(['success' => false, 'message' => 'Not authorized']);
    exit;
}

try {
    $db = new PDO('mysql:host=localhost;dbname=reservesphp2', 'root', '', [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);

    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!isset($input['articleId'], $input['title'], $input['content'], $input['topic'])) {
        throw new Exception('Missing required fields');
    }

    $stmt = $db->prepare("
        UPDATE articles 
        SET 
            title = :title,
            content = :content,
            topic = :topic,
            summary = :summary,
            updated_at = NOW()
        WHERE article_id = :article_id
    ");

    $stmt->execute([
        'title' => $input['title'],
        'content' => $input['content'],
        'topic' => $input['topic'],
        'summary' => $input['summary'] ?? substr($input['content'], 0, 200) . '...',
        'article_id' => $input['articleId']
    ]);

    echo json_encode([
        'success' => true,
        'message' => 'Article updated successfully'
    ]);

} catch (Exception $e) {
    error_log('Edit Article Error: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Error updating article'
    ]);
}