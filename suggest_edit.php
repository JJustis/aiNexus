<?php
header('Content-Type: application/json');
session_start();

$db = new PDO('mysql:host=localhost;dbname=reservesphp2', 'root', '');

$data = json_decode(file_get_contents('php://input'), true);
$articleId = $data['articleId'];
$correction = $data['correction'];

// Save correction
$stmt = $db->prepare("INSERT INTO corrections (article_id, correction_text) VALUES (?, ?)");
$stmt->execute([$articleId, $correction]);

// Award more XP for corrections
$_SESSION['exp'] = ($_SESSION['exp'] ?? 0) + 50;

echo json_encode([
    'success' => true,
    'newExp' => $_SESSION['exp']
]);
?>