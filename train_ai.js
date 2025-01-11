<?php
// train_ai.php
header('Content-Type: application/json');

require_once 'LanguageProcessor.class.php';
require_once 'ExperienceSystem.class.php';

try {
    $db = new PDO('mysql:host=localhost;dbname=reservesphp2', 'root', '');
    $languageProcessor = new LanguageProcessor($db);
    $expSystem = new ExperienceSystem($db);

    $data = json_decode(file_get_contents('php://input'), true);
    $articleId = $data['articleId'];

    // Process the article for learning
    $article = $db->query("SELECT * FROM articles WHERE id = $articleId")->fetch();
    $analysis = $languageProcessor->analyzeSentence($article['content']);
    
    // Store learning results
    foreach ($analysis['words'] as $word => $connections) {
        $languageProcessor->storeWordRelationship($word, $connections);
    }

    // Award experience points
    $expGained = $expSystem->awardExp($_SESSION['user_id'], 'training', strlen($article['content']));

    echo json_encode([
        'success' => true,
        'expGained' => $expGained,
        'newPatterns' => $analysis['patterns'],
        'wordConnections' => $analysis['connections']
    ]);

} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}