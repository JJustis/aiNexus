<?php
class DatabaseConnection {
    private static $instance = null;
    private $connection;

    private $host = 'localhost';
    private $dbname = 'reservesphp2';
    private $username = 'root';
    private $password = '';
    private $charset = 'utf8mb4';

    // Private constructor to prevent direct instantiation
    private function __construct() {
        try {
            // Set DSN (Data Source Name)
            $dsn = "mysql:host={$this->host};dbname={$this->dbname};charset={$this->charset}";
            
            // PDO options
            $options = [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES   => false,
            ];

            // Create a PDO instance
            $this->connection = new PDO($dsn, $this->username, $this->password, $options);
        } catch (PDOException $e) {
            // Log error instead of displaying sensitive information
            error_log('Database Connection Error: ' . $e->getMessage());
            throw new Exception('Database connection failed. Please try again later.');
        }
    }

    // Singleton pattern to ensure only one database connection
    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    // Get the database connection
    public function getConnection() {
        return $this->connection;
    }

    // Prevent cloning of the instance
    private function __clone() {}

    // Prevent unserialize of the instance
    public function __wakeup() {}

    /**
     * Helper method to execute a query
     * 
     * @param string $sql SQL query
     * @param array $params Query parameters
     * @return PDOStatement
     */
    public function query($sql, $params = []) {
        try {
            $stmt = $this->connection->prepare($sql);
            $stmt->execute($params);
            return $stmt;
        } catch (PDOException $e) {
            error_log('Query Error: ' . $e->getMessage());
            throw new Exception('Database query failed.');
        }
    }

    /**
     * Begin a database transaction
     */
    public function beginTransaction() {
        $this->connection->beginTransaction();
    }

    /**
     * Commit a database transaction
     */
    public function commit() {
        $this->connection->commit();
    }

    /**
     * Rollback a database transaction
     */
    public function rollback() {
        $this->connection->rollBack();
    }
}

// Function to get database connection quickly
function getDbConnection() {
    try {
        return DatabaseConnection::getInstance()->getConnection();
    } catch (Exception $e) {
        // Log error and handle gracefully
        error_log('Database Connection Error: ' . $e->getMessage());
        die('Sorry, a database error occurred.');
    }
}

// Optional: Configuration check
function checkDatabaseConnection() {
    try {
        $db = DatabaseConnection::getInstance()->getConnection();
        return true;
    } catch (Exception $e) {
        error_log('Database Connection Check Failed: ' . $e->getMessage());
        return false;
    }
}