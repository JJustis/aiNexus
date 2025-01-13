<?php
// Security headers
header('Strict-Transport-Security: max-age=31536000; includeSubDomains');
header('X-XSS-Protection: 1; mode=block');
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: DENY');
header('Referrer-Policy: same-origin');
header('Content-Security-Policy: default-src \'self\'');

// Advanced error reporting and logging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Configuration constants
define('APP_ROOT', __DIR__);
define('DB_HOST', 'localhost');
define('WORDS_DB_NAME', 'reservesphp');
define('ARTICLES_DB_NAME', 'reservesphp2');
define('LOG_DIR', APP_ROOT . '/logs');
define('LOG_FILE', LOG_DIR . '/article_generation.log');
define('MAX_GENERATION_ATTEMPTS', 3);

// Required files
require_once APP_ROOT . '/text_processor.php';
require_once APP_ROOT . '/database_connection.php';
require_once APP_ROOT . '/advanced_article_generator.php';

// Ensure log directory exists
if (!is_dir(LOG_DIR)) {
    mkdir(LOG_DIR, 0755, true);
}

// Comprehensive logging function
function logEvent($level, $message, $context = []) {
    $timestamp = date('Y-m-d H:i:s');
    $logEntry = "[{$timestamp}] [{$level}] {$message}\n";
    
    if (!empty($context)) {
        $logEntry .= "Context: " . json_encode($context, JSON_PRETTY_PRINT) . "\n";
    }
    
    file_put_contents(LOG_FILE, $logEntry, FILE_APPEND);
}

