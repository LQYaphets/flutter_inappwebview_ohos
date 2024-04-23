export default class URLUtil {
  static guessFileName(url: string, contentDisposition: string | null, mimeType: string | null): string | null {
    let filename: string | null = null;
    if (contentDisposition) {
      const filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
      const matches = filenameRegex.exec(contentDisposition);
      if (matches && matches[1]) {
        filename = matches[1].replace(/['"]/g, '');
      }
    }
    if (!filename) {
      const urlParts = url.split('/');
      filename = decodeURIComponent(urlParts[urlParts.length - 1]);
    }

    if (!filename) {
      filename = "downloadfile";
    }

    let dotIndex = filename.indexOf('.');
    if (dotIndex < 0 && mimeType) {
      const extension = mimeType.split('/')[1]; // 假设 MIME 类型是 'type/subtype'
      filename = `${filename}.${extension}`;
    }
    return filename
  }
}