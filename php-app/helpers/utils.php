<?php
/**
 * Utility functions for the application.
 */

/**
 * Redirects the user to the specified URL.
 *
 * @param string $url The URL to redirect to.
 * @throws Exception If the URL is invalid or unsafe.
 */
function redirect($url) {
    // Ensure HTTPS
    # if (!preg_match('/^https/', $url)) {
    #    $url = preg_replace('/^http:\/\//', 'https://', $url);
    # }

    // Validate URL to prevent open redirection vulnerabilities
    if (filter_var($url, FILTER_VALIDATE_URL) && parse_url($url, PHP_URL_HOST) === $_SERVER['HTTP_HOST']) {
        header("Location: $url");
        exit();
    } else {
        die("Invalid redirection URL.");
    }
}

/**
 * Calculates the total price, including tax.
 *
 * @param float|int $quantity The quantity of items.
 * @param float|int $price The price per item.
 * @param float|int $taxRate The tax rate as a percentage.
 * @return float The total price, rounded to two decimal places.
 * @throws InvalidArgumentException If any input is invalid.
 */
function calculateTotal($quantity, $price, $taxRate) {
    // Validate inputs
    if (!is_numeric($quantity) || $quantity <= 0) {
        throw new InvalidArgumentException("Quantity must be a positive number.");
    }
    if (!is_numeric($price) || $price < 0) {
        throw new InvalidArgumentException("Price must be a non-negative number.");
    }
    if (!is_numeric($taxRate) || $taxRate < 0) {
        throw new InvalidArgumentException("Tax rate must be a non-negative number.");
    }

    // Perform calculation
    $subtotal = $quantity * $price;
    $tax = $subtotal * ($taxRate / 100);
    return round($subtotal + $tax, 2); // Round to 2 decimal places for currency precision
}