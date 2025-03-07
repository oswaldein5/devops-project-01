<?php
// Start the session if not already started
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

require_once 'config/parameters.php';

function redirect($url) {
    // Validate URL to prevent open redirection vulnerabilities
    if (filter_var($url, FILTER_VALIDATE_URL) && parse_url($url, PHP_URL_HOST) === $_SERVER['HTTP_HOST']) {
        header("Location: $url");
        exit();
    } else {
        die("Invalid redirection URL.");
    }
}

// Generate a CSRF token if not already set
if (!isset($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate CSRF token
    if (!isset($_POST['csrf_token']) || $_POST['csrf_token'] !== $_SESSION['csrf_token']) {
        die("Invalid CSRF token.");
    }

    // Sanitize and validate inputs
    $username = filter_input(INPUT_POST, 'username', FILTER_SANITIZE_FULL_SPECIAL_CHARS);
    $password = $_POST['password']; // Do not sanitize passwords

    $envUsername = getenv('DEMO_USERNAME');
    $envPassword = getenv('DEMO_PASSWORD');

    // Verify credentials
    if ($username === $envUsername && $password === $envPassword) {
        // Regenerate session ID to prevent session fixation
        session_regenerate_id(true);
        $_SESSION['logged_in'] = true;
        redirect(BASE_URL . '/form');
    } else {
        error_log("Failed login attempt for username: $username");
        $error = "Login failed. Please check your credentials.";
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
</head>
<body>
    <h1>Login</h1>
    <?php if (isset($error)) echo "<p style='color:red;'>$error</p>"; ?>
    <form method="post" action="<?php echo htmlspecialchars($_SERVER['PHP_SELF']); ?>">
        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($_SESSION['csrf_token']) ?>">
        <label>Username: <input type="text" name="username" required></label><br>
        <label>Password: <input type="password" name="password" required></label><br>
        <button type="submit">Login</button>
    </form>
</body>
</html>