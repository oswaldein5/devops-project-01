<?php
// Start the session if not already started
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

require_once 'config/parameters.php';

// Define allowed pages
$allowed_pages = [
    'login' => 'auth.php',
    'form'  => 'form.php',
];

// Validate and sanitize the page parameter
$page = isset($_GET['page']) && array_key_exists($_GET['page'], $allowed_pages) ? $_GET['page'] : 'login';

// Function to check if the user is authenticated
function isAuthenticated() {
    return isset($_SESSION['logged_in']) && $_SESSION['logged_in'] === true;
}

// Handle routing
if (array_key_exists($page, $allowed_pages)) {
    if ($page === 'form' && !isAuthenticated()) {
        header("Location: " . BASE_URL . "/?page=login");
        exit();
    }
    include $allowed_pages[$page];
} else {
    http_response_code(404);
    error_log("Invalid page requested: $page");
    include '404.php';
    exit();
}
?>