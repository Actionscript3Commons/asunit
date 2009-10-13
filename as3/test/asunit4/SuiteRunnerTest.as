package asunit4 {
	import asunit.framework.TestCase;
	import flash.events.Event;
	import flash.utils.describeType;
	import asunit4.support.DoubleFailSuite;
	import asunit4.support.FailAssertTrueTest;
	import asunit4.support.FailAssertEqualsTest;
	import asunit4.events.TestResultEvent;
	import asunit.framework.ITestFailure;

	public class SuiteRunnerTest extends TestCase {
		private var suiteRunner:SuiteRunner;
		private var suiteClass:Class;

		public function SuiteRunnerTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			suiteRunner = new SuiteRunner();
			suiteClass = DoubleFailSuite;
		}

		protected override function tearDown():void {
			suiteRunner = null;
			suiteClass = null;
		}
		
		//////
		
		public function test_run_triggers_TestResultEvent_with_wasSuccessful_false_and_failures():void {
			suiteRunner.addEventListener(TestResultEvent.SUITE_COMPLETED, addAsync(check_TestResult_wasSuccessful_false, 100));
			suiteRunner.run(suiteClass);
		}
		
		private function check_TestResult_wasSuccessful_false(e:TestResultEvent):void {
			assertFalse(e.testResult.wasSuccessful);
			
			var failures:Array = e.testResult.failures;
			assertEquals('failures in testResult', 2, failures.length);
			
			var failure0:ITestFailure = failures[0] as ITestFailure;
			assertSame('failure0 test class', FailAssertEqualsTest, failure0.failedTest['constructor']);
			
			var failure1:ITestFailure = failures[1] as ITestFailure;
			assertSame('failure1 test class', FailAssertTrueTest, failure1.failedTest['constructor']);
		}
	}
}
