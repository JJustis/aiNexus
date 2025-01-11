<?php
header('Content-Type: application/json');

require_once 'database_connection.php';

try {
    // Get JSON input
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!isset($input['commentId']) || !isset($input['voteType'])) {
        throw new Exception('Missing required parameters');
    }
    
    $commentId = (int)$input['commentId'];
    $voteType = $input['voteType'];
    
    if (!in_array($voteType, ['up', 'down'])) {
        throw new Exception('Invalid vote type');
    }
    
    $db = getDbConnection();
    
    // Start transaction
    $db->beginTransaction();
    
    try {
        // Update vote count
        $voteChange = ($voteType === 'up') ? 1 : -1;
        
        $stmt = $db->prepare("
            UPDATE comments 
            SET votes = votes + :vote_change 
            WHERE comment_id = :comment_id
        ");
        
        $stmt->execute([
            'vote_change' => $voteChange,
            'comment_id' => $commentId
        ]);
        
        // Get updated vote count
        $stmt = $db->prepare("
            SELECT votes 
            FROM comments 
            WHERE comment_id = :comment_id
        ");
        
        $stmt->execute(['comment_id' => $commentId]);
        $votes = $stmt->fetchColumn();
        
        $db->commit();
        
        echo json_encode([
            'success' => true,
            'votes' => $votes,
            'message' => 'Vote recorded successfully'
        ]);
        
    } catch (Exception $e) {
        $db->rollBack();
        throw $e;
    }
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}