// Advanced response handler
class ResponseHandler {
    public static function sendJsonResponse($data, $statusCode = 200) {
        header('Content-Type: application/json');
        http_response_code($statusCode);
        
        echo json_encode($data + [
            'server_timestamp' => date('Y-m-d H:i:s'),
            'request_id' => uniqid('req_', true)
        ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        exit;
    }

    public static function sendSuccessResponse($articleId, $additionalData = []) {
        logEvent('INFO', 'Article generation successful', [
            'article_id' => $articleId,
            'additional_data' => $additionalData
        ]);

        self::sendJsonResponse([
            'success' => true,
            'articleId' => $articleId,
            'message' => 'Article generated successfully',
            'details' => $additionalData
        ]);
    }

    public static function sendErrorResponse($message, $context = [], $statusCode = 400) {
        logEvent('ERROR', $message, $context);

        self::sendJsonResponse([
            'success' => false,
            'message' => $message,
            'error_details' => $context
        ], $statusCode);
    }
}

// Database connection manager
class DatabaseConnectionManager {
    private static $connections = [];
    private static $connectionTimeouts = [];
    const CONNECTION_TIMEOUT = 3600; // 1 hour

    public static function getConnection($host, $dbName, $username = 'root', $password = '') {
        $connectionKey = "{$host}_{$dbName}";
        
        if (isset(self::$connections[$connectionKey])) {
            if (self::isConnectionValid($connectionKey)) {
                return self::$connections[$connectionKey];
            }
            self::closeConnection($connectionKey);
        }

        try {
            $dsn = "mysql:host={$host};dbname={$dbName};charset=utf8mb4";
            $options = [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
                PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci",
                PDO::ATTR_TIMEOUT => 5
            ];
            
            $connection = new PDO($dsn, $username, $password, $options);
            $connection->query("SELECT 1");
            
            self::$connections[$connectionKey] = $connection;
            self::$connectionTimeouts[$connectionKey] = time() + self::CONNECTION_TIMEOUT;
            
            return $connection;
        } catch (PDOException $e) {
            ResponseHandler::sendErrorResponse("Database connection failed", [
                'host' => $host,
                'database' => $dbName,
                'error' => $e->getMessage()
            ]);
        }
    }

    private static function isConnectionValid($connectionKey) {
        if (!isset(self::$connectionTimeouts[$connectionKey]) || 
            time() > self::$connectionTimeouts[$connectionKey]) {
            return false;
        }

        try {
            self::$connections[$connectionKey]->query("SELECT 1");
            return true;
        } catch (PDOException $e) {
            return false;
        }
    }

    private static function closeConnection($connectionKey) {
        self::$connections[$connectionKey] = null;
        unset(self::$connections[$connectionKey]);
        unset(self::$connectionTimeouts[$connectionKey]);
    }
}

// Comprehensive request validator
class RequestValidator {
    private static $validArticleTypes = [
        'term_article', 
        'trending_article', 
        'rss_synthesized_article'
    ];

    private static $validRSSCategories = [
    'technology', 
    'science', 
    'business',
    'world_news',
    'entertainment', 
    'sports', 
    'health', 
    'technology_reviews', 
    'environment', 
    'finance'
];

    public static function validateArticleGenerationRequest($postData) {
        if (!self::validateContentType()) {
            ResponseHandler::sendErrorResponse('Invalid Content-Type');
        }

        if (!isset($postData['article_type']) || 
            !in_array($postData['article_type'], self::$validArticleTypes)) {
            ResponseHandler::sendErrorResponse('Invalid article type', [
                'provided_type' => $postData['article_type'] ?? 'Not provided',
                'allowed_types' => self::$validArticleTypes
            ]);
        }

        switch ($postData['article_type']) {
            case 'term_article':
                self::validateTermArticle($postData);
                break;
            
            case 'rss_synthesized_article':
                self::validateRSSSynthesizedArticle($postData);
                break;
            
            case 'trending_article':
                self::validateTrendingArticle($postData);
                break;
        }
        
        return true;
    }

    private static function validateContentType() {
        $contentType = $_SERVER['CONTENT_TYPE'] ?? '';
        return strpos($contentType, 'application/x-www-form-urlencoded') !== false ||
               strpos($contentType, 'multipart/form-data') !== false;
    }

    private static function validateTermArticle($postData) {
        if (isset($postData['word']) && !empty($postData['word'])) {
            $word = trim($postData['word']);
            
            if (!preg_match('/^[a-zA-Z\-\s]{2,50}$/', $word)) {
                ResponseHandler::sendErrorResponse('Invalid word format', [
                    'word' => $word,
                    'error' => 'Word must be 2-50 characters, containing only letters, spaces, and hyphens'
                ]);
            }
        }
    }

    private static function validateRSSSynthesizedArticle($postData) {
        $category = $postData['rss_category'] ?? 'technology';
        
        if (!in_array($category, self::$validRSSCategories)) {
            ResponseHandler::sendErrorResponse('Invalid RSS category', [
                'provided_category' => $category,
                'allowed_categories' => self::$validRSSCategories
            ]);
        }
    }

    private static function validateTrendingArticle($postData) {
        // Add any trending article specific validation here
        if (isset($postData['trend_source']) && 
            !in_array($postData['trend_source'], ['rss', 'api', 'manual'])) {
            ResponseHandler::sendErrorResponse('Invalid trend source');
        }
    }
}

// Main script execution
try {
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        ResponseHandler::sendErrorResponse(
            'Only POST requests are allowed', 
            ['method' => $_SERVER['REQUEST_METHOD']], 
            405
        );
    }

    if (empty($_POST)) {
        ResponseHandler::sendErrorResponse('Empty request payload', [], 400);
    }

    RequestValidator::validateArticleGenerationRequest($_POST);

    $wordsDb = DatabaseConnectionManager::getConnection(
        DB_HOST, 
        WORDS_DB_NAME
    );
    $articlesDb = DatabaseConnectionManager::getConnection(
        DB_HOST, 
        ARTICLES_DB_NAME
    );

    $articleType = $_POST['article_type'];
    $options = [];

    switch ($articleType) {
        case 'term_article':
            if (!empty($_POST['word'])) {
                $options['word'] = filter_var($_POST['word'], FILTER_SANITIZE_STRING);
            }
            break;

        case 'rss_synthesized_article':
            $options['category'] = $_POST['rss_category'] ?? 'technology';
            break;
            
        case 'trending_article':
            $options['trend_source'] = $_POST['trend_source'] ?? 'rss';
            break;
    }

    $attempts = 0;
    $articleId = null;

    while ($attempts < MAX_GENERATION_ATTEMPTS) {
        try {
            $generator = new AdvancedArticleGenerator($wordsDb, $articlesDb);
            $articleId = $generator->generateArticle($articleType, $options);
            
            if ($articleId) {
                break;
            }
        } catch (Exception $e) {
            logEvent('WARNING', 'Article generation attempt failed', [
                'attempt' => $attempts + 1,
                'error' => $e->getMessage(),
                'type' => $articleType,
                'options' => $options
            ]);
        }
        
        $attempts++;
    }

    if (!$articleId) {
        ResponseHandler::sendErrorResponse(
            'Failed to generate article after multiple attempts', 
            [
                'article_type' => $articleType,
                'generation_options' => $options
            ], 
            500
        );
    }

    ResponseHandler::sendSuccessResponse($articleId, [
        'article_type' => $articleType,
        'generation_options' => $options,
        'attempts' => $attempts + 1
    ]);

} catch (Throwable $e) {
    ResponseHandler::sendErrorResponse(
        'Unexpected system error', 
        [
            'error_message' => $e->getMessage(),
            'error_trace' => $e->getTraceAsString()
        ], 
        500
    );
}