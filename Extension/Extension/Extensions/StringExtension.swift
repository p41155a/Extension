//
//  StringExtension.swift
//  Extension
//
//  Created by Yoojin Park on 2020/09/07.
//  Copyright © 2020 Yoojin Park. All rights reserved.
//

import UIKit

extension String {
    var youTubeId: String? {
        let typePattern = "(?:(?:\\.be\\/|embed\\/|v\\/|\\?v=|\\&v=|\\/videos\\/)|(?:[\\w+]+#\\w\\/\\w(?:\\/[\\w]+)?\\/\\w\\/))([\\w-_]+)"
        let regex = try? NSRegularExpression(pattern: typePattern, options: .caseInsensitive)
        return regex
            .flatMap { $0.firstMatch(in: self, range: NSMakeRange(0, self.count)) }
            .flatMap { Range($0.range(at: 1), in: self) }
            .map { String(self[$0]) }
    }
    // 휴대폰 번호
    func setPhone() -> String {
        let _str = self.replacingOccurrences(of: "-", with: "") // 하이픈 모두 빼준다
        if let regex = try? NSRegularExpression(pattern: "([0-9]{3})([0-9]{3,4})([0-9]{4})", options: .caseInsensitive) {
            let modString = regex.stringByReplacingMatches(in: _str, options: [], range: NSRange(_str.startIndex..., in: _str), withTemplate: "$1-$2-$3")
            return modString
        }
        return self
    }
    // 아이디
    func validateId() -> Bool {
        let idRegEx = "^(?=.*[a-zA-Z])[0-9a-zA-Z]{6,15}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", idRegEx)
        return predicate.evaluate(with: self)
    }
    // 비밀번호
    // 영문, 숫자 조합
    func validatePassword1() -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*[0-9])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`']{8,15}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: self)
    }
    // 숫자, 특수 문자 조합
    func validatePassword2() -> Bool {
        let passwordRegEx = "^(?=.*[0-9])(?=.*[^a-zA-Z0-9])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`']{8,15}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: self)
    }
    // 영문, 특수 문자 조합
    func validatePassword3() -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*[^a-zA-Z0-9])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`']{8,15}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: self)
    }
    //    func validatePasswordRule() -> Bool {
    //        let passwordRegEx = "^(?=.*\\d)(?=.*[a-z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`']{8,15}$"
    //        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    //        return predicate.evaluate(with: self)
    //    }
    // 3개 이상 연속된 숫자 또는 문자 사용 불가
    var validatePasswordSuccessive: Bool {
        let alphabetFilter = "(?:abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz)"
        let numberFilter = "(?:123|234|345|456|567|678|890|012)"
        let alphabetMatch = self.checkString(filter: alphabetFilter)
        let numberMatch = self.checkString(filter: numberFilter)
        if alphabetMatch || numberMatch {
            return false
        } else {
            return true
        }
    }
    
    func validateNickname() -> Bool {
        let nicknameRegEx = "^[0-9a-zA-Z가-핳]{2,15}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", nicknameRegEx)
        return predicate.evaluate(with: self)
    }
    
    func validateWeight() -> Bool {
        if self.count >= 4 && self.contains(".") == false {
            return false
        }
        
        let weightRegEx = "^([0-9]{1,3})([.][0-9])?$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", weightRegEx)
        return predicate.evaluate(with: self)
    }
    
    func checkString(filter: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: filter) else {
            return false
        }
        let range = NSRange(location: 0, length: self.utf16.count)
        let isMatch = regex.firstMatch(in: self, options: [], range: range) != nil
        return isMatch
    }
    
    /**
    SHA256 암호화
    참고링크 : https://stackoverflow.com/a/38788437
    */
    func sha256() -> String {
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }

    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }

    private func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)

        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }

        return hexString
    }
}
