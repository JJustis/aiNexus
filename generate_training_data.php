<?php
// Disable all error output to prevent JSON parsing issues
error_reporting(0);

// Start output buffering to capture and clean any potential output
ob_start();

// Establish database connection
try {
    $db = new PDO('mysql:host=localhost;dbname=reservesphp', 'root', '', [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_SILENT
    ]);
} catch(PDOException $e) {
    // Clear any previous output
    ob_end_clean();
    
    // Send clean JSON response
    header('Content-Type: application/json');
    echo json_encode([
        'status' => 'error',
        'message' => 'Database connection failed: ' . $e->getMessage()
    ]);
    exit;
}

function getWordDetails($word) {
    global $db;
    $stmt = $db->prepare("SELECT definition, wiki FROM word WHERE word = :word");
    $stmt->execute(['word' => $word]);
    return $stmt->fetch(PDO::FETCH_ASSOC);
}

function getSimilarWords($definition) {
    global $db;
    $stmt = $db->prepare("SELECT word FROM word WHERE definition LIKE :definition");
    $stmt->execute(['definition' => '%' . $definition . '%']);
    return $stmt->fetchAll(PDO::FETCH_COLUMN);
}

function generateTrainingData($word) {
    $details = getWordDetails($word);
    
    if ($details && !empty($details['definition']) && !empty($details['wiki'])) {
        $description = htmlspecialchars($details['definition'], ENT_QUOTES, 'UTF-8');
        $wiki = htmlspecialchars($details['wiki'], ENT_QUOTES, 'UTF-8');
        
        $trainingEntries = [];
        $trainingEntries[] = "the word $word is commonly referred to as $description from $wiki and a link to http://localhost/wordpedia/pages/$word will help.";
        
        $similarWords = getSimilarWords($description);
        foreach ($similarWords as $similarWord) {
            if ($similarWord !== $word) {
                $similarDetails = getWordDetails($similarWord);
                if ($similarDetails && !empty($similarDetails['definition']) && !empty($similarDetails['wiki'])) {
                    $similarDescription = htmlspecialchars($similarDetails['definition'], ENT_QUOTES, 'UTF-8');
                    $similarWiki = htmlspecialchars($similarDetails['wiki'], ENT_QUOTES, 'UTF-8');
                    $trainingEntries[] = "the word $similarWord is commonly referred to as $similarDescription from $similarWiki and a link to http://localhost/wordpedia/pages/$similarWord will help.";
                }
            }
        }
        
        return implode("\n", $trainingEntries);
    }
    
    return null;
}

function updateTrainingData() {
    global $db;
    try {
        $stmt = $db->query("SELECT word FROM word");
        $words = $stmt->fetchAll(PDO::FETCH_COLUMN);
        
        $trainingDataFile = 'training_data.txt';
        $generatedData = [];
        
        foreach ($words as $word) {
            $trainingData = generateTrainingData($word);
            if ($trainingData !== null) {
                $generatedData[] = $trainingData;
            }
        }
        
        if (!empty($generatedData)) {
            // Overwrite the file with new data to avoid duplicates
            file_put_contents($trainingDataFile, implode("\n", $generatedData) . "\n");
            return [
                'status' => 'success',
                'message' => "Generated training data for " . count($words) . " words.",
                'wordCount' => count($words)
            ];
        } else {
            return [
                'status' => 'warning',
                'message' => "No training data generated.",
                'wordCount' => 0
            ];
        }
    } catch(Exception $e) {
        return [
            'status' => 'error',
            'message' => "Error generating training data: " . $e->getMessage(),
            'wordCount' => 0
        ];
    }
}

// Handle AJAX request with comprehensive error handling
if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['update'])) {
    // Clear any previous output
    ob_end_clean();
    
    // Set JSON header
    header('Content-Type: application/json');
    
    try {
        $result = updateTrainingData();
        echo json_encode($result);
    } catch(Exception $e) {
        echo json_encode([
            'status' => 'error',
            'message' => "Unhandled exception: " . $e->getMessage(),
            'wordCount' => 0
        ]);
    }
    exit;
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Training Data Generation</title>
    <script>
        function updateTrainingData() {
            console.log('Attempting to fetch training data...');
            fetch('generate_training_data.php')
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('Received data:', data);
                    const trainingDataElement = document.getElementById('trainingData');
                    
                    // Create a new paragraph with different styling based on status
                    const p = document.createElement('p');
                    p.textContent = data.message;
                    
                    switch(data.status) {
                        case 'success':
                            p.style.color = 'green';
                            break;
                        case 'warning':
                            p.style.color = 'orange';
                            break;
                        case 'error':
                            p.style.color = 'red';
                            break;
                    }
                    
                    trainingDataElement.appendChild(p);
                })
                .catch(error => {
                    console.error('Fetch Error:', error);
                    const trainingDataElement = document.getElementById('trainingData');
                    const p = document.createElement('p');
                    p.textContent = `Error: ${error.message}`;
                    p.style.color = 'red';
                    trainingDataElement.appendChild(p);
                });
        }

        // Call updateTrainingData every 5 seconds
        setInterval(updateTrainingData, 5000);

        // Initial call to update data immediately
        document.addEventListener('DOMContentLoaded', updateTrainingData);
    </script>
</head>
<body>
    <h1>Training Data Generation</h1>
    <div id="trainingData"></div>
</body>
</html>