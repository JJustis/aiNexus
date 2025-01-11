<?php
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 0);

try {
    $db = new PDO('mysql:host=localhost;dbname=reservesphp2', 'root', '');
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    if (!isset($_GET['articleId'])) {
        throw new Exception('Article ID is required');
    }

    $stmt = $db->prepare("SELECT COUNT(*) FROM article_feedback WHERE article_id = ?");
    $stmt->execute([$_GET['articleId']]);
    $feedbackCount = $stmt->fetchColumn();
    
    // Calculate a simple progress percentage (modify according to your needs)
    $progress = min(100, ($feedbackCount * 20));  // Each feedback adds 20% progress

    echo json_encode([
        'success' => true,
        'progress' => $progress
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}