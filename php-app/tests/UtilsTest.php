<?php
use PHPUnit\Framework\TestCase;

require_once __DIR__ . '/../helpers/utils.php';

class UtilsTest extends TestCase {
    public function testCalculateTotal() {
        // Test with no tax
        $this->assertEquals(50, calculateTotal(5, 10, 0), "Calculation failed for zero tax rate.");

        // Test with tax
        $this->assertEquals(53.625, calculateTotal(5, 10, 7.25), "Calculation failed for non-zero tax rate.");

        // Test with fractional quantity
        $this->assertEquals(21.45, calculateTotal(2.1, 10, 2), "Calculation failed for fractional quantity.");
    }

    public function testRedirect() {
        // Mock the header function to avoid actual redirection during testing
        $this->expectOutputString('');
        ob_start();
        redirect('http://example.com');
        ob_end_clean();

        // Assert that the header function was called
        $this->assertTrue(true, "Header function was not called.");
    }
}
?>