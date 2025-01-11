<?php
// Database Table Structure Verification
try {
    $db = new PDO('mysql:host=localhost;dbname=reservesphp2', 'root', '', [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);

    // Check if articles table exists and has required columns
    $stmt = $db->query("DESCRIBE articles");
    $columns = $stmt->fetchAll(PDO::FETCH_COLUMN);

    $requiredColumns = [
        'article_id', 
        'title', 
        'summary', 
        'content', 
        'confidence', 
        'ai_thoughts', 
        'created_at', 
        'topic',
        'user_id'
    ];

    $missingColumns = array_diff($requiredColumns, $columns);

    if (!empty($missingColumns)) {
        echo "Missing columns in articles table: " . implode(', ', $missingColumns);
    } else {
        echo "Articles table structure looks good!";
    }

    // Sample query to test article retrieval
    $testQuery = $db->query("SELECT article_id, title FROM articles LIMIT 5");
    $articles = $testQuery->fetchAll(PDO::FETCH_ASSOC);

    echo "\n\nSample Articles:\n";
    print_r($articles);

} catch (PDOException $e) {
    echo "Database Error: " . $e->getMessage();
}
?>