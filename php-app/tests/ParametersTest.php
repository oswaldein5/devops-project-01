<?php
use PHPUnit\Framework\TestCase;

require_once __DIR__ . '/../config/parameters.php';

class ParametersTest extends TestCase {
    public function testBaseUrlIsDefined() {
        $this->assertTrue(defined('BASE_URL'), "BASE_URL constant is not defined.");
    }

    public function testBaseUrlMatchesEnvValue() {
        $dotenv = parse_ini_file(__DIR__ . '/../.env');
        $this->assertEquals($dotenv['BASE_URL'], BASE_URL, "BASE_URL does not match .env value.");
    }

    public function testEnvFileLoadsCorrectly() {
        $dotenv = parse_ini_file(__DIR__ . '/../.env');
        $this->assertArrayHasKey('DB_HOST', $dotenv, "DB_HOST is missing from .env file.");
        $this->assertArrayHasKey('DB_USER', $dotenv, "DB_USER is missing from .env file.");
        $this->assertArrayHasKey('DB_PASSWORD', $dotenv, "DB_PASSWORD is missing from .env file.");
        $this->assertArrayHasKey('DB_NAME', $dotenv, "DB_NAME is missing from .env file.");
        $this->assertArrayHasKey('APP_USER', $dotenv, "APP_USER is missing from .env file.");
        $this->assertArrayHasKey('APP_PASSWORD', $dotenv, "APP_PASSWORD is missing from .env file.");
    }
}
?>