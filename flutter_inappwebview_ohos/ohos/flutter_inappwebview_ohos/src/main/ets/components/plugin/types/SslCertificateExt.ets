import cert from '@ohos.security.cert';
import { Any } from '@ohos/flutter_ohos';

export default class SslCertificateExt {
  constructor() {}

  public static toMap(X509Cert: Array<cert.X509Cert> | null): Map<string, Any> | null{
    if(X509Cert == null) {
      return null
    }

    let sslCertificateMap: Map<string, Any> = new Map<string, Any>();

    for (let i = 0; i < X509Cert.length; i++) {
      let x509CertificateData = X509Cert[i].getEncoded()

      let validNotAfterDate: string = X509Cert[i].getNotAfterTime()
      let validNotBeforeDate: string = X509Cert[i].getNotBeforeTime()

      sslCertificateMap.set("issuedBy", Uint8ArrayToString(X509Cert[i].getIssuerName().data));
      sslCertificateMap.set("issuedTo", Uint8ArrayToString(X509Cert[i].getSubjectName().data));
      sslCertificateMap.set("validNotAfterDate", validNotAfterDate);
      sslCertificateMap.set("validNotBeforeDate", validNotBeforeDate);
      sslCertificateMap.set("x509Certificate", x509CertificateData);
    }


    return sslCertificateMap;
  }
}

function Uint8ArrayToString(dataArray:Uint8Array) {
  let dataString = ''
  for (let i = 0; i < dataArray.length; i++) {
    dataString += String.fromCharCode(dataArray[i])
  }
  return dataString
}