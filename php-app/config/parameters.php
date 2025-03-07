<?php
// Configuration parameters for the application

// Define the base URL for the application
$allowed_hosts = ['localhost']; // Whitelist of allowed hosts
if (in_array($_SERVER['HTTP_HOST'], $allowed_hosts)) {
    // Load environment variable for BASE_URL if available
    $env_base_url = getenv('BASE_URL');
    if ($env_base_url) {
        define('BASE_URL', $env_base_url);
    } else {
        // Dynamically determine the base URL
        $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
        if ($_SERVER['HTTP_HOST'] == 'localhost') {
            $port = $_SERVER['SERVER_PORT'] != 80 ? ':' . $_SERVER['SERVER_PORT'] : '';
            define('BASE_URL', 'http://localhost' . $port);
        } else {
            define('BASE_URL', $protocol . '://' . $_SERVER['HTTP_HOST']);
        }
    }
} else {
    die("Invalid host.");
}

// Ensure BASE_URL is defined
if (!defined('BASE_URL')) {
    die("Unable to determine BASE_URL. Please check your server configuration.");
}
?>