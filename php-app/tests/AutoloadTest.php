<?php
use PHPUnit\Framework\TestCase;

require_once __DIR__ . '/../autoload.php';

class AutoloadTest extends TestCase {
    public function testAutoloadRegistersCorrectly() {
        // Check if spl_autoload_functions contains our autoload function
        $autoloadFunctions = spl_autoload_functions();
        $this->assertNotEmpty($autoloadFunctions);

        $found = false;
        foreach ($autoloadFunctions as $function) {
            if (is_array($function) && $function[0] === 'spl_autoload_call') {
                $found = true;
                break;
            }
        }
        $this->assertTrue($found, "Autoloader was not registered.");
    }

    public function testAutoloadLoadsClass() {
        // Create a sample class file for testing
        $className = 'SampleClass';
        $filePath = __DIR__ . "/../{$className}.php";
        file_put_contents($filePath, "<?php class {$className} { public function greet() { return 'Hello'; } }");

        // Attempt to load the class
        $this->assertTrue(class_exists($className), "Class {$className} was not autoloaded.");

        // Clean up the temporary file
        unlink($filePath);
    }
}
?>