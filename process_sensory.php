<?php
header('Content-Type: application/json');
session_start();

try {
    $db = new PDO('mysql:host=localhost;dbname=reservesphp2', 'root', '', [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);

    // Get the raw input data
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!$input) {
        throw new Exception('Invalid input data');
    }

    // Insert sensory data into database
    $stmt = $db->prepare("
        INSERT INTO sensory_data (
            audio_level,
            sound_direction,
            sound_intensity,
            motion_x,
            motion_y,
            motion_intensity,
            timestamp,
            data_type
        ) VALUES (
            :audio_level,
            :sound_direction,
            :sound_intensity,
            :motion_x,
            :motion_y,
            :motion_intensity,
            NOW(),
            'realtime'
        )
    ");

    $stmt->execute([
        'audio_level' => $input['audioLevel'] ?? 0,
        'sound_direction' => $input['soundSource']['angle'] ?? 0,
        'sound_intensity' => $input['soundSource']['intensity'] ?? 0,
        'motion_x' => $input['spatialData']['x'] ?? 0,
        'motion_y' => $input['spatialData']['y'] ?? 0,
        'motion_intensity' => $input['spatialData']['intensity'] ?? 0
    ]);

    // Get analysis of last 5 seconds of data
    $stmt = $db->query("
        SELECT 
            AVG(audio_level) as avg_audio,
            AVG(sound_intensity) as avg_sound_intensity,
            AVG(motion_intensity) as avg_motion_intensity
        FROM sensory_data
        WHERE timestamp >= NOW() - INTERVAL 5 SECOND
    ");
    $analysis = $stmt->fetch(PDO::FETCH_ASSOC);

    // Calculate overall activity level
    $activityLevel = ($analysis['avg_audio'] + $analysis['avg_sound_intensity'] + $analysis['avg_motion_intensity']) / 3;

    // Return processed data
    echo json_encode([
        'success' => true,
        'analysis' => [
            'activityLevel' => $activityLevel,
            'soundTrend' => $analysis['avg_sound_intensity'],
            'motionTrend' => $analysis['avg_motion_intensity']
        ],
        'timestamp' => time()
    ]);

} catch (Exception $e) {
    error_log('Sensory Processing Error: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Internal processing error'
    ]);
}