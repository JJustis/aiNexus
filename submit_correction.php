<?php
session_start();
header('Content-Type: application/json');

try {
    // Database connection
    $db = new PDO('mysql:host=localhost;dbname=reservesphp2', 'root', '');
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Get POST data
    $data = json_decode(file_get_contents('php://input'), true);
    
    if (!isset($data['article_id']) || !isset($data['correction'])) {
        throw new Exception('Missing required data');
    }

    // Start transaction
    $db->beginTransaction();

    // Save the correction
    $stmt = $db->prepare("
        INSERT INTO corrections 
        (article_id, user_id, correction_text, status, created_at) 
        VALUES (?, ?, ?, 'pending', NOW())
    ");
    
    $userId = $_SESSION['user_id'] ?? 1; // Default to 1 if no session
    $stmt->execute([$data['article_id'], $userId, $data['correction']]);
    
    // Calculate experience points based on correction length and quality
    $words = str_word_count($data['correction']);
    $expPoints = min(50, $words * 2); // Cap at 50 points, 2 points per word
    
    // Update user experience points
    $stmt = $db->prepare("
        UPDATE users 
        SET exp_points = exp_points + ?,
            last_active = NOW()
        WHERE user_id = ?
    ");
    $stmt->execute([$expPoints, $userId]);
    
    // Get new total exp points
    $stmt = $db->prepare("
        SELECT exp_points 
        FROM users 
        WHERE user_id = ?
    ");
    $stmt->execute([$userId]);
    $newExp = $stmt->fetchColumn();

    // Process word patterns from correction
    $words = str_word_count(strtolower($data['correction']), 1);
    for ($i = 0; $i < count($words) - 1; $i++) {
        $currentWord = $words[$i];
        $nextWord = $words[$i + 1];
        
        // Update word relationships
        $stmt = $db->prepare("
            INSERT INTO word_relationships 
            (word, related_words, occurrence_count, last_used) 
            VALUES (?, JSON_ARRAY(?), 1, NOW())
            ON DUPLICATE KEY UPDATE 
            related_words = JSON_ARRAY_APPEND(
                COALESCE(related_words, JSON_ARRAY()), 
                '$', 
                ?
            ),
            occurrence_count = occurrence_count + 1,
            last_used = NOW()
        ");
        $stmt->execute([$currentWord, $nextWord, $nextWord]);
    }

    // Calculate training progress (example metric)
    $stmt = $db->query("
        SELECT 
            (COUNT(*) * 100 / (SELECT COUNT(*) FROM articles)) as progress 
        FROM corrections 
        WHERE status = 'approved'
    ");
    $trainingProgress = min(100, round($stmt->fetchColumn() ?? 0));

    $db->commit();

    // Send success response
    echo json_encode([
        'success' => true,
        'newXp' => $newExp,
        'expGained' => $expPoints,
        'trainingProgress' => $trainingProgress,
        'message' => 'Correction submitted successfully'
    ]);

} catch (Exception $e) {
    if (isset($db)) {
        $db->rollBack();
    }
    
    error_log("Error in submit_correction.php: " . $e->getMessage());
    
    echo json_encode([
        'success' => false,
        'error' => 'An error occurred while processing your correction',
        'debug' => $e->getMessage() // Remove in production
    ]);
}
?>