/**
 * CTPersonController
 * Main controller of Person__c object
 * @author Manish
 */
public with sharing class CTPersonController {
    /**
     * generate unique token using mobile number
     * use MD5 algorithm to generate one-way hash
     * @param mobile
     * @return string token
     */
    public static String getToken(String mobile) {
        // generate unique hash using md5 algorithm
        Blob value = Blob.valueOf(mobile);
        Blob hash = Crypto.generateDigest('MD5', value);
        // return encoded string
        return EncodingUtil.base64Encode(hash);
    }
}
