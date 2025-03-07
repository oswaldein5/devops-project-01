<?php
// Start the session if not already started
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

// Redirect unauthorized users
if (!isset($_SESSION['logged_in'])) {
    header("Location: " . BASE_URL . "/auth.php");
    exit();
}

// Include necessary files
require_once 'connection.php';
require_once 'helpers/utils.php';

// Generate a CSRF token if not already set
if (!isset($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

// Fetch cities and products from the database
try {
    $stmtCities = $pdo->prepare("SELECT * FROM cities");
    $stmtCities->execute();
    $cities = $stmtCities->fetchAll(PDO::FETCH_ASSOC);

    $stmtProducts = $pdo->prepare("SELECT * FROM products");
    $stmtProducts->execute();
    $products = $stmtProducts->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    error_log("Database error: " . $e->getMessage());
    die("An error occurred while loading data. Please try again later.");
}

// Initialize variables
$total = null;
$errors = [];

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate CSRF token
    if (!isset($_POST['csrf_token']) || $_POST['csrf_token'] !== $_SESSION['csrf_token']) {
        $errors[] = "Invalid CSRF token.";
    }

    // Validate inputs
    $cityId = filter_input(INPUT_POST, 'city', FILTER_VALIDATE_INT);
    $storeId = filter_input(INPUT_POST, 'store', FILTER_VALIDATE_INT);
    $quantity = filter_input(INPUT_POST, 'quantity', FILTER_VALIDATE_INT);
    $productId = filter_input(INPUT_POST, 'product', FILTER_VALIDATE_INT);

    if (!$cityId || !$storeId || !$quantity || !$productId) {
        $errors[] = "Invalid input. Please ensure all fields are filled correctly.";
    }

    // Fetch city tax rate
    if (empty($errors)) {
        try {
            $cityStmt = $pdo->prepare("SELECT tax_rate FROM cities WHERE id = ?");
            $cityStmt->execute([$cityId]);
            $city = $cityStmt->fetch(PDO::FETCH_ASSOC);

            if (!$city) {
                $errors[] = "Invalid city selection.";
            }
        } catch (PDOException $e) {
            error_log("Database error: " . $e->getMessage());
            $errors[] = "An error occurred while fetching city data.";
        }
    }

    // Fetch product price
    if (empty($errors)) {
        try {
            $productStmt = $pdo->prepare("SELECT price FROM products WHERE id = ?");
            $productStmt->execute([$productId]);
            $product = $productStmt->fetch(PDO::FETCH_ASSOC);

            if (!$product) {
                $errors[] = "Invalid product selection.";
            }
        } catch (PDOException $e) {
            error_log("Database error: " . $e->getMessage());
            $errors[] = "An error occurred while fetching product data.";
        }
    }

    // Calculate total if no errors
    if (empty($errors)) {
        $total = calculateTotal($quantity, $product['price'], $city['tax_rate']);
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form</title>
    <script>
        function loadStores() {
            const cityId = document.getElementById('city').value;
            const storeDropdown = document.getElementById('store');

            storeDropdown.innerHTML = '<option value="">Loading...</option>';

            fetch(`get_stores.php?city_id=${cityId}`)
                .then(response => response.json())
                .then(data => {
                    storeDropdown.innerHTML = '';
                    if (data.length > 0) {
                        data.forEach(store => {
                            const option = document.createElement('option');
                            option.value = store.id;
                            option.textContent = store.store_name;
                            storeDropdown.appendChild(option);
                        });
                    } else {
                        storeDropdown.innerHTML = '<option value="">No stores available</option>';
                    }
                })
                .catch(error => {
                    console.error('Error fetching stores:', error);
                    storeDropdown.innerHTML = '<option value="">Error loading stores</option>';
                });
        }
    </script>
</head>
<body>
    <h1>Estimate Total</h1>

    <?php if (!empty($errors)): ?>
        <div style="color: red;">
            <ul>
                <?php foreach ($errors as $error): ?>
                    <li><?= htmlspecialchars($error) ?></li>
                <?php endforeach; ?>
            </ul>
        </div>
    <?php endif; ?>

    <form method="post" action="">
        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($_SESSION['csrf_token']) ?>">

        <label>City:
            <select name="city" id="city" required onchange="loadStores()">
                <option value="">Select a city</option>
                <?php foreach ($cities as $city): ?>
                    <option value="<?= htmlspecialchars($city['id']) ?>" <?= isset($cityId) && $cityId == $city['id'] ? 'selected' : '' ?>>
                        <?= htmlspecialchars($city['city_name']) ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </label><br>

        <label>Store:
            <select name="store" id="store" required>
                <option value="">Select a store</option>
            </select>
        </label><br>

        <label>Product:
            <select name="product" required>
                <option value="">Select a product</option>
                <?php foreach ($products as $product): ?>
                    <option value="<?= htmlspecialchars($product['id']) ?>" <?= isset($productId) && $productId == $product['id'] ? 'selected' : '' ?>>
                        <?= htmlspecialchars($product['product_name']) ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </label><br>

        <label>Quantity:
            <input type="number" name="quantity" min="1" required value="<?= isset($quantity) ? htmlspecialchars($quantity) : '' ?>">
        </label><br>

        <button type="submit">Show Estimated Total</button>
    </form>

    <?php if (isset($total)): ?>
        <h2>Total: $<?= number_format($total, 2) ?></h2>
        <button onclick="window.location.href='<?= BASE_URL ?>/form.php'">New Search</button>
    <?php endif; ?>
</body>
</html>