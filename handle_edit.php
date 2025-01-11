<?php
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 0);
session_start();

try {
    $db = new PDO('mysql:host=localhost;dbname=reservesphp2', 'root', '');
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $data = json_decode(file_get_contents('php://input'), true);
    
    if (!isset($data['articleId']) || !isset($data['title']) || !isset($data['summary'])) {
        throw new Exception('Missing required fields');
    }

    // Update article
    $stmt = $db->prepare("
        UPDATE articles 
        SET title = ?, summary = ? 
        WHERE article_id = ?
    ");
    $stmt->execute([$data['title'], $data['summary'], $data['articleId']]);

    // Save edit history
    $stmt = $db->prepare("
        INSERT INTO article_edits 
        (article_id, user_id, notes, created_at) 
        VALUES (?, ?, ?, NOW())
    ");
    
    $userId = $_SESSION['user_id'] ?? 1;
    $stmt->execute([$data['articleId'], $userId, $data['notes']]);

    // Calculate XP
    $expGained = 25;  // Base XP for edits

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

    echo json_encode([
        'success' => true,
        'newExp' => $newExp,
        'expGained' => $expGained,
        'trainingProgress' => 75  // You can calculate this based on your needs
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}