<?php
require_once 'config/parameters.php';

class Conexion
{
    private $host;
    private $port = '3306';
    private $dbname;
    private $username;
    private $password;

    public function __construct()
    {
        $this->host = getenv('MYSQL_HOST');
        $this->dbname = getenv('MYSQL_DATABASE');
        $this->username = getenv('ADMIN_USERNAME');
        $this->password = getenv('ADMIN_PASSWORD');
    }

    public function conectar()
    {
        try {
            $connect = new PDO("mysql:host=$this->host;port=$this->port;dbname=$this->dbname", $this->username, $this->password);
            $connect->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            return $connect;
        } catch (PDOException $e) {
            echo 'Connection failed: ' . $e->getMessage();
        }
    }
}
?>