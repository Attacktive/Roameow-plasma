.pragma library

/**
 * Resolves a media source path or URL.
 * Returns the fallback when path is empty, preserves full URLs, and converts legacy bare absolute paths into file:// URLs.
 */
function source(path, fallback) {
	if (path === undefined || path === null) {
		return fallback;
	}

	const raw = path.toString();
	if (raw === '') {
		return fallback;
	}

	if (/^[a-zA-Z][a-zA-Z0-9+.-]*:\/\//.test(raw)) {
		return raw;
	}

	if (raw.startsWith('/')) {
		// Preserve percent escapes stored by the legacy image picker.
		const encodedPath = encodeURI(raw).replace(/%25([0-9a-f]{2})/gi, '%$1').replace(/[?#]/g, encodeURIComponent);
		return `file://${encodedPath}`;
	}

	return raw;
}
