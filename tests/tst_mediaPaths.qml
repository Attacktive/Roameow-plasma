import QtQuick
import QtTest
import '../package/contents/code/MediaPaths.js' as MediaPaths

TestCase {
	name: 'MediaPaths'

	function test_absolutePathEncoding_data() {
		return [
			{ tag: 'rawHash', path: '/tmp/cat#1.gif', expected: 'file:///tmp/cat%231.gif' },
			{ tag: 'rawQuery', path: '/tmp/cat?1.gif', expected: 'file:///tmp/cat%3F1.gif' },
			{ tag: 'rawSpace', path: '/tmp/cat space.gif', expected: 'file:///tmp/cat%20space.gif' },
			{ tag: 'rawPercent', path: '/tmp/cat%.gif', expected: 'file:///tmp/cat%25.gif' },
			{ tag: 'invalidEscape', path: '/tmp/cat%2x.gif', expected: 'file:///tmp/cat%252x.gif' },
			{ tag: 'legacyHash', path: '/tmp/cat%231.gif', expected: 'file:///tmp/cat%231.gif' },
			{ tag: 'legacyQuery', path: '/tmp/cat%3F1.gif', expected: 'file:///tmp/cat%3F1.gif' },
			{ tag: 'legacySpace', path: '/tmp/cat%20space.gif', expected: 'file:///tmp/cat%20space.gif' },
			{ tag: 'legacyPercent', path: '/tmp/cat%25.gif', expected: 'file:///tmp/cat%25.gif' },
			{ tag: 'legacyLowercase', path: '/tmp/cat%3f1.gif', expected: 'file:///tmp/cat%3f1.gif' },
			{ tag: 'mixedEncoding', path: '/tmp/cat%231?.gif', expected: 'file:///tmp/cat%231%3F.gif' },
			{ tag: 'unicodeAndReserved', path: '/tmp/고양이 #?.gif', expected: 'file:///tmp/%EA%B3%A0%EC%96%91%EC%9D%B4%20%23%3F.gif' }
		];
	}

	function test_absolutePathEncoding(data) {
		const source = MediaPaths.source(data.path, '');
		compare(source, data.expected);
	}
}
