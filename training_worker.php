<?php
// Disable all error output
error_reporting(0);

// Start output buffering immediately
ob_start();

session_start();
require_once 'config.php';

// Ensure clean JSON output for AJAX requests
if ($_SERVER['HTTP_X_REQUESTED_WITH'] === 'XMLHttpRequest') {
    // Clear any previous output completely
    ob_end_clean();
    ob_start();
}

// Ensure user is logged in
if (!isset($_SESSION['user_id'])) {
    header('Content-Type: application/json');
    echo json_encode(['status' => 'error', 'message' => 'Not authenticated']);
    ob_end_flush();
    exit;
}

$user_id = $_SESSION['user_id'];
$shared_training_data_file = 'training_data.txt';

try {
    // Database connections
    $db = new PDO("mysql:host=localhost;dbname=reservesphp2", 'root', '', [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);
    $db2 = new PDO("mysql:host=localhost;dbname=reservesphp", 'root', '', [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);

    // Check for existing active worker
    $stmt = $db->prepare("SELECT * FROM training_workers WHERE user_id = ? AND status = 'active'");
    $stmt->execute([$user_id]);
    $existingWorker = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($existingWorker) {
        // Update existing worker
        $stmt = $db->prepare("UPDATE training_workers SET last_updated_at = NOW() WHERE worker_id = ?");
        $stmt->execute([$existingWorker['worker_id']]);
    } else {
        // Create new worker
        $stmt = $db->prepare("INSERT INTO training_workers (user_id) VALUES (?)");
        $stmt->execute([$user_id]);
    }

    function getWordDetails($db, $word) {
        $stmt = $db->prepare("SELECT definition, wiki FROM word WHERE word = :word");
        $stmt->execute(['word' => $word]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    function getSimilarWords($db, $definition) {
        $stmt = $db->prepare("SELECT word FROM word WHERE definition LIKE :definition LIMIT 10");
        $stmt->execute(['definition' => '%' . $definition . '%']);
        return $stmt->fetchAll(PDO::FETCH_COLUMN);
    }

    function generateTrainingData($db, $shared_training_data_file, $user_id) {
        $stmt = $db->query("SELECT word FROM word ORDER BY RAND() LIMIT 500");
        $words = $stmt->fetchAll(PDO::FETCH_COLUMN);
        
        $generatedData = [];
        $uniqueEntries = [];
        
        // Read existing entries to avoid duplicates
        if (file_exists($shared_training_data_file)) {
            $existingData = file_get_contents($shared_training_data_file);
            $uniqueEntries = array_filter(explode("\n", $existingData));
        }

        foreach ($words as $word) {
            $details = getWordDetails($db, $word);
            
            if ($details && !empty($details['definition']) && !empty($details['wiki'])) {
                $description = htmlspecialchars($details['definition'], ENT_QUOTES, 'UTF-8');
                $wiki = htmlspecialchars($details['wiki'], ENT_QUOTES, 'UTF-8');
                
                // Generate primary entry
                $primaryEntry = "the word $word is commonly referred to as $description from $wiki and a link to http://localhost/wordpedia/pages/$word will help.";
                
                // Only add if not already in existing entries
                if (!in_array($primaryEntry, $uniqueEntries)) {
                    $generatedData[] = $primaryEntry;
                    $uniqueEntries[] = $primaryEntry;
                }
                
                // Generate similar word entries
                $similarWords = getSimilarWords($db, $description);
                foreach ($similarWords as $similarWord) {
                    if ($similarWord !== $word) {
                        $similarDetails = getWordDetails($db, $similarWord);
                        if ($similarDetails && !empty($similarDetails['definition']) && !empty($similarDetails['wiki'])) {
                            $similarDescription = htmlspecialchars($similarDetails['definition'], ENT_QUOTES, 'UTF-8');
                            $similarWiki = htmlspecialchars($similarDetails['wiki'], ENT_QUOTES, 'UTF-8');
                            
                            $similarEntry = "the word $similarWord is commonly referred to as $similarDescription from $similarWiki and a link to http://localhost/wordpedia/pages/$similarWord will help.";
                            
                            // Only add if not already in existing entries
                            if (!in_array($similarEntry, $uniqueEntries)) {
                                $generatedData[] = $similarEntry;
                                $uniqueEntries[] = $similarEntry;
                            }
                        }
                    }
                }
            }
        }
        
        if (!empty($generatedData)) {
            // Append new unique entries to the shared file
            $timestamp = date('Y-m-d H:i:s');
            $header = "\n--- Training Data Generated on {$timestamp} by User ID {$user_id} ---\n";
            file_put_contents($shared_training_data_file, $header . implode("\n", $generatedData) . "\n", FILE_APPEND);
            
            return [
                'status' => 'success',
                'message' => "Generated training data for " . count($generatedData) . " unique entries.",
                'wordCount' => count($generatedData)
            ];
        }
        
        return ['status' => 'warning', 'message' => "No new training data generated."];
    }

    $result = generateTrainingData($db2, $shared_training_data_file, $user_id);

    // Award experience points
    $exp_award = $result['wordCount'] * 10;
    $stmt = $db->prepare("UPDATE users SET exp_points = exp_points + ? WHERE user_id = ?");
    $stmt->execute([$exp_award, $user_id]);

    // Ensure clean JSON output
    header('Content-Type: application/json');
    echo json_encode(array_merge($result, ['exp_awarded' => $exp_award]));
    
    // Clear and end output buffering
    ob_end_flush();
    exit;

} catch(Exception $e) {
    // Ensure clean JSON output for errors
    header('Content-Type: application/json');
    echo json_encode([
        'status' => 'error', 
        'message' => $e->getMessage()
    ]);
    ob_end_flush();
    exit;
}
?>