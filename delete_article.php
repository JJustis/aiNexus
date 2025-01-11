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
    $articleId = $input['articleId'] ?? null;

    if (!$articleId) {
        throw new Exception('Article ID is required');
    }

    $stmt = $db->prepare("DELETE FROM articles WHERE article_id = ?");
    $stmt->execute([$articleId]);

    echo json_encode([
        'success' => true,
        'message' => 'Article deleted successfully'
    ]);

} catch (Exception $e) {
    error_log('Delete Article Error: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Error deleting article'
    ]);
}