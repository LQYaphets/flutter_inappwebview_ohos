import SslCertificate from './SslCertificate'

export default class SslError {
  public static SSL_NOTYETVALID: number = 0
  public static SSL_EXPIRED: number = 1
  public static SSL_IDMISMATCH: number = 2
  public static SSL_UNTRUSTED: number = 3
  public static SSL_DATE_INVALID: number = 4
  public static SSL_INVALID: number = 5

  public static SSL_MAX_ERROR: number = 6

  mErrors: number

  mCertificate: SslCertificate

  mUrl: string

  constructor(error: number, certificate: SslCertificate, url: string) {
    // if(certificate == null) return
    // if(url == null) return
    this.addError(error)
    this.mErrors = error
    this.mCertificate = certificate;
    this.mUrl = url;
  }

  public addError(error: number): boolean {
    let rval: boolean = (0 <= error && error < SslError.SSL_MAX_ERROR);
    if (rval) {
      this.mErrors |= (0x1 << error);
    }

    return rval;
  }

}