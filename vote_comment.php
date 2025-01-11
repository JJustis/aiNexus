<?php
require_once 'database_connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $commentId = $_POST['commentId'];
    $voteType = $_POST['voteType'];

    try {
        $db = getDbConnection();

        if ($voteType === 'up') {
            $db->query("UPDATE comments SET votes = votes + 1 WHERE comment_id = $commentId");
        } elseif ($voteType === 'down') {
            $db->query("UPDATE comments SET votes = votes - 1 WHERE comment_id = $commentId");
        }

        echo json_encode(['success' => true]);
    } catch (PDOException $e) {
        error_log($e->getMessage());
        echo json_encode(['success' => false, 'message' => 'An error occurred while processing the vote.']);
    }
}