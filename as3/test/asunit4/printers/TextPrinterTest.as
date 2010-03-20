package asunit4.printers {
    
    import asunit.framework.Test;
    import asunit.framework.TestCase;
    import asunit4.framework.ITestSuccess;
    import asunit4.framework.TestSuccess;
    import asunit.framework.ITestFailure;
    import asunit4.framework.TestFailure;
    import asunit4.framework.IResult;
    import asunit4.framework.Result;

    public class TextPrinterTest extends TestCase {

        private var printer:FakeTextPrinter;
        private var test:Test;
        private var success:ITestSuccess;
        private var failure:ITestFailure;
        private var testResult:IResult;

        public function TextPrinterTest(method:String=null) {
            super(method);
        }

        override protected function setUp():void {
            super.setUp();
            printer    = new FakeTextPrinter();
            testResult = new Result();
            test       = new TestCase();
            failure    = new TestFailure(test, 'testSomethingThatFails', new Error('Fake Failure'));
            success    = new TestSuccess(test, 'testSomethingThatSucceeds');
            testResult.addListener(printer);
        }

        override protected function tearDown():void {
            super.tearDown();
            removeChild(printer);
            failure    = null;
            printer    = null;
            testResult = null;
            success    = null;
            test       = null;
        }

        private function executeASucceedingTest():void {
            testResult.onRunStarted();
            testResult.onTestStarted(test);
            testResult.onTestSuccess(success);
            testResult.onTestCompleted(test);
            testResult.onRunCompleted(null);
        }

        private function executeAFailingTest():void {
            testResult.onRunStarted();
            testResult.onTestStarted(test);
            testResult.onTestFailure(failure);
            testResult.onTestCompleted(test);
            testResult.onRunCompleted(null);
        }

        public function testPrinterOnTestSuccess():void {
            executeASucceedingTest();
            assertTrue("Printer should print OK", printer.toString().indexOf('OK') > -1);
        }

        public function testPrinterFailure():void {
            executeAFailingTest();
            var expected:String = "testSomethingThatFails : Error: Fake Failure";
            var actual:String = printer.toString();
            assertTrue("Printer should fail", actual.indexOf(expected) > -1);
            assertTrue("Printer should include Test Duration: " + printer, actual.match(/\nTotal Time: \d/));
        }

        public function testPrinterDisplayed():void {
            addChild(printer);
            executeASucceedingTest();
            assertTrue("The output was displayed.", printer.getTextDisplay().text.indexOf('Time Summary:') > -1);
        }
    }
}

import asunit4.printers.TextPrinter;
import flash.text.TextField;

class FakeTextPrinter extends TextPrinter {

    // Prevent the printer from tracing results:
    override protected function logResult():void {
    }

    public function getTextDisplay():TextField {
        return textDisplay;
    }
}

