<?php
function prepareTrainingData() {
    $trainingDataFile = 'training_data.txt';
    
    if (!file_exists($trainingDataFile)) {
        return ['status' => 'error', 'message' => 'Training data file not found'];
    }

    $entries = file($trainingDataFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    
    // Clean and process entries
    $trainingData = [];
    
    foreach ($entries as $entry) {
        // Remove headers and trim
        $entry = preg_replace('/^---.*---/', '', $entry);
        $entry = trim($entry);
        
        // Basic preprocessing
        $words = explode(' ', strtolower($entry));
        
        // Create training samples
        for ($i = 0; $i < count($words) - 2; $i++) {
            $trainingData[] = [
                'input' => [
                    $words[$i],
                    $words[$i+1]
                ],
                'output' => $words[$i+2]
            ];
        }
    }

    // Save processed training data
    file_put_contents('brain_training_data.json', json_encode($trainingData));

    return [
        'status' => 'success', 
        'message' => 'Training data prepared',
        'total_samples' => count($trainingData)
    ];
}

// Handle training request
if (isset($_GET['train'])) {
    header('Content-Type: application/json');
    echo json_encode(prepareTrainingData());
    exit;
}

// Handle response generation
if (isset($_POST['query'])) {
    header('Content-Type: application/json');
    echo json_encode(['response' => 'Response generation will be handled by brain.js']);
    exit;
}