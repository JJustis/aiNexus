<?php
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 0);
session_start();

try {
    $db = new PDO('mysql:host=localhost;dbname=reservesphp2', 'root', '');
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $data = json_decode(file_get_contents('php://input'), true);
    
    if (!isset($data['articleId']) || !isset($data['feedbackType'])) {
        throw new Exception('Missing required data');
    }

    // Save feedback
    $stmt = $db->prepare("
        INSERT INTO article_feedback 
        (article_id, user_id, feedback_type, created_at) 
        VALUES (?, ?, ?, NOW())
    ");
    
    $userId = $_SESSION['user_id'] ?? 1;
    $stmt->execute([$data['articleId'], $userId, $data['feedbackType']]);

    // Calculate XP
    $expGained = ($data['feedbackType'] === 'accurate') ? 10 : 15;

    // Update user XP
    $stmt = $db->prepare("
        UPDATE users 
        SET exp_points = COALESCE(exp_points, 0) + ? 
        WHERE user_id = ?
    ");
    $stmt->execute([$expGained, $userId]);

    // Get updated XP
    $stmt = $db->prepare("SELECT COALESCE(exp_points, 0) FROM users WHERE user_id = ?");
    $stmt->execute([$userId]);
    $newExp = $stmt->fetchColumn();

    // Calculate progress
    $stmt = $db->prepare("SELECT COUNT(*) FROM article_feedback WHERE article_id = ?");
    $stmt->execute([$data['articleId']]);
    $feedbackCount = $stmt->fetchColumn();
    $progress = min(100, ($feedbackCount * 20));

    echo json_encode([
        'success' => true,
        'newExp' => $newExp,
        'expGained' => $expGained,
        'trainingProgress' => $progress
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}