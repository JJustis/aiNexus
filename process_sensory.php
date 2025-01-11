<?php
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 0); // Prevent PHP errors from breaking JSON output

try {
    // Database connection
    $db = new PDO('mysql:host=localhost;dbname=reservesphp2', 'root', '', [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);

    // Get the raw input data
    $input = file_get_contents('php://input');
    $data = json_decode($input, true);

    // Validate input data
    if (!$data) {
        throw new Exception('Invalid input data');
    }

    // Initialize response data
    $response = [
        'success' => true,
        'levels' => [
            isset($data['audioLevel']) ? floatval($data['audioLevel']) : 0,
            0, // video level placeholder
            0  // motion level placeholder
        ],
        'audio' => array_fill(0, 32, 0), // Default audio visualization data
        'timestamp' => time()
    ];

    // Store sensory data in database
    $stmt = $db->prepare("
        INSERT INTO sensory_inputs 
        (input_type, processed_data, created_at) 
        VALUES (?, ?, NOW())
    ");

    $processedData = json_encode([
        'audio' => $data['audioLevel'] ?? 0,
        'motion' => $data['motionData'] ?? null
    ]);

    $stmt->execute(['combined', $processedData]);

    // Send JSON response
    echo json_encode($response);

} catch (Exception $e) {
    // Log error
    error_log("Sensory Processing Error: " . $e->getMessage());
    
    // Send error response
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Internal processing error',
        'levels' => [0, 0, 0],
        'audio' => array_fill(0, 32, 0)
    ]);
}
?>